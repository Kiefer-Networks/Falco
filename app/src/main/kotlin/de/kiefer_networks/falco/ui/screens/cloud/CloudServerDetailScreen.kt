// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.foundation.layout.ExperimentalLayoutApi::class,
    androidx.compose.material3.ExperimentalMaterial3Api::class,
)
package de.kiefer_networks.falco.ui.screens.cloud

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Build
import androidx.compose.material.icons.filled.ContentCopy
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.PhotoCamera
import androidx.compose.material.icons.filled.PowerSettingsNew
import androidx.compose.material.icons.filled.Public
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.RestartAlt
import androidx.compose.material.icons.filled.Sell
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SecondaryTabRow
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SnackbarResult
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Tab
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.repo.MetricPeriod
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LineChart
import de.kiefer_networks.falco.ui.components.LoadingState
import kotlinx.coroutines.launch

@Composable
fun CloudServerDetailScreen(
    onBack: () -> Unit,
    viewModel: CloudServerDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val ctx = LocalContext.current

    LaunchedEffect(Unit) {
        viewModel.events.collect { ev ->
            when (ev) {
                is CloudServerEvent.Toast -> scope.launch { snackbar.showSnackbar(ev.text) }
                is CloudServerEvent.Failure -> scope.launch { snackbar.showSnackbar(ev.message) }
                is CloudServerEvent.RootPasswordRevealed -> scope.launch {
                    val res = snackbar.showSnackbar(
                        message = ctx.getString(R.string.server_rescue_root_password, ev.password),
                        actionLabel = ctx.getString(R.string.copy),
                        duration = androidx.compose.material3.SnackbarDuration.Long,
                    )
                    if (res == SnackbarResult.ActionPerformed) {
                        copyToClipboard(ctx, "root password", ev.password)
                    }
                }
            }
        }
    }

    LaunchedEffect(state.deleted) { if (state.deleted) onBack() }

    var menuOpen by remember { mutableStateOf(false) }
    var showRebuild by remember { mutableStateOf(false) }
    var showChangeType by remember { mutableStateOf(false) }
    var showIso by remember { mutableStateOf(false) }
    var showRename by remember { mutableStateOf(false) }
    var showDeleteFirst by remember { mutableStateOf(false) }
    var showDeleteFinal by remember { mutableStateOf(false) }
    var showProtection by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.server?.name ?: stringResource(R.string.cloud_servers),
                            style = MaterialTheme.typography.titleMedium,
                        )
                    },
                    navigationIcon = {
                        IconButton(onClick = onBack) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                        }
                    },
                    actions = {
                        IconButton(onClick = viewModel::refresh) {
                            Icon(Icons.Filled.Refresh, contentDescription = stringResource(R.string.refresh))
                        }
                        Box {
                            IconButton(onClick = { menuOpen = true }) {
                                Icon(Icons.Filled.MoreVert, contentDescription = null)
                            }
                            DropdownMenu(expanded = menuOpen, onDismissRequest = { menuOpen = false }) {
                                DropdownMenuItem(
                                    text = { Text(stringResource(R.string.server_action_rename)) },
                                    onClick = { menuOpen = false; showRename = true },
                                )
                                DropdownMenuItem(
                                    text = { Text(stringResource(R.string.server_action_rebuild)) },
                                    leadingIcon = { Icon(Icons.Filled.Build, contentDescription = null) },
                                    onClick = {
                                        menuOpen = false
                                        viewModel.loadImages()
                                        showRebuild = true
                                    },
                                )
                                DropdownMenuItem(
                                    text = { Text(stringResource(R.string.server_action_change_type)) },
                                    onClick = {
                                        menuOpen = false
                                        viewModel.loadServerTypes()
                                        showChangeType = true
                                    },
                                )
                                DropdownMenuItem(
                                    text = { Text(stringResource(R.string.server_action_iso_attach)) },
                                    onClick = {
                                        menuOpen = false
                                        viewModel.loadIsos()
                                        showIso = true
                                    },
                                )
                                if (state.server?.iso != null) {
                                    DropdownMenuItem(
                                        text = { Text(stringResource(R.string.server_action_iso_detach)) },
                                        onClick = {
                                            menuOpen = false
                                            viewModel.detachIso()
                                        },
                                    )
                                }
                                DropdownMenuItem(
                                    text = { Text(stringResource(R.string.server_action_protection)) },
                                    leadingIcon = { Icon(Icons.Filled.Shield, contentDescription = null) },
                                    onClick = { menuOpen = false; showProtection = true },
                                )
                                HorizontalDivider()
                                DropdownMenuItem(
                                    text = {
                                        Text(
                                            stringResource(R.string.server_action_delete),
                                            color = MaterialTheme.colorScheme.error,
                                        )
                                    },
                                    leadingIcon = {
                                        Icon(
                                            Icons.Filled.Delete,
                                            contentDescription = null,
                                            tint = MaterialTheme.colorScheme.error,
                                        )
                                    },
                                    onClick = { menuOpen = false; showDeleteFirst = true },
                                )
                            }
                        }
                    },
                )
                if (state.running) LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
            }
        },
        snackbarHost = { SnackbarHost(snackbar) },
    ) { padding ->
        when {
            state.loading -> Box(modifier = Modifier.padding(padding)) { LoadingState() }
            state.error != null -> Box(modifier = Modifier.padding(padding)) {
                ErrorState(message = state.error!!, onRetry = viewModel::refresh)
            }
            else -> {
                val server = state.server ?: return@Scaffold
                LazyColumn(
                    modifier = Modifier.fillMaxSize().padding(padding).padding(horizontal = 12.dp, vertical = 8.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp),
                ) {
                    item { OverviewCard(server) }
                    item { PowerActionsRow(server, viewModel) }
                    item {
                        ElevatedCard(modifier = Modifier.fillMaxWidth()) {
                            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                                SectionTitle(R.string.server_section_metrics)
                                PeriodTabs(state.period, viewModel::setPeriod)
                                MetricBlock(
                                    titleRes = R.string.metrics_cpu,
                                    state = state.cpuMetrics,
                                    unit = stringResource(R.string.metrics_unit_percent),
                                    capMaxY = 100.0,
                                )
                                MetricBlock(
                                    titleRes = R.string.metrics_disk,
                                    state = state.diskMetrics,
                                    unit = stringResource(R.string.metrics_unit_iops),
                                )
                                MetricBlock(
                                    titleRes = R.string.metrics_network,
                                    state = state.networkMetrics,
                                    unit = stringResource(R.string.metrics_unit_mbps),
                                )
                            }
                        }
                    }
                    item { ToggleSettingsCard(server, viewModel) }
                }
            }
        }
    }

    if (showRebuild) {
        RebuildDialog(
            images = state.imageOptions,
            currentImage = state.server?.image,
            onDismiss = { showRebuild = false },
            onRebuild = { id ->
                viewModel.rebuild(id)
                showRebuild = false
            },
        )
    }
    if (showChangeType) {
        ChangeTypeDialog(
            types = state.typeOptions,
            currentType = state.server?.serverType?.name,
            onDismiss = { showChangeType = false },
            onConfirm = { type, upgradeDisk ->
                viewModel.changeType(type, upgradeDisk)
                showChangeType = false
            },
        )
    }
    if (showIso) {
        IsoPickerDialog(
            isos = state.isoOptions,
            onDismiss = { showIso = false },
            onAttach = { isoName ->
                viewModel.attachIso(isoName)
                showIso = false
            },
        )
    }
    if (showRename) {
        RenameDialog(
            current = state.server?.name.orEmpty(),
            onDismiss = { showRename = false },
            onConfirm = { newName ->
                viewModel.rename(newName)
                showRename = false
            },
        )
    }
    if (showProtection) {
        ProtectionDialog(
            current = state.server?.protection,
            onDismiss = { showProtection = false },
            onApply = { del, reb ->
                viewModel.setProtection(delete = del, rebuild = reb)
                showProtection = false
            },
        )
    }
    if (showDeleteFirst) {
        AlertDialog(
            onDismissRequest = { showDeleteFirst = false },
            title = { Text(stringResource(R.string.server_delete_title)) },
            text = { Text(stringResource(R.string.server_delete_warning)) },
            confirmButton = {
                TextButton(onClick = { showDeleteFirst = false; showDeleteFinal = true }) {
                    Text(
                        stringResource(R.string.server_delete_button),
                        color = MaterialTheme.colorScheme.error,
                    )
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteFirst = false }) { Text(stringResource(R.string.cancel)) }
            },
        )
    }
    if (showDeleteFinal) {
        var typed by remember { mutableStateOf("") }
        val name = state.server?.name.orEmpty()
        AlertDialog(
            onDismissRequest = { showDeleteFinal = false },
            title = { Text(stringResource(R.string.server_delete_title)) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(stringResource(R.string.server_delete_type_to_confirm, name))
                    OutlinedTextField(
                        value = typed,
                        onValueChange = { typed = it },
                        singleLine = true,
                    )
                }
            },
            confirmButton = {
                TextButton(
                    enabled = typed == name && name.isNotBlank(),
                    onClick = {
                        viewModel.delete()
                        showDeleteFinal = false
                    },
                ) {
                    Text(
                        stringResource(R.string.server_delete_button),
                        color = MaterialTheme.colorScheme.error,
                    )
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteFinal = false }) { Text(stringResource(R.string.cancel)) }
            },
        )
    }
}

