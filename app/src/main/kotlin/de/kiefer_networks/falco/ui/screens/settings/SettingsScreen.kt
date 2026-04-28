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
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.selection.selectable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Language
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.OpenInNew
import androidx.compose.material.icons.filled.Palette
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.core.net.toUri
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.BuildConfig
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.auth.HetznerAccount
import de.kiefer_networks.falco.data.auth.SecurityPreferences
import de.kiefer_networks.falco.ui.screens.welcome.LanguagePicker
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

private const val SOURCE_URL = "https://github.com/maltekiefer/falco"

data class SettingsUiState(
    val activeAccount: HetznerAccount? = null,
    val autoLockTimeout: Int = SecurityPreferences.DEFAULT_LOCK_TIMEOUT,
    val themeMode: Int = SecurityPreferences.THEME_SYSTEM,
    val locale: String = "",
)

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val accounts: AccountManager,
    private val prefs: SecurityPreferences,
) : ViewModel() {

    val state: StateFlow<SettingsUiState> = combine(
        accounts.accounts,
        accounts.activeAccountId,
        prefs.autoLockTimeoutSeconds,
        prefs.themeMode,
        prefs.appLocale,
    ) { values ->
        @Suppress("UNCHECKED_CAST")
        val accountList = values[0] as List<HetznerAccount>
        val activeId = values[1] as String?
        val lock = values[2] as Int
        val theme = values[3] as Int
        val locale = values[4] as String
        SettingsUiState(
            activeAccount = accountList.firstOrNull { it.id == activeId },
            autoLockTimeout = lock,
            themeMode = theme,
            locale = locale,
        )
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), SettingsUiState())

    fun setLockTimeout(seconds: Int) {
        viewModelScope.launch { prefs.setAutoLockTimeoutSeconds(seconds) }
    }

    fun setThemeMode(mode: Int) {
        viewModelScope.launch { prefs.setThemeMode(mode) }
    }

    fun setAppLocale(tag: String) {
        viewModelScope.launch { prefs.setAppLocale(tag) }
    }
}

@Composable
fun SettingsScreen(viewModel: SettingsViewModel = hiltViewModel()) {
    val state by viewModel.state.collectAsState()
    val context = LocalContext.current
    var languageExpanded by remember { mutableStateOf(false) }

    LazyColumn(
        modifier = Modifier.fillMaxSize().padding(horizontal = 16.dp, vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        item { SectionHeader(Icons.Filled.Person, R.string.settings_section_account) }
        item {
            ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                Column(Modifier.padding(16.dp)) {
                    Text(
                        text = state.activeAccount?.displayName ?: stringResource(R.string.accounts_empty),
                        style = MaterialTheme.typography.titleMedium,
                    )
                    Text(
                        text = stringResource(R.string.settings_active_account),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
        }

        item { SectionHeader(Icons.Filled.Lock, R.string.settings_section_security) }
        item {
            ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                Column(Modifier.padding(16.dp)) {
                    Text(
                        stringResource(R.string.settings_lock_timeout),
                        style = MaterialTheme.typography.titleMedium,
                    )
                    Spacer(Modifier.height(8.dp))
                    LOCK_OPTIONS.forEach { (value, labelRes) ->
                        RadioRow(
                            selected = state.autoLockTimeout == value,
                            label = stringResource(labelRes),
                            onClick = { viewModel.setLockTimeout(value) },
                        )
                    }
                    Spacer(Modifier.height(8.dp))
                    HorizontalDivider()
                    Spacer(Modifier.height(8.dp))
                    Text(
                        stringResource(R.string.settings_pinning_info),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }
        }

        item { SectionHeader(Icons.Filled.Palette, R.string.settings_section_appearance) }
        item {
            ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                Column(Modifier.padding(16.dp)) {
                    THEME_OPTIONS.forEach { (value, labelRes) ->
                        RadioRow(
                            selected = state.themeMode == value,
                            label = stringResource(labelRes),
                            onClick = { viewModel.setThemeMode(value) },
                        )
                    }
                }
            }
        }

        item { SectionHeader(Icons.Filled.Language, R.string.settings_section_language) }
        item {
            ElevatedCard(
                modifier = Modifier.fillMaxWidth().clickable { languageExpanded = !languageExpanded },
            ) {
                Column(Modifier.padding(16.dp)) {
                    Text(
                        text = stringResource(R.string.settings_language),
                        style = MaterialTheme.typography.titleMedium,
                    )
                    Text(
                        text = currentLocaleLabel(state.locale),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    if (languageExpanded) {
                        Spacer(Modifier.height(12.dp))
                        LanguagePicker(
                            selectedTag = state.locale,
                            onPersist = viewModel::setAppLocale,
                        )
                    }
                }
            }
        }

        item { SectionHeader(null, R.string.settings_about) }
        item {
            ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                Column(Modifier.padding(16.dp)) {
                    Text(
                        stringResource(R.string.settings_version, BuildConfig.VERSION_NAME),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    Text(
                        stringResource(R.string.settings_license),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    Spacer(Modifier.height(12.dp))
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable {
                                context.startActivity(Intent(Intent.ACTION_VIEW, SOURCE_URL.toUri()))
                            }
                            .padding(vertical = 4.dp),
                    ) {
                        Icon(
                            Icons.Filled.OpenInNew,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.size(20.dp),
                        )
                        Spacer(Modifier.size(8.dp))
                        Text(
                            stringResource(R.string.settings_source),
                            style = MaterialTheme.typography.labelLarge,
                            color = MaterialTheme.colorScheme.primary,
                        )
                    }
                }
            }
        }

        item { Spacer(Modifier.height(24.dp)) }
    }
}

@Composable
private fun SectionHeader(icon: ImageVector?, @androidx.annotation.StringRes resId: Int) {
    Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.padding(top = 12.dp, bottom = 4.dp)) {
        if (icon != null) {
            Icon(
                icon,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.primary,
                modifier = Modifier.size(20.dp),
            )
            Spacer(Modifier.size(8.dp))
        }
        Text(
            stringResource(resId),
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.primary,
        )
    }
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

@Composable
private fun currentLocaleLabel(tag: String): String = when (tag) {
    "" -> stringResource(R.string.settings_theme_system) // "Follow system"
    "en" -> "English"
    "de" -> "Deutsch"
    "es" -> "Español"
    "fr" -> "Français"
    "it" -> "Italiano"
    "zh-CN" -> "简体中文"
    "ru" -> "Русский"
    else -> tag
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
