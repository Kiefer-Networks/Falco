// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.dto.CloudCertificate
import de.kiefer_networks.falco.data.dto.CloudLoadBalancer
import de.kiefer_networks.falco.data.dto.CloudPlacementGroup
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.data.util.sanitizeError
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class CloudLoadBalancersUiState(
    val loading: Boolean = true,
    val data: List<CloudLoadBalancer> = emptyList(),
    val error: String? = null,
)

@HiltViewModel
class CloudLoadBalancersViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudLoadBalancersUiState())
    val state: StateFlow<CloudLoadBalancersUiState> = _state.asStateFlow()
    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudLoadBalancersUiState(loading = true)
        runCatching { repo.listLoadBalancers() }
            .onSuccess { _state.value = CloudLoadBalancersUiState(loading = false, data = it) }
            .onFailure { _state.value = CloudLoadBalancersUiState(loading = false, error = sanitizeError(it)) }
    }

    fun delete(id: Long) = viewModelScope.launch {
        runCatching { repo.deleteLoadBalancer(id) }
            .onSuccess { refresh() }
            .onFailure { _events.emit(sanitizeError(it)) }
    }
}

data class CloudCertificatesUiState(
    val loading: Boolean = true,
    val data: List<CloudCertificate> = emptyList(),
    val error: String? = null,
)

@HiltViewModel
class CloudCertificatesViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudCertificatesUiState())
    val state: StateFlow<CloudCertificatesUiState> = _state.asStateFlow()
    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudCertificatesUiState(loading = true)
        runCatching { repo.listCertificates() }
            .onSuccess { _state.value = CloudCertificatesUiState(loading = false, data = it) }
            .onFailure { _state.value = CloudCertificatesUiState(loading = false, error = sanitizeError(it)) }
    }

    fun delete(id: Long) = viewModelScope.launch {
        runCatching { repo.deleteCertificate(id) }
            .onSuccess { refresh() }
            .onFailure { _events.emit(sanitizeError(it)) }
    }

    fun upload(
        name: String,
        certificate: String,
        privateKey: String,
        onDone: (Boolean) -> Unit,
        projectId: String? = null,
    ) =
        viewModelScope.launch {
            runCatching { repo.uploadCertificate(name.trim(), certificate, privateKey, projectId) }
                .onSuccess { refresh(); onDone(true) }
                .onFailure { _events.emit(sanitizeError(it)); onDone(false) }
        }

    fun requestManaged(
        name: String,
        domains: List<String>,
        onDone: (Boolean) -> Unit,
        projectId: String? = null,
    ) =
        viewModelScope.launch {
            runCatching { repo.requestManagedCertificate(name.trim(), domains, projectId) }
                .onSuccess { refresh(); onDone(true) }
                .onFailure { _events.emit(sanitizeError(it)); onDone(false) }
        }
}

data class CloudPlacementGroupsUiState(
    val loading: Boolean = true,
    val data: List<CloudPlacementGroup> = emptyList(),
    val error: String? = null,
)

@HiltViewModel
class CloudPlacementGroupsViewModel @Inject constructor(private val repo: CloudRepo) : ViewModel() {
    private val _state = MutableStateFlow(CloudPlacementGroupsUiState())
    val state: StateFlow<CloudPlacementGroupsUiState> = _state.asStateFlow()
    private val _events = MutableSharedFlow<String>(extraBufferCapacity = 4)
    val events: SharedFlow<String> = _events.asSharedFlow()

    init { refresh() }

    fun refresh() = viewModelScope.launch {
        _state.value = CloudPlacementGroupsUiState(loading = true)
        runCatching { repo.listPlacementGroups() }
            .onSuccess { _state.value = CloudPlacementGroupsUiState(loading = false, data = it) }
            .onFailure { _state.value = CloudPlacementGroupsUiState(loading = false, error = sanitizeError(it)) }
    }

    fun create(
        name: String,
        type: String,
        onDone: (Boolean) -> Unit,
        projectId: String? = null,
    ) = viewModelScope.launch {
        runCatching { repo.createPlacementGroup(name.trim(), type, projectId) }
            .onSuccess { refresh(); onDone(true) }
            .onFailure { _events.emit(sanitizeError(it)); onDone(false) }
    }

    fun delete(id: Long) = viewModelScope.launch {
        runCatching { repo.deletePlacementGroup(id) }
            .onSuccess { refresh() }
            .onFailure { _events.emit(sanitizeError(it)) }
    }
}
