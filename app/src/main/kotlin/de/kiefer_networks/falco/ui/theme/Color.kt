// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.theme

import androidx.compose.ui.graphics.Color

// "Operator console" palette. Neutral surfaces, one accent, hairlines instead
// of elevation or tonal fills.

// ---- Dark neutrals (primary look) -------------------------------------------

internal val DarkBackground = Color(0xFF0F1113)
internal val DarkSurface = Color(0xFF16191C)
internal val DarkSurfaceHigh = Color(0xFF1D2125)
internal val DarkSurfaceHighest = Color(0xFF262B30)
internal val DarkHairline = Color(0xFF2A2F35)
internal val DarkDivider = Color(0xFF1F2327)
internal val DarkOutline = Color(0xFF4A5057)
internal val DarkOnSurface = Color(0xFFE8E6E1)
internal val DarkOnSurfaceVariant = Color(0xFF9AA0A6)
internal val DarkTextTertiary = Color(0xFF7D838A)
internal val DarkBottomBar = Color(0xFF121417)

// ---- OLED: pure black background, slightly lifted surfaces -------------------

internal val OledBackground = Color(0xFF000000)
internal val OledSurface = Color(0xFF0E1012)
internal val OledSurfaceHigh = Color(0xFF16191C)
internal val OledSurfaceHighest = Color(0xFF1D2125)
internal val OledHairline = Color(0xFF23272C)
internal val OledDivider = Color(0xFF181B1E)
internal val OledBottomBar = Color(0xFF000000)

// ---- Light neutrals ---------------------------------------------------------

internal val LightBackground = Color(0xFFF4F2EE)
internal val LightSurface = Color(0xFFFFFFFF)
internal val LightSurfaceHigh = Color(0xFFF0EDE8)
internal val LightSurfaceHighest = Color(0xFFE9E5DF)
internal val LightHairline = Color(0xFFE2DED7)
internal val LightDivider = Color(0xFFEEEAE4)
internal val LightOutline = Color(0xFF9A9690)
internal val LightOnSurface = Color(0xFF15181B)
internal val LightOnSurfaceVariant = Color(0xFF5B6168)
internal val LightTextTertiary = Color(0xFF6B7178)
internal val LightBottomBar = Color(0xFFFFFFFF)

// ---- Status -----------------------------------------------------------------

internal val DarkRunning = Color(0xFF4CC38A)
internal val LightRunning = Color(0xFF1E7F4F)
internal val DarkOff = Color(0xFF7D838A)
internal val LightOff = Color(0xFF6B7178)
internal val DarkError = Color(0xFFF28B82)
internal val LightError = Color(0xFFB3261E)

// ---- Accent presets ---------------------------------------------------------

internal data class AccentTone(val accent: Color, val onAccent: Color)

internal data class AccentPalette(val light: AccentTone, val dark: AccentTone)

internal val AmberAccent = AccentPalette(
    light = AccentTone(Color(0xFFA85F00), Color(0xFFFFFFFF)),
    dark = AccentTone(Color(0xFFF2A33A), Color(0xFF15120C)),
)
internal val RedAccent = AccentPalette(
    light = AccentTone(Color(0xFFD50C2D), Color(0xFFFFFFFF)),
    dark = AccentTone(Color(0xFFFF8A8F), Color(0xFF2A0006)),
)
internal val BlueAccent = AccentPalette(
    light = AccentTone(Color(0xFF1976D2), Color(0xFFFFFFFF)),
    dark = AccentTone(Color(0xFF5FB3F0), Color(0xFF0A1622)),
)
internal val GreenAccent = AccentPalette(
    light = AccentTone(Color(0xFF2E7D32), Color(0xFFFFFFFF)),
    dark = AccentTone(Color(0xFF7FD48A), Color(0xFF0B1A0D)),
)
internal val PurpleAccent = AccentPalette(
    light = AccentTone(Color(0xFF6A1B9A), Color(0xFFFFFFFF)),
    dark = AccentTone(Color(0xFFC9A2EE), Color(0xFF1C0D2A)),
)
internal val OrangeAccent = AccentPalette(
    light = AccentTone(Color(0xFFC14500), Color(0xFFFFFFFF)),
    dark = AccentTone(Color(0xFFFF9E5E), Color(0xFF221004)),
)

internal fun accentPaletteFor(accent: Int): AccentPalette = when (accent) {
    0 -> RedAccent
    1 -> BlueAccent
    2 -> GreenAccent
    3 -> PurpleAccent
    4 -> OrangeAccent
    else -> AmberAccent
}