@Composable
private fun OverviewCard(server: CloudServer) {
    val ctx = LocalContext.current
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Surface(
                    shape = CircleShape,
                    color = statusDotColor(server.status),
                    modifier = Modifier.size(12.dp),
                ) {}
                Spacer(Modifier.width(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(server.name, style = MaterialTheme.typography.titleMedium)
                    Text(
                        server.status,
                        style = MaterialTheme.typography.bodySmall,
                        color = statusDotColor(server.status),
                    )
                }
                if (server.protection?.delete == true) {
                    Icon(
                        Icons.Filled.Shield,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.tertiary,
                        modifier = Modifier.size(20.dp),
                    )
                }
            }
            server.serverType?.let { st ->
                FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    SpecChip(Icons.Filled.Settings, "${st.cores} ${if (st.cores == 1) "core" else "cores"}")
                    SpecChip(Icons.Filled.Memory, "${formatGb(st.memory)} RAM")
                    SpecChip(Icons.Filled.Storage, "${st.disk} GB")
                    SpecChip(Icons.Filled.Sell, st.name)
                }
            }
            HorizontalDivider()
            server.publicNet?.ipv4?.ip?.let {
                CopyRow(Icons.Filled.Public, "Public IPv4", it, ctx)
            }
            server.publicNet?.ipv6?.ip?.let {
                CopyRow(Icons.Filled.Public, "Public IPv6", it, ctx)
            }
            val loc = listOfNotNull(
                server.datacenter?.name,
                server.datacenter?.location?.city,
                server.datacenter?.location?.country,
            ).joinToString(" · ")
            if (loc.isNotBlank()) {
                Property(Icons.Filled.LocationOn, "Datacenter", loc)
            }
            server.image?.let { img ->
                Property(
                    Icons.Filled.Build,
                    "Image",
                    listOfNotNull(img.name, img.description).joinToString(" · "),
                )
            }
            FlowRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                if (server.rescueEnabled) {
                    AssistChip(onClick = {}, label = { Text("rescue") })
                }
                server.iso?.let {
                    AssistChip(onClick = {}, label = { Text("ISO: ${it.name}") })
                }
                if (server.backupWindow != null) {
                    AssistChip(
                        onClick = {},
                        label = { Text("backup: ${server.backupWindow}") },
                    )
                }
            }
        }
    }
}

