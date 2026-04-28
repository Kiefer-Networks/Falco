// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SecondaryTabRow
import androidx.compose.material3.Surface
import androidx.compose.material3.Tab
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.CloudImage
import de.kiefer_networks.falco.data.dto.Image as CurrentImage

@Composable
fun RebuildDialog(
    images: List<CloudImage>,
    currentImage: CurrentImage?,
    onDismiss: () -> Unit,
    onRebuild: (imageIdOrName: String) -> Unit,
) {
    val systemImages = images.filter { it.type == "system" }
    val snapshotImages = images.filter { it.type == "snapshot" || it.type == "backup" }
    var tab by remember { mutableStateOf(0) }
    var selected by remember { mutableStateOf<CloudImage?>(null) }
    var showFinal by remember { mutableStateOf(false) }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false),
    ) {
        Surface(
            modifier = Modifier.fillMaxSize().padding(16.dp),
            shape = MaterialTheme.shapes.large,
        ) {
            Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
                Text(
                    stringResource(R.string.server_rebuild_title),
                    style = MaterialTheme.typography.titleLarge,
                    modifier = Modifier.padding(bottom = 8.dp),
                )
                Text(
                    stringResource(R.string.server_rebuild_warning),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.error,
                    modifier = Modifier.padding(bottom = 8.dp),
                )
                SecondaryTabRow(selectedTabIndex = tab) {
                    Tab(
                        selected = tab == 0,
                        onClick = { tab = 0 },
                        text = { Text(stringResource(R.string.server_rebuild_image_picker_system)) },
                    )
                    Tab(
                        selected = tab == 1,
                        onClick = { tab = 1 },
                        text = { Text(stringResource(R.string.server_rebuild_image_picker_snapshot)) },
                    )
                }
                val current = if (tab == 0) systemImages else snapshotImages
                LazyColumn(
                    modifier = Modifier.fillMaxWidth().fillMaxHeight(0.85f).padding(top = 8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    items(current, key = { it.id }) { image ->
                        ImageRow(
                            image = image,
                            selected = selected?.id == image.id,
                            onClick = { selected = image },
                        )
                    }
                }
                Box(modifier = Modifier.fillMaxWidth().padding(top = 8.dp), contentAlignment = Alignment.CenterEnd) {
                    Button(
                        enabled = selected != null,
                        onClick = { showFinal = true },
                    ) { Text(stringResource(R.string.server_rebuild_button)) }
                }
            }
        }
    }
    if (showFinal && selected != null) {
        AlertDialog(
            onDismissRequest = { showFinal = false },
            title = { Text(stringResource(R.string.server_rebuild_title)) },
            text = { Text(stringResource(R.string.server_rebuild_warning)) },
            confirmButton = {
                TextButton(onClick = {
                    val ref = selected!!.name ?: selected!!.id.toString()
                    onRebuild(ref)
                    showFinal = false
                }) {
                    Text(
                        stringResource(R.string.server_rebuild_button),
                        color = MaterialTheme.colorScheme.error,
                    )
                }
            },
            dismissButton = {
                TextButton(onClick = { showFinal = false }) { Text(stringResource(R.string.cancel)) }
            },
        )
    }
}

@Composable
private fun ImageRow(image: CloudImage, selected: Boolean, onClick: () -> Unit) {
    ElevatedCard(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onClick),
        colors = CardDefaults.elevatedCardColors(
            containerColor = if (selected) MaterialTheme.colorScheme.primaryContainer
            else MaterialTheme.colorScheme.surface,
        ),
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Text(
                text = image.name ?: image.description ?: "image #${image.id}",
                style = MaterialTheme.typography.titleSmall,
            )
            val parts = listOfNotNull(
                image.osFlavor,
                image.osVersion,
                image.architecture,
                image.diskSize?.let { "${it.toInt()} GB" },
            )
            if (parts.isNotEmpty()) {
                Text(parts.joinToString(" · "), style = MaterialTheme.typography.bodySmall)
            }
            if (image.deprecated != null) {
                Text(
                    "deprecated · ${image.deprecated}",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.error,
                )
            }
        }
    }
}
