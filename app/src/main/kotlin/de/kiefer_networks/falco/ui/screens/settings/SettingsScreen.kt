// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.settings

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.filled.Check
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.selection.selectable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.OpenInNew
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Language
import androidx.compose.material.icons.filled.Layers
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Palette
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
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

data class SettingsUiState(
    val activeAccount: HetznerAccount? = null,
    val autoLockTimeout: Int = SecurityPreferences.DEFAULT_LOCK_TIMEOUT,
    val themeMode: Int = SecurityPreferences.THEME_LIGHT,
    val accentMode: Int = SecurityPreferences.ACCENT_RED,
    val locale: String = "",
    val blockScreenshots: Boolean = true,
    val requireUnlockOnLaunch: Boolean = true,
    val aggregateProjects: Boolean = false,
    val hardwareBoundCredentials: Boolean = false,
)

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val accounts: AccountManager,
    private val prefs: SecurityPreferences,
) : ViewModel() {

    val state: StateFlow<SettingsUiState> = combine(
        listOf(
            accounts.accounts,
            accounts.activeAccountId,
            prefs.autoLockTimeoutSeconds,
            prefs.themeMode,
            prefs.appLocale,
            prefs.blockScreenshots,
            prefs.requireUnlockOnLaunch,
            prefs.accentMode,
            prefs.aggregateProjects,
            prefs.hardwareBoundCredentials,
        ),
    ) { values ->
        @Suppress("UNCHECKED_CAST")
        val accountList = values[0] as List<HetznerAccount>
        val activeId = values[1] as String?
        SettingsUiState(
            activeAccount = accountList.firstOrNull { it.id == activeId },
            autoLockTimeout = values[2] as Int,
            themeMode = values[3] as Int,
            locale = values[4] as String,
            blockScreenshots = values[5] as Boolean,
            requireUnlockOnLaunch = values[6] as Boolean,
            accentMode = values[7] as Int,
            aggregateProjects = values[8] as Boolean,
            hardwareBoundCredentials = values[9] as Boolean,
        )
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), SettingsUiState())

    fun setLockTimeout(seconds: Int) = viewModelScope.launch { prefs.setAutoLockTimeoutSeconds(seconds) }
    fun setThemeMode(mode: Int) = viewModelScope.launch { prefs.setThemeMode(mode) }
    fun setAccentMode(mode: Int) = viewModelScope.launch { prefs.setAccentMode(mode) }
    fun setAppLocale(tag: String) = viewModelScope.launch { prefs.setAppLocale(tag) }
    fun setBlockScreenshots(v: Boolean) = viewModelScope.launch { prefs.setBlockScreenshots(v) }
    fun setRequireUnlockOnLaunch(v: Boolean) = viewModelScope.launch { prefs.setRequireUnlockOnLaunch(v) }
    fun setAggregateProjects(v: Boolean) = viewModelScope.launch { prefs.setAggregateProjects(v) }
    fun setHardwareBoundCredentials(v: Boolean) = viewModelScope.launch { prefs.setHardwareBoundCredentials(v) }
}

@Composable
fun SettingsScreen(
    viewModel: SettingsViewModel = hiltViewModel(),
    onAbout: () -> Unit = {},
    onSecurity: () -> Unit = {},
    onAppearance: () -> Unit = {},
    onLanguage: () -> Unit = {},
) {
    val state by viewModel.state.collectAsState()
    val drawer = de.kiefer_networks.falco.ui.nav.LocalNavDrawer.current
    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(stringResource(R.string.nav_settings)) },
                navigationIcon = {
                    if (drawer.isCompact) {
                        IconButton(onClick = drawer::open) {
                            Icon(Icons.Filled.Menu, contentDescription = stringResource(R.string.nav_drawer_title))
                        }
                    }
                },
            )
        },
    ) { padding ->
        LazyColumn(
            modifier = Modifier.fillMaxSize().padding(padding).padding(horizontal = 16.dp, vertical = 8.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            item {
                ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                    Column(Modifier.padding(16.dp)) {
                        Text(
                            text = state.activeAccount?.displayName ?: stringResource(R.string.accounts_empty),
                            style = MaterialTheme.typography.titleMedium,
                        )
                        state.activeAccount?.description?.takeIf { it.isNotBlank() }?.let {
                            Text(
                                it,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                        }
                    }
                }
            }
            item { SectionHeader(R.string.settings_section_general) }
            item {
                NavTile(
                    icon = Icons.Filled.Palette,
                    title = stringResource(R.string.settings_section_appearance),
                    subtitle = themeLabel(state.themeMode),
                    onClick = onAppearance,
                )
            }
            item {
                NavTile(
                    icon = Icons.Filled.Language,
                    title = stringResource(R.string.settings_section_language),
                    subtitle = currentLocaleLabel(state.locale),
                    onClick = onLanguage,
                )
            }

            item { SectionHeader(R.string.settings_section_cloud) }
            item {
                OutlinedCard(modifier = Modifier.fillMaxWidth()) {
                    ToggleTile(
                        icon = Icons.Filled.Layers,
                        title = stringResource(R.string.settings_aggregate_projects),
                        subtitle = stringResource(R.string.settings_aggregate_projects_desc),
                        checked = state.aggregateProjects,
                        onChange = viewModel::setAggregateProjects,
                    )
                }
            }

            item { SectionHeader(R.string.settings_section_security) }
            item {
                NavTile(
                    icon = Icons.Filled.Shield,
                    title = stringResource(R.string.settings_section_security),
                    subtitle = stringResource(
                        R.string.settings_security_summary,
                        lockLabel(state.autoLockTimeout),
                    ),
                    onClick = onSecurity,
                )
            }

            item { SectionHeader(R.string.settings_section_about) }
            item {
                NavTile(
                    icon = Icons.Filled.Info,
                    title = stringResource(R.string.about_title),
                    subtitle = stringResource(R.string.settings_version, BuildConfig.VERSION_NAME),
                    onClick = onAbout,
                )
            }
            item { Spacer(Modifier.size(24.dp)) }
        }
    }
}

