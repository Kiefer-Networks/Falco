// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.components

import org.junit.Assert.assertEquals
import org.junit.Test

class ChartYRangeTest {

    @Test
    fun `ceiling is a minimum, data above it extends the scale`() {
        assertEquals(0.0 to 100.0, chartYRange(listOf(5.0, 40.0), 0.0, 100.0))
        assertEquals(0.0 to 350.0, chartYRange(listOf(5.0, 350.0), 0.0, 100.0))
    }

    @Test
    fun `equal values never give a zero span`() {
        assertEquals(0.0 to 1.0, chartYRange(listOf(0.0, 0.0), 0.0, null))
        val (lo, hi) = chartYRange(listOf(7.0), 7.0, null)
        assertEquals(7.0, lo, 0.0)
        assertEquals(8.0, hi, 0.0)
    }
}
