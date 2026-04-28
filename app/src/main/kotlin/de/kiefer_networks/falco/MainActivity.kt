// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco

import android.os.Bundle
import android.view.WindowManager
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.fragment.app.FragmentActivity
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.lifecycleScope
import dagger.hilt.android.AndroidEntryPoint
import de.kiefer_networks.falco.data.auth.BiometricGate
import de.kiefer_networks.falco.ui.FalcoRoot
import de.kiefer_networks.falco.ui.theme.FalcoTheme
import kotlinx.coroutines.launch

@AndroidEntryPoint
class MainActivity : FragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Block screenshots and Recent-Apps thumbnails — secrets live on this surface.
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        enableEdgeToEdge()

        setContent {
            FalcoTheme {
                FalcoRoot(viewModel = hiltViewModel())
            }
        }

        gateBiometric()
    }

    private fun gateBiometric() {
        val gate = BiometricGate(this)
        if (gate.availability() != BiometricGate.Availability.AVAILABLE) return
        lifecycleScope.launch {
            val result = gate.authenticate(
                title = getString(R.string.bio_prompt_title),
                subtitle = getString(R.string.bio_prompt_subtitle),
                negative = getString(R.string.bio_prompt_negative),
            )
            if (result is BiometricGate.Result.Error) finishAndRemoveTask()
        }
    }
}
