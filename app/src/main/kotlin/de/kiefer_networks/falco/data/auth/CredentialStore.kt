// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.auth

import android.content.Context
import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.google.crypto.tink.Aead
import com.google.crypto.tink.KeyTemplates
import com.google.crypto.tink.aead.AeadConfig
import com.google.crypto.tink.integration.android.AndroidKeysetManager
import dagger.hilt.android.qualifiers.ApplicationContext
import de.kiefer_networks.falco.di.CredentialsPrefs
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import java.security.KeyStore
import javax.crypto.KeyGenerator
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Encrypted persistent store for Hetzner credentials (v2).
 *
 * Architecture:
 *   * Tink AEAD primitive (AES-256-GCM) for per-field encryption.
 *   * Tink keyset itself is wrapped by an Android-Keystore-bound AES key
 *     (`falco_master_v2`) — keyset bytes never leave Android Keystore in
 *     plaintext.
 *   * Ciphertext-per-field is persisted in a dedicated `DataStore<Preferences>`
 *     (`falco_credentials_v2`). Plain (non-secret) account index continues to
 *     live in the separate `falco_account_prefs` store the AccountManager
 *     uses; the two stores never share a process-level keyspace.
 *
 * Hardware-bound mode (opt-in via [SecurityPreferences.hardwareBoundCredentials]):
 * the master Keystore key is created with `setUserAuthenticationRequired(true)`
 * (60-second validity) and `setInvalidatedByBiometricEnrollment(true)`. On a
 * StrongBox-capable device the key is also `setIsStrongBoxBacked(true)`.
 *
 * Migration from the v1.x [androidx.security.crypto.EncryptedSharedPreferences]
 * store happens lazily at first construction. Existing tokens are decrypted
 * with the old MasterKey, re-encrypted with the new Tink AEAD, written to the
 * new DataStore, and the legacy SharedPreferences file is wiped. The migration
 * marker `__migration_v2_done` is committed atomically with the migrated
 * payload so a process kill mid-migration is safe to retry.
 *
 * Recovery: if the master Keystore key has been invalidated (e.g. biometric
 * re-enrollment in hardware-bound mode), the keyset cannot be unwrapped and
 * the AEAD build throws. We catch that on construction, drop the old keyset
 * + ciphertext store, recreate the master key, and rebuild from scratch — the
 * user must re-enter their tokens. Without this dance the app would fail to
 * start. The hardware-bound toggle is preserved across recovery.
 */