@Composable
fun SecuritySettingsScreen(
    viewModel: SettingsViewModel = hiltViewModel(),
    onBack: () -> Unit = {},
) {
    val state by viewModel.state.collectAsState()
    SubScreenScaffold(title = stringResource(R.string.settings_section_security), onBack = onBack) {
        SectionHeader(R.string.settings_section_unlock)
        OutlinedCard(modifier = Modifier.fillMaxWidth()) {
            Column {
                ToggleTile(
                    icon = Icons.Filled.Lock,
                    title = stringResource(R.string.settings_require_unlock_on_launch),
                    subtitle = stringResource(R.string.settings_require_unlock_on_launch_desc),
                    checked = state.requireUnlockOnLaunch,
                    onChange = viewModel::setRequireUnlockOnLaunch,
                )
                HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        stringResource(R.string.settings_lock_timeout),
                        style = MaterialTheme.typography.bodyLarge,
                    )
                    Text(
                        stringResource(R.string.settings_lock_timeout_desc),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Spacer(Modifier.size(8.dp))
                    val options = listOf(
                        SecurityPreferences.LOCK_IMMEDIATE to R.string.settings_lock_immediate,
                        30 to R.string.settings_lock_30s,
                        60 to R.string.settings_lock_1m,
                        300 to R.string.settings_lock_5m,
                        900 to R.string.settings_lock_15m,
                    )
                    options.forEach { (seconds, label) ->
                        RadioRow(
                            selected = state.autoLockTimeout == seconds,
                            label = stringResource(label),
                            onClick = { viewModel.setLockTimeout(seconds) },
                        )
                    }
                }
            }
        }

        SectionHeader(R.string.settings_section_privacy)
        OutlinedCard(modifier = Modifier.fillMaxWidth()) {
            Column {
                ToggleTile(
                    icon = Icons.Filled.Shield,
                    title = stringResource(R.string.settings_block_screenshots),
                    subtitle = stringResource(R.string.settings_block_screenshots_desc),
                    checked = state.blockScreenshots,
                    onChange = viewModel::setBlockScreenshots,
                )
                HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
                ToggleTile(
                    icon = Icons.Filled.Lock,
                    title = stringResource(R.string.settings_hardware_bound),
                    subtitle = stringResource(R.string.settings_hardware_bound_desc),
                    checked = state.hardwareBoundCredentials,
                    onChange = viewModel::setHardwareBoundCredentials,
                )
            }
        }

        SectionHeader(R.string.settings_section_transport)
        OutlinedCard(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(
                    stringResource(R.string.settings_pinning_title),
                    style = MaterialTheme.typography.bodyLarge,
                )
                Text(
                    stringResource(R.string.settings_pinning_info),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
    }
}

@Composable
fun AppearanceSettingsScreen(
    viewModel: SettingsViewModel = hiltViewModel(),
    onBack: () -> Unit = {},
) {
    val state by viewModel.state.collectAsState()
    SubScreenScaffold(title = stringResource(R.string.settings_section_appearance), onBack = onBack) {
        SectionHeader(R.string.settings_theme)
        OutlinedCard(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                listOf(
                    SecurityPreferences.THEME_SYSTEM to R.string.settings_theme_system,
                    SecurityPreferences.THEME_LIGHT to R.string.settings_theme_light,
                    SecurityPreferences.THEME_DARK to R.string.settings_theme_dark,
                    SecurityPreferences.THEME_OLED to R.string.settings_theme_oled,
                ).forEach { (mode, label) ->
                    RadioRow(
                        selected = state.themeMode == mode,
                        label = stringResource(label),
                        onClick = { viewModel.setThemeMode(mode) },
                    )
                }
            }
        }

        SectionHeader(R.string.settings_accent)
        OutlinedCard(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    stringResource(R.string.settings_accent_desc),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                AccentRow(state.accentMode, onPick = viewModel::setAccentMode)
            }
        }
    }
}

