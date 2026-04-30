// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Lan
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Switch
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
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudNetwork
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import de.kiefer_networks.falco.ui.components.wizard.PickCard
import de.kiefer_networks.falco.ui.components.wizard.WizardScaffold
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudNetworksUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val data: List<CloudNetwork> = emptyList(),
)

data class CreateNetworkOptions(
    val running: Boolean = false,
)

private val NETWORK_ZONES = listOf("eu-central", "us-east", "us-west", "ap-southeast")

@HiltViewModel
class CloudNetworksViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudNetworksUiState())
    val state: StateFlow<CloudNetworksUiState> = _state.asStateFlow()

    private val _create = MutableStateFlow(CreateNetworkOptions())
    val createOptions: StateFlow<CreateNetworkOptions> = _create.asStateFlow()

    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudNetworksUiState(loading = true)
        runCatching { repo.listNetworks() }
            .onSuccess { _state.value = CloudNetworksUiState(loading = false, data = it) }
            .onFailure { _state.value = CloudNetworksUiState(loading = false, error = sanitizeError(it)) }
    }

    fun create(
        name: String,
        ipRange: String,
        addSubnet: Boolean,
        subnetType: String,
        subnetZone: String,
        subnetIpRange: String?,
        onDone: (Boolean) -> Unit,
    ) {
        if (_create.value.running) return
        viewModelScope.launch {
            _create.update { it.copy(running = true) }
            val res = runCatching {
                val net = repo.createNetwork(name = name, ipRange = ipRange)
                if (addSubnet) {
                    repo.addNetworkSubnet(
                        id = net.id,
                        type = subnetType,
                        networkZone = subnetZone,
                        ipRange = subnetIpRange?.takeIf { it.isNotBlank() },
                    )
                }
            }
            _create.update { it.copy(running = false) }
            res.onSuccess {
                refresh()
                onDone(true)
            }.onFailure { e ->
                _events.emit(sanitizeError(e))
                onDone(false)
            }
        }
    }
}

@Composable
fun CloudNetworksTab(viewModel: CloudNetworksViewModel = hiltViewModel()) {
    val s by viewModel.state.collectAsState()
    var createOpen by remember { mutableStateOf(false) }
    androidx.compose.runtime.LaunchedEffect(Unit) { viewModel.refresh() }
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
                items(s.data, key = { it.id }) { network -> NetworkCard(network) }
            }
        }
        FloatingActionButton(
            onClick = { createOpen = true },
            modifier = Modifier.align(Alignment.BottomEnd).padding(16.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.cloud_network_create))
        }
    }

    if (createOpen) {
        CreateNetworkWizard(
            viewModel = viewModel,
            onDismiss = { createOpen = false },
            onCreated = { createOpen = false },
        )
    }
}

@Composable
private fun NetworkCard(network: CloudNetwork) {
    Card(modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
        Column(Modifier.padding(12.dp)) {
            Text(network.name, style = MaterialTheme.typography.titleMedium)
            Text(
                stringResource(R.string.cloud_network_ip_range, network.ipRange),
                style = MaterialTheme.typography.bodyMedium,
            )
            Text(
                pluralStringResource(
                    R.plurals.cloud_network_subnet_count,
                    network.subnets.size,
                    network.subnets.size,
                ),
                style = MaterialTheme.typography.bodyMedium,
            )
            Text(
                pluralStringResource(
                    R.plurals.cloud_network_server_count,
                    network.servers.size,
                    network.servers.size,
                ),
                style = MaterialTheme.typography.bodyMedium,
            )
        }
    }
}

@Composable
internal fun CreateNetworkWizard(
    viewModel: CloudNetworksViewModel,
    onDismiss: () -> Unit,
    onCreated: () -> Unit,
) {
    val opts by viewModel.createOptions.collectAsState()

    var step by remember { mutableStateOf(0) }
    var name by remember { mutableStateOf("") }
    var ipRange by remember { mutableStateOf("10.0.0.0/16") }
    var addSubnet by remember { mutableStateOf(false) }
    var subnetZone by remember { mutableStateOf<String?>("eu-central") }
    var subnetType by remember { mutableStateOf("cloud") }
    var subnetIpRange by remember { mutableStateOf("") }

    val stepLabels = listOf(
        stringResource(R.string.wizard_step_details),
        stringResource(R.string.wizard_step_subnet),
    )

    val canGoNext = when (step) {
        0 -> name.isNotBlank() && ipRange.isNotBlank()
        1 -> !addSubnet || subnetZone != null
        else -> false
    }

    WizardScaffold(
        title = stringResource(R.string.cloud_network_create),
        steps = stepLabels,
        currentStep = step,
        canGoNext = canGoNext,
        isLastStep = step == stepLabels.lastIndex,
        isRunning = opts.running,
        onDismiss = onDismiss,
        onBack = { if (step > 0) step-- },
        onNext = { if (step < stepLabels.lastIndex) step++ },
        onFinish = {
            viewModel.create(
                name = name.trim(),
                ipRange = ipRange.trim(),
                addSubnet = addSubnet,
                subnetType = subnetType,
                subnetZone = subnetZone ?: "eu-central",
                subnetIpRange = subnetIpRange.trim().ifBlank { null },
                onDone = { ok -> if (ok) onCreated() },
            )
        },
        nextLabel = stringResource(R.string.wizard_next),
        finishLabel = stringResource(R.string.cloud_network_create_action),
        backLabel = stringResource(R.string.wizard_back),
        cancelLabel = stringResource(R.string.cancel),
    ) {
        when (step) {
            0 -> Column(
                modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
            ) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.cloud_network_create_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = ipRange,
                    onValueChange = { ipRange = it },
                    label = { Text(stringResource(R.string.cloud_network_create_ip_range)) },
                    singleLine = true,
                    supportingText = { Text(stringResource(R.string.cloud_network_create_ip_range_hint)) },
                    modifier = Modifier.fillMaxWidth(),
                )
                Spacer(Modifier.size(8.dp))
            }
            1 -> Column(
                modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.cloud_network_create_subnet_optional),
                        modifier = Modifier.weight(1f),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    Switch(checked = addSubnet, onCheckedChange = { addSubnet = it })
                }
                if (addSubnet) {
                    Text(
                        stringResource(R.string.cloud_network_subnet_zone).uppercase(),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        NETWORK_ZONES.forEach { zone ->
                            PickCard(
                                title = zone,
                                icon = Icons.Filled.Lan,
                                selected = subnetZone == zone,
                                onClick = { subnetZone = zone },
                            )
                        }
                    }
                    Text(
                        stringResource(R.string.cloud_network_subnet_type).uppercase(),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        listOf("cloud", "server", "vswitch").forEach { t ->
                            FilterChip(
                                selected = subnetType == t,
                                onClick = { subnetType = t },
                                label = { Text(t) },
                            )
                        }
                    }
                    OutlinedTextField(
                        value = subnetIpRange,
                        onValueChange = { subnetIpRange = it },
                        label = { Text(stringResource(R.string.cloud_network_subnet_ip_range)) },
                        singleLine = true,
                        supportingText = { Text(stringResource(R.string.cloud_network_subnet_ip_range_hint)) },
                        modifier = Modifier.fillMaxWidth(),
                    )
                }
                Spacer(Modifier.size(8.dp))
            }
        }
    }
}