@Singleton
class CredentialStore @Inject constructor(
    @ApplicationContext context: Context,
    private val securityPrefs: SecurityPreferences,
    @CredentialsPrefs private val dataStore: DataStore<Preferences>,
) {

    private val ctx: Context = context.applicationContext

    private val aead: Aead = run {
        AeadConfig.register()
        val hardwareBound = runBlocking { securityPrefs.hardwareBoundCredentialsNow() }
        runCatching { ensureMasterKey(hardwareBound) }
        val a = runCatching { buildAead() }.getOrElse {
            // Master key invalidated or keyset corrupt. Wipe and rebuild.
            recoverFromInvalidatedMaster()
            runCatching { ensureMasterKey(hardwareBound) }
            buildAead()
        }
        runBlocking { migrateFromLegacyIfNeeded(a) }
        a
    }

    suspend fun put(accountId: String, field: Field, value: String) {
        val k = stringPreferencesKey(key(accountId, field))
        val ct = aead.encrypt(value.toByteArray(Charsets.UTF_8), AAD)
        dataStore.edit { it[k] = Base64.encodeToString(ct, Base64.NO_WRAP) }
    }

    suspend fun get(accountId: String, field: Field): String? {
        val k = stringPreferencesKey(key(accountId, field))
        val b64 = dataStore.data.first()[k] ?: return null
        return runCatching {
            String(aead.decrypt(Base64.decode(b64, Base64.NO_WRAP), AAD), Charsets.UTF_8)
        }.getOrNull()
    }

    suspend fun remove(accountId: String) {
        dataStore.edit { prefs ->
            Field.entries.forEach { prefs.remove(stringPreferencesKey(key(accountId, it))) }
        }
    }

    suspend fun listAccountIds(): Set<String> {
        val prefs = dataStore.data.first()
        return prefs.asMap().keys
            .map { it.name }
            .mapNotNull { name ->
                if (name.startsWith("__")) return@mapNotNull null
                name.substringBefore('|', missingDelimiterValue = "").takeIf(String::isNotEmpty)
            }
            .toSet()
    }

    private fun buildAead(): Aead =
        AndroidKeysetManager.Builder()
            .withSharedPref(ctx, KEYSET_NAME, KEYSET_PREFS_FILE)
            .withKeyTemplate(KeyTemplates.get("AES256_GCM"))
            .withMasterKeyUri(MASTER_KEY_URI)
            .build()
            .keysetHandle
            .getPrimitive(Aead::class.java)

    private fun ensureMasterKey(hardwareBound: Boolean) {
        val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        if (ks.containsAlias(MASTER_KEY_ALIAS)) return
        runCatching { generateMasterKey(hardwareBound = hardwareBound) }
            .onFailure {
                // Hardware-bound generation can fail on emulators / no StrongBox HAL;
                // fall back to a soft-bound key so the app still starts.
                if (hardwareBound) {
                    runCatching { generateMasterKey(hardwareBound = false) }
                }
            }
    }

    @Suppress("DEPRECATION") // setUserAuthenticationValidityDurationSeconds is API 30+ deprecated but functional.
    private fun generateMasterKey(hardwareBound: Boolean) {
        val gen = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        val spec = KeyGenParameterSpec.Builder(
            MASTER_KEY_ALIAS,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .apply {
                if (hardwareBound) {
                    setUserAuthenticationRequired(true)
                    setUserAuthenticationValidityDurationSeconds(60)
                    setInvalidatedByBiometricEnrollment(true)
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    runCatching { setIsStrongBoxBacked(true) }
                }
            }
            .build()
        gen.init(spec)
        gen.generateKey()
    }

    private fun recoverFromInvalidatedMaster() {
        runCatching {
            val ks = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
            if (ks.containsAlias(MASTER_KEY_ALIAS)) ks.deleteEntry(MASTER_KEY_ALIAS)
        }
        ctx.deleteSharedPreferences(KEYSET_PREFS_FILE)
        runBlocking {
            dataStore.edit { it.clear() }
        }
    }

    /**
     * One-time migration from v1 EncryptedSharedPreferences to Tink + DataStore.
     * Idempotent — guarded by `__migration_v2_done` in the new DataStore. Failures
     * leave the marker unset so we retry on the next launch; they do NOT crash.
     */
    private suspend fun migrateFromLegacyIfNeeded(activeAead: Aead) {
        if (dataStore.data.first()[MIGRATION_DONE] == true) return
        val legacy = ctx.getSharedPreferences(LEGACY_FILE, Context.MODE_PRIVATE)
        if (legacy.all.isEmpty()) {
            dataStore.edit { it[MIGRATION_DONE] = true }
            return
        }
        runCatching {
            val masterKey = androidx.security.crypto.MasterKey.Builder(ctx)
                .setKeyScheme(androidx.security.crypto.MasterKey.KeyScheme.AES256_GCM)
                .build()
            val esp = androidx.security.crypto.EncryptedSharedPreferences.create(
                ctx,
                LEGACY_FILE,
                masterKey,
                androidx.security.crypto.EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                androidx.security.crypto.EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
            )
            val migrated = mutableMapOf<Preferences.Key<String>, String>()
            esp.all.forEach { (k, v) ->
                val plaintext = (v as? String) ?: return@forEach
                val ct = activeAead.encrypt(plaintext.toByteArray(Charsets.UTF_8), AAD)
                migrated[stringPreferencesKey(k)] = Base64.encodeToString(ct, Base64.NO_WRAP)
            }
            dataStore.edit { prefs ->
                migrated.forEach { (k, v) -> prefs[k] = v }
                prefs[MIGRATION_DONE] = true
            }
            esp.edit().clear().commit()
            ctx.deleteSharedPreferences(LEGACY_FILE)
        }
        // Failure path: marker not set, retry next launch. Caller sees an empty
        // store; user re-enters tokens. Better than crashing the app shell.
    }

    private fun key(accountId: String, field: Field): String = "$accountId|${field.name}"

    enum class Field {
        DISPLAY_NAME,
        DESCRIPTION,
        // Legacy v0.1/v0.2 fields. Read by the migration in AccountManager and
        // then folded into CLOUD_PROJECTS_JSON; new writes go through the
        // project-list field below.
        CLOUD_TOKEN,
        S3_ENDPOINT,
        S3_REGION,
        S3_ACCESS_KEY,
        S3_SECRET_KEY,
        // Current-shape fields (v0.3+).
        ROBOT_USER,
        ROBOT_PASS,
        DNS_TOKEN,
        CLOUD_PROJECTS_JSON,
        ACTIVE_CLOUD_PROJECT_ID,
    }

    companion object {
        private const val LEGACY_FILE = "falco_secure_v1"
        private const val KEYSET_NAME = "falco_v2_keyset"
        private const val KEYSET_PREFS_FILE = "falco_tink_meta"
        private const val MASTER_KEY_ALIAS = "falco_master_v2"
        private const val MASTER_KEY_URI = "android-keystore://falco_master_v2"
        private val AAD = "falco_v2_creds".toByteArray(Charsets.UTF_8)
        private val MIGRATION_DONE = booleanPreferencesKey("__migration_v2_done")
    }
}
