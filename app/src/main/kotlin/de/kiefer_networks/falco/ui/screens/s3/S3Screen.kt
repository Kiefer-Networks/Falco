// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.s3

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.repo.S3Repo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class S3UiState(val loading: Boolean = true, val buckets: List<String> = emptyList(), val error: String? = null)

@HiltViewModel
class S3ViewModel @Inject constructor(private val repo: S3Repo) : ViewModel() {
    private val _state = MutableStateFlow(S3UiState())
    val state: StateFlow<S3UiState> = _state.asStateFlow()
    init { refresh() }
    fun refresh() = viewModelScope.launch {
        _state.value = S3UiState(loading = true)
        runCatching { repo.listBuckets() }
            .onSuccess { _state.value = S3UiState(loading = false, buckets = it) }
            .onFailure { _state.value = S3UiState(loading = false, error = it.message) }
    }
}

@Composable
fun S3Screen(viewModel: S3ViewModel = hiltViewModel()) {
    val s by viewModel.state.collectAsState()
    when {
        s.loading -> Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
        s.error != null -> Box(Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) { Text(s.error!!) }
        else -> LazyColumn(Modifier.fillMaxSize().padding(12.dp)) {
            items(s.buckets, key = { it }) { bucket ->
                Card(Modifier.fillMaxWidth().padding(vertical = 6.dp)) {
                    Column(Modifier.padding(12.dp)) {
                        Text(bucket, style = MaterialTheme.typography.titleMedium)
                    }
                }
            }
        }
    }
}
