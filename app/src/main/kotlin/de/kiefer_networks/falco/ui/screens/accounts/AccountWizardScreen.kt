// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.foundation.layout.ExperimentalLayoutApi::class,
    androidx.compose.material3.ExperimentalMaterial3Api::class,
)
package de.kiefer_networks.falco.ui.screens.accounts

import android.content.Intent
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.OpenInNew
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material3.Button
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.core.net.toUri
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R

@Composable
fun AccountWizardScreen(
    viewModel: AccountWizardViewModel = hiltViewModel(),
    onClose: (firstService: HetznerService?) -> Unit,
) {
    val state by viewModel.state.collectAsState()
    val steps = remember(state.services) { viewModel.steps(state) }
    val total = steps.size
    val current = steps[state.stepIndex.coerceIn(0, steps.lastIndex)]
    val stepNumber = state.stepIndex + 1

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = stringResource(R.string.wizard_title_step, stepNumber, total),
                            style = MaterialTheme.typography.titleMedium,
                        )
                    },
                    navigationIcon = {
                        IconButton(onClick = {
                            if (state.stepIndex == 0) onClose(null) else viewModel.back()
                        }) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                        }
                    },
                )
                LinearProgressIndicator(
                    progress = { stepNumber.toFloat() / total.toFloat() },
                    modifier = Modifier.fillMaxWidth(),
                )
            }
        },
        bottomBar = {
            Surface(tonalElevation = 3.dp) {
                Row(
                    modifier = Modifier.fillMaxWidth().padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                ) {
                    OutlinedButton(
                        onClick = { viewModel.back() },
                        enabled = state.stepIndex > 0 && current !is WizardStep.Done,
                    ) { Text(stringResource(R.string.wizard_back)) }

                    val isReview = current == WizardStep.Review
                    val isDone = current == WizardStep.Done

                    Button(
                        enabled = viewModel.isCurrentStepValid() && !state.saving,
                        onClick = {
                            when {
                                isReview -> viewModel.save()
                                isDone -> onClose(state.services.firstOrNull())
                                else -> viewModel.next()
                            }
                        },
                    ) {
                        Text(
                            when {
                                isDone -> stringResource(R.string.wizard_finish)
                                isReview -> stringResource(R.string.wizard_save)
                                else -> stringResource(R.string.wizard_next)
                            },
                        )
                    }
                }
            }
        },
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp, vertical = 16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            when (current) {
                WizardStep.Name -> StepName(state = state, viewModel = viewModel)
                WizardStep.ServicePicker -> StepServicePicker(state = state, viewModel = viewModel)
                is WizardStep.Credentials -> when (current.service) {
                    HetznerService.Cloud -> StepCloudProjects(state = state, viewModel = viewModel)
                    HetznerService.Robot -> StepRobot(state = state, viewModel = viewModel)
                    HetznerService.Dns -> StepDns(state = state, viewModel = viewModel)
                }
                WizardStep.Review -> StepReview(state = state, viewModel = viewModel)
                WizardStep.Done -> StepDone(state = state)
            }
        }
    }
}

@Composable
private fun StepHeader(title: String, body: String) {
    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
        Text(title, style = MaterialTheme.typography.headlineSmall)
        Text(
            text = body,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}

@Composable
private fun ConsoleLink(label: String, url: String) {
    val ctx = LocalContext.current
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier
            .fillMaxWidth()
            .clickable { ctx.startActivity(Intent(Intent.ACTION_VIEW, url.toUri())) }
            .padding(vertical = 8.dp),
    ) {
        Icon(
            Icons.Filled.OpenInNew,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(20.dp),
        )
        Spacer(Modifier.size(8.dp))
        Text(
            text = label,
            style = MaterialTheme.typography.labelLarge,
            color = MaterialTheme.colorScheme.primary,
        )
    }
}

@Composable
private fun StepName(state: WizardState, viewModel: AccountWizardViewModel) {
    StepHeader(
        title = stringResource(R.string.wizard_step_name),
        body = stringResource(R.string.wizard_help_name),
    )
    OutlinedTextField(
        value = state.name,
        onValueChange = viewModel::setName,
        label = { Text(stringResource(R.string.account_name)) },
        singleLine = true,
        modifier = Modifier.fillMaxWidth(),
    )
}

@Composable
private fun StepServicePicker(state: WizardState, viewModel: AccountWizardViewModel) {
    StepHeader(
        title = stringResource(R.string.wizard_step_services),
        body = stringResource(R.string.wizard_service_picker_caption),
    )
    FlowRow(
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        val items = listOf(
            HetznerService.Cloud to (Icons.Filled.Cloud to stringResource(R.string.nav_cloud)),
            HetznerService.Robot to (Icons.Filled.Memory to stringResource(R.string.nav_robot)),
            HetznerService.Dns to (Icons.Filled.Dns to stringResource(R.string.nav_dns)),
        )
        items.forEach { (svc, labels) ->
            val selected = svc in state.services
            FilterChip(
                selected = selected,
                onClick = { viewModel.toggleService(svc) },
                leadingIcon = {
                    Icon(
                        labels.first,
                        contentDescription = null,
                        modifier = Modifier.size(FilterChipDefaults.IconSize),
                    )
                },
                label = { Text(labels.second) },
            )
        }
    }
    if (state.services.isEmpty()) {
        Text(
            text = stringResource(R.string.wizard_service_required),
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.error,
        )
    }
}

