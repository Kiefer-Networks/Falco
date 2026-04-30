// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import de.kiefer_networks.falco.data.auth.SecurityPreferences

private fun lightSchemeFor(accent: Int): ColorScheme {
    val tone = accentPaletteFor(accent).light
    return lightColorScheme(
        primary = tone.primary,
        onPrimary = tone.onPrimary,
        primaryContainer = tone.primaryContainer,
        onPrimaryContainer = tone.onPrimaryContainer,
        secondary = tone.secondary,
        onSecondary = tone.onSecondary,
        secondaryContainer = tone.secondaryContainer,
        onSecondaryContainer = tone.onSecondaryContainer,
        tertiary = tone.tertiary,
        onTertiary = tone.onTertiary,
        tertiaryContainer = tone.tertiaryContainer,
        onTertiaryContainer = tone.onTertiaryContainer,
        error = tone.error,
        onError = tone.onError,
        errorContainer = tone.errorContainer,
        onErrorContainer = tone.onErrorContainer,
        background = LightBackground,
        onBackground = LightOnBackground,
        surface = LightSurface,
        onSurface = LightOnSurface,
        surfaceVariant = LightSurfaceVariant,
        onSurfaceVariant = LightOnSurfaceVariant,
        outline = LightOutline,
        outlineVariant = LightOutlineVariant,
        inverseSurface = LightInverseSurface,
        inverseOnSurface = LightInverseOnSurface,
        inversePrimary = tone.inversePrimary,
        surfaceTint = tone.primary,
        scrim = LightScrim,
    )
}

private fun darkSchemeFor(accent: Int, oled: Boolean): ColorScheme {
    val tone = accentPaletteFor(accent).dark
    val background = if (oled) OledBackground else DarkBackground
    val surface = if (oled) OledSurface else DarkSurface
    val surfaceVariant = if (oled) OledSurfaceVariant else DarkSurfaceVariant
    val outlineVariant = if (oled) OledOutlineVariant else DarkOutlineVariant
    return darkColorScheme(
        primary = tone.primary,
        onPrimary = tone.onPrimary,
        primaryContainer = tone.primaryContainer,
        onPrimaryContainer = tone.onPrimaryContainer,
        secondary = tone.secondary,
        onSecondary = tone.onSecondary,
        secondaryContainer = tone.secondaryContainer,
        onSecondaryContainer = tone.onSecondaryContainer,
        tertiary = tone.tertiary,
        onTertiary = tone.onTertiary,
        tertiaryContainer = tone.tertiaryContainer,
        onTertiaryContainer = tone.onTertiaryContainer,
        error = tone.error,
        onError = tone.onError,
        errorContainer = tone.errorContainer,
        onErrorContainer = tone.onErrorContainer,
        background = background,
        onBackground = DarkOnBackground,
        surface = surface,
        onSurface = DarkOnSurface,
        surfaceVariant = surfaceVariant,
        onSurfaceVariant = DarkOnSurfaceVariant,
        outline = DarkOutline,
        outlineVariant = outlineVariant,
        inverseSurface = DarkInverseSurface,
        inverseOnSurface = DarkInverseOnSurface,
        inversePrimary = tone.inversePrimary,
        surfaceTint = tone.primary,
        scrim = DarkScrim,
    )
}

@Composable
fun FalcoTheme(
    themeMode: Int = SecurityPreferences.THEME_LIGHT,
    accentMode: Int = SecurityPreferences.ACCENT_RED,
    content: @Composable () -> Unit,
) {
    val systemDark = isSystemInDarkTheme()
    val (dark, oled) = when (themeMode) {
        SecurityPreferences.THEME_LIGHT -> false to false
        SecurityPreferences.THEME_DARK -> true to false
        SecurityPreferences.THEME_OLED -> true to true
        else -> systemDark to false
    }
    val scheme = if (dark) darkSchemeFor(accentMode, oled) else lightSchemeFor(accentMode)
    MaterialTheme(
        colorScheme = scheme,
        typography = FalcoTypography,
        content = content,
    )
}
