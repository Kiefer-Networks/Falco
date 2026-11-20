// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.nav

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Test
import java.net.URLDecoder

class RoutesTest {

    @Test
    fun `s3 route args round trip through percent decoding`() {
        for (value in listOf("My Photos/", "a+b/c&d=e?f", "ümlaut %20 x", "")) {
            val encoded = Routes.encodeArg(value)
            // Navigation uses Uri.decode, which leaves '+' untouched. With no
            // '+' in the output, URLDecoder decodes exactly like Uri.decode.
            assertFalse(encoded.contains('+'))
            assertEquals(value, URLDecoder.decode(encoded, "UTF-8"))
        }
    }

    @Test
    fun `s3Browser encodes spaces as percent 20`() {
        assertEquals("s3/browser?bucket=b&prefix=My%20Photos%2F", Routes.s3Browser("b", "My Photos/"))
    }
}
