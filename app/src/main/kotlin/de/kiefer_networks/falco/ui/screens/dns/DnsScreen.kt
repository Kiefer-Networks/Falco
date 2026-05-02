// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.material3.ExperimentalMaterial3Api::class,
    androidx.compose.foundation.ExperimentalFoundationApi::class,
)
package de.kiefer_networks.falco.ui.screens.dns

import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material3.Card
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.ui.components.dialog.TypeToConfirmDeleteDialog
import de.kiefer_networks.falco.ui.nav.LocalNavDrawer
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.DnsZone
import de.kiefer_networks.falco.data.repo.DnsRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class DnsUiState(val loading: Boolean = true, val zones: List<DnsZone> = emptyList(), val error: String? = null)

@HiltViewModel
class DnsViewModel @Inject constructor(private val repo: DnsRepo) : ViewModel() {
    private val _state = MutableStateFlow(DnsUiState())
    val state: StateFlow<DnsUiState> = _state.asStateFlow()
    init { refresh() }
    fun refresh() = viewModelScope.launch {
        _state.value = _state.value.copy(loading = true, error = null)
        runCatching { repo.listZones() }
            .onSuccess { _state.value = DnsUiState(loading = false, zones = it) }
            .onFailure { _state.value = DnsUiState(loading = false, error = sanitizeError(it)) }
    }

    fun createZone(name: String, ttl: Int?) = viewModelScope.launch {
        runCatching { repo.createZone(name, ttl) }
            .onFailure { _state.value = _state.value.copy(error = sanitizeError(it)) }
        refresh()
    }

    fun updateZone(id: String, name: String, ttl: Int?) = viewModelScope.launch {
        runCatching { repo.updateZone(id, name, ttl) }
            .onFailure { _state.value = _state.value.copy(error = sanitizeError(it)) }
        refresh()
    }

    fun deleteZone(id: String) = viewModelScope.launch {
        runCatching { repo.deleteZone(id) }
            .onFailure { _state.value = _state.value.copy(error = sanitizeError(it)) }
        refresh()
    }
}

@Composable
fun DnsScreen(
    onZoneClick: (String) -> Unit = {},
    viewModel: DnsViewModel = hiltViewModel(),
) {
    val s by viewModel.state.collectAsState()
    val drawer = LocalNavDrawer.current

    // Active zone for dropdown (long-press), edit dialog, or delete dialog.
    // Distinct slots so dismissing the menu does not also dismiss an edit dialog
    // that hosts another action sheet on top of it.
    var menuZone by remember { mutableStateOf<DnsZone?>(null) }
    var editing by remember { mutableStateOf<DnsZone?>(null) }
    var deleting by remember { mutableStateOf<DnsZone?>(null) }
    var creating by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(stringResource(R.string.nav_dns)) },
                navigationIcon = {
                    if (drawer.isCompact) {
                        IconButton(onClick = drawer::open) {
                            Icon(Icons.Filled.Menu, contentDescription = stringResource(R.string.nav_drawer_title))
                        }
                    }
                },
            )
        },
        floatingActionButton = {
            FloatingActionButton(onClick = { creating = true }) {
                Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.dns_zone_create))
            }
        },
    ) { padding ->
        when {
            s.loading -> Box(Modifier.fillMaxSize().padding(padding), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
            s.error != null -> Box(Modifier.fillMaxSize().padding(padding).padding(24.dp), contentAlignment = Alignment.Center) { Text(s.error!!) }
            else -> LazyColumn(Modifier.fillMaxSize().padding(padding).padding(12.dp)) {
                items(s.zones, key = { it.id }) { zone ->
                    Box {
                        Card(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 6.dp)
                                .combinedClickable(
                                    onClick = { onZoneClick(zone.id) },
                                    onLongClick = { menuZone = zone },
                                ),
                        ) {
                            Column(Modifier.padding(12.dp)) {
                                Text(zone.name, style = MaterialTheme.typography.titleMedium)
                                val cnt = zone.recordsCount ?: 0
                                Text(
                                    pluralStringResource(R.plurals.dns_records_count, cnt, cnt),
                                    style = MaterialTheme.typography.bodyMedium,
                                )
                            }
                        }
                        // Anchor the dropdown to the row that owns it.
                        DropdownMenu(
                            expanded = menuZone?.id == zone.id,
                            onDismissRequest = { menuZone = null },
                        ) {
                            DropdownMenuItem(
                                text = { Text(stringResource(R.string.dns_zone_edit)) },
                                onClick = {
                                    menuZone = null
                                    editing = zone
                                },
                            )
                            DropdownMenuItem(
                                text = { Text(stringResource(R.string.dns_zone_delete)) },
                                onClick = {
                                    menuZone = null
                                    deleting = zone
                                },
                            )
                        }
                    }
                }
            }
        }
    }

    if (creating) {
        ZoneFormDialog(
            existing = null,
            onDismiss = { creating = false },
            onConfirm = { name, ttl ->
                creating = false
                viewModel.createZone(name, ttl)
            },
        )
    }
    val edit = editing
    if (edit != null) {
        ZoneFormDialog(
            existing = edit,
            onDismiss = { editing = null },
            onConfirm = { name, ttl ->
                editing = null
                viewModel.updateZone(edit.id, name, ttl)
            },
        )
    }
    val del = deleting
    if (del != null) {
        TypeToConfirmDeleteDialog(
            title = stringResource(R.string.dns_zone_delete_title),
            warning = stringResource(R.string.dns_zone_delete_warning, del.name),
            confirmName = del.name,
            confirmButtonLabel = stringResource(R.string.delete),
            onConfirm = {
                deleting = null
                viewModel.deleteZone(del.id)
            },
            onDismiss = { deleting = null },
        )
    }
}
