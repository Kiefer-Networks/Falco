// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.components.dialog

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Icon
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import de.kiefer_networks.falco.ui.theme.Spacing

data class SheetAction(
    val icon: ImageVector,
    val label: String,
    val destructive: Boolean = false,
    val enabled: Boolean = true,
    val onClick: () -> Unit,
)

data class SheetSection(
    val title: String? = null,
    val actions: List<SheetAction>,
)

@Composable
fun ActionsBottomSheet(
    title: String? = null,
    actions: List<SheetAction>,
    onDismiss: () -> Unit,
) {
    ActionsBottomSheetSections(
        title = title,
        sections = listOf(SheetSection(actions = actions)),
        onDismiss = onDismiss,
    )
}

@Composable
fun ActionsBottomSheetSections(
    title: String? = null,
    sections: List<SheetSection>,
    onDismiss: () -> Unit,
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    ModalBottomSheet(
        onDismissRequest = onDismiss,
        sheetState = sheetState,
    ) {
        Column(modifier = Modifier.fillMaxWidth().padding(bottom = Spacing.md)) {
            if (!title.isNullOrBlank()) {
                Text(
                    title,
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier.padding(horizontal = Spacing.lg, vertical = Spacing.sm),
                )
            }
            sections.forEachIndexed { idx, section ->
                if (idx > 0) {
                    androidx.compose.material3.HorizontalDivider(
                        color = MaterialTheme.colorScheme.outlineVariant,
                        modifier = Modifier.padding(vertical = Spacing.xs),
                    )
                }
                if (!section.title.isNullOrBlank()) {
                    Text(
                        section.title.uppercase(),
                        style = MaterialTheme.typography.labelSmall.copy(
                            letterSpacing = androidx.compose.ui.unit.TextUnit(1.2f, androidx.compose.ui.unit.TextUnitType.Sp),
                        ),
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(
                            start = Spacing.lg,
                            end = Spacing.lg,
                            top = Spacing.sm,
                            bottom = Spacing.xs,
                        ),
                    )
                }
                section.actions.forEach { action ->
                    ListItem(
                        leadingContent = {
                            Icon(
                                action.icon,
                                contentDescription = null,
                                tint = if (action.destructive) {
                                    MaterialTheme.colorScheme.error
                                } else {
                                    MaterialTheme.colorScheme.primary
                                },
                            )
                        },
                        headlineContent = {
                            Text(
                                action.label,
                                color = if (action.destructive) {
                                    MaterialTheme.colorScheme.error
                                } else {
                                    MaterialTheme.colorScheme.onSurface
                                },
                            )
                        },
                        modifier = Modifier
                            .fillMaxWidth()
                            .let { if (action.enabled) it.clickable { action.onClick() } else it },
                        colors = ListItemDefaults.colors(),
                    )
                }
            }
        }
    }
}
