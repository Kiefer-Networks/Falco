// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco

import android.content.Intent
import android.os.Bundle
import android.os.SystemClock
import android.provider.Settings
import android.view.WindowManager
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.windowsizeclass.ExperimentalMaterial3WindowSizeClassApi
import androidx.compose.material3.windowsizeclass.calculateWindowSizeClass
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
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
    private val unlocked: androidx.compose.runtime.MutableState<Boolean> =
        androidx.compose.runtime.mutableStateOf(false)
    private val biometricUnavailable: androidx.compose.runtime.MutableState<Boolean> =
        androidx.compose.runtime.mutableStateOf(false)

    @OptIn(ExperimentalMaterial3WindowSizeClassApi::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Block screenshots and Recent-Apps thumbnails — secrets live on this surface.
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        enableEdgeToEdge()
        // Force re-auth on every cold start, including activity recreation after
        // process death — never persist `unlocked` across instances.
        unlocked.value = false

        setContent {
            val themeMode by securityPrefs.themeMode.collectAsState(initial = SecurityPreferences.THEME_LIGHT)
            val windowSizeClass = calculateWindowSizeClass(this)
            FalcoTheme(themeMode = themeMode) {
                when {
                    biometricUnavailable.value -> BiometricUnavailableScreen(
                        onOpenSettings = { startActivity(Intent(Settings.ACTION_SECURITY_SETTINGS)) },
                        onExit = { finishAndRemoveTask() },
                    )
                    !unlocked.value -> LockedPlaceholder()
                    else -> FalcoRoot(viewModel = hiltViewModel(), windowSizeClass = windowSizeClass)
                }
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
        if (!unlocked.value) return
        lifecycleScope.launch {
            val timeout = securityPrefs.autoLockTimeoutSeconds.first()
            val elapsedMs = SystemClock.elapsedRealtime() - lastPausedAt
            val shouldRelock = timeout == SecurityPreferences.LOCK_IMMEDIATE ||
                elapsedMs >= timeout * 1000L
            if (shouldRelock) {
                unlocked.value = false
                gateBiometric()
            }
        }
    }

    private fun gateBiometric() {
        val gate = BiometricGate(this)
        if (gate.availability() != BiometricGate.Availability.AVAILABLE) {
            // Hardware/credential gate failed entirely (no biometric AND no PIN/pattern set).
            biometricUnavailable.value = true
            return
        }
        biometricUnavailable.value = false
        lifecycleScope.launch {
            val result = gate.authenticate(
                title = getString(R.string.bio_prompt_title),
                subtitle = getString(R.string.bio_prompt_subtitle),
                negative = getString(R.string.bio_prompt_negative),
            )
            if (result is BiometricGate.Result.Error) {
                finishAndRemoveTask()
            } else {
                unlocked.value = true
            }
        }
    }
}

@Composable
private fun LockedPlaceholder() {
    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background,
    ) {}
}

@Composable
private fun BiometricUnavailableScreen(
    onOpenSettings: () -> Unit,
    onExit: () -> Unit,
) {
    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background,
    ) {
        Column(
            modifier = Modifier.fillMaxSize().padding(32.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            Text(
                stringResource(R.string.bio_unavailable),
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onBackground,
            )
            Column(
                modifier = Modifier.padding(top = 24.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                Button(onClick = onOpenSettings) {
                    Text(stringResource(R.string.bio_open_security_settings))
                }
                androidx.compose.material3.OutlinedButton(onClick = onExit) {
                    Text(stringResource(R.string.close))
                }
            }
        }
    }
}

