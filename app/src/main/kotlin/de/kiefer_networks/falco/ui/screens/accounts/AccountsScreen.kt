// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.accounts

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.RadioButtonChecked
import androidx.compose.material.icons.filled.RadioButtonUnchecked
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.StarBorder
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.auth.HetznerAccount

@Composable
fun AccountsScreen(
    viewModel: AccountsViewModel = hiltViewModel(),
    onAdd: () -> Unit,
    onManageProjects: () -> Unit = {},
) {
    val state by viewModel.uiState.collectAsState()
    var pendingRemoval by remember { mutableStateOf<HetznerAccount?>(null) }
    var pendingEdit by remember { mutableStateOf<HetznerAccount?>(null) }
    val drawer = de.kiefer_networks.falco.ui.nav.LocalNavDrawer.current

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(stringResource(R.string.nav_accounts)) },
                navigationIcon = {
                    if (drawer.isCompact) {
                        IconButton(onClick = drawer::open) {
                            Icon(Icons.Filled.Menu, contentDescription = stringResource(R.string.nav_drawer_title))
                        }
                    }
                },
            )
        },
    ) { padding ->
        Box(modifier = Modifier.fillMaxSize().padding(padding)) {
            if (state.accounts.isEmpty()) {
                Column(
                    modifier = Modifier.fillMaxSize().padding(24.dp),
                    verticalArrangement = Arrangement.Center,
                    horizontalAlignment = Alignment.CenterHorizontally,
                ) {
                    Text(stringResource(R.string.accounts_empty), style = MaterialTheme.typography.bodyLarge)
                }
            } else {
                LazyColumn(modifier = Modifier.fillMaxSize().padding(12.dp)) {
                    items(state.accounts, key = { it.id }) { acc ->
                        AccountRow(
                            account = acc,
                            active = state.activeId == acc.id,
                            isDefault = state.defaultId == acc.id,
                            onActivate = { viewModel.setActive(acc.id) },
                            onEdit = { pendingEdit = acc },
                            onSetDefault = { viewModel.setDefault(acc.id) },
                            onRemove = { pendingRemoval = acc },
                            onManageProjects = {
                                viewModel.setActive(acc.id)
                                onManageProjects()
                            },
                        )
                    }
                }
            }
            ExtendedFloatingActionButton(
                onClick = onAdd,
                icon = { Icon(Icons.Filled.Add, contentDescription = null) },
                text = { Text(stringResource(R.string.account_add)) },
                modifier = Modifier.align(Alignment.BottomEnd).padding(24.dp),
            )
        }
    }

    pendingRemoval?.let { acc ->
        AlertDialog(
            onDismissRequest = { pendingRemoval = null },
            title = { Text(stringResource(R.string.account_remove)) },
            text = { Text(stringResource(R.string.account_remove_confirm)) },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.remove(acc.id)
                    pendingRemoval = null
                }) {
                    Text(stringResource(R.string.delete), color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { pendingRemoval = null }) {
                    Text(stringResource(R.string.cancel))
                }
            },
        )
    }

    pendingEdit?.let { acc ->
        EditAccountSheet(
            initial = acc,
            isDefault = state.defaultId == acc.id,
            onDismiss = { pendingEdit = null },
            onSave = { name, desc, makeDefault ->
                viewModel.update(acc.id, name, desc)
                if (makeDefault && state.defaultId != acc.id) viewModel.setDefault(acc.id)
                pendingEdit = null
            },
        )
    }
}

