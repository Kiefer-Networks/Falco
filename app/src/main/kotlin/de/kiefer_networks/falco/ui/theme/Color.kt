// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.theme

import androidx.compose.ui.graphics.Color

// ---- Neutrals --------------------------------------------------------------

internal val LightBackground = Color(0xFFFFFBFF)
internal val LightOnBackground = Color(0xFF201A1A)
internal val LightSurface = Color(0xFFFFFBFF)
internal val LightOnSurface = Color(0xFF201A1A)
internal val LightSurfaceVariant = Color(0xFFEFE7E7)
internal val LightOnSurfaceVariant = Color(0xFF534343)
internal val LightOutline = Color(0xFF857373)
internal val LightOutlineVariant = Color(0xFFD8C2C1)
internal val LightInverseSurface = Color(0xFF362F2F)
internal val LightInverseOnSurface = Color(0xFFFBEEED)
internal val LightScrim = Color(0xFF000000)

// Strong delta between background and surface so ElevatedCard / OutlinedCard
// containers visibly lift off the page.
internal val DarkBackground = Color(0xFF0E0A0A)
internal val DarkOnBackground = Color(0xFFEDE0DF)
internal val DarkSurface = Color(0xFF2C2424)
internal val DarkOnSurface = Color(0xFFEDE0DF)
internal val DarkSurfaceVariant = Color(0xFF463939)
internal val DarkOnSurfaceVariant = Color(0xFFD8C2C1)
internal val DarkOutline = Color(0xFFB39E9E)
internal val DarkOutlineVariant = Color(0xFF7A6868)
internal val DarkInverseSurface = Color(0xFFEDE0DF)
internal val DarkInverseOnSurface = Color(0xFF362F2F)
internal val DarkScrim = Color(0xFF000000)

// True black for OLED — saves power on AMOLED displays. Surfaces bumped so
// cards remain readable against the pure-black background.
internal val OledBackground = Color(0xFF000000)
internal val OledSurface = Color(0xFF1C1C1C)
internal val OledSurfaceVariant = Color(0xFF2E2E2E)
internal val OledOutlineVariant = Color(0xFF4A4A4A)

// ---- Brand constant -------------------------------------------------------

val HetznerRed = Color(0xFFD50C2D)

// ---- Accent palettes ------------------------------------------------------

internal data class AccentPalette(
    val light: AccentTone,
    val dark: AccentTone,
)

internal data class AccentTone(
    val primary: Color,
    val onPrimary: Color,
    val primaryContainer: Color,
    val onPrimaryContainer: Color,
    val secondary: Color,
    val onSecondary: Color,
    val secondaryContainer: Color,
    val onSecondaryContainer: Color,
    val tertiary: Color,
    val onTertiary: Color,
    val tertiaryContainer: Color,
    val onTertiaryContainer: Color,
    val error: Color,
    val onError: Color,
    val errorContainer: Color,
    val onErrorContainer: Color,
    val inversePrimary: Color,
)

internal val RedAccent = AccentPalette(
    light = AccentTone(
        primary = Color(0xFFD50C2D),
        onPrimary = Color(0xFFFFFFFF),
        primaryContainer = Color(0xFFFFDADC),
        onPrimaryContainer = Color(0xFF410008),
        secondary = Color(0xFF775656),
        onSecondary = Color(0xFFFFFFFF),
        secondaryContainer = Color(0xFFFFDADC),
        onSecondaryContainer = Color(0xFF2C1516),
        tertiary = Color(0xFF735B2E),
        onTertiary = Color(0xFFFFFFFF),
        tertiaryContainer = Color(0xFFFFDEA6),
        onTertiaryContainer = Color(0xFF261900),
        error = Color(0xFFBA1A1A),
        onError = Color(0xFFFFFFFF),
        errorContainer = Color(0xFFFFDAD6),
        onErrorContainer = Color(0xFF410002),
        inversePrimary = Color(0xFFFFB3B7),
    ),
    dark = AccentTone(
        primary = Color(0xFFFFB3B7),
        onPrimary = Color(0xFF680015),
        primaryContainer = Color(0xFF93001E),
        onPrimaryContainer = Color(0xFFFFDADC),
        secondary = Color(0xFFE6BDBC),
        onSecondary = Color(0xFF44292A),
        secondaryContainer = Color(0xFF5D3F3F),
        onSecondaryContainer = Color(0xFFFFDADC),
        tertiary = Color(0xFFE2C28C),
        onTertiary = Color(0xFF402D04),
        tertiaryContainer = Color(0xFF594319),
        onTertiaryContainer = Color(0xFFFFDEA6),
        error = Color(0xFFFFB4AB),
        onError = Color(0xFF690005),
        errorContainer = Color(0xFF93000A),
        onErrorContainer = Color(0xFFFFDAD6),
        inversePrimary = Color(0xFFB1234B),
    ),
)

