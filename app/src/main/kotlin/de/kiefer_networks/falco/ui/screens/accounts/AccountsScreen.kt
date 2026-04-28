// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.accounts

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R

@Composable
fun AccountsScreen(
    viewModel: AccountsViewModel = hiltViewModel(),
    onAdd: () -> Unit,
) {
    val accounts by viewModel.accounts.collectAsState()

    Box(modifier = Modifier.fillMaxSize()) {
        if (accounts.isEmpty()) {
            Column(
                modifier = Modifier.fillMaxSize().padding(24.dp),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Text(stringResource(R.string.accounts_empty), style = MaterialTheme.typography.bodyLarge)
            }
        } else {
            LazyColumn(modifier = Modifier.fillMaxSize().padding(top = 8.dp)) {
                items(accounts, key = { it.id }) { acc ->
                    ListItem(
                        headlineContent = { Text(acc.displayName) },
                        supportingContent = {
                            val flags = buildList {
                                if (acc.hasCloud) add("Cloud")
                                if (acc.hasRobot) add("Robot")
                                if (acc.hasDns) add("DNS")
                                if (acc.hasS3) add("S3")
                            }.joinToString(" • ")
                            Text(flags)
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
