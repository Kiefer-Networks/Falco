// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.auth

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import java.util.UUID
import javax.inject.Inject
import javax.inject.Singleton

data class HetznerAccount(
    val id: String,
    val displayName: String,
    val hasCloud: Boolean,
    val hasRobot: Boolean,
    val hasDns: Boolean,
    val hasS3: Boolean,
)

data class AccountSecrets(
    val cloudToken: String? = null,
    val robotUser: String? = null,
    val robotPass: String? = null,
    val dnsToken: String? = null,
    val s3Endpoint: String? = null,
    val s3Region: String? = null,
    val s3AccessKey: String? = null,
    val s3SecretKey: String? = null,
)

/**
 * Owns the catalogue of Hetzner accounts and the currently active selection.
 *
 * Plain non-secret metadata (account id list, active id) lives in DataStore;
 * actual credentials are delegated to [CredentialStore] which encrypts at rest.
 */
@Singleton
class AccountManager @Inject constructor(
    private val store: CredentialStore,
    private val dataStore: DataStore<Preferences>,
) {
    val accounts: Flow<List<HetznerAccount>> = dataStore.data.map { prefs ->
        val ids = prefs[ACCOUNT_IDS]?.split(',')?.filter(String::isNotBlank).orEmpty()
        ids.map { id -> readAccount(id) }
    }

    val activeAccountId: Flow<String?> = dataStore.data.map { it[ACTIVE_ID] }

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

    suspend fun remove(id: String) {
        store.remove(id)
        dataStore.edit { prefs ->
            val remaining = prefs[ACCOUNT_IDS]
                ?.split(',')
                ?.filter { it.isNotBlank() && it != id }
                .orEmpty()
            prefs[ACCOUNT_IDS] = remaining.joinToString(",")
            if (prefs[ACTIVE_ID] == id) prefs[ACTIVE_ID] = remaining.firstOrNull() ?: ""
        }
    }

    suspend fun secretsFor(id: String): AccountSecrets = AccountSecrets(
        cloudToken = store.get(id, CredentialStore.Field.CLOUD_TOKEN),
        robotUser = store.get(id, CredentialStore.Field.ROBOT_USER),
        robotPass = store.get(id, CredentialStore.Field.ROBOT_PASS),
        dnsToken = store.get(id, CredentialStore.Field.DNS_TOKEN),
        s3Endpoint = store.get(id, CredentialStore.Field.S3_ENDPOINT),
        s3Region = store.get(id, CredentialStore.Field.S3_REGION),
        s3AccessKey = store.get(id, CredentialStore.Field.S3_ACCESS_KEY),
        s3SecretKey = store.get(id, CredentialStore.Field.S3_SECRET_KEY),
    )

    suspend fun activeSecrets(): AccountSecrets? =
        activeAccountId.first()?.takeIf { it.isNotBlank() }?.let { secretsFor(it) }

    private fun applySecrets(id: String, s: AccountSecrets) {
        s.cloudToken?.let { store.put(id, CredentialStore.Field.CLOUD_TOKEN, it) }
        s.robotUser?.let { store.put(id, CredentialStore.Field.ROBOT_USER, it) }
        s.robotPass?.let { store.put(id, CredentialStore.Field.ROBOT_PASS, it) }
        s.dnsToken?.let { store.put(id, CredentialStore.Field.DNS_TOKEN, it) }
        s.s3Endpoint?.let { store.put(id, CredentialStore.Field.S3_ENDPOINT, it) }
        s.s3Region?.let { store.put(id, CredentialStore.Field.S3_REGION, it) }
        s.s3AccessKey?.let { store.put(id, CredentialStore.Field.S3_ACCESS_KEY, it) }
        s.s3SecretKey?.let { store.put(id, CredentialStore.Field.S3_SECRET_KEY, it) }
    }

    private fun readAccount(id: String): HetznerAccount = HetznerAccount(
        id = id,
        displayName = store.get(id, CredentialStore.Field.DISPLAY_NAME).orEmpty(),
        hasCloud = !store.get(id, CredentialStore.Field.CLOUD_TOKEN).isNullOrBlank(),
        hasRobot = !store.get(id, CredentialStore.Field.ROBOT_USER).isNullOrBlank() &&
            !store.get(id, CredentialStore.Field.ROBOT_PASS).isNullOrBlank(),
        hasDns = !store.get(id, CredentialStore.Field.DNS_TOKEN).isNullOrBlank(),
        hasS3 = !store.get(id, CredentialStore.Field.S3_ACCESS_KEY).isNullOrBlank() &&
            !store.get(id, CredentialStore.Field.S3_SECRET_KEY).isNullOrBlank(),
    )

    companion object {
        private val ACCOUNT_IDS = stringPreferencesKey("account_ids")
        private val ACTIVE_ID = stringPreferencesKey("active_id")
    }
}
