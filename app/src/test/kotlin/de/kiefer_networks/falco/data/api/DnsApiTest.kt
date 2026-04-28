// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import kotlinx.coroutines.test.runTest
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.mockwebserver.MockResponse
import okhttp3.mockwebserver.MockWebServer
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory

class DnsApiTest {

    private lateinit var server: MockWebServer
    private lateinit var api: DnsApi

    private val json = Json { ignoreUnknownKeys = true }

    @Before
    fun setUp() {
        server = MockWebServer()
        server.start()
        api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .addConverterFactory(json.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(DnsApi::class.java)
    }

    @After
    fun tearDown() {
        server.shutdown()
    }

    @Test
    fun `listZones parses zone list`() = runTest {
        server.enqueue(
            MockResponse()
                .setHeader("Content-Type", "application/json")
                .setBody(
                    """
                    {
                      "zones": [
                        {
                          "id": "1abc2def3",
                          "name": "example.com",
                          "ttl": 86400,
                          "registrar": "hetzner",
                          "status": "verified",
                          "records_count": 5
                        },
                        {
                          "id": "4ghi5jkl6",
                          "name": "another.example",
                          "status": "verified"
                        }
                      ]
                    }
                    """.trimIndent(),
                ),
        )

        val list = api.listZones()
        assertEquals(2, list.zones.size)
        assertEquals("1abc2def3", list.zones[0].id)
        assertEquals("example.com", list.zones[0].name)
        assertEquals(86400, list.zones[0].ttl)
        assertEquals(5, list.zones[0].recordsCount)
        assertEquals("4ghi5jkl6", list.zones[1].id)
        assertEquals(null, list.zones[1].ttl)

        val recorded = server.takeRequest()
        assertEquals("GET", recorded.method)
        assertEquals("/api/v1/zones?page=1&per_page=100", recorded.path)
    }
}
