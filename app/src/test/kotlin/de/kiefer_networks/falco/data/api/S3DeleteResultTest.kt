// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import org.junit.Assert.assertEquals
import org.junit.Test
import java.io.IOException

class S3DeleteResultTest {

    @Test
    fun `per key errors are excluded from deleted keys`() {
        val deleted = successfulDeletes(listOf("a", "b", "c"), listOf(Result.success("b")))
        assertEquals(listOf("a", "c"), deleted)
    }

    @Test
    fun `no errors means every key was deleted`() {
        assertEquals(listOf("a", "b"), successfulDeletes(listOf("a", "b"), emptyList()))
    }

    @Test(expected = IOException::class)
    fun `request level error is rethrown instead of reporting success`() {
        successfulDeletes(listOf("a", "b"), listOf(Result.failure(IOException("boom"))))
    }
}
