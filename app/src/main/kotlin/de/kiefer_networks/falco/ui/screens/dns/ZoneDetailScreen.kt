// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.dns

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.DnsRecord
import de.kiefer_networks.falco.data.dto.DnsZone

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ZoneDetailScreen(
    onBack: () -> Unit,
    viewModel: ZoneDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    var dialogRecord by remember { mutableStateOf<DnsRecord?>(null) }
    var creating by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(state.zone?.name ?: stringResource(R.string.dns_zones)) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = stringResource(R.string.close))
                    }
                },
            )
        },
        floatingActionButton = {
            if (state.zone != null) {
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
}

@Composable
private fun Content(
    zone: DnsZone?,
    records: List<DnsRecord>,
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
            Spacer(Modifier.height(8.dp))
            Text(
                stringResource(R.string.dns_records),
                style = MaterialTheme.typography.titleMedium,
                modifier = Modifier.padding(horizontal = 4.dp, vertical = 4.dp),
            )
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
                RecordRow(record = record, onEdit = { onEdit(record) }, onDelete = { onDelete(record) })
            }
        }
    }
}

@Composable
private fun RecordRow(
    record: DnsRecord,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
) {
    var menuOpen by remember { mutableStateOf(false) }
    Card(Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
        Row(
            modifier = Modifier.fillMaxWidth().padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
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
