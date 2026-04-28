// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.robot

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import kotlinx.coroutines.launch

@Composable
fun ServerDetailScreen(viewModel: ServerDetailViewModel = hiltViewModel()) {
    val state by viewModel.state.collectAsState()
    val event by viewModel.events.collectAsState()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    var showResetDialog by remember { mutableStateOf(false) }
    var showWolDialog by remember { mutableStateOf(false) }

    val runningMsg = stringResource(R.string.robot_action_running)
    val doneMsg = stringResource(R.string.robot_action_done)
    val failedFmt = stringResource(R.string.robot_action_failed)

    LaunchedEffect(event) {
        event?.let {
            val msg = when (it) {
                is ServerActionResult.Success -> it.message
                is ServerActionResult.Failure -> it.message
            }
            scope.launch { snackbarHostState.showSnackbar(msg) }
            viewModel.consumeEvent()
        }
    }

    Scaffold(snackbarHost = { SnackbarHost(snackbarHostState) }) { padding ->
        Box(Modifier.fillMaxSize().padding(padding)) {
            when {
                state.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
                state.error != null -> Box(
                    Modifier.fillMaxSize().padding(24.dp),
                    contentAlignment = Alignment.Center,
                ) { Text(state.error!!) }
                state.server == null -> Box(
                    Modifier.fillMaxSize().padding(24.dp),
                    contentAlignment = Alignment.Center,
                ) { Text(stringResource(R.string.empty_list)) }
                else -> {
                    val s = state.server!!
                    Column(
                        Modifier
                            .fillMaxSize()
                            .padding(16.dp)
                            .verticalScroll(rememberScrollState()),
                    ) {
                        Text(
                            s.serverName ?: s.serverIp ?: "#${s.serverNumber}",
                            style = MaterialTheme.typography.titleLarge,
                        )
                        Spacer(Modifier.height(8.dp))
                        Card(Modifier.fillMaxWidth()) {
                            Column(Modifier.padding(12.dp)) {
                                DetailRow(stringResource(R.string.robot_field_number), s.serverNumber.toString())
                                s.serverIp?.let { DetailRow(stringResource(R.string.robot_field_ip), it) }
                                s.serverIpv6Net?.let { DetailRow(stringResource(R.string.robot_field_ipv6_net), it) }
                                s.product?.let { DetailRow(stringResource(R.string.robot_field_product), it) }
                                s.dc?.let { DetailRow(stringResource(R.string.robot_field_datacenter), it) }
                                s.paidUntil?.let { DetailRow(stringResource(R.string.robot_field_paid_until), it) }
                                s.traffic?.let { DetailRow(stringResource(R.string.robot_field_traffic), it) }
                                s.status?.let { DetailRow(stringResource(R.string.robot_field_status), it) }
                            }
                        }
                        Spacer(Modifier.height(16.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            Button(
                                onClick = { showResetDialog = true },
                                enabled = !state.running,
                            ) {
                                Text(stringResource(R.string.action_reset))
                            }
                            OutlinedButton(
                                onClick = { showWolDialog = true },
                                enabled = !state.running,
                            ) {
                                Text(stringResource(R.string.action_wol))
                            }
                        }
                        if (state.running) {
                            Spacer(Modifier.height(12.dp))
                            Text(runningMsg, style = MaterialTheme.typography.bodyMedium)
                        }
                    }
                }
            }
        }
    }

    if (showResetDialog) {
        ResetDialog(
            onDismiss = { showResetDialog = false },
            onConfirm = { type ->
                showResetDialog = false
                viewModel.reset(
                    type = type,
                    successMsg = doneMsg,
                    failureFmt = { msg -> failedFmt.format(msg) },
                )
            },
        )
    }
    if (showWolDialog) {
        AlertDialog(
            onDismissRequest = { showWolDialog = false },
            title = { Text(stringResource(R.string.action_wol)) },
            text = { Text(stringResource(R.string.robot_wol_confirm)) },
            confirmButton = {
                Button(onClick = {
                    showWolDialog = false
                    viewModel.wakeOnLan(
                        successMsg = doneMsg,
                        failureFmt = { msg -> failedFmt.format(msg) },
                    )
                }) { Text(stringResource(R.string.ok)) }
            },
            dismissButton = {
                TextButton(onClick = { showWolDialog = false }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }
}

@Composable
private fun ResetDialog(
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    val options = listOf(
        "sw" to R.string.robot_reset_type_sw,
        "hw" to R.string.robot_reset_type_hw,
        "man" to R.string.robot_reset_type_man,
        "power" to R.string.robot_reset_type_power,
    )
    var selected by remember { mutableStateOf("sw") }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.robot_reset_title)) },
        text = {
            Column {
                Text(stringResource(R.string.robot_reset_message))
                Spacer(Modifier.height(8.dp))
                options.forEach { (key, labelRes) ->
                    Row(
                        Modifier
                            .fillMaxWidth()
                            .selectable(
                                selected = (selected == key),
                                onClick = { selected = key },
                            )
                            .padding(vertical = 6.dp),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        RadioButton(
                            selected = (selected == key),
                            onClick = { selected = key },
                        )
                        Spacer(Modifier.height(0.dp))
                        Text(
                            text = stringResource(labelRes),
                            modifier = Modifier.padding(start = 8.dp),
                        )
                    }
                }
            }
        },
        confirmButton = {
            Button(onClick = { onConfirm(selected) }) {
                Text(stringResource(R.string.ok))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text(stringResource(R.string.cancel))
            }
        },
    )
}

@Composable
private fun DetailRow(label: String, value: String) {
    Row(Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
        Text(
            text = label,
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.padding(end = 12.dp),
        )
        Text(text = value, style = MaterialTheme.typography.bodyMedium)
    }
}

