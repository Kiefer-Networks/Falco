// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.foundation.layout.ExperimentalLayoutApi::class,
    androidx.compose.material3.ExperimentalMaterial3Api::class,
)
package de.kiefer_networks.falco.ui.screens.cloud

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
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.PhotoCamera
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.Checkbox
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.DialogProperties
import androidx.compose.ui.window.SecureFlagPolicy
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudStorageBox
import de.kiefer_networks.falco.data.dto.CloudStorageBoxAccessSettings
import de.kiefer_networks.falco.data.dto.CloudStorageBoxSnapshot
import de.kiefer_networks.falco.data.dto.CloudStorageBoxSubaccount
import de.kiefer_networks.falco.data.dto.CloudSubaccountAccessSettings
import de.kiefer_networks.falco.ui.components.ErrorState
import de.kiefer_networks.falco.ui.components.LoadingState
import kotlinx.coroutines.launch

@Composable
fun CloudStorageBoxDetailScreen(
    onBack: () -> Unit,
    viewModel: CloudStorageBoxDetailViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsState()
    val snackbar = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        viewModel.events.collect { event ->
            val text = when (event) {
                is StorageBoxEvent.Toast -> event.text
                is StorageBoxEvent.Failure -> event.message
            }
            scope.launch { snackbar.showSnackbar(text) }
        }
    }

    var sheetOpen by remember { mutableStateOf(false) }
    var showResetDialog by remember { mutableStateOf(false) }
    var showCreateSnapshot by remember { mutableStateOf(false) }
    var showCreateSubaccount by remember { mutableStateOf(false) }
    var snapshotPendingDelete by remember { mutableStateOf<CloudStorageBoxSnapshot?>(null) }
    var snapshotPendingRollback by remember { mutableStateOf<CloudStorageBoxSnapshot?>(null) }
    var subaccountPendingDelete by remember { mutableStateOf<CloudStorageBoxSubaccount?>(null) }
    var subaccountResetPassword by remember { mutableStateOf<CloudStorageBoxSubaccount?>(null) }

    Scaffold(
        topBar = {
            Column {
                CenterAlignedTopAppBar(
                    title = {
                        Text(
                            text = state.box?.name ?: stringResource(R.string.cloud_storage_boxes),
                            style = MaterialTheme.typography.titleMedium,
                        )
                    },
                    navigationIcon = {
                        IconButton(onClick = onBack) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                        }
                    },
                    actions = {
                        androidx.compose.material3.FilledTonalButton(
                            onClick = { sheetOpen = true },
                            modifier = Modifier.padding(end = 8.dp),
                        ) {
                            Text(stringResource(R.string.actions_sheet_title))
                        }
                    },
                )
                if (state.running) {
                    LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
                }
            }
        },
        snackbarHost = { SnackbarHost(snackbar) },
    ) { padding ->
        when {
            state.loading -> Box(modifier = Modifier.padding(padding)) { LoadingState() }
            state.error != null -> Box(modifier = Modifier.padding(padding)) {
                ErrorState(message = state.error!!, onRetry = viewModel::refresh)
            }
            else -> {
                val box = state.box ?: return@Scaffold
                LazyColumn(
                    modifier = Modifier.fillMaxSize().padding(padding).padding(horizontal = 12.dp, vertical = 8.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp),
                ) {
                    item { OverviewCard(box) }
                    box.accessSettings?.let { settings ->
                        item {
                            AccessSettingsCard(
                                settings = settings,
                                onSamba = viewModel::setSamba,
                                onSsh = viewModel::setSsh,
                                onWebdav = viewModel::setWebdav,
                                onZfs = viewModel::setZfs,
                                onExternal = viewModel::setExternal,
                            )
                        }
                    }

                    item { SectionHeader(Icons.Filled.PhotoCamera, R.string.storagebox_snapshots) }
                    item {
                        AddRowButton(
                            label = stringResource(R.string.storagebox_create_snapshot),
                            onClick = { showCreateSnapshot = true },
                        )
                    }
                    if (state.snapshots.isEmpty()) {
                        item {
                            Text(
                                stringResource(R.string.empty_list),
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier.padding(8.dp),
                            )
                        }
                    } else {
                        items(state.snapshots, key = { it.id }) { snap ->
                            SnapshotCard(
                                snapshot = snap,
                                onRollback = { snapshotPendingRollback = snap },
                                onDelete = { snapshotPendingDelete = snap },
                            )
                        }
                    }

                    item { SectionHeader(Icons.Filled.Person, R.string.storagebox_subaccounts) }
                    item {
                        AddRowButton(
                            label = stringResource(R.string.storagebox_create_subaccount),
                            onClick = { showCreateSubaccount = true },
                        )
                    }
                    if (state.subaccounts.isEmpty()) {
                        item {
                            Text(
                                stringResource(R.string.empty_list),
                                style = MaterialTheme.typography.bodyMedium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier.padding(8.dp),
                            )
                        }
                    } else {
                        items(state.subaccounts, key = { it.id }) { sub ->
                            SubaccountCard(
                                subaccount = sub,
                                onResetPassword = { subaccountResetPassword = sub },
                                onDelete = { subaccountPendingDelete = sub },
                            )
                        }
                    }
                }
            }
        }
    }

    if (sheetOpen) {
        de.kiefer_networks.falco.ui.components.dialog.ActionsBottomSheetSections(
            title = stringResource(R.string.actions_sheet_title),
            sections = listOf(
                de.kiefer_networks.falco.ui.components.dialog.SheetSection(
                    title = stringResource(R.string.server_detail_section_settings),
                    actions = listOf(
                        de.kiefer_networks.falco.ui.components.dialog.SheetAction(
                            icon = Icons.Filled.Lock,
                            label = stringResource(R.string.storagebox_password_reset),
                        ) { sheetOpen = false; showResetDialog = true },
                    ),
                ),
                de.kiefer_networks.falco.ui.components.dialog.SheetSection(
                    title = stringResource(R.string.server_section_state),
                    actions = listOf(
                        de.kiefer_networks.falco.ui.components.dialog.SheetAction(
                            icon = Icons.Filled.PhotoCamera,
                            label = stringResource(R.string.storagebox_create_snapshot),
                        ) { sheetOpen = false; showCreateSnapshot = true },
                        de.kiefer_networks.falco.ui.components.dialog.SheetAction(
                            icon = Icons.Filled.Person,
                            label = stringResource(R.string.storagebox_create_subaccount),
                        ) { sheetOpen = false; showCreateSubaccount = true },
                    ),
                ),
            ),
            onDismiss = { sheetOpen = false },
        )
    }

    if (showResetDialog) {
        PasswordPromptDialog(
            title = stringResource(R.string.storagebox_password_reset),
            body = stringResource(R.string.storagebox_password_reset_confirm),
            onDismiss = { showResetDialog = false },
            onConfirm = { pw ->
                viewModel.resetPassword(pw)
                showResetDialog = false
            },
        )
    }
    if (showCreateSnapshot) {
        TextPromptDialog(
            title = stringResource(R.string.storagebox_create_snapshot),
            label = stringResource(R.string.storagebox_snapshot_description),
            initial = "",
            optional = true,
            onDismiss = { showCreateSnapshot = false },
            onConfirm = { desc ->
                viewModel.createSnapshot(desc.takeIf(String::isNotBlank))
                showCreateSnapshot = false
            },
        )
    }
    snapshotPendingDelete?.let { snap ->
        ConfirmDialog(
            title = stringResource(R.string.storagebox_snapshot_delete_title),
            message = stringResource(R.string.storagebox_snapshot_delete_confirm, snap.name ?: snap.id.toString()),
            destructive = true,
            onDismiss = { snapshotPendingDelete = null },
            onConfirm = {
                viewModel.deleteSnapshot(snap.id)
                snapshotPendingDelete = null
            },
        )
    }
    snapshotPendingRollback?.let { snap ->
        ConfirmDialog(
            title = stringResource(R.string.storagebox_snapshot_rollback_title),
            message = stringResource(R.string.storagebox_snapshot_rollback_confirm),
            destructive = true,
            onDismiss = { snapshotPendingRollback = null },
            onConfirm = {
                viewModel.rollbackSnapshot(snap.id)
                snapshotPendingRollback = null
            },
        )
    }
    if (showCreateSubaccount) {
        SubaccountFormDialog(
            onDismiss = { showCreateSubaccount = false },
            onConfirm = { password, home, access, desc ->
                viewModel.createSubaccount(password, home, access, desc)
                showCreateSubaccount = false
            },
        )
    }
    subaccountPendingDelete?.let { sub ->
        ConfirmDialog(
            title = stringResource(R.string.storagebox_subaccount_delete_title),
            message = stringResource(R.string.storagebox_subaccount_delete_confirm, sub.username),
            destructive = true,
            onDismiss = { subaccountPendingDelete = null },
            onConfirm = {
                viewModel.deleteSubaccount(sub.id)
                subaccountPendingDelete = null
            },
        )
    }
    subaccountResetPassword?.let { sub ->
        PasswordPromptDialog(
            title = stringResource(R.string.storagebox_subaccount_password_reset),
            body = stringResource(R.string.storagebox_subaccount_password_reset_confirm, sub.username),
            onDismiss = { subaccountResetPassword = null },
            onConfirm = { pw ->
                viewModel.resetSubaccountPassword(sub.id, pw)
                subaccountResetPassword = null
            },
        )
    }
}

