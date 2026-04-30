// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.foundation.layout.ExperimentalLayoutApi::class,
    androidx.compose.material3.ExperimentalMaterial3Api::class,
)
package de.kiefer_networks.falco.ui.screens.cloud

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
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Security
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.AssistChip
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
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
import de.kiefer_networks.falco.data.dto.CloudFirewall
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.FirewallApplication
import de.kiefer_networks.falco.data.dto.FirewallRule
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import de.kiefer_networks.falco.ui.components.dialog.ActionsBottomSheetSections
import de.kiefer_networks.falco.ui.components.dialog.SheetAction
import de.kiefer_networks.falco.ui.components.dialog.SheetSection
import kotlinx.coroutines.launch

@Composable
fun CloudFirewallDetailScreen(
    onBack: () -> Unit,
    viewModel: CloudFirewallDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        viewModel.events.collect { event ->
            val text = when (event) {
                is FirewallEvent.Toast -> event.text
                is FirewallEvent.Failure -> event.message
            }
            scope.launch { snackbar.showSnackbar(text) }
        }
    }

    LaunchedEffect(state.deleted) {
        if (state.deleted) onBack()
    }

    var sheetOpen by remember { mutableStateOf(false) }
    var renameOpen by remember { mutableStateOf(false) }
    var deleteOpen by remember { mutableStateOf(false) }
    var editingRule by remember { mutableStateOf<RuleEdit?>(null) }
    var pendingRuleDelete by remember { mutableStateOf<FirewallRule?>(null) }
    var pendingDetach by remember { mutableStateOf<Long?>(null) }
    var applyOpen by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.firewall?.name ?: stringResource(R.string.cloud_firewalls),
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
                            Icon(Icons.Filled.Refresh, contentDescription = null)
                        }
                        FilledTonalButton(
                            onClick = { sheetOpen = true },
                            modifier = Modifier.padding(end = 8.dp),
                        ) {
                            Text(stringResource(R.string.actions_sheet_title))
                        }
                    },
                )
                if (state.running) {
                    LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
                }
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
                val fw = state.firewall ?: return@Scaffold
                LazyColumn(
                    modifier = Modifier.fillMaxSize().padding(padding).padding(horizontal = 12.dp, vertical = 8.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp),
                ) {
                    item {
                        OverviewCard(
                            fw = fw,
                            onAppliedClick = {
                                viewModel.loadServers()
                                applyOpen = true
                            },
                        )
                    }

                    item { SectionHeader(stringResource(R.string.firewall_section_rules)) }
                    item {
                        AddRowButton(
                            label = stringResource(R.string.firewall_rule_new),
                            onClick = { editingRule = RuleEdit(original = null) },
                        )
                    }
                    if (fw.rules.isEmpty()) {
                        item { EmptyHint(stringResource(R.string.firewall_no_rules)) }
                    } else {
                        items(fw.rules) { rule ->
                            RuleCard(
                                rule = rule,
                                onEdit = { editingRule = RuleEdit(original = rule) },
                                onDelete = { pendingRuleDelete = rule },
                            )
                        }
                    }

                    item { SectionHeader(stringResource(R.string.firewall_section_attached)) }
                    item {
                        AddRowButton(
                            label = stringResource(R.string.firewall_apply_title),
                            onClick = {
                                viewModel.loadServers()
                                applyOpen = true
                            },
                        )
                    }
                    if (fw.appliedTo.isEmpty()) {
                        item { EmptyHint(stringResource(R.string.firewall_no_attached)) }
                    } else {
                        items(fw.appliedTo) { app ->
                            AppliedRow(
                                application = app,
                                serverName = state.servers.firstOrNull { it.id == app.server?.id }?.name,
                                onDetach = { app.server?.id?.let { pendingDetach = it } },
                            )
                        }
                    }
                }
            }
        }
    }

    if (sheetOpen) {
        ActionsBottomSheetSections(
            title = stringResource(R.string.actions_sheet_title),
            sections = listOf(
                SheetSection(
                    title = stringResource(R.string.server_detail_section_settings),
                    actions = listOf(
                        SheetAction(Icons.Filled.Edit, stringResource(R.string.firewall_action_rename)) {
                            sheetOpen = false; renameOpen = true
                        },
                    ),
                ),
                SheetSection(
                    title = stringResource(R.string.server_section_danger),
                    actions = listOf(
                        SheetAction(
                            icon = Icons.Filled.Delete,
                            label = stringResource(R.string.delete),
                            destructive = true,
                        ) { sheetOpen = false; deleteOpen = true },
                    ),
                ),
            ),
            onDismiss = { sheetOpen = false },
        )
    }

    if (renameOpen) {
        TextPromptDialog(
            title = stringResource(R.string.firewall_action_rename),
            label = stringResource(R.string.cloud_firewalls),
            initial = state.firewall?.name.orEmpty(),
            optional = false,
            onDismiss = { renameOpen = false },
            onConfirm = {
                viewModel.rename(it)
                renameOpen = false
            },
        )
    }

    if (deleteOpen) {
        AlertDialog(
            onDismissRequest = { deleteOpen = false },
            title = { Text(stringResource(R.string.firewall_delete_title)) },
            text = { Text(stringResource(R.string.firewall_delete_warning, state.firewall?.name.orEmpty())) },
            confirmButton = {
                TextButton(
                    onClick = {
                        deleteOpen = false
                        viewModel.delete()
                    },
                ) {
                    Text(stringResource(R.string.delete), color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { deleteOpen = false }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    editingRule?.let { edit ->
        FirewallRuleDialog(
            initial = edit.original,
            onDismiss = { editingRule = null },
            onConfirm = { rule ->
                viewModel.upsertRule(edit.original, rule)
                editingRule = null
            },
        )
    }

    pendingRuleDelete?.let { rule ->
        AlertDialog(
            onDismissRequest = { pendingRuleDelete = null },
            title = { Text(stringResource(R.string.firewall_rule_delete_title)) },
            text = { Text(ruleSummary(rule)) },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.removeRule(rule)
                    pendingRuleDelete = null
                }) { Text(stringResource(R.string.delete), color = MaterialTheme.colorScheme.error) }
            },
            dismissButton = {
                TextButton(onClick = { pendingRuleDelete = null }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    pendingDetach?.let { id ->
        AlertDialog(
            onDismissRequest = { pendingDetach = null },
            title = { Text(stringResource(R.string.firewall_detach_title)) },
            text = { Text(stringResource(R.string.firewall_detach_warning)) },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.detachServer(id)
                    pendingDetach = null
                }) { Text(stringResource(R.string.ok)) }
            },
            dismissButton = {
                TextButton(onClick = { pendingDetach = null }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    if (applyOpen) {
        val excluded = state.firewall?.appliedTo
            ?.mapNotNull { it.server?.id }
            ?.toSet()
            .orEmpty()
        FirewallApplyDialog(
            servers = state.servers,
            excludedIds = excluded,
            onDismiss = { applyOpen = false },
            onConfirm = { id ->
                viewModel.attachServer(id)
                applyOpen = false
            },
        )
    }
}

private data class RuleEdit(val original: FirewallRule?)

@Composable
private fun OverviewCard(fw: CloudFirewall, onAppliedClick: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp),
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                fw.name,
                style = MaterialTheme.typography.headlineMedium,
                color = MaterialTheme.colorScheme.onSurface,
            )
            Spacer(Modifier.size(12.dp))
            StatusPill(
                label = if (fw.appliedTo.isEmpty()) {
                    stringResource(R.string.firewall_status_unapplied)
                } else {
                    stringResource(R.string.firewall_status_active)
                },
                tone = if (fw.appliedTo.isEmpty()) {
                    StatusTone.Neutral
                } else {
                    StatusTone.Active
                },
            )
        }
        val rulesText = androidx.compose.ui.res.pluralStringResource(
            R.plurals.cloud_firewall_rule_count, fw.rules.size, fw.rules.size,
        )
        val appliedText = androidx.compose.ui.res.pluralStringResource(
            R.plurals.cloud_firewall_applied_count, fw.appliedTo.size, fw.appliedTo.size,
        )
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                text = rulesText,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            Text(
                text = " · ",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            Text(
                text = appliedText,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.primary,
                modifier = Modifier
                    .clickable(onClick = onAppliedClick)
                    .padding(vertical = 2.dp),
            )
        }
    }
}

private enum class StatusTone { Active, Neutral }

@Composable
private fun StatusPill(label: String, tone: StatusTone) {
    val (bg, fg) = when (tone) {
        StatusTone.Active -> MaterialTheme.colorScheme.primaryContainer to MaterialTheme.colorScheme.onPrimaryContainer
        StatusTone.Neutral -> MaterialTheme.colorScheme.surfaceVariant to MaterialTheme.colorScheme.onSurfaceVariant
    }
    Surface(shape = RoundedCornerShape(50), color = bg) {
        Text(
            label,
            style = MaterialTheme.typography.labelMedium,
            color = fg,
            modifier = Modifier.padding(horizontal = 12.dp, vertical = 4.dp),
        )
    }
}

@Composable
private fun RuleCard(
    rule: FirewallRule,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Row(modifier = Modifier.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                Text(ruleHeader(rule), style = MaterialTheme.typography.titleSmall)
                if (!rule.description.isNullOrBlank()) {
                    Text(
                        rule.description!!,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                val ips = if (rule.direction == "in") rule.sourceIps else rule.destinationIps
                if (ips.isNotEmpty()) {
                    FlowRow(horizontalArrangement = Arrangement.spacedBy(4.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                        ips.forEach { ip ->
                            AssistChip(
                                onClick = {},
                                label = { Text(ip, style = MaterialTheme.typography.labelSmall) },
                            )
                        }
                    }
                }
            }
            IconButton(onClick = onEdit) {
                Icon(Icons.Filled.Edit, contentDescription = stringResource(R.string.firewall_action_rename))
            }
            IconButton(onClick = onDelete) {
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
private fun ruleHeader(rule: FirewallRule): String {
    val dir = if (rule.direction == "in") {
        stringResource(R.string.firewall_dir_in)
    } else {
        stringResource(R.string.firewall_dir_out)
    }
    val proto = rule.protocol.uppercase()
    val port = rule.port?.takeIf { it.isNotBlank() }?.let { ":$it" }.orEmpty()
    return "$dir · $proto$port"
}

@Composable
private fun ruleSummary(rule: FirewallRule): String = ruleHeader(rule)

@Composable
private fun AppliedRow(
    application: FirewallApplication,
    serverName: String?,
    onDetach: () -> Unit,
) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Row(modifier = Modifier.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    serverName ?: ("#" + (application.server?.id?.toString() ?: "?")),
                    style = MaterialTheme.typography.bodyMedium,
                )
                Text(
                    application.type,
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            if (application.server != null) {
                IconButton(onClick = onDetach) {
                    Icon(
                        Icons.Filled.Delete,
                        contentDescription = stringResource(R.string.firewall_action_detach),
                        tint = MaterialTheme.colorScheme.error,
                    )
                }
            }
        }
    }
}

@Composable
private fun SectionHeader(text: String) {
    Text(
        text,
        style = MaterialTheme.typography.titleMedium,
        color = MaterialTheme.colorScheme.primary,
        modifier = Modifier.padding(top = 12.dp, bottom = 4.dp),
    )
}

@Composable
private fun EmptyHint(text: String) {
    Text(
        text,
        style = MaterialTheme.typography.bodyMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(8.dp),
    )
}

@Composable
private fun AddRowButton(label: String, onClick: () -> Unit) {
    Surface(
        onClick = onClick,
        shape = RoundedCornerShape(12.dp),
        color = MaterialTheme.colorScheme.surfaceVariant,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = null, tint = MaterialTheme.colorScheme.primary)
            Text(label, color = MaterialTheme.colorScheme.primary)
        }
    }
}

@Composable
private fun Property(label: String, value: String) {
    Column {
        Text(label, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        Text(value, style = MaterialTheme.typography.bodyMedium)
    }
}

@Composable
private fun TextPromptDialog(
    title: String,
    label: String,
    initial: String,
    optional: Boolean,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    var text by remember { mutableStateOf(initial) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            OutlinedTextField(
                value = text,
                onValueChange = { text = it },
                label = { Text(label) },
                singleLine = true,
            )
        },
        confirmButton = {
            TextButton(
                enabled = optional || text.isNotBlank(),
                onClick = { onConfirm(text) },
            ) { Text(stringResource(R.string.ok)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

