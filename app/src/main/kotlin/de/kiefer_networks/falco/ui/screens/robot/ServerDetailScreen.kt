// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.robot

import android.content.Context
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.selection.selectable
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.PowerSettingsNew
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.Build
import androidx.compose.material.icons.filled.CancelScheduleSend
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.RestartAlt
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material.icons.filled.Tag
import androidx.compose.material.icons.filled.Undo
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.components.detail.HeroCard
import de.kiefer_networks.falco.ui.components.detail.HeroStatus
import de.kiefer_networks.falco.ui.components.detail.Kpi
import de.kiefer_networks.falco.ui.components.detail.KpiStrip
import de.kiefer_networks.falco.ui.components.dialog.ActionsBottomSheetSections
import de.kiefer_networks.falco.ui.components.dialog.SheetAction
import de.kiefer_networks.falco.ui.components.dialog.SheetSection
import de.kiefer_networks.falco.ui.theme.Spacing
import androidx.compose.ui.graphics.Color
import kotlinx.coroutines.launch

@Composable
fun ServerDetailScreen(
    onBack: () -> Unit = {},
    viewModel: ServerDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val event by viewModel.events.collectAsState()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    var showResetDialog by remember { mutableStateOf(false) }
    var showWolDialog by remember { mutableStateOf(false) }
    var showRescueDialog by remember { mutableStateOf(false) }
    var showRdnsDialog by remember { mutableStateOf(false) }
    var showCancelDialog by remember { mutableStateOf(false) }
    var sheetOpen by remember { mutableStateOf(false) }
    var revealedRescuePassword by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(Unit) {
        viewModel.rescuePassword.collect { pw -> revealedRescuePassword = pw }
    }

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

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.server?.let {
                                it.serverName ?: it.serverIp ?: "#${it.serverNumber}"
                            } ?: stringResource(R.string.robot_dedis),
                            style = MaterialTheme.typography.titleMedium,
                            maxLines = 1,
                        )
                    },
                    navigationIcon = {
                        IconButton(onClick = onBack) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                        }
                    },
                )
                if (state.running) {
                    LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
                }
            }
        },
        snackbarHost = { SnackbarHost(snackbarHostState) },
    ) { padding ->
        when {
            state.loading -> Box(modifier = Modifier.padding(padding)) { LoadingState() }
            state.error != null -> Box(modifier = Modifier.padding(padding)) {
                ErrorState(message = state.error!!, onRetry = viewModel::refresh)
            }
            state.server == null -> Box(
                modifier = Modifier.fillMaxSize().padding(padding).padding(Spacing.lg),
                contentAlignment = Alignment.Center,
            ) {
                Text(stringResource(R.string.empty_list))
            }
            else -> {
                val s = state.server!!
                val ctx = LocalContext.current
                LazyColumn(
                    modifier = Modifier.fillMaxSize().padding(padding).padding(horizontal = Spacing.md, vertical = Spacing.sm),
                    verticalArrangement = Arrangement.spacedBy(Spacing.md),
                ) {
                    item {
                        HeroCard(
                            title = s.serverName ?: s.serverIp ?: "#${s.serverNumber}",
                            status = statusFor(s),
                            subtitle = listOfNotNull(s.product, s.dc).joinToString(" · "),
                        )
                    }
                    item { KpiStrip(items = kpisFor(s)) }
                    item { ActionRow(running = state.running, onActions = { sheetOpen = true }) }
                    item { SectionHeader(stringResource(R.string.server_detail_section_network)) }
                    item {
                        s.serverIp?.let {
                            CopyRow(Icons.Filled.Public, stringResource(R.string.server_public_ipv4), it, ctx)
                        }
                    }
                    item {
                        s.serverIpv6Net?.let {
                            CopyRow(Icons.Filled.Public, stringResource(R.string.robot_field_ipv6_net), it, ctx)
                        }
                    }
                    item { SectionHeader(stringResource(R.string.robot_field_status)) }
                    item {
                        DetailLine(stringResource(R.string.robot_field_status), s.status ?: "-")
                    }
                    item {
                        s.paidUntil?.let { DetailLine(stringResource(R.string.robot_field_paid_until), it) }
                    }
                    item {
                        s.traffic?.let { DetailLine(stringResource(R.string.robot_field_traffic), it) }
                    }
                    state.traffic?.let { t ->
                        item { SectionHeader(stringResource(R.string.robot_section_traffic_month)) }
                        item {
                            DetailLine(
                                stringResource(R.string.robot_traffic_in),
                                stringResource(R.string.robot_traffic_gb_format, t.inGb),
                            )
                        }
                        item {
                            DetailLine(
                                stringResource(R.string.robot_traffic_out),
                                stringResource(R.string.robot_traffic_gb_format, t.outGb),
                            )
                        }
                        item {
                            DetailLine(
                                stringResource(R.string.robot_traffic_sum),
                                stringResource(R.string.robot_traffic_gb_format, t.sumGb),
                            )
                        }
                    }
                }
            }
        }
    }

    if (sheetOpen) {
        val rescueActive = state.rescueActive
        val cancelled = state.cancellationCancelled
        ActionsBottomSheetSections(
            title = stringResource(R.string.actions_sheet_title),
            sections = listOf(
                SheetSection(
                    title = stringResource(R.string.server_section_power),
                    actions = listOf(
                        SheetAction(
                            icon = Icons.Filled.RestartAlt,
                            label = stringResource(R.string.action_reset),
                            onClick = { sheetOpen = false; showResetDialog = true },
                        ),
                        SheetAction(
                            icon = Icons.Filled.PowerSettingsNew,
                            label = stringResource(R.string.action_wol),
                            onClick = { sheetOpen = false; showWolDialog = true },
                        ),
                    ),
                ),
                SheetSection(
                    title = stringResource(R.string.server_section_state),
                    actions = listOf(
                        SheetAction(
                            icon = Icons.Filled.Build,
                            label = if (rescueActive) {
                                stringResource(R.string.server_action_rescue_disable)
                            } else {
                                stringResource(R.string.server_action_rescue_enable)
                            },
                            onClick = {
                                sheetOpen = false
                                if (rescueActive) {
                                    viewModel.disableRescue(doneMsg) { msg -> failedFmt.format(msg) }
                                } else {
                                    showRescueDialog = true
                                }
                            },
                        ),
                    ),
                ),
                SheetSection(
                    title = stringResource(R.string.server_detail_section_network),
                    actions = listOf(
                        SheetAction(
                            icon = Icons.Filled.Dns,
                            label = stringResource(R.string.server_action_reverse_dns),
                            onClick = { sheetOpen = false; showRdnsDialog = true },
                        ),
                    ),
                ),
                SheetSection(
                    title = stringResource(R.string.server_section_danger),
                    actions = listOf(
                        if (cancelled) {
                            SheetAction(
                                icon = Icons.Filled.Undo,
                                label = stringResource(R.string.server_action_cancellation_withdraw),
                                onClick = {
                                    sheetOpen = false
                                    viewModel.withdrawCancellation(doneMsg) { msg -> failedFmt.format(msg) }
                                },
                            )
                        } else {
                            SheetAction(
                                icon = Icons.Filled.CancelScheduleSend,
                                label = stringResource(R.string.server_action_cancellation),
                                onClick = { sheetOpen = false; showCancelDialog = true },
                            )
                        },
                    ),
                ),
            ),
            onDismiss = { sheetOpen = false },
        )
    }

    if (showRescueDialog) {
        var key by remember { mutableStateOf("") }
        AlertDialog(
            onDismissRequest = { showRescueDialog = false },
            title = { Text(stringResource(R.string.server_action_rescue_enable)) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(stringResource(R.string.server_rescue_caption))
                    OutlinedTextField(
                        value = key,
                        onValueChange = { key = it },
                        label = { Text(stringResource(R.string.server_rescue_authorized_key)) },
                        singleLine = true,
                    )
                }
            },
            confirmButton = {
                Button(onClick = {
                    showRescueDialog = false
                    viewModel.enableRescue(
                        authorizedKey = key.takeIf { it.isNotBlank() },
                        successMsg = doneMsg,
                        failureFmt = { msg -> failedFmt.format(msg) },
                    )
                }) { Text(stringResource(R.string.ok)) }
            },
            dismissButton = {
                TextButton(onClick = { showRescueDialog = false }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    if (showRdnsDialog) {
        val server = state.server
        var ip by remember { mutableStateOf(server?.serverIp.orEmpty()) }
        var ptr by remember { mutableStateOf("") }
        AlertDialog(
            onDismissRequest = { showRdnsDialog = false },
            title = { Text(stringResource(R.string.server_action_reverse_dns)) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    OutlinedTextField(
                        value = ip,
                        onValueChange = { ip = it },
                        label = { Text(stringResource(R.string.server_reverse_dns_ip)) },
                        singleLine = true,
                    )
                    OutlinedTextField(
                        value = ptr,
                        onValueChange = { ptr = it },
                        label = { Text(stringResource(R.string.server_reverse_dns_ptr)) },
                        singleLine = true,
                    )
                }
            },
            confirmButton = {
                Button(
                    enabled = ip.isNotBlank() && ptr.isNotBlank(),
                    onClick = {
                        showRdnsDialog = false
                        viewModel.setRdns(ip.trim(), ptr.trim(), doneMsg) { msg -> failedFmt.format(msg) }
                    },
                ) { Text(stringResource(R.string.ok)) }
            },
            dismissButton = {
                TextButton(onClick = { showRdnsDialog = false }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    if (showCancelDialog) {
        var date by remember { mutableStateOf("") }
        var reason by remember { mutableStateOf("") }
        AlertDialog(
            onDismissRequest = { showCancelDialog = false },
            title = { Text(stringResource(R.string.server_action_cancellation)) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(stringResource(R.string.server_cancellation_caption))
                    OutlinedTextField(
                        value = date,
                        onValueChange = { date = it },
                        label = { Text(stringResource(R.string.server_cancellation_date)) },
                        placeholder = { Text("YYYY-MM-DD") },
                        singleLine = true,
                    )
                    OutlinedTextField(
                        value = reason,
                        onValueChange = { reason = it },
                        label = { Text(stringResource(R.string.server_cancellation_reason)) },
                        singleLine = false,
                        minLines = 2,
                    )
                }
            },
            confirmButton = {
                Button(
                    enabled = date.isNotBlank(),
                    onClick = {
                        showCancelDialog = false
                        viewModel.cancelServer(
                            date = date.trim(),
                            reason = reason.trim().ifBlank { null },
                            successMsg = doneMsg,
                            failureFmt = { msg -> failedFmt.format(msg) },
                        )
                    },
                ) { Text(stringResource(R.string.ok)) }
            },
            dismissButton = {
                TextButton(onClick = { showCancelDialog = false }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
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

    revealedRescuePassword?.let { pw ->
        val ctx = LocalContext.current
        de.kiefer_networks.falco.ui.components.dialog.SecureRevealDialog(
            title = stringResource(R.string.server_root_password_title),
            secret = pw,
            warning = stringResource(R.string.server_root_password_warning),
            onCopy = {
                de.kiefer_networks.falco.ui.util.Clipboard.copySensitive(ctx, "rescue password", pw)
            },
            onDismiss = { revealedRescuePassword = null },
        )
    }
}

@Composable
private fun statusFor(s: RobotServer): HeroStatus? {
    val raw = s.status ?: return null
    val color = when {
        raw.equals("ready", ignoreCase = true) -> Color(0xFF2E7D32)
        s.cancelled -> MaterialTheme.colorScheme.error
        else -> MaterialTheme.colorScheme.onSurfaceVariant
    }
    return HeroStatus(label = raw, color = color)
}

@Composable
private fun kpisFor(s: RobotServer): List<Kpi> = buildList {
    add(Kpi(Icons.Filled.Tag, stringResource(R.string.robot_field_number), s.serverNumber.toString()))
    s.product?.takeIf { it.isNotBlank() }?.let {
        add(Kpi(Icons.Filled.Memory, stringResource(R.string.robot_field_product), it))
    }
    s.dc?.takeIf { it.isNotBlank() }?.let {
        add(Kpi(Icons.Filled.Storage, stringResource(R.string.robot_field_datacenter), it))
    }
}

@Composable
private fun ActionRow(running: Boolean, onActions: () -> Unit) {
    androidx.compose.material3.FilledTonalButton(
        onClick = onActions,
        enabled = !running,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Text(stringResource(R.string.actions_sheet_title))
    }
}

@Composable
private fun SectionHeader(text: String) {
    Text(
        text,
        style = MaterialTheme.typography.titleMedium,
        color = MaterialTheme.colorScheme.primary,
        modifier = Modifier.padding(top = Spacing.sm, bottom = Spacing.xs),
    )
}

@Composable
private fun DetailLine(label: String, value: String) {
    Column(modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.xs)) {
        Text(
            label,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Text(value, style = MaterialTheme.typography.bodyMedium)
    }
    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
}

@Composable
private fun CopyRow(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    label: String,
    value: String,
    ctx: Context,
) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(vertical = Spacing.xs),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Icon(
            icon,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(20.dp),
        )
        Column(modifier = Modifier.weight(1f).padding(horizontal = Spacing.sm)) {
            Text(
                label,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            Text(value, style = MaterialTheme.typography.bodyMedium)
        }
        IconButton(onClick = {
            de.kiefer_networks.falco.ui.util.Clipboard.copySensitive(ctx, label, value)
        }) {
            Icon(Icons.Filled.ContentCopy, contentDescription = stringResource(R.string.copy))
        }
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
                options.forEach { (key, labelRes) ->
                    Row(
                        Modifier
                            .fillMaxWidth()
                            .selectable(
                                selected = (selected == key),
                                onClick = { selected = key },
                            )
                            .padding(vertical = Spacing.xs),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        RadioButton(
                            selected = (selected == key),
                            onClick = { selected = key },
                        )
                        Text(
                            text = stringResource(labelRes),
                            modifier = Modifier.padding(start = Spacing.sm),
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
