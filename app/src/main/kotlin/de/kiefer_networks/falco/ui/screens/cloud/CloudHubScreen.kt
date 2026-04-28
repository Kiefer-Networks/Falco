// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.Hub
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material.icons.filled.SwapHoriz
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SecondaryTabRow
import androidx.compose.material3.Tab
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.ui.components.EmptyState

private data class CloudTab(val labelRes: Int, val icon: ImageVector)

private val CLOUD_TABS = listOf(
    CloudTab(R.string.cloud_servers, Icons.Filled.Computer),
    CloudTab(R.string.cloud_volumes, Icons.Filled.Storage),
    CloudTab(R.string.cloud_networks, Icons.Filled.Hub),
    CloudTab(R.string.cloud_firewalls, Icons.Filled.Security),
    CloudTab(R.string.cloud_floating_ips, Icons.Filled.SwapHoriz),
    CloudTab(R.string.cloud_storage_boxes, Icons.Filled.Inventory2),
)

@Composable
fun CloudHubScreen(
    onAddProject: () -> Unit,
    onManageProjects: () -> Unit,
    onOpenStorageBox: (Long) -> Unit = {},
    onOpenServer: (Long) -> Unit = {},
    viewModel: ProjectsViewModel = hiltViewModel(),
) {
    var selected by rememberSaveable { mutableIntStateOf(0) }
    var pickerOpen by remember { mutableStateOf(false) }
    val projectsState by viewModel.state.collectAsState()
    val activeProject = projectsState.projects.firstOrNull { it.id == projectsState.activeProjectId }
    val hasProjects = projectsState.projects.isNotEmpty()

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier
                            .padding(horizontal = 8.dp)
                            .clickable(enabled = hasProjects) { pickerOpen = true },
                    ) {
                        Text(
                            text = activeProject?.name ?: stringResource(R.string.project_no_active),
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        if (hasProjects) {
                            Icon(
                                Icons.Filled.ArrowDropDown,
                                contentDescription = stringResource(R.string.project_picker_title),
                            )
                        }
                    }
                },
            )
        },
    ) { padding ->
        Column(
            modifier = Modifier.fillMaxSize().padding(padding),
        ) {
            if (!hasProjects) {
                EmptyState(
                    icon = Icons.Filled.Cloud,
                    title = stringResource(R.string.project_no_active),
                    body = stringResource(R.string.project_picker_add),
                    modifier = Modifier.clickable { onAddProject() },
                )
                return@Column
            }
            SecondaryTabRow(selectedTabIndex = selected) {
                CLOUD_TABS.forEachIndexed { index, tab ->
                    Tab(
                        selected = selected == index,
                        onClick = { selected = index },
                        icon = {
                            Icon(
                                imageVector = tab.icon,
                                contentDescription = stringResource(tab.labelRes),
                            )
                        },
                    )
                }
            }
            Box(modifier = Modifier.fillMaxSize()) {
                when (selected) {
                    0 -> CloudScreen(onOpenServer = onOpenServer)
                    1 -> CloudVolumesTab()
                    2 -> CloudNetworksTab()
                    3 -> CloudFirewallsTab()
                    4 -> CloudFloatingIpsTab()
                    5 -> CloudStorageBoxesTab(onOpen = onOpenStorageBox)
                }
            }
        }
    }

    if (pickerOpen) {
        ProjectPickerSheet(
            state = projectsState,
            onDismiss = { pickerOpen = false },
            onSelect = { id -> viewModel.setActive(id) },
            onAdd = {
                pickerOpen = false
                onAddProject()
            },
            onManage = {
                pickerOpen = false
                onManageProjects()
            },
        )
    }
}
