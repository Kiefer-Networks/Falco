// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.dns

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.ExpandLess
import androidx.compose.material.icons.filled.ExpandMore
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.Card
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.DnsPrimaryServer
import de.kiefer_networks.falco.data.dto.DnsRecord
import de.kiefer_networks.falco.data.dto.DnsValidateResponse
import de.kiefer_networks.falco.data.dto.DnsZone
import kotlinx.coroutines.launch

@Composable
fun ZoneDetailScreen(
    onBack: () -> Unit,
    viewModel: ZoneDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val context = LocalContext.current
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    var dialogRecord by remember { mutableStateOf<DnsRecord?>(null) }
    var creating by remember { mutableStateOf(false) }
    var overflowOpen by remember { mutableStateOf(false) }

    // Bulk edit. Using rememberSaveable so the selection survives rotation.
    var bulkMode by rememberSaveable { mutableStateOf(false) }
    var selectedIds by rememberSaveable { mutableStateOf(emptySet<String>()) }
    var bulkApplyOpen by remember { mutableStateOf(false) }

    // BIND import preview state.
    var validateResult by remember { mutableStateOf<DnsValidateResponse?>(null) }
    var pendingBindText by remember { mutableStateOf<String?>(null) }

    // Primary servers.
    var primaryExpanded by rememberSaveable { mutableStateOf(false) }
    var primaryAddOpen by remember { mutableStateOf(false) }
    var primaryEditing by remember { mutableStateOf<DnsPrimaryServer?>(null) }
    var primaryDeleteCandidate by remember { mutableStateOf<DnsPrimaryServer?>(null) }

    // SAF: import.
    val openImportLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocument(),
    ) { uri: Uri? ->
        if (uri != null) {
            // BindFileTooLargeException kicks in only after the bytes are
            // converted in the repo; we still try to read the whole thing
            // because OpenableColumns.SIZE is not always reliable on SAF.
            val text = runCatching {
                context.contentResolver.openInputStream(uri)?.use { it.bufferedReader().readText() }
            }.getOrNull()
            if (text == null) {
                scope.launch {
                    snackbarHostState.showSnackbar(context.getString(R.string.dns_import_read_failed))
                }
            } else {
                viewModel.validateBind(text)
            }
        }
    }

    // SAF: export.
    val exportLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.CreateDocument("text/plain"),
    ) { uri: Uri? ->
        val text = pendingBindText
        if (uri != null && text != null) {
            val ok = runCatching {
                context.contentResolver.openOutputStream(uri)?.use { os ->
                    os.write(text.toByteArray(Charsets.UTF_8))
                } != null
            }.getOrDefault(false)
            scope.launch {
                snackbarHostState.showSnackbar(
                    context.getString(
                        if (ok) R.string.dns_export_saved else R.string.dns_export_write_failed,
                    ),
                )
            }
        }
        pendingBindText = null
    }

    // VM event drain.
    LaunchedEffect(viewModel) {
        viewModel.events.collect { event ->
            when (event) {
                is ZoneDetailEvent.ExportReady -> {
                    pendingBindText = event.text
                    exportLauncher.launch(event.suggestedName)
                }
                is ZoneDetailEvent.ValidationReady -> {
                    validateResult = event.result
                    pendingBindText = event.bindText
                }
                is ZoneDetailEvent.SnackMessage -> {
                    val msg = if (event.message == ZONE_DETAIL_BIND_TOO_LARGE) {
                        context.getString(R.string.dns_import_too_large)
                    } else {
                        event.message
                    }
                    snackbarHostState.showSnackbar(msg)
                }
                ZoneDetailEvent.ImportSucceeded -> {
                    snackbarHostState.showSnackbar(context.getString(R.string.dns_import_succeeded))
                }
                ZoneDetailEvent.BulkSucceeded -> {
                    bulkMode = false
                    selectedIds = emptySet()
                    snackbarHostState.showSnackbar(context.getString(R.string.dns_bulk_succeeded))
                }
                is ZoneDetailEvent.BulkFailed -> {
                    bulkMode = false
                    selectedIds = emptySet()
                    snackbarHostState.showSnackbar(
                        context.getString(R.string.dns_bulk_failed, event.failedCount),
                    )
                }
            }
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    if (bulkMode) {
                        Text(stringResource(R.string.dns_bulk_selection_count, selectedIds.size))
                    } else {
                        Text(state.zone?.name ?: stringResource(R.string.dns_zones))
                    }
                },
                navigationIcon = {
                    IconButton(onClick = {
                        if (bulkMode) {
                            bulkMode = false
                            selectedIds = emptySet()
                        } else {
                            onBack()
                        }
                    }) {
                        if (bulkMode) {
                            Icon(Icons.Filled.Close, contentDescription = stringResource(R.string.close))
                        } else {
                            Icon(Icons.Filled.ArrowBack, contentDescription = stringResource(R.string.close))
                        }
                    }
                },
                actions = {
                    if (bulkMode) {
                        TextButton(
                            enabled = selectedIds.isNotEmpty(),
                            onClick = { bulkApplyOpen = true },
                        ) { Text(stringResource(R.string.dns_bulk_apply)) }
                    } else if (state.zone != null) {
                        IconButton(onClick = { overflowOpen = true }) {
                            Icon(Icons.Filled.MoreVert, contentDescription = null)
                        }
                        DropdownMenu(
                            expanded = overflowOpen,
                            onDismissRequest = { overflowOpen = false },
                        ) {
                            DropdownMenuItem(
                                text = { Text(stringResource(R.string.dns_bulk_edit)) },
                                onClick = {
                                    overflowOpen = false
                                    bulkMode = true
                                    selectedIds = emptySet()
                                },
                            )
                            DropdownMenuItem(
                                text = { Text(stringResource(R.string.dns_import)) },
                                onClick = {
                                    overflowOpen = false
                                    // Most BIND zone files come without a strict
                                    // MIME type, so accept anything and let the
                                    // 1 MiB byte cap reject obvious junk.
                                    openImportLauncher.launch(arrayOf("*/*"))
                                },
                            )
                            DropdownMenuItem(
                                text = { Text(stringResource(R.string.dns_export)) },
                                onClick = {
                                    overflowOpen = false
                                    viewModel.exportBind()
                                },
                            )
                        }
                    }
                },
            )
        },
        snackbarHost = { SnackbarHost(snackbarHostState) },
        floatingActionButton = {
            if (state.zone != null && !bulkMode) {
                FloatingActionButton(onClick = { creating = true }) {
                    Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.dns_record_create))
                }
            }
        },
    ) { padding ->
        Box(Modifier.fillMaxSize().padding(padding)) {
            when {
                state.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
                state.error != null -> Box(
                    Modifier.fillMaxSize().padding(24.dp),
                    contentAlignment = Alignment.Center,
                ) { Text(state.error!!) }
                else -> Content(
                    zone = state.zone,
                    records = state.records,
                    bulkMode = bulkMode,
                    selectedIds = selectedIds,
                    primaryServers = state.primaryServers,
                    primaryServersLoading = state.primaryServersLoading,
                    primaryExpanded = primaryExpanded,
                    onTogglePrimary = { primaryExpanded = !primaryExpanded },
                    onAddPrimary = { primaryAddOpen = true },
                    onEditPrimary = { primaryEditing = it },
                    onDeletePrimary = { primaryDeleteCandidate = it },
                    onToggleSelect = { id ->
                        selectedIds = if (id in selectedIds) selectedIds - id else selectedIds + id
                    },
                    onSelectAll = {
                        // Records without an id (rare; happens when the API
                        // returns a record while it is still being created)
                        // cannot be bulk-updated; skip them.
                        selectedIds = state.records.mapNotNull { it.id }.toSet()
                    },
                    onClearSelection = { selectedIds = emptySet() },
                    onEdit = { dialogRecord = it },
                    onDelete = { rec -> rec.id?.let { viewModel.deleteRecord(it) } },
                )
            }
        }
    }

    if (creating) {
        RecordDialog(
            zoneId = viewModel.zoneId,
            existing = null,
            onDismiss = { creating = false },
            onConfirm = { rec ->
                creating = false
                viewModel.createRecord(rec)
            },
        )
    }

    val editing = dialogRecord
    if (editing != null) {
        RecordDialog(
            zoneId = viewModel.zoneId,
            existing = editing,
            onDismiss = { dialogRecord = null },
            onConfirm = { rec ->
                val id = editing.id
                dialogRecord = null
                if (id != null) viewModel.updateRecord(id, rec)
            },
        )
    }

    if (bulkApplyOpen) {
        BulkEditDialog(
            selectedCount = selectedIds.size,
            onDismiss = { bulkApplyOpen = false },
            onApply = { value, ttl ->
                bulkApplyOpen = false
                viewModel.applyBulkEdit(selectedIds, value, ttl)
            },
        )
    }

    val preview = validateResult
    val previewText = pendingBindText
    if (preview != null && previewText != null) {
        ImportPreviewDialog(
            result = preview,
            onConfirm = {
                val text = previewText
                validateResult = null
                pendingBindText = null
                viewModel.importBind(text)
            },
            onDismiss = {
                validateResult = null
                pendingBindText = null
            },
        )
    }

    if (primaryAddOpen) {
        PrimaryServerDialog(
            existing = null,
            onDismiss = { primaryAddOpen = false },
            onConfirm = { address, port ->
                primaryAddOpen = false
                viewModel.addPrimaryServer(address, port)
            },
        )
    }
    val edit = primaryEditing
    if (edit != null) {
        PrimaryServerDialog(
            existing = edit,
            onDismiss = { primaryEditing = null },
            onConfirm = { address, port ->
                primaryEditing = null
                viewModel.updatePrimaryServer(edit.id, address, port)
            },
        )
    }
    val delPs = primaryDeleteCandidate
    if (delPs != null) {
        androidx.compose.material3.AlertDialog(
            onDismissRequest = { primaryDeleteCandidate = null },
            title = { Text(stringResource(R.string.dns_primary_server_delete)) },
            text = {
                Text(
                    stringResource(
                        R.string.dns_primary_server_delete_confirm,
                        delPs.address,
                        delPs.port,
                    ),
                )
            },
            confirmButton = {
                TextButton(onClick = {
                    primaryDeleteCandidate = null
                    viewModel.deletePrimaryServer(delPs.id)
                }) { Text(stringResource(R.string.delete)) }
            },
            dismissButton = {
                TextButton(onClick = { primaryDeleteCandidate = null }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }
}

@Composable
private fun Content(
    zone: DnsZone?,
    records: List<DnsRecord>,
    bulkMode: Boolean,
    selectedIds: Set<String>,
    primaryServers: List<DnsPrimaryServer>,
    primaryServersLoading: Boolean,
    primaryExpanded: Boolean,
    onTogglePrimary: () -> Unit,
    onAddPrimary: () -> Unit,
    onEditPrimary: (DnsPrimaryServer) -> Unit,
    onDeletePrimary: (DnsPrimaryServer) -> Unit,
    onToggleSelect: (String) -> Unit,
    onSelectAll: () -> Unit,
    onClearSelection: () -> Unit,
    onEdit: (DnsRecord) -> Unit,
    onDelete: (DnsRecord) -> Unit,
) {
    LazyColumn(Modifier.fillMaxSize().padding(12.dp)) {
        if (zone != null) {
            item {
                Card(Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
                    Column(Modifier.padding(12.dp)) {
                        Text(zone.name, style = MaterialTheme.typography.titleLarge)
                        Spacer(Modifier.height(4.dp))
                        Text(
                            "${stringResource(R.string.dns_record_ttl)}: ${zone.ttl ?: "—"}",
                            style = MaterialTheme.typography.bodyMedium,
                        )
                        Text(
                            "${stringResource(R.string.dns_zone_status)}: ${zone.status ?: "—"}",
                            style = MaterialTheme.typography.bodyMedium,
                        )
                        Text(
                            "${stringResource(R.string.dns_records)}: ${zone.recordsCount ?: records.size}",
                            style = MaterialTheme.typography.bodyMedium,
                        )
                    }
                }
            }
        }
        item {
            PrimaryServersCard(
                expanded = primaryExpanded,
                loading = primaryServersLoading,
                servers = primaryServers,
                onToggle = onTogglePrimary,
                onAdd = onAddPrimary,
                onEdit = onEditPrimary,
                onDelete = onDeletePrimary,
            )
        }
        item {
            Spacer(Modifier.height(8.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    stringResource(R.string.dns_records),
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier
                        .padding(horizontal = 4.dp, vertical = 4.dp)
                        .weight(1f),
                )
                if (bulkMode) {
                    TextButton(onClick = onSelectAll) {
                        Text(stringResource(R.string.dns_bulk_select_all))
                    }
                    TextButton(onClick = onClearSelection) {
                        Text(stringResource(R.string.dns_bulk_clear))
                    }
                }
            }
        }
        if (records.isEmpty()) {
            item {
                Box(
                    Modifier.fillMaxWidth().padding(24.dp),
                    contentAlignment = Alignment.Center,
                ) { Text(stringResource(R.string.empty_list)) }
            }
        } else {
            items(records, key = { it.id ?: (it.name + it.type + it.value) }) { record ->
                RecordRow(
                    record = record,
                    bulkMode = bulkMode,
                    selected = record.id != null && record.id in selectedIds,
                    onToggleSelect = {
                        record.id?.let(onToggleSelect)
                    },
                    onEdit = { onEdit(record) },
                    onDelete = { onDelete(record) },
                )
            }
        }
    }
}

@Composable
private fun PrimaryServersCard(
    expanded: Boolean,
    loading: Boolean,
    servers: List<DnsPrimaryServer>,
    onToggle: () -> Unit,
    onAdd: () -> Unit,
    onEdit: (DnsPrimaryServer) -> Unit,
    onDelete: (DnsPrimaryServer) -> Unit,
) {
    Card(Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
        Column(Modifier.padding(8.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable(onClick = onToggle)
                    .padding(8.dp),
            ) {
                Text(
                    stringResource(R.string.dns_primary_servers),
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier.weight(1f),
                )
                IconButton(onClick = onAdd) {
                    Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.dns_primary_server_add))
                }
                Icon(
                    if (expanded) Icons.Filled.ExpandLess else Icons.Filled.ExpandMore,
                    contentDescription = null,
                )
            }
            AnimatedVisibility(visible = expanded) {
                Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                    when {
                        loading -> Box(
                            Modifier.fillMaxWidth().padding(12.dp),
                            contentAlignment = Alignment.Center,
                        ) {
                            CircularProgressIndicator(modifier = Modifier.size(20.dp))
                        }
                        servers.isEmpty() -> Text(
                            stringResource(R.string.dns_primary_server_empty),
                            style = MaterialTheme.typography.bodyMedium,
                            modifier = Modifier.padding(12.dp),
                        )
                        else -> servers.forEach { ps ->
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clickable { onEdit(ps) }
                                    .padding(horizontal = 12.dp, vertical = 8.dp),
                                verticalAlignment = Alignment.CenterVertically,
                            ) {
                                Column(Modifier.weight(1f)) {
                                    Text(
                                        "${ps.address}:${ps.port}",
                                        style = MaterialTheme.typography.bodyLarge,
                                    )
                                }
                                IconButton(onClick = { onDelete(ps) }) {
                                    Icon(
                                        Icons.Filled.Delete,
                                        contentDescription = stringResource(R.string.dns_primary_server_delete),
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun RecordRow(
    record: DnsRecord,
    bulkMode: Boolean,
    selected: Boolean,
    onToggleSelect: () -> Unit,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
) {
    var menuOpen by remember { mutableStateOf(false) }
    Card(
        Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
            .then(
                // In bulk mode the whole row toggles selection. Outside bulk
                // mode we keep the row passive (the trailing menu still works)
                // to match the rest of the app's tap semantics.
                if (bulkMode) Modifier.clickable(onClick = onToggleSelect) else Modifier,
            ),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth().padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            if (bulkMode) {
                Checkbox(
                    // Records without an id can't be bulk-updated; show as
                    // disabled so the user understands why selecting them
                    // does nothing.
                    enabled = record.id != null,
                    checked = selected,
                    onCheckedChange = { onToggleSelect() },
                )
            }
            Column(Modifier.weight(1f)) {
                Text(record.name, style = MaterialTheme.typography.titleMedium)
                Text(
                    listOf(
                        record.type,
                        record.value,
                        "TTL ${record.ttl ?: "—"}",
                    ).joinToString(" • "),
                    style = MaterialTheme.typography.bodySmall,
                )
            }
            if (!bulkMode) {
                Box {
                    IconButton(onClick = { menuOpen = true }) {
                        Icon(Icons.Filled.MoreVert, contentDescription = null)
                    }
                    DropdownMenu(expanded = menuOpen, onDismissRequest = { menuOpen = false }) {
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.dns_record_edit)) },
                            onClick = {
                                menuOpen = false
                                onEdit()
                            },
                        )
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.dns_record_delete)) },
                            onClick = {
                                menuOpen = false
                                onDelete()
                            },
                        )
                    }
                }
            }
        }
    }
}