@Composable
private fun PowerActionsRow(server: CloudServer, vm: CloudServerDetailViewModel) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            SectionTitle(R.string.server_section_actions)
            FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                ActionChip(Icons.Filled.RestartAlt, stringResource(R.string.action_reboot), vm::reboot)
                if (server.status == "running") {
                    ActionChip(Icons.Filled.PowerSettingsNew, stringResource(R.string.action_shutdown), vm::shutdown)
                    ActionChip(Icons.Filled.PowerSettingsNew, stringResource(R.string.action_power_off), vm::powerOff)
                } else {
                    ActionChip(Icons.Filled.PowerSettingsNew, stringResource(R.string.action_power_on), vm::powerOn)
                }
                ActionChip(Icons.Filled.RestartAlt, stringResource(R.string.action_reset), vm::reset)
                ActionChip(Icons.Filled.PhotoCamera, stringResource(R.string.action_snapshot), vm::snapshot)
            }
        }
    }
}

@Composable
private fun ToggleSettingsCard(server: CloudServer, vm: CloudServerDetailViewModel) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            ToggleRow(
                label = if (server.backupWindow != null) {
                    stringResource(R.string.server_action_backup_disable)
                } else {
                    stringResource(R.string.server_action_backup_enable)
                },
                checked = server.backupWindow != null,
                onCheckedChange = vm::setBackup,
            )
            ToggleRow(
                label = if (server.rescueEnabled) {
                    stringResource(R.string.server_action_rescue_disable)
                } else {
                    stringResource(R.string.server_action_rescue_enable)
                },
                checked = server.rescueEnabled,
                onCheckedChange = { vm.setRescue(it) },
            )
        }
    }
}

