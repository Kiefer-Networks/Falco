// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.Button
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.model.CloudProject
import java.util.UUID

@Composable
fun ProjectFormScreen(
    projectId: String? = null,
    onClose: () -> Unit,
    viewModel: ProjectsViewModel = hiltViewModel(),
) {
    val uiState by viewModel.state.collectAsState()
    var name by remember { mutableStateOf("") }
    var token by remember { mutableStateOf("") }
    var s3Enabled by remember { mutableStateOf(false) }
    var endpoint by remember { mutableStateOf("fsn1.your-objectstorage.com") }
    var region by remember { mutableStateOf("") }
    var accessKey by remember { mutableStateOf("") }
    var secretKey by remember { mutableStateOf("") }
    var loadedFor by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(projectId, uiState.accountId) {
        if (projectId != null && loadedFor != projectId) {
            viewModel.projectById(projectId)?.let { p ->
                name = p.name
                token = p.cloudToken
                s3Enabled = p.hasS3
                endpoint = p.s3Endpoint ?: "fsn1.your-objectstorage.com"
                region = p.s3Region.orEmpty()
                accessKey = p.s3AccessKey.orEmpty()
                secretKey = p.s3SecretKey.orEmpty()
                loadedFor = projectId
            }
        }
    }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Text(
                        if (projectId == null) {
                            stringResource(R.string.project_picker_add)
                        } else {
                            stringResource(R.string.project_form_save)
                        },
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onClose) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                    }
                },
            )
        },
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp, vertical = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            OutlinedTextField(
                value = name,
                onValueChange = { name = it },
                label = { Text(stringResource(R.string.project_form_name)) },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
            )
            OutlinedTextField(
                value = token,
                onValueChange = { token = it },
                label = { Text(stringResource(R.string.project_form_token)) },
                singleLine = true,
                visualTransformation = PasswordVisualTransformation(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                modifier = Modifier.fillMaxWidth(),
            )
            HorizontalDivider()
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    stringResource(R.string.project_form_s3_toggle),
                    modifier = Modifier.weight(1f),
                    style = MaterialTheme.typography.bodyMedium,
                )
                Switch(checked = s3Enabled, onCheckedChange = { s3Enabled = it })
            }
            if (s3Enabled) {
                OutlinedTextField(
                    value = endpoint,
                    onValueChange = { endpoint = it },
                    label = { Text(stringResource(R.string.account_s3_endpoint)) },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Uri),
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = region,
                    onValueChange = { region = it },
                    label = { Text(stringResource(R.string.account_s3_region_optional)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = accessKey,
                    onValueChange = { accessKey = it },
                    label = { Text(stringResource(R.string.account_s3_access_key)) },
                    singleLine = true,
                    visualTransformation = PasswordVisualTransformation(),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = secretKey,
                    onValueChange = { secretKey = it },
                    label = { Text(stringResource(R.string.account_s3_secret_key)) },
                    singleLine = true,
                    visualTransformation = PasswordVisualTransformation(),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                    modifier = Modifier.fillMaxWidth(),
                )
            }
            Spacer(Modifier.height(16.dp))
            Button(
                onClick = {
                    val project = CloudProject(
                        id = projectId ?: UUID.randomUUID().toString(),
                        name = name,
                        cloudToken = token,
                        s3Endpoint = endpoint.takeIf { s3Enabled && it.isNotBlank() },
                        s3Region = region.takeIf { s3Enabled && it.isNotBlank() },
                        s3AccessKey = accessKey.takeIf { s3Enabled && it.isNotBlank() },
                        s3SecretKey = secretKey.takeIf { s3Enabled && it.isNotBlank() },
                    )
                    if (projectId == null) {
                        viewModel.add(project, onClose)
                    } else {
                        viewModel.update(project, onClose)
                    }
                },
                enabled = name.isNotBlank() && token.isNotBlank() &&
                    (!s3Enabled || (endpoint.isNotBlank() && accessKey.isNotBlank() && secretKey.isNotBlank())),
                modifier = Modifier.fillMaxWidth(),
            ) {
                Text(stringResource(R.string.project_form_save))
            }
        }
    }
}
