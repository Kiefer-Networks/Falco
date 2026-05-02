// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.auth

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import de.kiefer_networks.falco.data.api.CloudApi
import de.kiefer_networks.falco.data.api.DnsApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.RobotApi
import de.kiefer_networks.falco.data.model.CloudProject
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json
import java.util.UUID
import javax.inject.Inject
import javax.inject.Singleton

data class HetznerAccount(
    val id: String,
    val displayName: String,
    val description: String?,
    val cloudProjectCount: Int,
    val activeCloudProjectId: String?,
    val hasRobot: Boolean,
    val hasDns: Boolean,
    val hasS3: Boolean,
)

data class AccountSecrets(
    val cloudProjects: List<CloudProject> = emptyList(),
    val activeCloudProjectId: String? = null,
    val robotUser: String? = null,
    val robotPass: String? = null,
    val dnsToken: String? = null,
)

/**
 * Owns the catalogue of Hetzner accounts and their cloud projects. Plain
 * non-secret metadata (account-id list, active-id) lives in DataStore;
 * actual credentials are delegated to [CredentialStore] which encrypts at rest.
 *
 * Each account holds a list of [CloudProject]s. Migration from the v0.2
 * single-`cloudToken` shape happens lazily on first read in [readAccount] and
 * is idempotent.
 */
