// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.material3.ExperimentalMaterial3Api::class,
    androidx.compose.foundation.layout.ExperimentalLayoutApi::class,
)
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
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Slider
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
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudVolume
import de.kiefer_networks.falco.data.dto.Location
import de.kiefer_networks.falco.data.repo.CloudRepo
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
import de.kiefer_networks.falco.data.util.sanitizeError
import javax.inject.Inject

data class CloudVolumesUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val data: List<ProjectAware<CloudVolume>> = emptyList(),
)

data class CreateVolumeOptions(
    val loading: Boolean = false,
    val running: Boolean = false,
    val locations: List<Location> = emptyList(),
    val servers: List<CloudServer> = emptyList(),
    val pricePerGbMonthGross: Double? = null,
    val pricePerGbMonthNet: Double? = null,
    val currency: String = "EUR",
)

@HiltViewModel
class CloudVolumesViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudVolumesUiState())
    val state: StateFlow<CloudVolumesUiState> = _state.asStateFlow()

    private val _create = MutableStateFlow(CreateVolumeOptions())
    val createOptions: StateFlow<CreateVolumeOptions> = _create.asStateFlow()

    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudVolumesUiState(loading = true)
        runCatching { repo.listVolumesAware() }
            .onSuccess { items ->
                _state.value = CloudVolumesUiState(
                    loading = false,
                    data = items.map { (pid, v) -> ProjectAware(pid, v) },
                )
            }
            .onFailure { _state.value = CloudVolumesUiState(loading = false, error = sanitizeError(it)) }
    }

    fun loadCreateOptions() = viewModelScope.launch {
        _create.update { it.copy(loading = true) }
        runCatching {
            val locs = repo.listLocations()
            val servers = repo.listServers()
            val pricing = runCatching { repo.getPricing() }.getOrNull()
            val gross = pricing?.volume?.pricePerGbMonth?.gross?.toDoubleOrNull()
            val net = pricing?.volume?.pricePerGbMonth?.net?.toDoubleOrNull()
            val currency = pricing?.currency ?: "EUR"
            _create.update {
                it.copy(
                    loading = false,
                    locations = locs,
                    servers = servers,
                    pricePerGbMonthGross = gross,
                    pricePerGbMonthNet = net,
                    currency = currency,
                )
            }
        }.onFailure { e ->
            _create.update { it.copy(loading = false) }
            _events.emit(sanitizeError(e))
        }
    }

    fun create(
        name: String,
        size: Int,
        location: String?,
        serverId: Long?,
        format: String?,
        automount: Boolean?,
        onDone: (Boolean) -> Unit,
        projectId: String? = null,
    ) {
        if (_create.value.running) return
        viewModelScope.launch {
            _create.update { it.copy(running = true) }
            val res = runCatching {
                repo.createVolume(
                    name = name,
                    size = size,
                    location = location,
                    serverId = serverId,
                    format = format,
                    automount = automount,
                    projectId = projectId,
                )
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
fun CloudVolumesTab(viewModel: CloudVolumesViewModel = hiltViewModel()) {
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
                items(
                    s.data,
                    key = { "${it.projectId.orEmpty()}-${it.item.id}" },
                ) { entry -> VolumeCard(entry.item) }
            }
        }
        FloatingActionButton(
            onClick = {
                viewModel.loadCreateOptions()
                createOpen = true
            },
            modifier = Modifier.align(Alignment.BottomEnd).padding(16.dp),
        ) {
            Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.cloud_volume_create))
        }
    }

    if (createOpen) {
        CreateVolumeWizard(
            viewModel = viewModel,
            onDismiss = { createOpen = false },
            onCreated = { createOpen = false },
        )
    }
}

