// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
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
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.RobotVSwitch
import de.kiefer_networks.falco.data.repo.RobotRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.theme.Spacing
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import retrofit2.HttpException
import javax.inject.Inject

data class VSwitchUiState(
    val loading: Boolean = true,
    val items: List<RobotVSwitch> = emptyList(),
    val error: String? = null,
    val noPermission: Boolean = false,
    val running: Boolean = false,
)

@HiltViewModel
class VSwitchViewModel @Inject constructor(private val repo: RobotRepo) : ViewModel() {
    private val _state = MutableStateFlow(VSwitchUiState())
    val state: StateFlow<VSwitchUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() {
        viewModelScope.launch {
            _state.value = VSwitchUiState(loading = true)
            runCatching { repo.listVSwitches() }
                .onSuccess { _state.value = VSwitchUiState(loading = false, items = it) }
                .onFailure { e ->
                    when ((e as? HttpException)?.code()) {
                        404 -> _state.value = VSwitchUiState(loading = false, items = emptyList())
                        401, 403 -> _state.value = VSwitchUiState(loading = false, noPermission = true)
                        else -> _state.value = VSwitchUiState(loading = false, error = sanitizeError(e))
                    }
                }
        }
    }

    fun create(name: String, vlan: Int) = viewModelScope.launch {
        _state.update { it.copy(running = true) }
        runCatching { repo.createVSwitch(name, vlan) }.onSuccess { refresh() }
        _state.update { it.copy(running = false) }
    }
}

@Composable
fun VSwitchTab(
    viewModel: VSwitchViewModel = hiltViewModel(),
    onVSwitchClick: (Long) -> Unit = {},
) {
    val s by viewModel.state.collectAsState()
    var createOpen by remember { mutableStateOf(false) }

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
                items(s.items, key = { it.id }) { vs ->
                    OutlinedCard(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { onVSwitchClick(vs.id) },
                    ) {
                        Column(Modifier.padding(Spacing.md)) {
                            Text(vs.name, style = MaterialTheme.typography.titleMedium)
                            Text(
                                stringResource(R.string.robot_vswitch_meta, vs.vlan, vs.id),
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                            if (vs.cancelled) {
                                Text(
                                    stringResource(R.string.robot_vswitch_cancelled),
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.error,
                                )
                            }
                        }
                    }
                }
            }
        }

        if (!s.noPermission) {
            FloatingActionButton(
                onClick = { createOpen = true },
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .padding(Spacing.md),
            ) {
                Icon(
                    Icons.Filled.Add,
                    contentDescription = stringResource(R.string.robot_vswitch_create),
                )
            }
        }
    }

    if (createOpen) {
        CreateVSwitchDialog(
            onDismiss = { createOpen = false },
            onConfirm = { name, vlan ->
                viewModel.create(name, vlan)
                createOpen = false
            },
        )
    }
}

@Composable
private fun CreateVSwitchDialog(
    onDismiss: () -> Unit,
    onConfirm: (name: String, vlan: Int) -> Unit,
) {
    var name by remember { mutableStateOf("") }
    var vlan by remember { mutableStateOf("") }
    val vlanInt = vlan.toIntOrNull()
    val vlanValid = vlanInt != null && vlanInt in 4000..4091
    val canSubmit = name.isNotBlank() && vlanValid

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.robot_vswitch_create)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(Spacing.sm)) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.robot_vswitch_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = vlan,
                    onValueChange = { v -> vlan = v.filter { it.isDigit() }.take(4) },
                    label = { Text(stringResource(R.string.robot_vswitch_vlan)) },
                    singleLine = true,
                    isError = vlan.isNotBlank() && !vlanValid,
                    keyboardOptions = KeyboardOptions(
                        keyboardType = KeyboardType.Number,
                        imeAction = ImeAction.Done,
                    ),
                    supportingText = {
                        Text(
                            if (vlan.isNotBlank() && !vlanValid) {
                                stringResource(R.string.robot_vswitch_invalid_vlan)
                            } else {
                                stringResource(R.string.robot_vswitch_vlan_hint)
                            },
                            color = if (vlan.isNotBlank() && !vlanValid) {
                                MaterialTheme.colorScheme.error
                            } else {
                                MaterialTheme.colorScheme.onSurfaceVariant
                            },
                        )
                    },
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        confirmButton = {
            Button(
                enabled = canSubmit,
                onClick = { onConfirm(name.trim(), vlanInt!!) },
            ) { Text(stringResource(R.string.robot_vswitch_create_action)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
