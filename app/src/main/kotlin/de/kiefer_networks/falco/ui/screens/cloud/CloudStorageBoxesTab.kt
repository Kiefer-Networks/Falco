// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudStorageBox
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.ui.components.EmptyState
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudStorageBoxesUiState(
    val loading: Boolean = true,
    val error: String? = null,
    val data: List<CloudStorageBox> = emptyList(),
)

@HiltViewModel
class CloudStorageBoxesViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudStorageBoxesUiState())
    val state: StateFlow<CloudStorageBoxesUiState> = _state.asStateFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudStorageBoxesUiState(loading = true)
        runCatching { repo.listStorageBoxes() }
            .onSuccess { _state.value = CloudStorageBoxesUiState(loading = false, data = it) }
            .onFailure { _state.value = CloudStorageBoxesUiState(loading = false, error = it.message ?: "error") }
    }
}

@Composable
fun CloudStorageBoxesTab(
    viewModel: CloudStorageBoxesViewModel = hiltViewModel(),
    onOpen: (Long) -> Unit = {},
) {
    val s by viewModel.state.collectAsState()
    when {
        s.loading -> LoadingState()
        s.error != null -> ErrorState(message = s.error!!, onRetry = viewModel::refresh)
        s.data.isEmpty() -> EmptyState(
            icon = Icons.Filled.Inventory2,
            title = stringResource(R.string.cloud_storage_boxes),
            body = stringResource(R.string.empty_list),
        )
        else -> LazyColumn(
            modifier = Modifier.fillMaxSize().padding(horizontal = 12.dp, vertical = 8.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            items(s.data, key = { it.id }) { box -> StorageBoxCard(box, onClick = { onOpen(box.id) }) }
        }
    }
}

@Composable
private fun StorageBoxCard(box: CloudStorageBox, onClick: () -> Unit) {
    ElevatedCard(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                StatusDotColor(active = box.accessible)
                Spacer(Modifier.size(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(box.name, style = MaterialTheme.typography.titleMedium)
                    Text(
                        text = if (box.accessible) {
                            stringResource(R.string.cloud_storage_box_status_active)
                        } else {
                            stringResource(R.string.cloud_storage_box_status_inactive)
                        },
                        style = MaterialTheme.typography.bodySmall,
                        color = if (box.accessible) {
                            MaterialTheme.colorScheme.primary
                        } else {
                            MaterialTheme.colorScheme.onSurfaceVariant
                        },
                    )
                }
                if (box.protection?.delete == true) {
                    Text(
                        text = stringResource(R.string.cloud_storage_box_protected),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.tertiary,
                    )
                }
            }
            box.storageBoxType?.let { st ->
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        stringResource(R.string.cloud_storage_box_type_label) + ": ",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    Text(st.name, style = MaterialTheme.typography.bodyMedium)
                    if (st.size != null) {
                        Spacer(Modifier.size(8.dp))
                        Text(
                            text = "· ${de.kiefer_networks.falco.ui.util.formatBytes(st.size)}",
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            }
            box.location?.let { loc ->
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        Icons.Filled.LocationOn,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(16.dp),
                    )
                    Spacer(Modifier.size(8.dp))
                    Text(
                        text = listOfNotNull(loc.name, loc.city, loc.country).joinToString(" · "),
                        style = MaterialTheme.typography.bodyMedium,
                    )
                }
            }
            val linkedCount = box.linkedResources.size
            Text(
                text = if (linkedCount == 0) {
                    stringResource(R.string.cloud_storage_box_unlinked)
                } else {
                    stringResource(R.string.cloud_storage_box_linked_resources, linkedCount)
                },
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

@Composable
private fun StatusDotColor(active: Boolean) {
    Surface(
        shape = CircleShape,
        color = if (active) Color(0xFF2E7D32) else Color(0xFF9E9E9E),
        modifier = Modifier.size(12.dp),
    ) {}
}
