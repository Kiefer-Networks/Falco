// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.RobotFailover
import de.kiefer_networks.falco.data.repo.RobotRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.components.dialog.TypeToConfirmDeleteDialog
import de.kiefer_networks.falco.ui.theme.Spacing
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import retrofit2.HttpException
import javax.inject.Inject

data class FailoverUiState(
    val loading: Boolean = true,
    val items: List<RobotFailover> = emptyList(),
    val error: String? = null,
    val noPermission: Boolean = false,
    val running: Boolean = false,
)

@HiltViewModel
class FailoverViewModel @Inject constructor(private val repo: RobotRepo) : ViewModel() {
    private val _state = MutableStateFlow(FailoverUiState())
    val state: StateFlow<FailoverUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = FailoverUiState(loading = true)
            runCatching { repo.listFailoverIps() }
                .onSuccess { _state.value = FailoverUiState(loading = false, items = it) }
                .onFailure { e ->
                    when ((e as? HttpException)?.code()) {
                        404 -> _state.value = FailoverUiState(loading = false, items = emptyList())
                        401, 403 -> _state.value = FailoverUiState(loading = false, noPermission = true)
                        else -> _state.value = FailoverUiState(loading = false, error = sanitizeError(e))
                    }
                }
        }
    }

    fun route(failoverIp: String, targetServerIp: String) = viewModelScope.launch {
        _state.update { it.copy(running = true) }
        runCatching { repo.routeFailover(failoverIp, targetServerIp) }
            .onSuccess { refresh() }
            .onFailure { e -> _state.update { it.copy(running = false, error = sanitizeError(e)) } }
    }

    fun unroute(failoverIp: String) = viewModelScope.launch {
        _state.update { it.copy(running = true) }
        runCatching { repo.unrouteFailover(failoverIp) }
            .onSuccess { refresh() }
            .onFailure { e -> _state.update { it.copy(running = false, error = sanitizeError(e)) } }
    }
}

@Composable
fun FailoverTab(viewModel: FailoverViewModel = hiltViewModel()) {
    val s by viewModel.state.collectAsState()
    var routeTarget by remember { mutableStateOf<RobotFailover?>(null) }
    var unrouteTarget by remember { mutableStateOf<RobotFailover?>(null) }

    when {
        s.loading -> LoadingState()
        s.noPermission -> Box(
            modifier = Modifier.fillMaxSize().padding(Spacing.lg),
            contentAlignment = Alignment.Center,
        ) {
            Text(
                stringResource(R.string.robot_no_permission),
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
        s.error != null -> ErrorState(message = s.error!!, onRetry = viewModel::refresh)
        s.items.isEmpty() -> Box(
            modifier = Modifier.fillMaxSize().padding(Spacing.lg),
            contentAlignment = Alignment.Center,
        ) {
            Text(stringResource(R.string.empty_list))
        }
        else -> LazyColumn(
            modifier = Modifier.fillMaxSize().padding(Spacing.md),
            verticalArrangement = Arrangement.spacedBy(Spacing.sm),
        ) {
            items(s.items, key = { it.ip }) { fo ->
                FailoverRow(
                    fo = fo,
                    onRoute = { routeTarget = fo },
                    onUnroute = { unrouteTarget = fo },
                )
            }
        }
    }

    routeTarget?.let { fo ->
        RouteDialog(
            failoverIp = fo.ip,
            currentTarget = fo.activeServerIp,
            onDismiss = { routeTarget = null },
            onConfirm = { target ->
                viewModel.route(fo.ip, target.trim())
                routeTarget = null
            },
        )
    }

    unrouteTarget?.let { fo ->
        TypeToConfirmDeleteDialog(
            title = stringResource(R.string.robot_failover_route_unroute_title),
            warning = stringResource(R.string.robot_failover_route_unroute_warning, fo.ip),
            confirmName = fo.ip,
            confirmButtonLabel = stringResource(R.string.robot_failover_route_unroute_confirm),
            onConfirm = {
                viewModel.unroute(fo.ip)
                unrouteTarget = null
            },
            onDismiss = { unrouteTarget = null },
        )
    }
}

@Composable
private fun FailoverRow(
    fo: RobotFailover,
    onRoute: () -> Unit,
    onUnroute: () -> Unit,
) {
    var menuOpen by remember { mutableStateOf(false) }
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(Spacing.md),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.fillMaxWidth().weight(1f)) {
                Text(fo.ip, style = MaterialTheme.typography.titleMedium)
                Text(
                    "→ #${fo.serverNumber} (${fo.serverIp})",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Text(
                    stringResource(R.string.robot_failover_active_on, fo.activeServerIp),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.primary,
                )
            }
            Box {
                IconButton(onClick = { menuOpen = true }) {
                    Icon(
                        Icons.Filled.MoreVert,
                        contentDescription = stringResource(R.string.robot_failover_route_actions),
                    )
                }
                DropdownMenu(
                    expanded = menuOpen,
                    onDismissRequest = { menuOpen = false },
                ) {
                    DropdownMenuItem(
                        text = { Text(stringResource(R.string.robot_failover_route_to)) },
                        onClick = {
                            menuOpen = false
                            onRoute()
                        },
                    )
                    DropdownMenuItem(
                        text = {
                            Text(
                                stringResource(R.string.robot_failover_route_unroute),
                                color = MaterialTheme.colorScheme.error,
                            )
                        },
                        onClick = {
                            menuOpen = false
                            onUnroute()
                        },
                    )
                }
            }
        }
    }
}

@Composable
private fun RouteDialog(
    failoverIp: String,
    currentTarget: String,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    var target by remember { mutableStateOf(currentTarget) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.robot_failover_route_dialog_title)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                Text(
                    stringResource(R.string.robot_failover_route_dialog_caption, failoverIp),
                    style = MaterialTheme.typography.bodyMedium,
                )
                OutlinedTextField(
                    value = target,
                    onValueChange = { target = it },
                    label = { Text(stringResource(R.string.robot_failover_route_target_ip)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            Button(
                enabled = target.isNotBlank() && target.trim() != currentTarget,
                onClick = { onConfirm(target) },
            ) { Text(stringResource(R.string.ok)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
