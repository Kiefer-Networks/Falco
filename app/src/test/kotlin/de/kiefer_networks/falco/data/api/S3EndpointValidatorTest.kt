// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class S3EndpointValidatorTest {

    @Test
    fun `accepts bare allowed host`() {
        assertEquals("https://fsn1.your-objectstorage.com", validateAndNormalizeS3Endpoint("fsn1.your-objectstorage.com"))
    }

    @Test
    fun `accepts https allowed host`() {
        assertEquals("https://hel1.your-objectstorage.com", validateAndNormalizeS3Endpoint("https://hel1.your-objectstorage.com"))
    }

    @Test
    fun `accepts trailing slash root path`() {
        assertEquals("https://nbg1.your-objectstorage.com", validateAndNormalizeS3Endpoint("https://nbg1.your-objectstorage.com/"))
    }

    @Test
    fun `rejects cleartext`() {
        assertThrows(CleartextS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("http://fsn1.your-objectstorage.com")
        }
    }

    @Test
    fun `rejects unknown host`() {
        assertThrows(UnpinnedS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("evil.example.com")
        }
    }

    @Test
    fun `rejects userinfo`() {
        assertThrows(UnpinnedS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("https://user:pw@fsn1.your-objectstorage.com")
        }
    }

    @Test
    fun `rejects userinfo at sign smuggle`() {
        assertThrows(UnpinnedS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("https://fsn1.your-objectstorage.com@evil.example.com")
        }
    }

    @Test
    fun `rejects non default port`() {
        assertThrows(UnpinnedS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("https://fsn1.your-objectstorage.com:8443")
        }
    }

    @Test
    fun `rejects path`() {
        assertThrows(UnpinnedS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("https://fsn1.your-objectstorage.com/bucket")
        }
    }

    @Test
    fun `rejects query`() {
        assertThrows(UnpinnedS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("https://fsn1.your-objectstorage.com/?x=1")
        }
    }

    @Test
    fun `rejects fragment`() {
        assertThrows(UnpinnedS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("https://fsn1.your-objectstorage.com/#frag")
        }
    }

    @Test
    fun `rejects garbage`() {
        assertThrows(UnpinnedS3EndpointException::class.java) {
            validateAndNormalizeS3Endpoint("https://")
        }
    }
}
