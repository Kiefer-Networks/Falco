// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.settings

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.auth.HetznerAccount
import de.kiefer_networks.falco.data.auth.SecurityPreferences
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

data class SettingsUiState(
    val activeAccount: HetznerAccount? = null,
    val autoLockTimeout: Int = SecurityPreferences.DEFAULT_LOCK_TIMEOUT,
    val themeMode: Int = SecurityPreferences.THEME_SYSTEM,
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
    ) { accountList, activeId, lock, theme ->
        SettingsUiState(
            activeAccount = accountList.firstOrNull { it.id == activeId },
            autoLockTimeout = lock,
            themeMode = theme,
        )
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), SettingsUiState())

    fun setLockTimeout(seconds: Int) {
        viewModelScope.launch { prefs.setAutoLockTimeoutSeconds(seconds) }
    }

    fun setThemeMode(mode: Int) {
        viewModelScope.launch { prefs.setThemeMode(mode) }
    }
}
