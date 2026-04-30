// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.auth.HetznerAccount
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

data class AccountsBarState(
    val accounts: List<HetznerAccount> = emptyList(),
    val activeAccount: HetznerAccount? = null,
)

@HiltViewModel
class FalcoRootViewModel @Inject constructor(
    private val accounts: AccountManager,
) : ViewModel() {
    init {
        viewModelScope.launch {
            val list = accounts.accounts.first()
            val activeId = accounts.activeAccountId.first()
            if (list.isNotEmpty() && (activeId.isNullOrBlank() || list.none { it.id == activeId })) {
                val defaultId = accounts.defaultAccountId.first()
                val pick = list.firstOrNull { it.id == defaultId } ?: list.first()
                accounts.setActive(pick.id)
            }
        }
    }

    val hasAccount: StateFlow<Boolean> = accounts.accounts
        .map { it.isNotEmpty() }
        .stateIn(viewModelScope, SharingStarted.Eagerly, false)

    val accountsBar: StateFlow<AccountsBarState> = combine(
        accounts.accounts,
        accounts.activeAccountId,
    ) { list, activeId ->
        AccountsBarState(
            accounts = list,
            activeAccount = list.firstOrNull { it.id == activeId } ?: list.firstOrNull(),
        )
    }.stateIn(viewModelScope, SharingStarted.Eagerly, AccountsBarState())

    fun switchAccount(id: String) {
        viewModelScope.launch { accounts.setActive(id) }
    }
}
