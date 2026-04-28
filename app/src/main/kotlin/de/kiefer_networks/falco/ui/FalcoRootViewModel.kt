// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.auth.AccountManager
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import javax.inject.Inject

@HiltViewModel
class FalcoRootViewModel @Inject constructor(
    accounts: AccountManager,
) : ViewModel() {
    val hasAccount: StateFlow<Boolean> = accounts.accounts
        .map { it.isNotEmpty() }
        .stateIn(viewModelScope, SharingStarted.Eagerly, false)
}
