// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.auth

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
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
 *   * `-1` — never re-gate after the initial unlock (until the process dies).
 *   * any other positive value — number of seconds the app may sit in the
 *     background before the next resume requires a fresh biometric unlock.
 *
 * The default of 60 seconds is applied when the key is absent.
 */
@Singleton
class SecurityPreferences @Inject constructor(
    private val dataStore: DataStore<Preferences>,
) {
    val autoLockTimeoutSeconds: Flow<Int> =
        dataStore.data.map { it[KEY_LOCK_TIMEOUT] ?: DEFAULT_LOCK_TIMEOUT }

    suspend fun setAutoLockTimeoutSeconds(value: Int) {
        dataStore.edit { it[KEY_LOCK_TIMEOUT] = value }
    }

    /** Theme mode: 0 = follow system, 1 = light, 2 = dark. */
    val themeMode: Flow<Int> =
        dataStore.data.map { it[KEY_THEME_MODE] ?: THEME_SYSTEM }

    suspend fun setThemeMode(value: Int) {
        dataStore.edit { it[KEY_THEME_MODE] = value }
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

    companion object {
        const val DEFAULT_LOCK_TIMEOUT = 60
        const val LOCK_IMMEDIATE = 0
        const val LOCK_NEVER = -1

        const val THEME_SYSTEM = 0
        const val THEME_LIGHT = 1
        const val THEME_DARK = 2

        private val KEY_LOCK_TIMEOUT = intPreferencesKey("auto_lock_timeout_seconds")
        private val KEY_THEME_MODE = intPreferencesKey("theme_mode")
        private val KEY_APP_LOCALE = stringPreferencesKey("app_locale_tag")
    }
}