@Composable
private fun AccentRow(current: Int, onPick: (Int) -> Unit) {
    val accents = listOf(
        SecurityPreferences.ACCENT_RED to androidx.compose.ui.graphics.Color(0xFFD50C2D),
        SecurityPreferences.ACCENT_BLUE to androidx.compose.ui.graphics.Color(0xFF1976D2),
        SecurityPreferences.ACCENT_GREEN to androidx.compose.ui.graphics.Color(0xFF2E7D32),
        SecurityPreferences.ACCENT_PURPLE to androidx.compose.ui.graphics.Color(0xFF6A1B9A),
        SecurityPreferences.ACCENT_ORANGE to androidx.compose.ui.graphics.Color(0xFFE65100),
    )
    Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
        accents.forEach { (mode, color) ->
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .background(color, CircleShape)
                    .clickable { onPick(mode) },
                contentAlignment = Alignment.Center,
            ) {
                if (mode == current) {
                    Icon(
                        imageVector = Icons.Filled.Check,
                        contentDescription = null,
                        tint = androidx.compose.ui.graphics.Color.White,
                    )
                }
            }
        }
    }
}

@Composable
fun LanguageSettingsScreen(
    viewModel: SettingsViewModel = hiltViewModel(),
    onBack: () -> Unit = {},
) {
    val state by viewModel.state.collectAsState()
    SubScreenScaffold(title = stringResource(R.string.settings_section_language), onBack = onBack) {
        SectionHeader(R.string.settings_section_language)
        OutlinedCard(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                LanguagePicker(selectedTag = state.locale, onPersist = viewModel::setAppLocale)
            }
        }
    }
}

@Composable
private fun SubScreenScaffold(
    title: String,
    onBack: () -> Unit,
    content: @Composable () -> Unit,
) {
    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(title) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                    }
                },
            )
        },
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(horizontal = 16.dp, vertical = 8.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            content()
        }
    }
}

@Composable
private fun NavTile(
    icon: ImageVector,
    title: String,
    subtitle: String,
    onClick: () -> Unit,
) {
    OutlinedCard(modifier = Modifier.fillMaxWidth().clickable { onClick() }) {
        Row(
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 14.dp).fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Icon(
                icon,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.primary,
                modifier = Modifier.size(20.dp),
            )
            Spacer(Modifier.size(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(title, style = MaterialTheme.typography.bodyLarge)
                Text(
                    subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            Icon(
                Icons.Filled.ChevronRight,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(20.dp),
            )
        }
    }
}

@Composable
private fun ToggleTile(
    icon: ImageVector,
    title: String,
    subtitle: String,
    checked: Boolean,
    onChange: (Boolean) -> Unit,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onChange(!checked) }
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Icon(
            icon,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(20.dp),
        )
        Spacer(Modifier.size(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(title, style = MaterialTheme.typography.bodyLarge)
            Text(
                subtitle,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        Switch(checked = checked, onCheckedChange = onChange)
    }
}

@Composable
private fun SectionHeader(@androidx.annotation.StringRes resId: Int) {
    Text(
        stringResource(resId).uppercase(),
        style = MaterialTheme.typography.labelMedium,
        color = MaterialTheme.colorScheme.primary,
        modifier = Modifier.padding(top = 12.dp, bottom = 4.dp, start = 8.dp),
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

@Composable
private fun themeLabel(mode: Int): String = when (mode) {
    SecurityPreferences.THEME_LIGHT -> stringResource(R.string.settings_theme_light)
    SecurityPreferences.THEME_DARK -> stringResource(R.string.settings_theme_dark)
    else -> stringResource(R.string.settings_theme_system)
}

@Composable
private fun lockLabel(seconds: Int): String = when (seconds) {
    SecurityPreferences.LOCK_IMMEDIATE -> stringResource(R.string.settings_lock_immediate)
    30 -> stringResource(R.string.settings_lock_30s)
    60 -> stringResource(R.string.settings_lock_1m)
    300 -> stringResource(R.string.settings_lock_5m)
    900 -> stringResource(R.string.settings_lock_15m)
    else -> "${seconds}s"
}

@Composable
private fun currentLocaleLabel(tag: String): String = when (tag) {
    "" -> stringResource(R.string.settings_theme_system)
    "en" -> "English"
    "de" -> "Deutsch"
    "es" -> "Español"
    "fr" -> "Français"
    "it" -> "Italiano"
    "ru" -> "Русский"
    "zh-CN" -> "简体中文"
    else -> tag
}
