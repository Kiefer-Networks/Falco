// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import kotlinx.coroutines.test.runTest
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.mockwebserver.MockResponse
import okhttp3.mockwebserver.MockWebServer
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory

class CloudApiTest {

    private lateinit var server: MockWebServer
    private lateinit var api: CloudApi

    private val json = Json { ignoreUnknownKeys = true }

    @Before
    fun setUp() {
        server = MockWebServer()
        server.start()
        // Build Retrofit directly here — HttpClientFactory pins certs to real
        // hosts, which would block MockWebServer.
        api = Retrofit.Builder()
            .baseUrl(server.url("/v1/"))
            .addConverterFactory(json.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(CloudApi::class.java)
    }

    @After
    fun tearDown() {
        server.shutdown()
    }

    @Test
    fun `listServers parses Hetzner Cloud server payload`() = runTest {
        server.enqueue(
            MockResponse()
                .setHeader("Content-Type", "application/json")
                .setBody(
                    """
                    {
                      "servers": [
                        {
                          "id": 42,
                          "name": "my-server",
                          "status": "running",
                          "created": "2016-01-30T23:55:00+00:00",
                          "public_net": {
                            "ipv4": { "ip": "1.2.3.4", "blocked": false }
                          },
                          "server_type": {
                            "id": 1, "name": "cx22", "cores": 2, "memory": 4.0, "disk": 40
                          }
                        }
                      ],
                      "meta": {
                        "pagination": { "page": 1, "per_page": 50, "total_entries": 1, "last_page": 1 }
                      }
                    }
                    """.trimIndent(),
                ),
        )

        val list = api.listServers()
        assertEquals(1, list.servers.size)
        val server = list.servers.first()
        assertEquals(42L, server.id)
        assertEquals("my-server", server.name)
        assertEquals("running", server.status)
        assertEquals("1.2.3.4", server.publicNet?.ipv4?.ip)
        assertEquals("cx22", server.serverType?.name)

        val recorded = this@CloudApiTest.server.takeRequest()
        assertEquals("GET", recorded.method)
        // Default page=1, per_page=50 must be sent
        assertEquals("/v1/servers?page=1&per_page=50", recorded.path)
    }

    @Test
    fun `reboot issues POST to correct path`() = runTest {
        server.enqueue(
            MockResponse()
                .setHeader("Content-Type", "application/json")
                .setBody(
                    """
                    {
                      "action": {
                        "id": 13,
                        "command": "reboot_server",
                        "status": "running",
                        "progress": 0,
                        "started": "2016-01-30T23:55:00+00:00",
                        "finished": null
                      }
                    }
                    """.trimIndent(),
                ),
        )

        val response = api.reboot(42L)
        assertEquals(13L, response.action.id)
        assertEquals("reboot_server", response.action.command)

        val recorded = this@CloudApiTest.server.takeRequest()
        assertEquals("POST", recorded.method)
        assertEquals("/v1/servers/42/actions/reboot", recorded.path)
        // Reboot has no body
        assertTrue(recorded.bodySize == 0L)
    }

    @Test
    fun `listServers honours custom paging parameters`() = runTest {
        server.enqueue(
            MockResponse()
                .setHeader("Content-Type", "application/json")
                .setBody("""{"servers": []}"""),
        )

        api.listServers(page = 3, perPage = 10)

        val recorded = server.takeRequest()
        assertEquals("/v1/servers?page=3&per_page=10", recorded.path)
    }
}
