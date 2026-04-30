// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.background
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Security
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
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
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudFirewall
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.repo.CloudRepo
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import de.kiefer_networks.falco.data.util.sanitizeError
import javax.inject.Inject

data class CloudFirewallsUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val running: Boolean = false,
    val data: List<CloudFirewall> = emptyList(),
    val servers: List<CloudServer> = emptyList(),
)

@HiltViewModel
class CloudFirewallsViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudFirewallsUiState())
    val state: StateFlow<CloudFirewallsUiState> = _state.asStateFlow()

    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.update { it.copy(loading = true, error = null) }
        runCatching { repo.listFirewalls() }
            .onSuccess { list -> _state.update { CloudFirewallsUiState(loading = false, data = list) } }
            .onFailure { e -> _state.update { it.copy(loading = false, error = sanitizeError(e)) } }
    }

    fun create(name: String) = viewModelScope.launch {
        if (_state.value.running) return@launch
        _state.update { it.copy(running = true) }
        runCatching { repo.createFirewall(name) }
            .onSuccess { refresh() }
            .onFailure { e -> _events.emit(sanitizeError(e)) }
        _state.update { it.copy(running = false) }
    }

    fun loadServers() = viewModelScope.launch {
        runCatching { repo.listServers() }
            .onSuccess { list -> _state.update { it.copy(servers = list) } }
            .onFailure { e -> _events.emit(sanitizeError(e)) }
    }

    fun attach(firewallId: Long, serverId: Long) = viewModelScope.launch {
        if (_state.value.running) return@launch
        _state.update { it.copy(running = true) }
        runCatching { repo.applyFirewallToServer(firewallId, serverId) }
            .onSuccess { refresh() }
            .onFailure { e -> _events.emit(sanitizeError(e)) }
        _state.update { it.copy(running = false) }
    }
}

@Composable
fun CloudFirewallsTab(
    onOpen: (Long) -> Unit = {},
    viewModel: CloudFirewallsViewModel = hiltViewModel(),
) {
    val s by viewModel.state.collectAsState()
    var createOpen by remember { mutableStateOf(false) }
    var applyFor by remember { mutableStateOf<CloudFirewall?>(null) }

    LaunchedEffect(Unit) { viewModel.refresh() }
    LaunchedEffect(Unit) {
        viewModel.events.collect { /* no-op; could surface to snackbar */ }
    }

    Box(Modifier.fillMaxSize()) {
        when {
            s.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
            s.error != null -> Box(
                Modifier.fillMaxSize().padding(24.dp),
                contentAlignment = Alignment.Center,
            ) {
                Text(s.error!!, style = MaterialTheme.typography.bodyLarge)
            }
            s.data.isEmpty() -> Box(
                Modifier.fillMaxSize().padding(24.dp),
                contentAlignment = Alignment.Center,
            ) {
                Text(stringResource(R.string.empty_list))
            }
            else -> LazyColumn(Modifier.fillMaxSize().padding(12.dp)) {
                items(s.data, key = { it.id }) { firewall ->
                    FirewallCard(
                        firewall,
                        onClick = { onOpen(firewall.id) },
                        onApplyClick = {
                            viewModel.loadServers()
                            applyFor = firewall
                        },
                    )
                }
            }
        }
        FloatingActionButton(
            onClick = { createOpen = true },
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(16.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.firewall_create_title))
        }
    }

    if (createOpen) {
        CreateFirewallSheet(
            onDismiss = { createOpen = false },
            onConfirm = { name ->
                viewModel.create(name.trim())
                createOpen = false
            },
        )
    }

    applyFor?.let { fw ->
        val excluded = fw.appliedTo.mapNotNull { it.server?.id }.toSet()
        FirewallApplyDialog(
            servers = s.servers,
            excludedIds = excluded,
            onDismiss = { applyFor = null },
            onConfirm = { serverId ->
                viewModel.attach(fw.id, serverId)
                applyFor = null
            },
        )
    }
}

@Composable
private fun FirewallCard(firewall: CloudFirewall, onClick: () -> Unit, onApplyClick: () -> Unit) {
    val active = firewall.appliedTo.isNotEmpty()
    ElevatedCard(
        onClick = onClick,
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 6.dp),
    ) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Surface(
                    shape = RoundedCornerShape(10.dp),
                    color = MaterialTheme.colorScheme.primaryContainer,
                    modifier = Modifier.size(40.dp),
                ) {
                    Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxSize()) {
                        Icon(
                            Icons.Filled.Security,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.onPrimaryContainer,
                            modifier = Modifier.size(22.dp),
                        )
                    }
                }
                Spacer(Modifier.size(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        firewall.name,
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                    )
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(8.dp)
                                .background(
                                    color = if (active) {
                                        androidx.compose.ui.graphics.Color(0xFF2E7D32)
                                    } else {
                                        MaterialTheme.colorScheme.onSurfaceVariant
                                    },
                                    shape = CircleShape,
                                ),
                        )
                        Spacer(Modifier.size(6.dp))
                        Text(
                            text = if (active) {
                                stringResource(R.string.firewall_status_active)
                            } else {
                                stringResource(R.string.firewall_status_unapplied)
                            },
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                StatChip(
                    icon = Icons.Filled.Security,
                    text = pluralStringResource(
                        R.plurals.cloud_firewall_rule_count,
                        firewall.rules.size,
                        firewall.rules.size,
                    ),
                    onClick = null,
                )
                StatChip(
                    icon = Icons.Filled.Add,
                    text = pluralStringResource(
                        R.plurals.cloud_firewall_applied_count,
                        firewall.appliedTo.size,
                        firewall.appliedTo.size,
                    ),
                    onClick = onApplyClick,
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun CreateFirewallSheet(
    onDismiss: () -> Unit,
    onConfirm: (name: String) -> Unit,
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    var name by remember { mutableStateOf("") }
    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheetState) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp, vertical = 16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            Text(
                stringResource(R.string.firewall_create_title),
                style = MaterialTheme.typography.titleLarge,
            )
            OutlinedTextField(
                value = name,
                onValueChange = { name = it },
                label = { Text(stringResource(R.string.firewall_create_name)) },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
            )
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
                TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
                Spacer(Modifier.size(8.dp))
                Button(
                    enabled = name.isNotBlank(),
                    onClick = { onConfirm(name) },
                ) { Text(stringResource(R.string.save)) }
            }
            Spacer(Modifier.size(16.dp))
        }
    }
}

@Composable
private fun StatChip(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    text: String,
    onClick: (() -> Unit)?,
) {
    AssistChip(
        onClick = onClick ?: {},
        enabled = onClick != null,
        leadingIcon = {
            Icon(icon, contentDescription = null, modifier = Modifier.size(AssistChipDefaults.IconSize))
        },
        label = { Text(text, style = MaterialTheme.typography.labelMedium) },
    )
}
