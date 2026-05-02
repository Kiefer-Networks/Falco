// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.Inventory2
import androidx.compose.material.icons.filled.Key
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.ViewModule
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
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
import de.kiefer_networks.falco.ui.nav.LocalNavDrawer

private data class CloudTab(val labelRes: Int, val icon: ImageVector)

private val CLOUD_TABS = listOf(
    CloudTab(R.string.cloud_servers, Icons.Filled.Computer),
    CloudTab(R.string.cloud_firewalls, Icons.Filled.Security),
    CloudTab(R.string.cloud_storage_boxes, Icons.Filled.Inventory2),
    CloudTab(R.string.cloud_tab_resources, Icons.Filled.ViewModule),
    CloudTab(R.string.cloud_ssh_keys, Icons.Filled.Key),
)

@Composable
fun CloudHubScreen(
    onAddProject: () -> Unit,
    onManageProjects: () -> Unit,
    onOpenStorageBox: (Long) -> Unit = {},
    onOpenServer: (Long) -> Unit = {},
    onOpenFirewall: (Long) -> Unit = {},
    onOpenVolume: (Long) -> Unit = {},
    onOpenFloatingIp: (Long) -> Unit = {},
    onOpenLoadBalancer: (Long) -> Unit = {},
    onOpenPrimaryIp: (Long) -> Unit = {},
    viewModel: ProjectsViewModel = hiltViewModel(),
) {
    // R-006: in aggregate-projects mode the hub lists span every project, but
    // detail screens read via the active project's token. Wrap each detail-nav
    // in `selectProjectThen` so the DataStore commit lands before the new
    // screen's repo runs. The helper is a no-op when the source project is
    // already active (single-project mode, or a card from the active project).
    val openServerSwitch: (String?, Long) -> Unit = { pid, id ->
        viewModel.selectProjectThen(pid) { onOpenServer(id) }
    }
    val openFirewallSwitch: (String?, Long) -> Unit = { pid, id ->
        viewModel.selectProjectThen(pid) { onOpenFirewall(id) }
    }
    val openStorageBoxSwitch: (String?, Long) -> Unit = { pid, id ->
        viewModel.selectProjectThen(pid) { onOpenStorageBox(id) }
    }
    val openVolumeSwitch: (String?, Long) -> Unit = { pid, id ->
        viewModel.selectProjectThen(pid) { onOpenVolume(id) }
    }
    val openFloatingIpSwitch: (String?, Long) -> Unit = { pid, id ->
        viewModel.selectProjectThen(pid) { onOpenFloatingIp(id) }
    }
    val openLoadBalancerSwitch: (String?, Long) -> Unit = { pid, id ->
        viewModel.selectProjectThen(pid) { onOpenLoadBalancer(id) }
    }
    val openPrimaryIpSwitch: (String?, Long) -> Unit = { pid, id ->
        viewModel.selectProjectThen(pid) { onOpenPrimaryIp(id) }
    }
    var selected by rememberSaveable { mutableIntStateOf(0) }
    var pickerOpen by remember { mutableStateOf(false) }
    val projectsState by viewModel.state.collectAsState()
    val activeProject = projectsState.projects.firstOrNull { it.id == projectsState.activeProjectId }
    val hasProjects = projectsState.projects.isNotEmpty()

    val drawer = LocalNavDrawer.current
    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                navigationIcon = {
                    if (drawer.isCompact) {
                        IconButton(onClick = drawer::open) {
                            Icon(Icons.Filled.Menu, contentDescription = stringResource(R.string.nav_drawer_title))
                        }
                    }
                },
                actions = {
                    if (drawer.isCompact) {
                        Spacer(modifier = Modifier.size(48.dp))
                    }
                },
                title = {
                    val aggregate = projectsState.aggregateProjects
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier
                            .padding(horizontal = 8.dp)
                            .clickable(enabled = hasProjects && !aggregate) { pickerOpen = true },
                    ) {
                        Text(
                            text = when {
                                aggregate -> stringResource(R.string.project_all)
                                else -> activeProject?.name ?: stringResource(R.string.project_no_active)
                            },
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.onSurface,
                        )
                        if (hasProjects && !aggregate) {
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
            TabRow(selectedTabIndex = selected) {
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
                androidx.compose.runtime.key(projectsState.activeProjectId, projectsState.aggregateProjects) {
                    when (selected) {
                        0 -> CloudScreen(onOpenServer = openServerSwitch)
                        1 -> CloudFirewallsTab(onOpen = openFirewallSwitch)
                        2 -> CloudStorageBoxesTab(onOpen = openStorageBoxSwitch)
                        3 -> CloudResourcesTab(
                            onOpenVolume = openVolumeSwitch,
                            onOpenFloatingIp = openFloatingIpSwitch,
                            onOpenLoadBalancer = openLoadBalancerSwitch,
                            onOpenPrimaryIp = openPrimaryIpSwitch,
                        )
                        4 -> CloudSshKeysTab()
                    }
                }
            }
        }
    }

    if (pickerOpen) {
        ProjectPickerSheet(
            state = projectsState,
            onDismiss = { pickerOpen = false },
            onSelect = { id ->
                viewModel.setActive(id)
                pickerOpen = false
            },
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
