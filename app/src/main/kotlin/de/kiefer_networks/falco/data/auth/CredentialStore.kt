// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.auth

import android.annotation.SuppressLint
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.security.keystore.KeyProperties
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Encrypted persistent store for Hetzner credentials.
 *
 * Backed by [EncryptedSharedPreferences] with an AES-256 master key held in the
 * Android Keystore. On devices that support it (API 28+ with the StrongBox HAL),
 * the master key is bound to the StrongBox secure element. We attempt StrongBox
 * first and fall back to the regular Keystore-backed key if it isn't available
 * — without that fallback the app would fail to start on most devices.
 *
 * Tokens are addressed by a stable per-account id; the [AccountManager] owns the
 * id-to-display-name mapping.
 */
@Singleton
class CredentialStore @Inject constructor(@ApplicationContext context: Context) {

    private val prefs: SharedPreferences = run {
        val ctx = context.applicationContext
        val builder = MasterKey.Builder(ctx)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            // Best-effort StrongBox; will throw on devices without HAL — caught below.
            runCatching { builder.setRequestStrongBoxBacked(true) }
        }
        val masterKey = runCatching { builder.build() }.getOrElse {
            MasterKey.Builder(ctx)
                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                .build()
        }
        EncryptedSharedPreferences.create(
            ctx,
            FILE_NAME,
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
        )
    }

    /**
     * Writes a credential and waits for it to hit disk before returning.
     *
     * `apply()` would queue the write asynchronously, which lets us race
     * AccountManager: if the process dies between an `apply()` and the
     * follow-up DataStore append for `ACCOUNT_IDS`, the next launch sees an
     * id with no associated secrets — a "ghost account" that the UI can't
     * authenticate. `commit()` from an IO dispatcher serialises with the
     * subsequent DataStore write so the on-disk state is always consistent.
     */
    @SuppressLint("ApplySharedPref")
    suspend fun put(accountId: String, field: Field, value: String) {
        withContext(Dispatchers.IO) {
            prefs.edit().putString(key(accountId, field), value).commit()
        }
    }

    fun get(accountId: String, field: Field): String? = prefs.getString(key(accountId, field), null)

    @SuppressLint("ApplySharedPref")
    suspend fun remove(accountId: String) {
        withContext(Dispatchers.IO) {
            prefs.edit().apply {
                Field.entries.forEach { remove(key(accountId, it)) }
            }.commit()
        }
    }

    fun listAccountIds(): Set<String> = prefs.all.keys
        .mapNotNull { it.substringBefore('|', missingDelimiterValue = "").takeIf(String::isNotEmpty) }
        .toSet()

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
        private const val FILE_NAME = "falco_secure_v1"
        // Re-export to suppress unused warning on KeyProperties (kept for future hardware-bound keys).
        @Suppress("unused") private val keyAlgo = KeyProperties.KEY_ALGORITHM_AES
    }
}