@Composable
private fun SecretField(label: String, value: String, onValueChange: (String) -> Unit) {
    OutlinedTextField(
        value = value,
        onValueChange = onValueChange,
        label = { Text(label) },
        singleLine = true,
        visualTransformation = PasswordVisualTransformation(),
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
        modifier = Modifier.fillMaxWidth(),
    )
}

@Composable
private fun StepCloudProjects(state: WizardState, viewModel: AccountWizardViewModel) {
    StepHeader(
        title = stringResource(R.string.wizard_step_cloud),
        body = stringResource(R.string.wizard_help_cloud_projects),
    )
    state.cloudProjects.forEachIndexed { idx, draft ->
        ProjectDraftCard(
            index = idx + 1,
            draft = draft,
            removable = state.cloudProjects.size > 1,
            onChange = { transform -> viewModel.updateCloudProject(draft.id, transform) },
            onRemove = { viewModel.removeCloudProject(draft.id) },
        )
    }
    OutlinedButton(
        onClick = { viewModel.addCloudProject() },
        modifier = Modifier.fillMaxWidth(),
    ) {
        Icon(Icons.Filled.Add, contentDescription = null)
        Spacer(Modifier.size(8.dp))
        Text(stringResource(R.string.wizard_add_cloud_project))
    }
    ConsoleLink(
        label = stringResource(R.string.wizard_cloud_link),
        url = "https://console.hetzner.cloud/security/tokens",
    )
}

@Composable
private fun ProjectDraftCard(
    index: Int,
    draft: CloudProjectDraft,
    removable: Boolean,
    onChange: ((CloudProjectDraft) -> CloudProjectDraft) -> Unit,
    onRemove: () -> Unit,
) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    stringResource(R.string.wizard_project_index, index),
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier.weight(1f),
                )
                if (removable) {
                    IconButton(onClick = onRemove) {
                        Icon(
                            Icons.Filled.Delete,
                            contentDescription = stringResource(R.string.delete),
                            tint = MaterialTheme.colorScheme.error,
                        )
                    }
                }
            }
            OutlinedTextField(
                value = draft.name,
                onValueChange = { v -> onChange { it.copy(name = v) } },
                label = { Text(stringResource(R.string.project_form_name)) },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
            )
            SecretField(
                label = stringResource(R.string.project_form_token),
                value = draft.token,
                onValueChange = { v -> onChange { it.copy(token = v) } },
            )
            HorizontalDivider()
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    stringResource(R.string.project_form_s3_toggle),
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier.weight(1f),
                )
                Switch(
                    checked = draft.s3Enabled,
                    onCheckedChange = { v -> onChange { it.copy(s3Enabled = v) } },
                )
            }
            if (draft.s3Enabled) {
                OutlinedTextField(
                    value = draft.s3Endpoint,
                    onValueChange = { v -> onChange { it.copy(s3Endpoint = v) } },
                    label = { Text(stringResource(R.string.account_s3_endpoint)) },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Uri),
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = draft.s3Region,
                    onValueChange = { v -> onChange { it.copy(s3Region = v) } },
                    label = { Text(stringResource(R.string.account_s3_region_optional)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                SecretField(
                    label = stringResource(R.string.account_s3_access_key),
                    value = draft.s3AccessKey,
                    onValueChange = { v -> onChange { it.copy(s3AccessKey = v) } },
                )
                SecretField(
                    label = stringResource(R.string.account_s3_secret_key),
                    value = draft.s3SecretKey,
                    onValueChange = { v -> onChange { it.copy(s3SecretKey = v) } },
                )
            }
        }
    }
}

@Composable
private fun StepRobot(state: WizardState, viewModel: AccountWizardViewModel) {
    StepHeader(
        title = stringResource(R.string.wizard_step_robot),
        body = stringResource(R.string.wizard_help_robot),
    )
    OutlinedTextField(
        value = state.robot.user,
        onValueChange = viewModel::setRobotUser,
        label = { Text(stringResource(R.string.account_robot_user)) },
        singleLine = true,
        modifier = Modifier.fillMaxWidth(),
    )
    SecretField(
        label = stringResource(R.string.account_robot_pass),
        value = state.robot.pass,
        onValueChange = viewModel::setRobotPass,
    )
    ConsoleLink(
        label = stringResource(R.string.wizard_robot_link),
        url = "https://robot.hetzner.com/preferences/index",
    )
}

@Composable
private fun StepDns(state: WizardState, viewModel: AccountWizardViewModel) {
    StepHeader(
        title = stringResource(R.string.wizard_step_dns),
        body = stringResource(R.string.wizard_help_dns),
    )
    SecretField(
        label = stringResource(R.string.account_dns_token),
        value = state.dns.token,
        onValueChange = viewModel::setDnsToken,
    )
    ConsoleLink(
        label = stringResource(R.string.wizard_dns_link),
        url = "https://dns.hetzner.com/settings/api-token",
    )
}