@Composable
private fun OverviewCard(box: CloudStorageBox) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Surface(
                    shape = CircleShape,
                    color = if (box.accessible) Color(0xFF2E7D32) else Color(0xFF9E9E9E),
                    modifier = Modifier.size(12.dp),
                ) {}
                Spacer(Modifier.size(12.dp))
                Text(
                    text = if (box.accessible) {
                        stringResource(R.string.cloud_storage_box_status_active)
                    } else {
                        stringResource(R.string.cloud_storage_box_status_inactive)
                    },
                    style = MaterialTheme.typography.titleSmall,
                    color = if (box.accessible) {
                        MaterialTheme.colorScheme.primary
                    } else {
                        MaterialTheme.colorScheme.onSurfaceVariant
                    },
                )
                if (box.protection?.delete == true) {
                    Spacer(Modifier.size(8.dp))
                    Text(
                        stringResource(R.string.cloud_storage_box_protected),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.tertiary,
                    )
                }
            }
            HorizontalDivider()
            box.username?.let { Property(label = stringResource(R.string.account_robot_user), value = it) }
            box.storageBoxType?.let { st ->
                Property(label = stringResource(R.string.cloud_storage_box_type_label), value = st.name)
                st.size?.let {
                    Property(
                        label = stringResource(R.string.cloud_storage_box_size_label),
                        value = de.kiefer_networks.falco.ui.util.formatBytes(it),
                    )
                }
            }
            box.stats?.let { stats ->
                val total = box.storageBoxType?.size
                val used = stats.size
                if (used != null && total != null) {
                    Property(
                        label = stringResource(R.string.storagebox_stats_used),
                        value = "${de.kiefer_networks.falco.ui.util.formatBytes(used)} / ${de.kiefer_networks.falco.ui.util.formatBytes(total)}",
                    )
                } else if (used != null) {
                    Property(
                        label = stringResource(R.string.storagebox_stats_used),
                        value = de.kiefer_networks.falco.ui.util.formatBytes(used),
                    )
                }
                stats.sizeData?.let {
                    Property(
                        label = stringResource(R.string.storagebox_stats_data),
                        value = de.kiefer_networks.falco.ui.util.formatBytes(it),
                    )
                }
                stats.sizeSnapshots?.let {
                    Property(
                        label = stringResource(R.string.storagebox_stats_snapshots),
                        value = de.kiefer_networks.falco.ui.util.formatBytes(it),
                    )
                }
            }
            box.location?.let { loc ->
                Property(
                    label = stringResource(R.string.server_label_location),
                    value = listOfNotNull(loc.name, loc.city, loc.country).joinToString(" · "),
                )
            }
            if (box.linkedResources.isNotEmpty()) {
                Property(
                    label = stringResource(R.string.cloud_storage_box_linked_resources, box.linkedResources.size),
                    value = box.linkedResources.joinToString(" · ") { "${it.type}#${it.id ?: 0}" },
                )
            }
        }
    }
}