internal val BlueAccent = AccentPalette(
    light = AccentTone(
        primary = Color(0xFF1976D2),
        onPrimary = Color(0xFFFFFFFF),
        primaryContainer = Color(0xFFD3E4FD),
        onPrimaryContainer = Color(0xFF001C38),
        secondary = Color(0xFF555F71),
        onSecondary = Color(0xFFFFFFFF),
        secondaryContainer = Color(0xFFD9E3F8),
        onSecondaryContainer = Color(0xFF121C2B),
        tertiary = Color(0xFF6E5676),
        onTertiary = Color(0xFFFFFFFF),
        tertiaryContainer = Color(0xFFF6D9FF),
        onTertiaryContainer = Color(0xFF27132F),
        error = Color(0xFFBA1A1A),
        onError = Color(0xFFFFFFFF),
        errorContainer = Color(0xFFFFDAD6),
        onErrorContainer = Color(0xFF410002),
        inversePrimary = Color(0xFFA1C9FF),
    ),
    dark = AccentTone(
        primary = Color(0xFFA1C9FF),
        onPrimary = Color(0xFF003258),
        primaryContainer = Color(0xFF00497D),
        onPrimaryContainer = Color(0xFFD3E4FD),
        secondary = Color(0xFFBDC7DB),
        onSecondary = Color(0xFF273141),
        secondaryContainer = Color(0xFF3D4758),
        onSecondaryContainer = Color(0xFFD9E3F8),
        tertiary = Color(0xFFDABFE2),
        onTertiary = Color(0xFF3D2A45),
        tertiaryContainer = Color(0xFF55405D),
        onTertiaryContainer = Color(0xFFF6D9FF),
        error = Color(0xFFFFB4AB),
        onError = Color(0xFF690005),
        errorContainer = Color(0xFF93000A),
        onErrorContainer = Color(0xFFFFDAD6),
        inversePrimary = Color(0xFF1976D2),
    ),
)

internal val GreenAccent = AccentPalette(
    light = AccentTone(
        primary = Color(0xFF2E7D32),
        onPrimary = Color(0xFFFFFFFF),
        primaryContainer = Color(0xFFB2EFB6),
        onPrimaryContainer = Color(0xFF002106),
        secondary = Color(0xFF526350),
        onSecondary = Color(0xFFFFFFFF),
        secondaryContainer = Color(0xFFD5E8CF),
        onSecondaryContainer = Color(0xFF101F11),
        tertiary = Color(0xFF38656A),
        onTertiary = Color(0xFFFFFFFF),
        tertiaryContainer = Color(0xFFBCEBF0),
        onTertiaryContainer = Color(0xFF001F23),
        error = Color(0xFFBA1A1A),
        onError = Color(0xFFFFFFFF),
        errorContainer = Color(0xFFFFDAD6),
        onErrorContainer = Color(0xFF410002),
        inversePrimary = Color(0xFF95D69C),
    ),
    dark = AccentTone(
        primary = Color(0xFF95D69C),
        onPrimary = Color(0xFF00390D),
        primaryContainer = Color(0xFF11531B),
        onPrimaryContainer = Color(0xFFB2EFB6),
        secondary = Color(0xFFB9CCB4),
        onSecondary = Color(0xFF253424),
        secondaryContainer = Color(0xFF3B4B39),
        onSecondaryContainer = Color(0xFFD5E8CF),
        tertiary = Color(0xFFA0CED4),
        onTertiary = Color(0xFF00363B),
        tertiaryContainer = Color(0xFF1F4D52),
        onTertiaryContainer = Color(0xFFBCEBF0),
        error = Color(0xFFFFB4AB),
        onError = Color(0xFF690005),
        errorContainer = Color(0xFF93000A),
        onErrorContainer = Color(0xFFFFDAD6),
        inversePrimary = Color(0xFF2E7D32),
    ),
)

