// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.compose.foundation.combinedClickable
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
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.FloatingActionButton
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
import androidx.compose.ui.text.font.FontFamily
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.RobotRdns
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

data class RobotRdnsUiState(
    val loading: Boolean = true,
    val items: List<RobotRdns> = emptyList(),
    val error: String? = null,
    val noPermission: Boolean = false,
    val running: Boolean = false,
)

@HiltViewModel
class RobotRdnsViewModel @Inject constructor(private val repo: RobotRepo) : ViewModel() {
    private val _state = MutableStateFlow(RobotRdnsUiState())
    val state: StateFlow<RobotRdnsUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = RobotRdnsUiState(loading = true)
        runCatching { repo.listRdns() }
            .onSuccess { _state.value = RobotRdnsUiState(loading = false, items = it) }
            .onFailure { e ->
                when ((e as? HttpException)?.code()) {
                    404 -> _state.value = RobotRdnsUiState(loading = false, items = emptyList())
                    401, 403 -> _state.value = RobotRdnsUiState(loading = false, noPermission = true)
                    else -> _state.value = RobotRdnsUiState(loading = false, error = sanitizeError(e))
                }
            }
    }

    fun set(ip: String, ptr: String) = viewModelScope.launch {
        _state.update { it.copy(running = true) }
        runCatching { repo.setRdns(ip, ptr) }
            .onSuccess { refresh() }
            .onFailure { e -> _state.update { it.copy(running = false, error = sanitizeError(e)) } }
    }

    fun delete(ip: String) = viewModelScope.launch {
        _state.update { it.copy(running = true) }
        runCatching { repo.deleteRdns(ip) }
            .onSuccess { refresh() }
            .onFailure { e -> _state.update { it.copy(running = false, error = sanitizeError(e)) } }
    }
}

@Composable
fun RobotRdnsTab(viewModel: RobotRdnsViewModel = hiltViewModel()) {
    val s by viewModel.state.collectAsState()
    var showCreate by remember { mutableStateOf(false) }
    var editTarget by remember { mutableStateOf<RobotRdns?>(null) }
    var deleteTarget by remember { mutableStateOf<RobotRdns?>(null) }

    Box(modifier = Modifier.fillMaxSize()) {
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
                items(s.items, key = { it.ip }) { rdns ->
                    RdnsRow(
                        rdns = rdns,
                        onEdit = { editTarget = rdns },
                        onLongPress = { deleteTarget = rdns },
                        onDeleteClick = { deleteTarget = rdns },
                    )
                }
            }
        }

        FloatingActionButton(
            onClick = { showCreate = true },
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(Spacing.md),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.robot_rdns_add))
        }
    }

    if (showCreate) {
        RdnsEditDialog(
            initialIp = "",
            initialPtr = "",
            ipEditable = true,
            title = stringResource(R.string.robot_rdns_add),
            onDismiss = { showCreate = false },
            onConfirm = { ip, ptr ->
                viewModel.set(ip.trim(), ptr.trim())
                showCreate = false
            },
        )
    }

    editTarget?.let { rdns ->
        RdnsEditDialog(
            initialIp = rdns.ip,
            initialPtr = rdns.ptr,
            ipEditable = false,
            title = stringResource(R.string.robot_rdns_edit),
            onDismiss = { editTarget = null },
            onConfirm = { ip, ptr ->
                viewModel.set(ip.trim(), ptr.trim())
                editTarget = null
            },
        )
    }

    deleteTarget?.let { rdns ->
        TypeToConfirmDeleteDialog(
            title = stringResource(R.string.robot_rdns_delete_title),
            warning = stringResource(R.string.robot_rdns_delete_warning, rdns.ip),
            confirmName = rdns.ip,
            confirmButtonLabel = stringResource(R.string.delete),
            onConfirm = {
                viewModel.delete(rdns.ip)
                deleteTarget = null
            },
            onDismiss = { deleteTarget = null },
        )
    }
}

@OptIn(androidx.compose.foundation.ExperimentalFoundationApi::class)
@Composable
private fun RdnsRow(
    rdns: RobotRdns,
    onEdit: () -> Unit,
    onLongPress: () -> Unit,
    onDeleteClick: () -> Unit,
) {
    OutlinedCard(
        modifier = Modifier
            .fillMaxWidth()
            .combinedClickable(
                onClick = onEdit,
                onLongClick = onLongPress,
            ),
    ) {
        Row(
            modifier = Modifier.padding(Spacing.md),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    rdns.ip,
                    style = MaterialTheme.typography.titleSmall,
                    fontFamily = FontFamily.Monospace,
                )
                Text(
                    rdns.ptr,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            IconButton(onClick = onDeleteClick) {
                Icon(
                    Icons.Filled.Delete,
                    contentDescription = stringResource(R.string.delete),
                    tint = MaterialTheme.colorScheme.error,
                )
            }
        }
    }
}

@Composable
private fun RdnsEditDialog(
    initialIp: String,
    initialPtr: String,
    ipEditable: Boolean,
    title: String,
    onDismiss: () -> Unit,
    onConfirm: (ip: String, ptr: String) -> Unit,
) {
    var ip by remember { mutableStateOf(initialIp) }
    var ptr by remember { mutableStateOf(initialPtr) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                OutlinedTextField(
                    value = ip,
                    onValueChange = { if (ipEditable) ip = it },
                    label = { Text(stringResource(R.string.robot_rdns_ip)) },
                    singleLine = true,
                    enabled = ipEditable,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = ptr,
                    onValueChange = { ptr = it },
                    label = { Text(stringResource(R.string.robot_rdns_ptr)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            Button(
                enabled = ip.isNotBlank() && ptr.isNotBlank(),
                onClick = { onConfirm(ip, ptr) },
            ) { Text(stringResource(R.string.save)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