@Composable
private fun AccessSettingsCard(
    settings: CloudStorageBoxAccessSettings,
    onSamba: (Boolean) -> Unit,
    onSsh: (Boolean) -> Unit,
    onWebdav: (Boolean) -> Unit,
    onZfs: (Boolean) -> Unit,
    onExternal: (Boolean) -> Unit,
) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
            Text(
                stringResource(R.string.storagebox_access_title),
                style = MaterialTheme.typography.titleSmall,
                color = MaterialTheme.colorScheme.primary,
            )
            Text(
                stringResource(R.string.storagebox_access_caption),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            AccessRow(stringResource(R.string.storagebox_subaccount_ssh), settings.sshEnabled, onSsh)
            AccessRow(stringResource(R.string.storagebox_subaccount_samba), settings.sambaEnabled, onSamba)
            AccessRow(stringResource(R.string.storagebox_subaccount_webdav), settings.webdavEnabled, onWebdav)
            AccessRow(stringResource(R.string.storagebox_access_zfs), settings.zfsEnabled, onZfs)
            AccessRow(stringResource(R.string.storagebox_subaccount_external), settings.reachableExternally, onExternal)
        }
    }
}

@Composable
private fun AccessRow(label: String, checked: Boolean, onCheckedChange: (Boolean) -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(label, modifier = Modifier.weight(1f), style = MaterialTheme.typography.bodyMedium)
        androidx.compose.material3.Switch(checked = checked, onCheckedChange = onCheckedChange)
    }
}