@Composable
private fun StepReview(state: WizardState, viewModel: AccountWizardViewModel) {
    var revealed by remember { mutableStateOf(false) }
    StepHeader(
        title = stringResource(R.string.wizard_step_review),
        body = stringResource(R.string.wizard_help_review),
    )
    Row(verticalAlignment = Alignment.CenterVertically) {
        IconButton(onClick = { revealed = !revealed }) {
            Icon(
                if (revealed) Icons.Filled.VisibilityOff else Icons.Filled.Visibility,
                contentDescription = null,
            )
        }
        Text(
            text = if (revealed) {
                stringResource(R.string.wizard_review_revealed)
            } else {
                stringResource(R.string.wizard_review_hidden)
            },
            style = MaterialTheme.typography.bodyMedium,
        )
    }
    HorizontalDivider()

    ReviewRow(label = stringResource(R.string.account_name), value = state.name)

    if (HetznerService.Cloud in state.services && state.cloudProjects.isNotEmpty()) {
        state.cloudProjects.forEachIndexed { idx, draft ->
            ReviewSection(
                icon = Icons.Filled.Cloud,
                title = stringResource(R.string.wizard_review_project_title, idx + 1, draft.name),
                onEdit = { viewModel.goToStep(WizardStep.Credentials(HetznerService.Cloud)) },
            ) {
                ReviewRow(
                    label = stringResource(R.string.project_form_token),
                    value = mask(draft.token, revealed),
                )
                if (draft.s3Enabled) {
                    ReviewRow(label = stringResource(R.string.account_s3_endpoint), value = draft.s3Endpoint)
                    if (draft.s3Region.isNotBlank()) {
                        ReviewRow(
                            label = stringResource(R.string.account_s3_region_optional),
                            value = draft.s3Region,
                        )
                    }
                    ReviewRow(
                        label = stringResource(R.string.account_s3_access_key),
                        value = mask(draft.s3AccessKey, revealed),
                    )
                    ReviewRow(
                        label = stringResource(R.string.account_s3_secret_key),
                        value = mask(draft.s3SecretKey, revealed),
                    )
                }
            }
        }
    }
    if (HetznerService.Robot in state.services) {
        ReviewSection(
            icon = Icons.Filled.Memory,
            title = stringResource(R.string.nav_robot),
            onEdit = { viewModel.goToStep(WizardStep.Credentials(HetznerService.Robot)) },
        ) {
            ReviewRow(label = stringResource(R.string.account_robot_user), value = state.robot.user)
            ReviewRow(
                label = stringResource(R.string.account_robot_pass),
                value = mask(state.robot.pass, revealed),
            )
        }
    }
    if (HetznerService.Dns in state.services) {
        ReviewSection(
            icon = Icons.Filled.Dns,
            title = stringResource(R.string.nav_dns),
            onEdit = { viewModel.goToStep(WizardStep.Credentials(HetznerService.Dns)) },
        ) {
            ReviewRow(
                label = stringResource(R.string.account_dns_token),
                value = mask(state.dns.token, revealed),
            )
        }
    }
}

@Composable
private fun ReviewSection(
    icon: ImageVector,
    title: String,
    onEdit: () -> Unit,
    content: @Composable () -> Unit,
) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth(),
            ) {
                Icon(icon, contentDescription = null, tint = MaterialTheme.colorScheme.primary)
                Spacer(Modifier.size(8.dp))
                Text(text = title, style = MaterialTheme.typography.titleMedium, modifier = Modifier.weight(1f))
                IconButton(onClick = onEdit) {
                    Icon(Icons.Filled.Edit, contentDescription = stringResource(R.string.wizard_review_edit))
                }
            }
            content()
        }
    }
}

@Composable
private fun ReviewRow(label: String, value: String) {
    Column {
        Text(
            label,
            style = MaterialTheme.typography.labelMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Text(value.ifBlank { "—" }, style = MaterialTheme.typography.bodyMedium)
    }
}

private fun mask(value: String, revealed: Boolean): String {
    if (value.isBlank()) return value
    return if (revealed) value else "•".repeat(value.length.coerceAtMost(20))
}

@Composable
private fun StepDone(state: WizardState) {
    Box(modifier = Modifier.fillMaxSize().height(360.dp), contentAlignment = Alignment.Center) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            Surface(
                shape = CircleShape,
                color = MaterialTheme.colorScheme.primaryContainer,
                modifier = Modifier.size(96.dp),
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(
                        Icons.Filled.CheckCircle,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onPrimaryContainer,
                        modifier = Modifier.size(56.dp),
                    )
                }
            }
            Text(
                text = stringResource(R.string.wizard_step_done),
                style = MaterialTheme.typography.headlineSmall,
            )
            Text(
                text = stringResource(R.string.wizard_done_caption, state.name),
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

@Suppress("unused") private val keepStorageIcon = Icons.Filled.Storage
