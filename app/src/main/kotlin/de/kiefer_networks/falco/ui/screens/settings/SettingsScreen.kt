// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.settings

import android.content.Intent
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.selection.selectable
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.core.net.toUri
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.BuildConfig
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.auth.SecurityPreferences

private const val SOURCE_URL = "https://github.com/maltekiefer/falco"

@Composable
fun SettingsScreen(viewModel: SettingsViewModel = hiltViewModel()) {
    val state by viewModel.state.collectAsState()
    val context = LocalContext.current

    LazyColumn(
        modifier = Modifier.fillMaxSize().padding(horizontal = 16.dp, vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        item {
            SectionTitle(R.string.settings_section_account)
            Text(
                text = state.activeAccount?.displayName ?: stringResource(R.string.accounts_empty),
                style = MaterialTheme.typography.titleMedium,
            )
            Text(
                text = stringResource(R.string.settings_active_account),
                style = MaterialTheme.typography.bodySmall,
            )
            Spacer(Modifier.height(12.dp))
            HorizontalDivider()
        }

        item {
            SectionTitle(R.string.settings_section_security)
            Text(stringResource(R.string.settings_lock_timeout), style = MaterialTheme.typography.titleSmall)
        }
        items(LOCK_OPTIONS) { (value, labelRes) ->
            RadioRow(
                selected = state.autoLockTimeout == value,
                label = stringResource(labelRes),
                onClick = { viewModel.setLockTimeout(value) },
            )
        }
        item {
            Spacer(Modifier.height(8.dp))
            Text(stringResource(R.string.settings_pinning_info), style = MaterialTheme.typography.bodySmall)
            Spacer(Modifier.height(12.dp))
            HorizontalDivider()
        }

        item {
            SectionTitle(R.string.settings_section_appearance)
        }
        items(THEME_OPTIONS) { (value, labelRes) ->
            RadioRow(
                selected = state.themeMode == value,
                label = stringResource(labelRes),
                onClick = { viewModel.setThemeMode(value) },
            )
        }
        item { Spacer(Modifier.height(12.dp)); HorizontalDivider() }

        item {
            SectionTitle(R.string.settings_section_language)
            Text(stringResource(R.string.settings_language_info), style = MaterialTheme.typography.bodyMedium)
            Spacer(Modifier.height(12.dp))
            HorizontalDivider()
        }

        item {
            SectionTitle(R.string.settings_about)
            Text(
                stringResource(R.string.settings_version, BuildConfig.VERSION_NAME),
                style = MaterialTheme.typography.bodyMedium,
            )
            Text(stringResource(R.string.settings_license), style = MaterialTheme.typography.bodyMedium)
            Text(
                text = stringResource(R.string.settings_source),
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.primary,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 4.dp)
                    .clickable {
                        context.startActivity(Intent(Intent.ACTION_VIEW, SOURCE_URL.toUri()))
                    },
            )
        }
    }
}

@Composable
private fun SectionTitle(resId: Int) {
    Text(
        text = stringResource(resId),
        style = MaterialTheme.typography.titleLarge,
        modifier = Modifier.padding(top = 8.dp, bottom = 4.dp),
    )
}

@Composable
private fun RadioRow(selected: Boolean, label: String, onClick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .selectable(selected = selected, onClick = onClick)
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        RadioButton(selected = selected, onClick = onClick)
        Spacer(Modifier.padding(horizontal = 4.dp))
        Text(label, style = MaterialTheme.typography.bodyLarge)
    }
}

private val LOCK_OPTIONS = listOf(
    SecurityPreferences.LOCK_IMMEDIATE to R.string.settings_lock_immediately,
    30 to R.string.settings_lock_30s,
    60 to R.string.settings_lock_60s,
    300 to R.string.settings_lock_5min,
    SecurityPreferences.LOCK_NEVER to R.string.settings_lock_never,
)

private val THEME_OPTIONS = listOf(
    SecurityPreferences.THEME_SYSTEM to R.string.settings_theme_system,
    SecurityPreferences.THEME_LIGHT to R.string.settings_theme_light,
    SecurityPreferences.THEME_DARK to R.string.settings_theme_dark,
)
