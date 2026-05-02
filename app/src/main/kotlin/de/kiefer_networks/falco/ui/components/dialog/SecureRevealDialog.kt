// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.components.dialog

import android.os.Build
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.DialogProperties
import androidx.compose.ui.window.SecureFlagPolicy
import de.kiefer_networks.falco.R

/**
 * Modal dialog for one-time reveal of sensitive secrets (root passwords, console
 * tokens). Sets `FLAG_SECURE` on the dialog window so screenshots and the
 * recents-app preview don't leak the value.
 *
 * Caller controls dismiss — the secret should also be cleared from any
 * surrounding state when [onDismiss] fires so a re-render can't replay it.
 */
@Composable
fun SecureRevealDialog(
    title: String,
    secret: String,
    warning: String,
    copyLabel: String = stringResourceCopy(),
    closeLabel: String = stringResourceClose(),
    onCopy: () -> Unit,
    onDismiss: () -> Unit,
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(warning, style = MaterialTheme.typography.bodyMedium)
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                    Text(
                        stringResource(R.string.clipboard_pre_a13_caveat),
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.error,
                    )
                }
                Surface(
                    color = MaterialTheme.colorScheme.surfaceVariant,
                    shape = RoundedCornerShape(8.dp),
                    modifier = Modifier.fillMaxWidth(),
                ) {
                    Text(
                        secret,
                        style = MaterialTheme.typography.bodyMedium,
                        fontFamily = FontFamily.Monospace,
                        modifier = Modifier.padding(12.dp),
                    )
                }
            }
        },
        confirmButton = { TextButton(onClick = onCopy) { Text(copyLabel) } },
        dismissButton = { TextButton(onClick = onDismiss) { Text(closeLabel) } },
        properties = DialogProperties(securePolicy = SecureFlagPolicy.SecureOn),
    )
}

@Composable
private fun stringResourceCopy(): String =
    androidx.compose.ui.res.stringResource(R.string.copy)

@Composable
private fun stringResourceClose(): String =
    androidx.compose.ui.res.stringResource(R.string.close)