@Composable
private fun VolumeCard(volume: CloudVolume) {
    Card(modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
        Column(Modifier.padding(12.dp)) {
            Text(volume.name, style = MaterialTheme.typography.titleMedium)
            Text(
                stringResource(R.string.cloud_volume_size_gb, volume.size),
                style = MaterialTheme.typography.bodyMedium,
            )
            Text(
                stringResource(R.string.cloud_status_label, volume.status),
                style = MaterialTheme.typography.bodyMedium,
            )
            volume.server?.let {
                Text(
                    stringResource(R.string.cloud_attached_server, it),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
            volume.location?.let { loc ->
                Text(
                    stringResource(
                        R.string.cloud_location_label,
                        loc.city ?: loc.name,
                    ),
                    style = MaterialTheme.typography.bodyMedium,
                )
            }
        }
    }
}

private fun formatVolumeSize(gb: Int): String =
    if (gb >= 1024) {
        val tb = gb / 1024.0
        if (tb == tb.toInt().toDouble()) "${tb.toInt()} TB" else "%.1f TB".format(tb)
    } else "$gb GB"

@Composable
private fun VolumePriceEstimate(sizeGb: Int, opts: CreateVolumeOptions) {
    val gross = opts.pricePerGbMonthGross
    val net = opts.pricePerGbMonthNet
    if (gross == null && net == null) return
    val locale = java.util.Locale.getDefault()
    val nf = java.text.NumberFormat.getCurrencyInstance(locale).apply {
        try { currency = java.util.Currency.getInstance(opts.currency) } catch (_: Throwable) {}
        minimumFractionDigits = 2
        maximumFractionDigits = 2
    }
    val totalGross = gross?.let { it * sizeGb }
    val totalNet = net?.let { it * sizeGb }
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
            Text(
                stringResource(R.string.cloud_volume_price_label),
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            if (totalGross != null) {
                Text(
                    stringResource(R.string.cloud_volume_price_gross_per_month, nf.format(totalGross)),
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.primary,
                )
            }
            if (totalNet != null) {
                Text(
                    stringResource(R.string.cloud_volume_price_net_per_month, nf.format(totalNet)),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            if (gross != null) {
                Text(
                    stringResource(R.string.cloud_volume_price_per_gb, nf.format(gross)),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
    }
}

@Composable
internal fun CreateVolumeWizard(
    viewModel: CloudVolumesViewModel,
    onDismiss: () -> Unit,
    onCreated: () -> Unit,
    projectId: String? = null,
) {
    val opts by viewModel.createOptions.collectAsState()

    var step by remember { mutableStateOf(0) }
    var attachMode by remember { mutableStateOf(true) } // true = attach to server, false = standalone (location)
    var location by remember { mutableStateOf<String?>(null) }
    var serverId by remember { mutableStateOf<Long?>(null) }
    var size by remember { mutableStateOf(10f) } // GB
    var name by remember { mutableStateOf("") }
    var format by remember { mutableStateOf<String?>(null) }
    var automount by remember { mutableStateOf(false) }

    val stepLabels = listOf(
        stringResource(R.string.wizard_step_target),
        stringResource(R.string.wizard_step_size),
        stringResource(R.string.wizard_step_details),
    )

    val canGoNext = when (step) {
        0 -> if (attachMode) serverId != null else location != null
        1 -> size in 10f..10240f
        2 -> name.isNotBlank()
        else -> false
    }

    WizardScaffold(
        title = stringResource(R.string.cloud_volume_create),
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
                size = size.toInt(),
                location = if (attachMode) null else location,
                serverId = if (attachMode) serverId else null,
                format = format,
                automount = if (attachMode) automount else null,
                onDone = { ok -> if (ok) onCreated() },
                projectId = projectId,
            )
        },
        nextLabel = stringResource(R.string.wizard_next),
        finishLabel = stringResource(R.string.cloud_volume_create_action),
        backLabel = stringResource(R.string.wizard_back),
        cancelLabel = stringResource(R.string.cancel),
    ) {
        if (opts.loading) {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
            return@WizardScaffold
        }
        when (step) {
            0 -> Column(modifier = Modifier.fillMaxSize().padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.cloud_volume_attach_mode),
                        modifier = Modifier.weight(1f),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                    Switch(checked = attachMode, onCheckedChange = { attachMode = it })
                }
                if (attachMode) {
                    LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        items(opts.servers, key = { it.id }) { srv ->
                            PickCard(
                                title = srv.name,
                                subtitle = srv.status,
                                icon = Icons.Filled.Computer,
                                selected = serverId == srv.id,
                                onClick = { serverId = srv.id },
                            )
                        }
                    }
                } else {
                    LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        items(opts.locations, key = { it.name }) { loc ->
                            PickCard(
                                title = loc.city ?: loc.name,
                                subtitle = loc.country,
                                icon = Icons.Filled.LocationOn,
                                selected = location == loc.name,
                                onClick = { location = loc.name },
                            )
                        }
                    }
                }
            }
            1 -> Column(
                modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(24.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
            ) {
                Text(
                    text = formatVolumeSize(size.toInt()),
                    style = MaterialTheme.typography.displaySmall,
                    color = MaterialTheme.colorScheme.primary,
                )
                androidx.compose.foundation.layout.FlowRow(
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    listOf(10, 50, 100, 250, 500, 1024, 2048, 5120, 10240).forEach { preset ->
                        androidx.compose.material3.FilterChip(
                            selected = size.toInt() == preset,
                            onClick = { size = preset.toFloat() },
                            label = { Text(formatVolumeSize(preset)) },
                        )
                    }
                }
                Slider(
                    value = size,
                    onValueChange = { size = it.coerceIn(10f, 10240f) },
                    valueRange = 10f..10240f,
                    steps = 0,
                )
                Text(
                    stringResource(R.string.cloud_volume_size_hint),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                VolumePriceEstimate(sizeGb = size.toInt(), opts = opts)
            }
            2 -> Column(
                modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
            ) {
                VolumePriceEstimate(sizeGb = size.toInt(), opts = opts)
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.cloud_volume_create_name)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Text(
                    stringResource(R.string.cloud_volume_format).uppercase(),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf(null, "ext4", "xfs").forEach { f ->
                        val labelKey = f ?: stringResource(R.string.cloud_volume_format_none)
                        androidx.compose.material3.FilterChip(
                            selected = format == f,
                            onClick = { format = f },
                            label = { Text(labelKey) },
                        )
                    }
                }
                if (attachMode) {
                    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
                        Row(
                            modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 12.dp),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            Column(modifier = Modifier.weight(1f)) {
                                Text(
                                    stringResource(R.string.cloud_volume_automount),
                                    style = MaterialTheme.typography.bodyMedium,
                                )
                            }
                            Switch(checked = automount, onCheckedChange = { automount = it })
                        }
                    }
                }
                Spacer(Modifier.size(8.dp))
            }
        }
    }
}
