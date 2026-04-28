// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import de.kiefer_networks.falco.data.auth.SecurityPreferences

private val DarkColors = darkColorScheme(
    primary = FalcoBluePrimary,
    onPrimary = FalcoBlueOnPrimary,
    surface = FalcoSurfaceDark,
    background = FalcoSurfaceDark,
    secondary = FalcoAccent,
)

private val LightColors = lightColorScheme(
    primary = FalcoBluePrimary,
    onPrimary = FalcoBlueOnPrimary,
    surface = FalcoSurfaceLight,
    background = FalcoSurfaceLight,
    secondary = FalcoAccent,
)

@Composable
fun FalcoTheme(
    themeMode: Int = SecurityPreferences.THEME_SYSTEM,
    content: @Composable () -> Unit,
) {
    val darkTheme = when (themeMode) {
        SecurityPreferences.THEME_LIGHT -> false
        SecurityPreferences.THEME_DARK -> true
        else -> isSystemInDarkTheme()
    }
    MaterialTheme(
        colorScheme = if (darkTheme) DarkColors else LightColors,
        typography = FalcoTypography,
        content = content,
    )
}
