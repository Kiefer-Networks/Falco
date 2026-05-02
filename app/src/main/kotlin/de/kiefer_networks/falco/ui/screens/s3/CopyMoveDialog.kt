// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.s3

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.R

/**
 * Destination picker for copy/move. Defaults to the source bucket and the
 * source object's parent prefix so the user only has to retype the file name
 * if they want a rename within the same folder.
 *
 * The displayed final-key preview is derived from `prefix` + base name of the
 * source key. We do not validate the bucket or prefix client-side beyond
 * trimming — the server is the source of truth and any failure surfaces
 * through the standard error toast path.
 */
@Composable
fun CopyMoveDialog(
    titleRes: Int,
    confirmLabelRes: Int,
    sourceBucket: String,
    sourceKey: String,
    onDismiss: () -> Unit,
    onConfirm: (dstBucket: String, dstKey: String) -> Unit,
) {
    val baseName = sourceKey.trimEnd('/').substringAfterLast('/')
    val sourceParentPrefix = sourceKey.substringBeforeLast('/', missingDelimiterValue = "")
        .let { if (it.isEmpty()) "" else "$it/" }

    var dstBucket by remember { mutableStateOf(sourceBucket) }
    var dstPrefix by remember { mutableStateOf(sourceParentPrefix) }

    val finalKey = buildString {
        val p = dstPrefix.trim()
        if (p.isNotEmpty()) {
            append(p.trimEnd('/'))
            append('/')
        }
        append(baseName)
    }

    val canSubmit = dstBucket.trim().isNotEmpty() && baseName.isNotEmpty() &&
        // Reject a no-op same-bucket / same-key destination.
        !(dstBucket.trim() == sourceBucket && finalKey == sourceKey)

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(titleRes)) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    sourceKey,
                    style = MaterialTheme.typography.bodySmall,
                )
                OutlinedTextField(
                    value = dstBucket,
                    onValueChange = { dstBucket = it },
                    label = { Text(stringResource(R.string.s3_dest_bucket)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                OutlinedTextField(
                    value = dstPrefix,
                    onValueChange = { dstPrefix = it },
                    label = { Text(stringResource(R.string.s3_dest_prefix_optional)) },
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth(),
                )
                Text(
                    text = stringResource(R.string.s3_dest_key_label) + ": " + finalKey,
                    style = MaterialTheme.typography.bodySmall,
                )
            }
        },
        confirmButton = {
            TextButton(
                onClick = { onConfirm(dstBucket.trim(), finalKey) },
                enabled = canSubmit,
            ) { Text(stringResource(confirmLabelRes)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