@Composable
private fun SnapshotCard(
    snapshot: CloudStorageBoxSnapshot,
    onRollback: () -> Unit,
    onDelete: () -> Unit,
) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Row(modifier = Modifier.padding(16.dp).fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                Text(
                    snapshot.name ?: "#${snapshot.id}",
                    style = MaterialTheme.typography.titleMedium,
                )
                if (!snapshot.description.isNullOrBlank()) {
                    Text(snapshot.description!!, style = MaterialTheme.typography.bodySmall)
                }
                Text(
                    text = listOfNotNull(
                        snapshot.created,
                        snapshot.stats?.size?.let { de.kiefer_networks.falco.ui.util.formatBytes(it) },
                        if (snapshot.isAutomatic) stringResource(R.string.storagebox_snapshot_automatic) else null,
                    ).joinToString(" · "),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            var menuOpen by remember { mutableStateOf(false) }
            Box {
                IconButton(onClick = { menuOpen = true }) {
                    Icon(Icons.Filled.MoreVert, contentDescription = null)
                }
                DropdownMenu(expanded = menuOpen, onDismissRequest = { menuOpen = false }) {
                    DropdownMenuItem(
                        text = { Text(stringResource(R.string.storagebox_snapshot_rollback)) },
                        leadingIcon = { Icon(Icons.Filled.History, contentDescription = null) },
                        onClick = {
                            menuOpen = false
                            onRollback()
                        },
                    )
                    DropdownMenuItem(
                        text = {
                            Text(
                                stringResource(R.string.delete),
                                color = MaterialTheme.colorScheme.error,
                            )
                        },
                        leadingIcon = {
                            Icon(
                                Icons.Filled.Delete,
                                contentDescription = null,
                                tint = MaterialTheme.colorScheme.error,
                            )
                        },
                        onClick = {
                            menuOpen = false
                            onDelete()
                        },
                    )
                }
            }
        }
    }
}

