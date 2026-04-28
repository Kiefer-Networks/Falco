// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.accounts

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.auth.AccountSecrets
import de.kiefer_networks.falco.data.auth.HetznerAccount
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AccountsViewModel @Inject constructor(
    private val accountManager: AccountManager,
) : ViewModel() {

    val accounts: StateFlow<List<HetznerAccount>> = accountManager.accounts
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), emptyList())

    fun addAccount(name: String, secrets: AccountSecrets, onDone: () -> Unit) {
        viewModelScope.launch {
            accountManager.create(name, secrets)
            onDone()
        }
    }

    fun remove(id: String) {
        viewModelScope.launch { accountManager.remove(id) }
    }

    fun setActive(id: String) {
        viewModelScope.launch { accountManager.setActive(id) }
    }
}
