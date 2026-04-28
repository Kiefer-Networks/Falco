// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.util

/** Format a byte count using IEC units (KiB / MiB / GiB / TiB). */
fun formatBytes(bytes: Long?): String {
    if (bytes == null) return "—"
    if (bytes < 1024) return "$bytes B"
    val units = arrayOf("KiB", "MiB", "GiB", "TiB", "PiB")
    var v = bytes.toDouble() / 1024
    var idx = 0
    while (v >= 1024 && idx < units.lastIndex) {
        v /= 1024
        idx++
    }
    return if (v >= 100) "%.0f %s".format(v, units[idx]) else "%.1f %s".format(v, units[idx])
}
