// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.model.ProjectAction
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.components.ActivityRow
import de.kiefer_networks.falco.ui.components.ErrorState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudActivityUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val items: List<ProjectAction> = emptyList(),
)

@HiltViewModel
class CloudActivityViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudActivityUiState())
    val state: StateFlow<CloudActivityUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.update { it.copy(loading = true, error = null) }
        runCatching { repo.listProjectActivity() }
            .onSuccess { items -> _state.update { CloudActivityUiState(loading = false, items = items) } }
            .onFailure { e -> _state.update { it.copy(loading = false, error = sanitizeError(e)) } }
    }
}

private enum class StatusFilter { ALL, RUNNING, ERROR }

/**
 * Project wide activity: the newest Hetzner actions of every resource type
 * (servers, volumes, networks, firewalls, IPs, load balancers, certificates,
 * images, storage boxes) across the selected project, or all projects in
 * aggregate mode.
 */
@Composable
fun CloudActivityScreen(
    onBack: () -> Unit,
    viewModel: CloudActivityViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    var filter by remember { mutableStateOf(StatusFilter.ALL) }
    val showProject = state.items.mapNotNull { it.projectId }.distinct().size > 1
    val visible = state.items.filter {
        when (filter) {
            StatusFilter.ALL -> true
            StatusFilter.RUNNING -> it.action.status.equals("running", ignoreCase = true)
            StatusFilter.ERROR -> it.action.status.equals("error", ignoreCase = true)
        }
    }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(stringResource(R.string.cloud_activity_title)) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                    }
                },
                actions = {
                    IconButton(onClick = { viewModel.refresh() }) {
                        Icon(Icons.Filled.Refresh, contentDescription = stringResource(R.string.refresh))
                    }
                },
            )
        },
    ) { padding ->
        Box(modifier = Modifier.fillMaxSize().padding(padding)) {
            when {
                state.error != null && state.items.isEmpty() ->
                    ErrorState(message = state.error.orEmpty(), onRetry = { viewModel.refresh() })
                else -> LazyColumn(
                    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
                ) {
                    item {
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            FilterChip(
                                selected = filter == StatusFilter.ALL,
                                onClick = { filter = StatusFilter.ALL },
                                label = { Text(stringResource(R.string.cloud_activity_filter_all)) },
                            )
                            FilterChip(
                                selected = filter == StatusFilter.RUNNING,
                                onClick = { filter = StatusFilter.RUNNING },
                                label = { Text(stringResource(R.string.cloud_activity_filter_running)) },
                            )
                            FilterChip(
                                selected = filter == StatusFilter.ERROR,
                                onClick = { filter = StatusFilter.ERROR },
                                label = { Text(stringResource(R.string.cloud_activity_filter_error)) },
                            )
                        }
                    }
                    if (state.loading) item { LinearProgressIndicator(modifier = Modifier.padding(vertical = 8.dp)) }
                    if (!state.loading && visible.isEmpty()) {
                        item {
                            Text(
                                stringResource(R.string.cloud_server_activity_empty),
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier.padding(vertical = 16.dp),
                            )
                        }
                    }
                    items(visible, key = { "${it.projectId}-${it.resourceType}-${it.action.id}" }) { item ->
                        val resource = item.action.resources.joinToString(", ") { "${it.type} #${it.id}" }
                            .ifBlank { item.resourceType }
                        ActivityRow(
                            command = item.action.command,
                            status = item.action.status,
                            started = item.action.started,
                            finished = item.action.finished,
                            subtitle = listOfNotNull(resource, item.projectName?.takeIf { showProject })
                                .joinToString(" · "),
                            errorMessage = item.action.error?.message,
                        )
                        HorizontalDivider()
                    }
                }
            }
        }
    }
}