@Composable
private fun AccountRow(
    account: HetznerAccount,
    active: Boolean,
    isDefault: Boolean,
    onActivate: () -> Unit,
    onEdit: () -> Unit,
    onSetDefault: () -> Unit,
    onRemove: () -> Unit,
    onManageProjects: () -> Unit,
) {
    val flags = buildList {
        if (account.cloudProjectCount > 0) {
            add(
                if (account.cloudProjectCount == 1) {
                    stringResource(R.string.account_service_cloud)
                } else {
                    stringResource(R.string.account_service_cloud_with_count, account.cloudProjectCount)
                },
            )
        }
        if (account.hasRobot) add(stringResource(R.string.nav_robot))
        if (account.hasDns) add(stringResource(R.string.nav_dns))
    }.joinToString(" • ")

    var menuOpen by remember { mutableStateOf(false) }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 6.dp)
            .clickable(enabled = !active, onClick = onActivate),
        colors = CardDefaults.cardColors(
            containerColor = if (active) {
                MaterialTheme.colorScheme.secondaryContainer
            } else {
                MaterialTheme.colorScheme.surface
            },
        ),
    ) {
        Row(
            modifier = Modifier.padding(12.dp).fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Icon(
                if (active) Icons.Filled.RadioButtonChecked else Icons.Filled.RadioButtonUnchecked,
                contentDescription = if (active) stringResource(R.string.account_active_label) else null,
                tint = if (active) MaterialTheme.colorScheme.primary else Color.Unspecified,
            )
            Spacer(Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(account.displayName, style = MaterialTheme.typography.titleMedium)
                    if (isDefault) {
                        Spacer(Modifier.width(8.dp))
                        Icon(
                            Icons.Filled.Star,
                            contentDescription = stringResource(R.string.account_default_label),
                            tint = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.size(16.dp),
                        )
                    }
                }
                if (!account.description.isNullOrBlank()) {
                    Text(
                        account.description,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                if (flags.isNotEmpty()) {
                    Text(flags, style = MaterialTheme.typography.bodyMedium)
                }
                Row(verticalAlignment = Alignment.CenterVertically) {
                    if (active) {
                        Text(
                            stringResource(R.string.account_active_label),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.primary,
                        )
                    }
                }
            }
            Box {
                IconButton(onClick = { menuOpen = true }) {
                    Icon(Icons.Filled.MoreVert, contentDescription = null)
                }
                DropdownMenu(expanded = menuOpen, onDismissRequest = { menuOpen = false }) {
                    DropdownMenuItem(
                        leadingIcon = { Icon(Icons.Filled.Edit, contentDescription = null) },
                        text = { Text(stringResource(R.string.account_edit)) },
                        onClick = {
                            menuOpen = false
                            onEdit()
                        },
                    )
                    if (account.cloudProjectCount > 0) {
                        DropdownMenuItem(
                            leadingIcon = { Icon(Icons.Filled.Cloud, contentDescription = null) },
                            text = { Text(stringResource(R.string.account_manage_projects)) },
                            onClick = {
                                menuOpen = false
                                onManageProjects()
                            },
                        )
                    }
                    DropdownMenuItem(
                        leadingIcon = {
                            Icon(
                                if (isDefault) Icons.Filled.Star else Icons.Filled.StarBorder,
                                contentDescription = null,
                                tint = if (isDefault) MaterialTheme.colorScheme.primary else Color.Unspecified,
                            )
                        },
                        text = {
                            Text(
                                if (isDefault) {
                                    stringResource(R.string.account_default_active)
                                } else {
                                    stringResource(R.string.account_set_default)
                                },
                            )
                        },
                        enabled = !isDefault,
                        onClick = {
                            menuOpen = false
                            onSetDefault()
                        },
                    )
                    DropdownMenuItem(
                        text = {
                            Text(
                                stringResource(R.string.account_remove),
                                color = MaterialTheme.colorScheme.error,
                            )
                        },
                        onClick = {
                            menuOpen = false
                            onRemove()
                        },
                    )
                }
            }
        }
    }
}

@Composable
private fun EditAccountSheet(
    initial: HetznerAccount,
    isDefault: Boolean,
    onDismiss: () -> Unit,
    onSave: (name: String, description: String, makeDefault: Boolean) -> Unit,
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    var name by remember { mutableStateOf(initial.displayName) }
    var description by remember { mutableStateOf(initial.description.orEmpty()) }
    var makeDefault by remember { mutableStateOf(isDefault) }

    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheetState) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 24.dp, vertical = 16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            Text(
                stringResource(R.string.account_edit),
                style = MaterialTheme.typography.titleLarge,
            )
            OutlinedTextField(
                value = name,
                onValueChange = { name = it },
                label = { Text(stringResource(R.string.account_name)) },
                singleLine = true,
                modifier = Modifier.fillMaxWidth(),
            )
            OutlinedTextField(
                value = description,
                onValueChange = { description = it },
                label = { Text(stringResource(R.string.account_description)) },
                singleLine = false,
                minLines = 2,
                modifier = Modifier.fillMaxWidth(),
            )
            Row {
                AssistChip(
                    onClick = { makeDefault = !makeDefault },
                    leadingIcon = {
                        Icon(
                            if (makeDefault) Icons.Filled.Star else Icons.Filled.StarBorder,
                            contentDescription = null,
                            modifier = Modifier.size(AssistChipDefaults.IconSize),
                            tint = if (makeDefault) MaterialTheme.colorScheme.primary else Color.Unspecified,
                        )
                    },
                    label = {
                        Text(
                            if (makeDefault) {
                                stringResource(R.string.account_default_active)
                            } else {
                                stringResource(R.string.account_set_default)
                            },
                        )
                    },
                )
            }
            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
                TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
                Spacer(Modifier.width(8.dp))
                Button(
                    enabled = name.isNotBlank(),
                    onClick = { onSave(name.trim(), description.trim(), makeDefault) },
                ) { Text(stringResource(R.string.save)) }
            }
            Spacer(Modifier.size(16.dp))
        }
    }
}
