// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Shapes
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import de.kiefer_networks.falco.data.auth.SecurityPreferences

/** Tokens Material's ColorScheme has no slot for. Read via [MaterialTheme.falcoColors]. */
@Immutable
data class FalcoColors(
    val running: Color,
    val off: Color,
    val progress: Color,
    val error: Color,
    val hairline: Color,
    val divider: Color,
    val textTertiary: Color,
    val bottomBar: Color,
)

val LocalFalcoColors = staticCompositionLocalOf {
    FalcoColors(
        running = DarkRunning,
        off = DarkOff,
        progress = AmberAccent.dark.accent,
        error = DarkError,
        hairline = DarkHairline,
        divider = DarkDivider,
        textTertiary = DarkTextTertiary,
        bottomBar = DarkBottomBar,
    )
}

val MaterialTheme.falcoColors: FalcoColors
    @Composable @ReadOnlyComposable
    get() = LocalFalcoColors.current

private val FalcoShapes = Shapes(
    extraSmall = RoundedCornerShape(8.dp),
    small = RoundedCornerShape(10.dp),
    medium = RoundedCornerShape(14.dp),
    large = RoundedCornerShape(18.dp),
    extraLarge = RoundedCornerShape(24.dp),
)

private fun lightSchemeFor(accent: Int): ColorScheme {
    val tone = accentPaletteFor(accent).light
    return lightColorScheme(
        primary = tone.accent,
        onPrimary = tone.onAccent,
        // Containers stay neutral: no tonal Material You fills.
        primaryContainer = LightSurfaceHigh,
        onPrimaryContainer = LightOnSurface,
        inversePrimary = tone.accent,
        secondary = LightOnSurfaceVariant,
        onSecondary = LightSurface,
        secondaryContainer = LightSurfaceHighest,
        onSecondaryContainer = LightOnSurface,
        tertiary = tone.accent,
        onTertiary = tone.onAccent,
        tertiaryContainer = LightSurfaceHigh,
        onTertiaryContainer = LightOnSurface,
        background = LightBackground,
        onBackground = LightOnSurface,
        surface = LightSurface,
        onSurface = LightOnSurface,
        surfaceVariant = LightSurfaceHigh,
        onSurfaceVariant = LightOnSurfaceVariant,
        surfaceTint = Color.Transparent,
        inverseSurface = Color(0xFF1D2125),
        inverseOnSurface = Color(0xFFE8E6E1),
        error = LightError,
        onError = Color.White,
        errorContainer = LightSurfaceHigh,
        onErrorContainer = LightError,
        outline = LightOutline,
        outlineVariant = LightHairline,
        scrim = Color.Black,
        surfaceBright = LightSurface,
        surfaceDim = LightBackground,
        surfaceContainerLowest = LightSurface,
        surfaceContainerLow = LightSurface,
        surfaceContainer = LightSurface,
        surfaceContainerHigh = LightSurfaceHigh,
        surfaceContainerHighest = LightSurfaceHighest,
    )
}

private fun darkSchemeFor(accent: Int, oled: Boolean): ColorScheme {
    val tone = accentPaletteFor(accent).dark
    val background = if (oled) OledBackground else DarkBackground
    val surface = if (oled) OledSurface else DarkSurface
    val high = if (oled) OledSurfaceHigh else DarkSurfaceHigh
    val highest = if (oled) OledSurfaceHighest else DarkSurfaceHighest
    val hairline = if (oled) OledHairline else DarkHairline
    return darkColorScheme(
        primary = tone.accent,
        onPrimary = tone.onAccent,
        primaryContainer = high,
        onPrimaryContainer = DarkOnSurface,
        inversePrimary = tone.accent,
        secondary = DarkOnSurfaceVariant,
        onSecondary = background,
        secondaryContainer = highest,
        onSecondaryContainer = DarkOnSurface,
        tertiary = tone.accent,
        onTertiary = tone.onAccent,
        tertiaryContainer = high,
        onTertiaryContainer = DarkOnSurface,
        background = background,
        onBackground = DarkOnSurface,
        surface = surface,
        onSurface = DarkOnSurface,
        surfaceVariant = high,
        onSurfaceVariant = DarkOnSurfaceVariant,
        surfaceTint = Color.Transparent,
        inverseSurface = DarkOnSurface,
        inverseOnSurface = DarkBackground,
        error = DarkError,
        onError = Color(0xFF2A0A07),
        errorContainer = high,
        onErrorContainer = DarkError,
        outline = DarkOutline,
        outlineVariant = hairline,
        scrim = Color.Black,
        surfaceBright = high,
        surfaceDim = background,
        surfaceContainerLowest = background,
        surfaceContainerLow = surface,
        surfaceContainer = surface,
        surfaceContainerHigh = high,
        surfaceContainerHighest = highest,
    )
}

private fun falcoColorsFor(dark: Boolean, oled: Boolean, scheme: ColorScheme) = if (dark) {
    FalcoColors(
        running = DarkRunning,
        off = DarkOff,
        progress = scheme.primary,
        error = DarkError,
        hairline = if (oled) OledHairline else DarkHairline,
        divider = if (oled) OledDivider else DarkDivider,
        textTertiary = DarkTextTertiary,
        bottomBar = if (oled) OledBottomBar else DarkBottomBar,
    )
} else {
    FalcoColors(
        running = LightRunning,
        off = LightOff,
        progress = scheme.primary,
        error = LightError,
        hairline = LightHairline,
        divider = LightDivider,
        textTertiary = LightTextTertiary,
        bottomBar = LightBottomBar,
    )
}

@Composable
fun FalcoTheme(
    themeMode: Int = SecurityPreferences.THEME_LIGHT,
    accentMode: Int = SecurityPreferences.ACCENT_AMBER,
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
    CompositionLocalProvider(LocalFalcoColors provides falcoColorsFor(dark, oled, scheme)) {
        MaterialTheme(
            colorScheme = scheme,
            typography = FalcoTypography,
            shapes = FalcoShapes,
            content = content,
        )
    }
}
