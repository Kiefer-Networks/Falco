// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco

import android.app.Application
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.LocaleListCompat
import dagger.hilt.android.HiltAndroidApp
import de.kiefer_networks.falco.data.auth.SecurityPreferences
import kotlinx.coroutines.runBlocking
import javax.inject.Inject

@HiltAndroidApp
class FalcoApp : Application() {

    @Inject lateinit var securityPrefs: SecurityPreferences

    override fun onCreate() {
        super.onCreate()
        // Apply persisted per-app locale before any Activity is created so the
        // first frame already renders in the chosen language.
        val tag = runBlocking { securityPrefs.appLocaleNow() }
        AppCompatDelegate.setApplicationLocales(
            if (tag.isBlank()) LocaleListCompat.getEmptyLocaleList()
            else LocaleListCompat.forLanguageTags(tag),
        )
    }
}
