// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.welcome

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.auth.SecurityPreferences
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class OnboardingViewModel @Inject constructor(
    private val prefs: SecurityPreferences,
) : ViewModel() {

    val locale: StateFlow<String> = prefs.appLocale
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), "")

    fun setLocale(tag: String) {
        viewModelScope.launch { prefs.setAppLocale(tag) }
    }
}
