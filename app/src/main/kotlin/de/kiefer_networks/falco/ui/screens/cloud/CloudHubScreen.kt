// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.Hub
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material.icons.filled.SwapHoriz
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.SecondaryTabRow
import androidx.compose.material3.Tab
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import de.kiefer_networks.falco.R

private data class CloudTab(val labelRes: Int, val icon: ImageVector)

private val CLOUD_TABS = listOf(
    CloudTab(R.string.cloud_servers, Icons.Filled.Computer),
    CloudTab(R.string.cloud_volumes, Icons.Filled.Storage),
    CloudTab(R.string.cloud_networks, Icons.Filled.Hub),
    CloudTab(R.string.cloud_firewalls, Icons.Filled.Security),
    CloudTab(R.string.cloud_floating_ips, Icons.Filled.SwapHoriz),
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CloudHubScreen() {
    var selected by rememberSaveable { mutableIntStateOf(0) }

    Column(Modifier.fillMaxSize()) {
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
        when (selected) {
            0 -> CloudScreen()
            1 -> CloudVolumesTab()
            2 -> CloudNetworksTab()
            3 -> CloudFirewallsTab()
            4 -> CloudFloatingIpsTab()
        }
    }
}
