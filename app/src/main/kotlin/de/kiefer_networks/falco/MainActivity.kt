// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco

import android.os.Bundle
import android.os.SystemClock
import android.view.WindowManager
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.fragment.app.FragmentActivity
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.lifecycleScope
import dagger.hilt.android.AndroidEntryPoint
import de.kiefer_networks.falco.data.auth.BiometricGate
import de.kiefer_networks.falco.data.auth.SecurityPreferences
import de.kiefer_networks.falco.ui.FalcoRoot
import de.kiefer_networks.falco.ui.theme.FalcoTheme
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : FragmentActivity() {

    @Inject lateinit var securityPrefs: SecurityPreferences

    private var lastPausedAt: Long = 0L
    private var unlocked: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Block screenshots and Recent-Apps thumbnails — secrets live on this surface.
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        enableEdgeToEdge()

        setContent {
            val themeMode by securityPrefs.themeMode.collectAsState(initial = SecurityPreferences.THEME_SYSTEM)
            FalcoTheme(themeMode = themeMode) {
                FalcoRoot(viewModel = hiltViewModel())
            }
        }

        gateBiometric()
    }

    override fun onPause() {
        super.onPause()
        lastPausedAt = SystemClock.elapsedRealtime()
    }

    override fun onResume() {
        super.onResume()
        if (!unlocked) return // initial gate handles first unlock
        lifecycleScope.launch {
            val timeout = securityPrefs.autoLockTimeoutSeconds.first()
            if (timeout == SecurityPreferences.LOCK_NEVER) return@launch
            val elapsedMs = SystemClock.elapsedRealtime() - lastPausedAt
            val shouldRelock = timeout == SecurityPreferences.LOCK_IMMEDIATE ||
                elapsedMs >= timeout * 1000L
            if (shouldRelock) {
                unlocked = false
                gateBiometric()
            }
        }
    }

    private fun gateBiometric() {
        val gate = BiometricGate(this)
        if (gate.availability() != BiometricGate.Availability.AVAILABLE) {
            unlocked = true
            return
        }
        lifecycleScope.launch {
            val result = gate.authenticate(
                title = getString(R.string.bio_prompt_title),
                subtitle = getString(R.string.bio_prompt_subtitle),
                negative = getString(R.string.bio_prompt_negative),
            )
            if (result is BiometricGate.Result.Error) {
                finishAndRemoveTask()
            } else {
                unlocked = true
            }
        }
    }
}
