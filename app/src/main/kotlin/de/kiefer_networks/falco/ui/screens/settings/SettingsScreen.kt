// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.settings

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.BuildConfig
import de.kiefer_networks.falco.R

@Composable
fun SettingsScreen() {
    val context = LocalContext.current
    Column(modifier = Modifier.fillMaxSize().padding(24.dp)) {
        Text(stringResource(R.string.settings_about), style = MaterialTheme.typography.titleLarge)
        Spacer(Modifier.height(12.dp))
        Text(context.getString(R.string.settings_version, BuildConfig.VERSION_NAME))
        Text(stringResource(R.string.settings_license))
        Spacer(Modifier.height(16.dp))
        HorizontalDivider()
        Spacer(Modifier.height(16.dp))
        Text(stringResource(R.string.settings_pinning), style = MaterialTheme.typography.titleMedium)
        Spacer(Modifier.height(8.dp))
        Text(
            "Cloud, Robot, DNS und Object Storage TLS-Verbindungen sind durch Certificate Pinning geschützt. "
                + "Pins werden beim Release über scripts/fetch_pins.sh aktualisiert.",
            style = MaterialTheme.typography.bodyMedium,
        )
    }
}
