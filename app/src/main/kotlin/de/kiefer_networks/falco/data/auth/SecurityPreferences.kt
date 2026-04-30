// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.auth

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

/**
 * User-facing security and appearance preferences persisted in DataStore.
 *
 * Auto-lock timeout is stored in seconds:
 *   * `0`  — re-gate immediately on every resume.
 *   * `30` / `60` / `300` / `900` — number of seconds the app may sit in the
 *     background before the next resume requires a fresh biometric unlock.
 *
 * Hard-capped at [MAX_LOCK_TIMEOUT] (15 minutes) so the user cannot disable
 * re-authentication indefinitely. A previously persisted unlimited-session
 * value (legacy `-1`) is mapped to the default on read.
 */
@Singleton
class SecurityPreferences @Inject constructor(
    private val dataStore: DataStore<Preferences>,
) {
    val autoLockTimeoutSeconds: Flow<Int> =
        dataStore.data.map {
            val raw = it[KEY_LOCK_TIMEOUT] ?: DEFAULT_LOCK_TIMEOUT
            when {
                raw < 0 -> DEFAULT_LOCK_TIMEOUT
                raw > MAX_LOCK_TIMEOUT -> MAX_LOCK_TIMEOUT
                else -> raw
            }
        }

    suspend fun setAutoLockTimeoutSeconds(value: Int) {
        val clamped = value.coerceIn(LOCK_IMMEDIATE, MAX_LOCK_TIMEOUT)
        dataStore.edit { it[KEY_LOCK_TIMEOUT] = clamped }
    }

    /** Theme mode: 0 = follow system, 1 = light, 2 = dark, 3 = OLED black. */
    val themeMode: Flow<Int> =
        dataStore.data.map { it[KEY_THEME_MODE] ?: THEME_LIGHT }

    suspend fun setThemeMode(value: Int) {
        dataStore.edit { it[KEY_THEME_MODE] = value }
    }

    /** Accent palette. 0 = Hetzner Red, 1 = Blue, 2 = Green, 3 = Purple, 4 = Orange. */
    val accentMode: Flow<Int> =
        dataStore.data.map { it[KEY_ACCENT_MODE] ?: ACCENT_RED }

    suspend fun setAccentMode(value: Int) {
        dataStore.edit { it[KEY_ACCENT_MODE] = value }
    }

    /**
     * BCP-47 language tag for the app UI. Empty string means "follow the
     * system locale". Otherwise one of the seven supported tags
     * (en, de, es, fr, it, zh-CN, ru).
     */
    val appLocale: Flow<String> =
        dataStore.data.map { it[KEY_APP_LOCALE] ?: "" }

    suspend fun setAppLocale(tag: String) {
        dataStore.edit { it[KEY_APP_LOCALE] = tag }
    }

    /** Synchronous accessor for [FalcoApp.onCreate], called once at process start. */
    suspend fun appLocaleNow(): String = dataStore.data.first()[KEY_APP_LOCALE] ?: ""

    /**
     * Blocks screenshots and Recent-Apps thumbnails via FLAG_SECURE.
     * Default on — switching off is a deliberate trust trade-off.
     */
    val blockScreenshots: Flow<Boolean> =
        dataStore.data.map { it[KEY_BLOCK_SCREENSHOTS] ?: true }
    suspend fun setBlockScreenshots(value: Boolean) {
        dataStore.edit { it[KEY_BLOCK_SCREENSHOTS] = value }
    }
    suspend fun blockScreenshotsNow(): Boolean = dataStore.data.first()[KEY_BLOCK_SCREENSHOTS] ?: true

    /**
     * Force biometric unlock on every cold start regardless of background time.
     * When `false`, [autoLockTimeoutSeconds] still applies.
     */
    val requireUnlockOnLaunch: Flow<Boolean> =
        dataStore.data.map { it[KEY_REQUIRE_UNLOCK_ON_LAUNCH] ?: true }
    suspend fun setRequireUnlockOnLaunch(value: Boolean) {
        dataStore.edit { it[KEY_REQUIRE_UNLOCK_ON_LAUNCH] = value }
    }

    /**
     * Confirmation prompt before destructive actions (delete server, drop
     * volume, remove account, etc).
     */
    val confirmDestructiveActions: Flow<Boolean> =
        dataStore.data.map { it[KEY_CONFIRM_DESTRUCTIVE] ?: true }
    suspend fun setConfirmDestructiveActions(value: Boolean) {
        dataStore.edit { it[KEY_CONFIRM_DESTRUCTIVE] = value }
    }

    /** Master switch for the on-device crash-log retention (off-by-default). */
    val keepDiagnostics: Flow<Boolean> =
        dataStore.data.map { it[KEY_KEEP_DIAGNOSTICS] ?: false }
    suspend fun setKeepDiagnostics(value: Boolean) {
        dataStore.edit { it[KEY_KEEP_DIAGNOSTICS] = value }
    }

    companion object {
        const val DEFAULT_LOCK_TIMEOUT = 60
        const val LOCK_IMMEDIATE = 0
        const val MAX_LOCK_TIMEOUT = 900

        const val THEME_SYSTEM = 0
        const val THEME_LIGHT = 1
        const val THEME_DARK = 2
        const val THEME_OLED = 3

        const val ACCENT_RED = 0
        const val ACCENT_BLUE = 1
        const val ACCENT_GREEN = 2
        const val ACCENT_PURPLE = 3
        const val ACCENT_ORANGE = 4

        private val KEY_LOCK_TIMEOUT = intPreferencesKey("auto_lock_timeout_seconds")
        private val KEY_THEME_MODE = intPreferencesKey("theme_mode")
        private val KEY_ACCENT_MODE = intPreferencesKey("accent_mode")
        private val KEY_APP_LOCALE = stringPreferencesKey("app_locale_tag")
        private val KEY_BLOCK_SCREENSHOTS = booleanPreferencesKey("block_screenshots")
        private val KEY_REQUIRE_UNLOCK_ON_LAUNCH = booleanPreferencesKey("require_unlock_on_launch")
        private val KEY_CONFIRM_DESTRUCTIVE = booleanPreferencesKey("confirm_destructive")
        private val KEY_KEEP_DIAGNOSTICS = booleanPreferencesKey("keep_diagnostics")
    }
}
