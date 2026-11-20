// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.components.dialog

import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import de.kiefer_networks.falco.R

/**
 * Single-step confirmation for destructive or disruptive actions (reset,
 * power off, disabling backups, deleting listeners or records). [actionLabel]
 * names the action on the confirm button so the user sees what will run.
 */
@Composable
fun ConfirmDestructiveDialog(
    actionLabel: String,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
    message: String = stringResource(R.string.confirm_destructive_msg),
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.confirm_destructive_title)) },
        text = { Text(message) },
        confirmButton = {
            TextButton(onClick = { onDismiss(); onConfirm() }) {
                Text(actionLabel, color = MaterialTheme.colorScheme.error)
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.cancel)) }
        },
    )
}
