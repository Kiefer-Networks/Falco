// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.SecondaryTabRow
import androidx.compose.material3.Tab
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import de.kiefer_networks.falco.R

private data class CloudTab(val labelRes: Int)

private val CLOUD_TABS = listOf(
    CloudTab(R.string.cloud_servers),
    CloudTab(R.string.cloud_volumes),
    CloudTab(R.string.cloud_networks),
    CloudTab(R.string.cloud_firewalls),
    CloudTab(R.string.cloud_floating_ips),
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
                    text = {
                        Text(
                            stringResource(tab.labelRes),
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis,
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
