// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.model.CloudProject
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

data class ProjectsUiState(
    val accountId: String? = null,
    val projects: List<CloudProject> = emptyList(),
    val activeProjectId: String? = null,
    val aggregateProjects: Boolean = false,
)

@HiltViewModel
class ProjectsViewModel @Inject constructor(
    private val accountManager: AccountManager,
    private val securityPreferences: de.kiefer_networks.falco.data.auth.SecurityPreferences,
) : ViewModel() {

    val state: StateFlow<ProjectsUiState> = combine(
        accountManager.activeAccountId,
        accountManager.accounts,
        accountManager.activeCloudProject,
        securityPreferences.aggregateProjects,
    ) { activeId, accounts, activeProject, aggregate ->
        val account = accounts.firstOrNull { it.id == activeId }
        val projects = if (account == null) emptyList() else accountManager.cloudProjects(account.id)
        ProjectsUiState(
            accountId = account?.id,
            projects = projects,
            activeProjectId = activeProject?.id ?: account?.activeCloudProjectId,
            aggregateProjects = aggregate,
        )
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), ProjectsUiState())

    fun setActive(projectId: String) {
        val accountId = state.value.accountId ?: return
        viewModelScope.launch { accountManager.setActiveCloudProject(accountId, projectId) }
    }

    fun add(project: CloudProject, onDone: () -> Unit = {}) {
        val accountId = state.value.accountId ?: return
        viewModelScope.launch {
            accountManager.addCloudProject(accountId, project)
            onDone()
        }
    }

    fun update(project: CloudProject, onDone: () -> Unit = {}) {
        val accountId = state.value.accountId ?: return
        viewModelScope.launch {
            accountManager.updateCloudProject(accountId, project)
            onDone()
        }
    }

    fun remove(projectId: String) {
        val accountId = state.value.accountId ?: return
        viewModelScope.launch { accountManager.removeCloudProject(accountId, projectId) }
    }

    suspend fun projectById(id: String): CloudProject? {
        val accountId = state.value.accountId ?: return null
        return accountManager.cloudProjects(accountId).firstOrNull { it.id == id }
    }
}
