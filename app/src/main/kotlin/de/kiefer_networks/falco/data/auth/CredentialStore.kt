// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.auth

import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.security.keystore.KeyProperties
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import dagger.hilt.android.qualifiers.ApplicationContext
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
            .setUserAuthenticationRequired(false, 0)
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

    fun put(accountId: String, field: Field, value: String) {
        prefs.edit().putString(key(accountId, field), value).apply()
    }

    fun get(accountId: String, field: Field): String? = prefs.getString(key(accountId, field), null)

    fun remove(accountId: String) {
        prefs.edit().apply {
            Field.entries.forEach { remove(key(accountId, it)) }
        }.apply()
    }

    fun listAccountIds(): Set<String> = prefs.all.keys
        .mapNotNull { it.substringBefore('|', missingDelimiterValue = "").takeIf(String::isNotEmpty) }
        .toSet()

    private fun key(accountId: String, field: Field): String = "$accountId|${field.name}"

    enum class Field {
        DISPLAY_NAME,
        CLOUD_TOKEN,
        ROBOT_USER,
        ROBOT_PASS,
        DNS_TOKEN,
        S3_ENDPOINT,
        S3_REGION,
        S3_ACCESS_KEY,
        S3_SECRET_KEY,
    }

    companion object {
        private const val FILE_NAME = "falco_secure_v1"
        // Re-export to suppress unused warning on KeyProperties (kept for future hardware-bound keys).
        @Suppress("unused") private val keyAlgo = KeyProperties.KEY_ALGORITHM_AES
    }
}
