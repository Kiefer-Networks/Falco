// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.components.dialog

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.ui.components.CardShape
import de.kiefer_networks.falco.ui.theme.falcoColors

/**
 * Single-step confirmation for destructive or disruptive actions (reset,
 * power off, disabling backups, deleting listeners or records), shown as a
 * bottom sheet. [actionLabel] names the action in the title and on the
 * confirm button so the user sees what will run.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ConfirmDestructiveDialog(
    actionLabel: String,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
    message: String = stringResource(R.string.confirm_destructive_msg),
) {
    ModalBottomSheet(
        onDismissRequest = onDismiss,
        sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true),
        shape = RoundedCornerShape(topStart = 24.dp, topEnd = 24.dp),
        containerColor = MaterialTheme.colorScheme.surface,
    ) {
        Column(
            modifier = Modifier.fillMaxWidth().padding(start = 20.dp, end = 20.dp, bottom = 24.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                Text(
                    stringResource(R.string.confirm_action_title, actionLabel),
                    style = MaterialTheme.typography.headlineSmall,
                )
                Text(
                    message,
                    style = MaterialTheme.typography.bodyLarge.copy(fontSize = 15.sp, lineHeight = 22.sp),
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Button(
                    onClick = { onDismiss(); onConfirm() },
                    modifier = Modifier.fillMaxWidth().height(52.dp),
                    shape = CardShape,
                ) {
                    Text(actionLabel, fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
                }
                OutlinedButton(
                    onClick = onDismiss,
                    modifier = Modifier.fillMaxWidth().height(52.dp),
                    shape = CardShape,
                    border = BorderStroke(1.dp, MaterialTheme.falcoColors.hairline),
                ) {
                    Text(
                        stringResource(R.string.cancel),
                        fontSize = 16.sp,
                        color = MaterialTheme.colorScheme.onSurface,
                    )
                }
            }
        }
    }
}