@Composable
private fun ToggleRow(label: String, checked: Boolean, onCheckedChange: (Boolean) -> Unit) {
    Row(modifier = Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        Text(label, modifier = Modifier.weight(1f), style = MaterialTheme.typography.bodyMedium)
        Switch(checked = checked, onCheckedChange = onCheckedChange)
    }
}

@Composable
private fun PeriodTabs(period: MetricPeriod, onChange: (MetricPeriod) -> Unit) {
    val periods = listOf(
        MetricPeriod.H1 to R.string.metrics_period_1h,
        MetricPeriod.H24 to R.string.metrics_period_24h,
        MetricPeriod.D7 to R.string.metrics_period_7d,
        MetricPeriod.D30 to R.string.metrics_period_30d,
    )
    SecondaryTabRow(selectedTabIndex = periods.indexOfFirst { it.first == period }) {
        periods.forEach { (p, label) ->
            Tab(selected = p == period, onClick = { onChange(p) }, text = { Text(stringResource(label)) })
        }
    }
}

@Composable
private fun MetricBlock(
    titleRes: Int,
    state: MetricLoadState,
    unit: String,
    capMaxY: Double? = null,
) {
    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
        Text(stringResource(titleRes), style = MaterialTheme.typography.titleSmall)
        when (state) {
            MetricLoadState.Loading -> Box(
                modifier = Modifier.fillMaxWidth().padding(8.dp),
                contentAlignment = Alignment.Center,
            ) {
                Text("…", color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
            is MetricLoadState.Failed -> Text(
                state.message,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.error,
            )
            is MetricLoadState.Loaded -> {
                val series = state.series.series.values.firstOrNull().orEmpty()
                if (series.isEmpty()) {
                    Text(
                        "—",
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        style = MaterialTheme.typography.bodySmall,
                    )
                } else {
                    val values = series.map { it.second }
                    Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                        Text(
                            "${stringResource(R.string.metrics_min)}: %.1f%s".format(values.min(), unit),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        Text(
                            "${stringResource(R.string.metrics_max)}: %.1f%s".format(values.max(), unit),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        Text(
                            "${stringResource(R.string.metrics_avg)}: %.1f%s".format(values.average(), unit),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    LineChart(
                        points = series,
                        unit = unit,
                        maxY = capMaxY,
                    )
                }
            }
        }
    }
}

@Composable
private fun SectionTitle(@androidx.annotation.StringRes resId: Int) {
    Text(
        stringResource(resId),
        style = MaterialTheme.typography.titleMedium,
        color = MaterialTheme.colorScheme.primary,
    )
}

@Composable
private fun SpecChip(icon: ImageVector, label: String) {
    AssistChip(
        onClick = {},
        leadingIcon = { Icon(icon, contentDescription = null, modifier = Modifier.size(AssistChipDefaults.IconSize)) },
        label = { Text(label, style = MaterialTheme.typography.labelMedium) },
    )
}

@Composable
private fun ActionChip(icon: ImageVector, label: String, onClick: () -> Unit) {
    AssistChip(
        onClick = onClick,
        leadingIcon = { Icon(icon, contentDescription = null, modifier = Modifier.size(AssistChipDefaults.IconSize)) },
        label = { Text(label) },
    )
}

@Composable
private fun Property(icon: ImageVector, label: String, value: String) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Icon(icon, contentDescription = null, tint = MaterialTheme.colorScheme.primary, modifier = Modifier.size(18.dp))
        Spacer(Modifier.width(10.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(label, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Text(value, style = MaterialTheme.typography.bodyMedium)
        }
    }
}

@Composable
private fun CopyRow(icon: ImageVector, label: String, value: String, ctx: Context) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier
            .fillMaxWidth()
            .clickable { copyToClipboard(ctx, label, value) }
            .padding(vertical = 2.dp),
    ) {
        Icon(icon, contentDescription = null, tint = MaterialTheme.colorScheme.primary, modifier = Modifier.size(18.dp))
        Spacer(Modifier.width(10.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(label, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Text(value, style = MaterialTheme.typography.bodyMedium, fontFamily = FontFamily.Monospace)
        }
        Icon(
            Icons.Filled.ContentCopy,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.onSurfaceVariant,
            modifier = Modifier.size(18.dp),
        )
    }
}

@Composable
private fun RenameDialog(current: String, onDismiss: () -> Unit, onConfirm: (String) -> Unit) {
    var name by remember { mutableStateOf(current) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.server_action_rename)) },
        text = {
            OutlinedTextField(value = name, onValueChange = { name = it }, singleLine = true)
        },
        confirmButton = {
            TextButton(enabled = name.isNotBlank() && name != current, onClick = { onConfirm(name) }) {
                Text(stringResource(R.string.ok))
            }
        },
        dismissButton = { TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) } },
    )
}

