// SPDX-License-Identifier: GPL-3.0-or-later
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
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Cloud
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
import androidx.compose.material3.ExperimentalMaterial3Api
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
import androidx.compose.material3.Text
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
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.unit.dp
import androidx.core.net.toUri
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R

@OptIn(ExperimentalMaterial3Api::class)
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
                    HetznerService.Cloud -> StepCloud(state = state, viewModel = viewModel)
                    HetznerService.Robot -> StepRobot(state = state, viewModel = viewModel)
                    HetznerService.Dns -> StepDns(state = state, viewModel = viewModel)
                    HetznerService.S3 -> StepS3(state = state, viewModel = viewModel)
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

@OptIn(ExperimentalMaterial3Api::class, androidx.compose.foundation.layout.ExperimentalLayoutApi::class)
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
            HetznerService.S3 to (Icons.Filled.Storage to stringResource(R.string.nav_storage)),
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
private fun StepCloud(state: WizardState, viewModel: AccountWizardViewModel) {
    StepHeader(
        title = stringResource(R.string.wizard_step_cloud),
        body = stringResource(R.string.wizard_help_cloud),
    )
    SecretField(
        label = stringResource(R.string.account_cloud_token),
        value = state.cloud.token,
        onValueChange = viewModel::setCloudToken,
    )
    ConsoleLink(
        label = stringResource(R.string.wizard_cloud_link),
        url = "https://console.hetzner.cloud/security/tokens",
    )
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
private fun StepS3(state: WizardState, viewModel: AccountWizardViewModel) {
    StepHeader(
        title = stringResource(R.string.wizard_step_s3),
        body = stringResource(R.string.wizard_help_s3),
    )
    OutlinedTextField(
        value = state.s3.endpoint,
        onValueChange = viewModel::setS3Endpoint,
        label = { Text(stringResource(R.string.account_s3_endpoint)) },
        singleLine = true,
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Uri),
        modifier = Modifier.fillMaxWidth(),
    )
    OutlinedTextField(
        value = state.s3.region,
        onValueChange = viewModel::setS3Region,
        label = { Text(stringResource(R.string.account_s3_region_optional)) },
        singleLine = true,
        modifier = Modifier.fillMaxWidth(),
    )
    SecretField(
        label = stringResource(R.string.account_s3_access_key),
        value = state.s3.accessKey,
        onValueChange = viewModel::setS3AccessKey,
    )
    SecretField(
        label = stringResource(R.string.account_s3_secret_key),
        value = state.s3.secretKey,
        onValueChange = viewModel::setS3SecretKey,
    )
    ConsoleLink(
        label = stringResource(R.string.wizard_s3_link),
        url = "https://console.hetzner.cloud/",
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
    if (HetznerService.Cloud in state.services) {
        ReviewSection(
            icon = Icons.Filled.Cloud,
            title = stringResource(R.string.nav_cloud),
            onEdit = { viewModel.goToStep(WizardStep.Credentials(HetznerService.Cloud)) },
        ) {
            ReviewRow(
                label = stringResource(R.string.account_cloud_token),
                value = mask(state.cloud.token, revealed),
            )
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
    if (HetznerService.S3 in state.services) {
        ReviewSection(
            icon = Icons.Filled.Storage,
            title = stringResource(R.string.nav_storage),
            onEdit = { viewModel.goToStep(WizardStep.Credentials(HetznerService.S3)) },
        ) {
            ReviewRow(label = stringResource(R.string.account_s3_endpoint), value = state.s3.endpoint)
            if (state.s3.region.isNotBlank()) {
                ReviewRow(
                    label = stringResource(R.string.account_s3_region_optional),
                    value = state.s3.region,
                )
            }
            ReviewRow(
                label = stringResource(R.string.account_s3_access_key),
                value = mask(state.s3.accessKey, revealed),
            )
            ReviewRow(
                label = stringResource(R.string.account_s3_secret_key),
                value = mask(state.s3.secretKey, revealed),
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