internal val PurpleAccent = AccentPalette(
    light = AccentTone(
        primary = Color(0xFF6A1B9A),
        onPrimary = Color(0xFFFFFFFF),
        primaryContainer = Color(0xFFEFD8FF),
        onPrimaryContainer = Color(0xFF260038),
        secondary = Color(0xFF665A6F),
        onSecondary = Color(0xFFFFFFFF),
        secondaryContainer = Color(0xFFEDDCF6),
        onSecondaryContainer = Color(0xFF211829),
        tertiary = Color(0xFF815158),
        onTertiary = Color(0xFFFFFFFF),
        tertiaryContainer = Color(0xFFFFD9DD),
        onTertiaryContainer = Color(0xFF331017),
        error = Color(0xFFBA1A1A),
        onError = Color(0xFFFFFFFF),
        errorContainer = Color(0xFFFFDAD6),
        onErrorContainer = Color(0xFF410002),
        inversePrimary = Color(0xFFD7B2F1),
    ),
    dark = AccentTone(
        primary = Color(0xFFD7B2F1),
        onPrimary = Color(0xFF3F1562),
        primaryContainer = Color(0xFF54307C),
        onPrimaryContainer = Color(0xFFEFD8FF),
        secondary = Color(0xFFD0C2DA),
        onSecondary = Color(0xFF362D3F),
        secondaryContainer = Color(0xFF4D4357),
        onSecondaryContainer = Color(0xFFEDDCF6),
        tertiary = Color(0xFFF4B7BF),
        onTertiary = Color(0xFF4B252B),
        tertiaryContainer = Color(0xFF663A41),
        onTertiaryContainer = Color(0xFFFFD9DD),
        error = Color(0xFFFFB4AB),
        onError = Color(0xFF690005),
        errorContainer = Color(0xFF93000A),
        onErrorContainer = Color(0xFFFFDAD6),
        inversePrimary = Color(0xFF6A1B9A),
    ),
)

internal val OrangeAccent = AccentPalette(
    light = AccentTone(
        primary = Color(0xFFE65100),
        onPrimary = Color(0xFFFFFFFF),
        primaryContainer = Color(0xFFFFDCC4),
        onPrimaryContainer = Color(0xFF301400),
        secondary = Color(0xFF765848),
        onSecondary = Color(0xFFFFFFFF),
        secondaryContainer = Color(0xFFFFDCC4),
        onSecondaryContainer = Color(0xFF2B1709),
        tertiary = Color(0xFF635F30),
        onTertiary = Color(0xFFFFFFFF),
        tertiaryContainer = Color(0xFFE8E3A8),
        onTertiaryContainer = Color(0xFF1E1C00),
        error = Color(0xFFBA1A1A),
        onError = Color(0xFFFFFFFF),
        errorContainer = Color(0xFFFFDAD6),
        onErrorContainer = Color(0xFF410002),
        inversePrimary = Color(0xFFFFB779),
    ),
    dark = AccentTone(
        primary = Color(0xFFFFB779),
        onPrimary = Color(0xFF4F2500),
        primaryContainer = Color(0xFF703800),
        onPrimaryContainer = Color(0xFFFFDCC4),
        secondary = Color(0xFFE6BFA8),
        onSecondary = Color(0xFF432B1C),
        secondaryContainer = Color(0xFF5C4031),
        onSecondaryContainer = Color(0xFFFFDCC4),
        tertiary = Color(0xFFCBC68F),
        onTertiary = Color(0xFF333107),
        tertiaryContainer = Color(0xFF4B481B),
        onTertiaryContainer = Color(0xFFE8E3A8),
        error = Color(0xFFFFB4AB),
        onError = Color(0xFF690005),
        errorContainer = Color(0xFF93000A),
        onErrorContainer = Color(0xFFFFDAD6),
        inversePrimary = Color(0xFFE65100),
    ),
)

internal fun accentPaletteFor(accent: Int): AccentPalette = when (accent) {
    1 -> BlueAccent
    2 -> GreenAccent
    3 -> PurpleAccent
    4 -> OrangeAccent
    else -> RedAccent
}