@Composable
private fun SubaccountCard(
    subaccount: CloudStorageBoxSubaccount,
    onResetPassword: () -> Unit,
    onDelete: () -> Unit,
) {
    ElevatedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
                    Text(subaccount.username, style = MaterialTheme.typography.titleMedium)
                    if (!subaccount.description.isNullOrBlank()) {
                        Text(
                            subaccount.description!!,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    if (!subaccount.homeDirectory.isNullOrBlank()) {
                        Text(
                            subaccount.homeDirectory!!,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
                var menuOpen by remember { mutableStateOf(false) }
                Box {
                    IconButton(onClick = { menuOpen = true }) {
                        Icon(Icons.Filled.MoreVert, contentDescription = null)
                    }
                    DropdownMenu(expanded = menuOpen, onDismissRequest = { menuOpen = false }) {
                        DropdownMenuItem(
                            text = { Text(stringResource(R.string.storagebox_subaccount_password_reset)) },
                            leadingIcon = { Icon(Icons.Filled.Lock, contentDescription = null) },
                            onClick = {
                                menuOpen = false
                                onResetPassword()
                            },
                        )
                        DropdownMenuItem(
                            text = {
                                Text(
                                    stringResource(R.string.delete),
                                    color = MaterialTheme.colorScheme.error,
                                )
                            },
                            leadingIcon = {
                                Icon(
                                    Icons.Filled.Delete,
                                    contentDescription = null,
                                    tint = MaterialTheme.colorScheme.error,
                                )
                            },
                            onClick = {
                                menuOpen = false
                                onDelete()
                            },
                        )
                    }
                }
            }
            val access = subaccount.accessSettings
            if (access != null) {
                FlowRow(horizontalArrangement = Arrangement.spacedBy(6.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                    if (access.sshEnabled) ProtocolBadge(stringResource(R.string.storagebox_subaccount_ssh))
                    if (access.sambaEnabled) ProtocolBadge(stringResource(R.string.storagebox_subaccount_samba))
                    if (access.webdavEnabled) ProtocolBadge(stringResource(R.string.storagebox_subaccount_webdav))
                    if (access.readonly) ProtocolBadge(stringResource(R.string.storagebox_subaccount_readonly), tonal = true)
                }
            }
        }
    }
}

@Composable
private fun ProtocolBadge(label: String, tonal: Boolean = false) {
    AssistChip(
        onClick = {},
        label = { Text(label, style = MaterialTheme.typography.labelMedium) },
        colors = if (tonal) {
            AssistChipDefaults.assistChipColors(
                containerColor = MaterialTheme.colorScheme.tertiaryContainer,
                labelColor = MaterialTheme.colorScheme.onTertiaryContainer,
            )
        } else {
            AssistChipDefaults.assistChipColors()
        },
    )
}

@Composable
private fun Property(label: String, value: String) {
    Column {
        Text(
            label,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Text(value, style = MaterialTheme.typography.bodyMedium)
    }
}

@Composable
private fun SectionHeader(icon: ImageVector, @androidx.annotation.StringRes resId: Int) {
    Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.padding(top = 12.dp, bottom = 4.dp)) {
        Icon(icon, contentDescription = null, tint = MaterialTheme.colorScheme.primary, modifier = Modifier.size(20.dp))
        Spacer(Modifier.size(8.dp))
        Text(
            stringResource(resId),
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.primary,
        )
    }
}

@Composable
private fun AddRowButton(label: String, onClick: () -> Unit) {
    Surface(
        onClick = onClick,
        shape = androidx.compose.foundation.shape.RoundedCornerShape(12.dp),
        color = MaterialTheme.colorScheme.surfaceVariant,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            Icon(
                Icons.Filled.Add,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.primary,
            )
            Text(label, color = MaterialTheme.colorScheme.primary)
        }
    }
}

@Composable
private fun ConfirmDialog(
    title: String,
    message: String,
    destructive: Boolean,
    onDismiss: () -> Unit,
    onConfirm: () -> Unit,
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = { Text(message) },
        confirmButton = {
            TextButton(onClick = onConfirm) {
                Text(
                    stringResource(R.string.ok),
                    color = if (destructive) MaterialTheme.colorScheme.error else MaterialTheme.colorScheme.primary,
                )
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

@Composable
private fun PasswordPromptDialog(
    title: String,
    body: String,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    var pw by remember { mutableStateOf("") }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(body)
                OutlinedTextField(
                    value = pw,
                    onValueChange = { pw = it },
                    label = { Text(stringResource(R.string.storagebox_new_password)) },
                    singleLine = true,
                    visualTransformation = PasswordVisualTransformation(),
                )
            }
        },
        confirmButton = {
            TextButton(enabled = pw.length >= 8, onClick = { onConfirm(pw) }) {
                Text(stringResource(R.string.ok))
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
        properties = DialogProperties(securePolicy = SecureFlagPolicy.SecureOn),
    )
}

@Composable
private fun TextPromptDialog(
    title: String,
    label: String,
    initial: String,
    optional: Boolean,
    onDismiss: () -> Unit,
    onConfirm: (String) -> Unit,
) {
    var text by remember { mutableStateOf(initial) }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            OutlinedTextField(
                value = text,
                onValueChange = { text = it },
                label = { Text(label) },
                singleLine = false,
            )
        },
        confirmButton = {
            TextButton(
                enabled = optional || text.isNotBlank(),
                onClick = { onConfirm(text) },
            ) { Text(stringResource(R.string.ok)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}

/**
 * SSH / Samba / WebDAV are gated by the box-level access_settings — toggling
 * them per subaccount can never widen the box's permission. Keep only the
 * subaccount-specific flags (readonly + external) here; protocol toggles
 * inherit from the box.
 */
@Composable
private fun SubaccountFormDialog(
    onDismiss: () -> Unit,
    onConfirm: (password: String, home: String, access: CloudSubaccountAccessSettings, desc: String?) -> Unit,
) {
    var password by remember { mutableStateOf("") }
    var home by remember { mutableStateOf("/") }
    var description by remember { mutableStateOf("") }
    var readonly by remember { mutableStateOf(false) }
    var external by remember { mutableStateOf(false) }

    androidx.compose.ui.window.Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(
            usePlatformDefaultWidth = false,
            securePolicy = SecureFlagPolicy.SecureOn,
        ),
    ) {
        Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
            Scaffold(
                topBar = {
                    CenterAlignedTopAppBar(
                        title = { Text(stringResource(R.string.storagebox_create_subaccount)) },
                        navigationIcon = {
                            IconButton(onClick = onDismiss) {
                                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                            }
                        },
                        actions = {
                            TextButton(
                                enabled = password.length >= 8 && home.isNotBlank(),
                                onClick = {
                                    onConfirm(
                                        password,
                                        home,
                                        CloudSubaccountAccessSettings(
                                            sambaEnabled = false,
                                            sshEnabled = true,
                                            webdavEnabled = false,
                                            readonly = readonly,
                                            reachableExternally = external,
                                        ),
                                        description.takeIf(String::isNotBlank),
                                    )
                                },
                            ) { Text(stringResource(R.string.save)) }
                        },
                    )
                },
            ) { padding ->
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding)
                        .padding(horizontal = 16.dp, vertical = 8.dp)
                        .verticalScroll(rememberScrollState()),
                    verticalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    OutlinedTextField(
                        value = password,
                        onValueChange = { password = it },
                        label = { Text(stringResource(R.string.storagebox_new_password)) },
                        singleLine = true,
                        visualTransformation = PasswordVisualTransformation(),
                        modifier = Modifier.fillMaxWidth(),
                    )
                    OutlinedTextField(
                        value = home,
                        onValueChange = { home = it },
                        label = { Text(stringResource(R.string.storagebox_subaccount_homedir)) },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                    )
                    OutlinedTextField(
                        value = description,
                        onValueChange = { description = it },
                        label = { Text(stringResource(R.string.dns_record_value)) },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                    )
                    Text(
                        stringResource(R.string.storagebox_subaccount_protocols_hint),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                    ProtocolToggle(
                        checked = readonly,
                        onCheckedChange = { readonly = it },
                        label = stringResource(R.string.storagebox_subaccount_readonly),
                    )
                    ProtocolToggle(
                        checked = external,
                        onCheckedChange = { external = it },
                        label = stringResource(R.string.storagebox_subaccount_external),
                    )
                }
            }
        }
    }
}

@Composable
private fun ProtocolToggle(checked: Boolean, onCheckedChange: (Boolean) -> Unit, label: String) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Checkbox(checked = checked, onCheckedChange = onCheckedChange)
        Spacer(Modifier.size(8.dp))
        Text(label)
    }
}
