// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import java.io.IOException

class S3LocationsTest {

    @Test
    fun `no endpoint means all locations, explicit endpoint pins one`() {
        assertEquals(HETZNER_S3_LOCATIONS, s3LocationsFor(null))
        assertEquals(HETZNER_S3_LOCATIONS, s3LocationsFor(" "))
        assertEquals(listOf("nbg1"), s3LocationsFor("nbg1.your-objectstorage.com"))
        assertEquals(listOf("hel1"), s3LocationsFor("https://hel1.your-objectstorage.com"))
    }

    @Test
    fun `merge keeps location per bucket and skips failed locations`() {
        val merged = mergeBucketListings(
            listOf(
                "fsn1" to Result.success(listOf("a", "b")),
                "nbg1" to Result.failure(IOException("down")),
                "hel1" to Result.success(listOf("c", "a")),
            ),
        )
        assertEquals(listOf(S3Bucket("a", "fsn1"), S3Bucket("b", "fsn1"), S3Bucket("c", "hel1")), merged)
    }

    @Test(expected = IOException::class)
    fun `merge fails only when every location failed`() {
        mergeBucketListings(
            listOf(
                "fsn1" to Result.failure(IOException("x")),
                "nbg1" to Result.failure(IllegalStateException("y")),
            ),
        )
    }

    @Test
    fun `resolve uses single location, then known map`() {
        assertEquals("fsn1", resolveBucketLocation("any", listOf("fsn1"), null))
        assertEquals("hel1", resolveBucketLocation("c", HETZNER_S3_LOCATIONS, mapOf("c" to "hel1")))
        assertNull(resolveBucketLocation("x", HETZNER_S3_LOCATIONS, mapOf("c" to "hel1")))
        assertNull(resolveBucketLocation("x", HETZNER_S3_LOCATIONS, null))
    }
}
