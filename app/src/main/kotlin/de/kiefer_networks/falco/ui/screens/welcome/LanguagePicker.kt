// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.welcome

import androidx.appcompat.app.AppCompatDelegate
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.core.os.LocaleListCompat

private data class LocaleOption(val tag: String, val nativeLabel: String, val englishHint: String?)

private val SUPPORTED = listOf(
    LocaleOption("", "Follow system", null),
    LocaleOption("en", "English", null),
    LocaleOption("de", "Deutsch", "German"),
    LocaleOption("es", "Español", "Spanish"),
    LocaleOption("fr", "Français", "French"),
    LocaleOption("it", "Italiano", "Italian"),
    LocaleOption("zh-CN", "简体中文", "Chinese (Simplified)"),
    LocaleOption("ru", "Русский", "Russian"),
)

/**
 * Renders a vertical radio list of supported languages. Selecting one applies
 * it immediately at runtime via AppCompatDelegate and persists via [onPersist].
 */
@Composable
fun LanguagePicker(
    selectedTag: String,
    onPersist: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier = modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(4.dp),
    ) {
        SUPPORTED.forEach { opt ->
            val selected = opt.tag == selectedTag
            Surface(
                onClick = {
                    AppCompatDelegate.setApplicationLocales(
                        if (opt.tag.isBlank()) LocaleListCompat.getEmptyLocaleList()
                        else LocaleListCompat.forLanguageTags(opt.tag),
                    )
                    onPersist(opt.tag)
                },
                shape = RoundedCornerShape(12.dp),
                color = if (selected) {
                    MaterialTheme.colorScheme.primaryContainer
                } else {
                    MaterialTheme.colorScheme.surface
                },
                tonalElevation = if (selected) 2.dp else 0.dp,
                modifier = Modifier.fillMaxWidth(),
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp),
                ) {
                    RadioButton(selected = selected, onClick = null)
                    Spacer(Modifier.width(12.dp))
                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            text = opt.nativeLabel,
                            style = MaterialTheme.typography.titleMedium,
                            color = if (selected) {
                                MaterialTheme.colorScheme.onPrimaryContainer
                            } else {
                                MaterialTheme.colorScheme.onSurface
                            },
                        )
                        if (opt.englishHint != null) {
                            Text(
                                text = opt.englishHint,
                                style = MaterialTheme.typography.bodySmall,
                                color = if (selected) {
                                    MaterialTheme.colorScheme.onPrimaryContainer
                                } else {
                                    MaterialTheme.colorScheme.onSurfaceVariant
                                },
                            )
                        }
                    }
                }
            }
        }
    }
}