@Singleton
class AccountManager @Inject constructor(
    private val store: CredentialStore,
    private val dataStore: DataStore<Preferences>,
) {
    private val json = Json { ignoreUnknownKeys = true }

    val accounts: Flow<List<HetznerAccount>> = dataStore.data.map { prefs ->
        val ids = prefs[ACCOUNT_IDS]?.split(',')?.filter(String::isNotBlank).orEmpty()
        ids.map { id -> readAccount(id) }
    }

    val activeAccountId: Flow<String?> = dataStore.data.map { it[ACTIVE_ID] }

    val defaultAccountId: Flow<String?> = dataStore.data.map { it[DEFAULT_ID] }

    /** Active project of the active account, or null when no project exists. */
    val activeCloudProject: Flow<CloudProject?> = combine(
        activeAccountId,
        dataStore.data,
    ) { accountId, _ ->
        if (accountId.isNullOrBlank()) return@combine null
        val projects = readCloudProjects(accountId)
        if (projects.isEmpty()) return@combine null
        val activeId = store.get(accountId, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID)
        projects.firstOrNull { it.id == activeId } ?: projects.first()
    }

    /**
     * Best-effort credential probe: fires cheap GETs against each non-blank
     * credential supplied in [secrets] (Cloud `listLocations`, DNS `listZones`,
     * Robot `listFailoverIps`). Throws on the first failure so callers can
     * abort persistence before bad creds land in [CredentialStore]. Safe to
     * retry — performs no mutation, touches no DataStore / CredentialStore
     * state. S3 creds are intentionally not probed (would require spinning up
     * a MinIO client with a different failure surface). Caller decides when
     * to invoke; [create] does not wire this in.
     */
    suspend fun probeCredentials(secrets: AccountSecrets) {
        secrets.cloudProjects
            .filter { it.cloudToken.isNotBlank() }
            .forEach { project ->
                HttpClientFactory.cloudRetrofit(project.cloudToken)
                    .create(CloudApi::class.java)
                    .listLocations()
            }
        secrets.dnsToken?.takeIf { it.isNotBlank() }?.let { token ->
            HttpClientFactory.dnsRetrofit(token)
                .create(DnsApi::class.java)
                .listZones(page = 1, perPage = 1)
        }
        val user = secrets.robotUser
        val pass = secrets.robotPass
        if (!user.isNullOrBlank() && !pass.isNullOrBlank()) {
            HttpClientFactory.robotRetrofit(user, pass)
                .create(RobotApi::class.java)
                .listFailoverIps()
        }
    }

    suspend fun create(displayName: String, secrets: AccountSecrets): HetznerAccount {
        val id = UUID.randomUUID().toString()
        store.put(id, CredentialStore.Field.DISPLAY_NAME, displayName)
        applySecrets(id, secrets)
        dataStore.edit { prefs ->
            val current = prefs[ACCOUNT_IDS]?.split(',')?.filter(String::isNotBlank).orEmpty()
            prefs[ACCOUNT_IDS] = (current + id).joinToString(",")
            if (prefs[ACTIVE_ID].isNullOrBlank()) prefs[ACTIVE_ID] = id
        }
        return readAccount(id)
    }

    suspend fun setActive(id: String) {
        dataStore.edit { it[ACTIVE_ID] = id }
    }

    suspend fun setDefault(id: String) {
        dataStore.edit { it[DEFAULT_ID] = id }
    }

    suspend fun updateDisplayName(id: String, name: String) {
        store.put(id, CredentialStore.Field.DISPLAY_NAME, name)
        dataStore.edit { /* trigger flow */ }
    }

    suspend fun updateDescription(id: String, description: String) {
        store.put(id, CredentialStore.Field.DESCRIPTION, description)
        dataStore.edit { /* trigger flow */ }
    }

    suspend fun remove(id: String) {
        store.remove(id)
        dataStore.edit { prefs ->
            val remaining = prefs[ACCOUNT_IDS]
                ?.split(',')
                ?.filter { it.isNotBlank() && it != id }
                .orEmpty()
            prefs[ACCOUNT_IDS] = remaining.joinToString(",")
            if (prefs[ACTIVE_ID] == id) prefs[ACTIVE_ID] = remaining.firstOrNull() ?: ""
            if (prefs[DEFAULT_ID] == id) prefs[DEFAULT_ID] = ""
        }
    }

    suspend fun cloudProjects(accountId: String): List<CloudProject> = readCloudProjects(accountId)

    suspend fun addCloudProject(accountId: String, project: CloudProject) {
        val current = readCloudProjects(accountId)
        val withId = if (project.id.isBlank()) project.copy(id = UUID.randomUUID().toString()) else project
        writeCloudProjects(accountId, current + withId)
        // First project becomes active automatically.
        if (current.isEmpty()) {
            store.put(accountId, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID, withId.id)
        }
    }

    suspend fun updateCloudProject(accountId: String, project: CloudProject) {
        val current = readCloudProjects(accountId)
        writeCloudProjects(accountId, current.map { if (it.id == project.id) project else it })
    }

    suspend fun removeCloudProject(accountId: String, projectId: String) {
        val current = readCloudProjects(accountId)
        val remaining = current.filterNot { it.id == projectId }
        writeCloudProjects(accountId, remaining)
        val activeId = store.get(accountId, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID)
        if (activeId == projectId) {
            val next = remaining.firstOrNull()?.id.orEmpty()
            store.put(accountId, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID, next)
        }
    }

    suspend fun setActiveCloudProject(accountId: String, projectId: String) {
        store.put(accountId, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID, projectId)
        // Bump tick so dataStore.data emits and Flow re-evaluates.
        dataStore.edit { it[ACTIVE_PROJECT_TICK] = "$accountId:$projectId:${System.nanoTime()}" }
    }

    suspend fun secretsFor(id: String): AccountSecrets {
        val projects = readCloudProjects(id)
        val activeId = store.get(id, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID)
            ?.takeIf { tag -> projects.any { it.id == tag } }
            ?: projects.firstOrNull()?.id
        return AccountSecrets(
            cloudProjects = projects,
            activeCloudProjectId = activeId,
            robotUser = store.get(id, CredentialStore.Field.ROBOT_USER),
            robotPass = store.get(id, CredentialStore.Field.ROBOT_PASS),
            dnsToken = store.get(id, CredentialStore.Field.DNS_TOKEN),
        )
    }

    suspend fun activeSecrets(): AccountSecrets? =
        activeAccountId.first()?.takeIf { it.isNotBlank() }?.let { secretsFor(it) }

    private suspend fun applySecrets(id: String, s: AccountSecrets) {
        if (s.cloudProjects.isNotEmpty()) {
            writeCloudProjects(id, s.cloudProjects)
            val active = s.activeCloudProjectId
                ?.takeIf { tag -> s.cloudProjects.any { it.id == tag } }
                ?: s.cloudProjects.first().id
            store.put(id, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID, active)
        }
        s.robotUser?.let { store.put(id, CredentialStore.Field.ROBOT_USER, it) }
        s.robotPass?.let { store.put(id, CredentialStore.Field.ROBOT_PASS, it) }
        s.dnsToken?.let { store.put(id, CredentialStore.Field.DNS_TOKEN, it) }
    }

    /**
     * Reads + lazily migrates the project list for an account. Migration:
     * legacy single CLOUD_TOKEN (+ optional S3 fields) folds into a single
     * `Default` project the first time. Idempotent.
     */
    private val projectListSerializer = ListSerializer(CloudProject.serializer())

    private suspend fun readCloudProjects(id: String): List<CloudProject> {
        val raw = store.get(id, CredentialStore.Field.CLOUD_PROJECTS_JSON)
        if (!raw.isNullOrBlank()) {
            return runCatching { json.decodeFromString(projectListSerializer, raw) }.getOrDefault(emptyList())
        }
        // Migration path.
        val legacyToken = store.get(id, CredentialStore.Field.CLOUD_TOKEN)
        if (legacyToken.isNullOrBlank()) return emptyList()
        val migrated = CloudProject(
            id = UUID.randomUUID().toString(),
            name = "Default",
            cloudToken = legacyToken,
            s3Endpoint = store.get(id, CredentialStore.Field.S3_ENDPOINT),
            s3Region = store.get(id, CredentialStore.Field.S3_REGION),
            s3AccessKey = store.get(id, CredentialStore.Field.S3_ACCESS_KEY),
            s3SecretKey = store.get(id, CredentialStore.Field.S3_SECRET_KEY),
        )
        writeCloudProjects(id, listOf(migrated))
        store.put(id, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID, migrated.id)
        return listOf(migrated)
    }

    private suspend fun writeCloudProjects(id: String, projects: List<CloudProject>) {
        store.put(id, CredentialStore.Field.CLOUD_PROJECTS_JSON, json.encodeToString(projectListSerializer, projects))
    }

    private suspend fun readAccount(id: String): HetznerAccount {
        val projects = readCloudProjects(id)
        val activeProj = store.get(id, CredentialStore.Field.ACTIVE_CLOUD_PROJECT_ID)
            ?.takeIf { tag -> projects.any { it.id == tag } }
            ?: projects.firstOrNull()?.id
        return HetznerAccount(
            id = id,
            displayName = store.get(id, CredentialStore.Field.DISPLAY_NAME).orEmpty(),
            description = store.get(id, CredentialStore.Field.DESCRIPTION)?.takeIf { it.isNotBlank() },
            cloudProjectCount = projects.size,
            activeCloudProjectId = activeProj,
            hasRobot = !store.get(id, CredentialStore.Field.ROBOT_USER).isNullOrBlank() &&
                !store.get(id, CredentialStore.Field.ROBOT_PASS).isNullOrBlank(),
            hasDns = !store.get(id, CredentialStore.Field.DNS_TOKEN).isNullOrBlank(),
            hasS3 = projects.any {
                !it.s3Endpoint.isNullOrBlank() &&
                    !it.s3AccessKey.isNullOrBlank() &&
                    !it.s3SecretKey.isNullOrBlank()
            },
        )
    }

    companion object {
        private val ACCOUNT_IDS = stringPreferencesKey("account_ids")
        private val ACTIVE_ID = stringPreferencesKey("active_id")
        private val DEFAULT_ID = stringPreferencesKey("default_id")
        private val ACTIVE_PROJECT_TICK = stringPreferencesKey("active_project_tick")
    }
}