@Composable
private fun ProtectionDialog(
    current: de.kiefer_networks.falco.data.dto.CloudServerProtection?,
    onDismiss: () -> Unit,
    onApply: (delete: Boolean?, rebuild: Boolean?) -> Unit,
) {
    var delete by remember { mutableStateOf(current?.delete == true) }
    var rebuild by remember { mutableStateOf(current?.rebuild == true) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.server_action_protection)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                ToggleRow(label = stringResource(R.string.server_action_delete), checked = delete, onCheckedChange = { delete = it })
                ToggleRow(label = stringResource(R.string.server_action_rebuild), checked = rebuild, onCheckedChange = { rebuild = it })
            }
        },
        confirmButton = {
            TextButton(onClick = { onApply(delete, rebuild) }) { Text(stringResource(R.string.ok)) }
        },
        dismissButton = { TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) } },
    )
}

private fun copyToClipboard(context: Context, label: String, value: String) {
    val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    cm.setPrimaryClip(ClipData.newPlainText(label, value))
}

private fun statusDotColor(status: String): Color = when (status.lowercase()) {
    "running" -> Color(0xFF2E7D32)
    "starting", "initializing", "rebuilding", "migrating" -> Color(0xFFEF6C00)
    "stopping", "off", "deleting" -> Color(0xFF6D4C41)
    else -> Color(0xFF9E9E9E)
}

private fun formatGb(memory: Double): String =
    if (memory % 1.0 == 0.0) "${memory.toInt()} GB" else "%.1f GB".format(memory)
