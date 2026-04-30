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

class RobotApiTest {

    private lateinit var server: MockWebServer
    private lateinit var api: RobotApi

    private val json = Json { ignoreUnknownKeys = true }

    @Before
    fun setUp() {
        server = MockWebServer()
        server.start()
        api = Retrofit.Builder()
            .baseUrl(server.url("/"))
            .addConverterFactory(json.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(RobotApi::class.java)
    }

    @After
    fun tearDown() {
        server.shutdown()
    }

    @Test
    fun `listServers parses envelope-wrapped response`() = runTest {
        server.enqueue(
            MockResponse()
                .setHeader("Content-Type", "application/json")
                .setBody(
                    """
                    [
                      {
                        "server": {
                          "server_ip": "123.123.123.123",
                          "server_ipv6_net": "2a01:4f8:111:4221::",
                          "server_number": 321,
                          "server_name": "server1",
                          "product": "EX 41-SSD",
                          "dc": "FSN1-DC18",
                          "traffic": "5 TB",
                          "status": "ready",
                          "cancelled": false,
                          "paid_until": "2026-12-31"
                        }
                      },
                      {
                        "server": {
                          "server_ip": "124.124.124.124",
                          "server_number": 421,
                          "server_name": "server2",
                          "status": "ready"
                        }
                      }
                    ]
                    """.trimIndent(),
                ),
        )

        val servers = api.listServers()
        assertEquals(2, servers.size)
        assertEquals(321L, servers[0].server.serverNumber)
        assertEquals("server1", servers[0].server.serverName)
        assertEquals("EX 41-SSD", servers[0].server.product)
        assertEquals(421L, servers[1].server.serverNumber)

        val recorded = server.takeRequest()
        assertEquals("GET", recorded.method)
        assertEquals("/server", recorded.path)
    }

    // Storage Box endpoints on robot-ws were removed by Hetzner on 2025-07-30 —
    // the corresponding test was deleted. Storage Boxes now live on api.hetzner.com
    // (see CloudApi/StorageBoxApi).

    @Test
    fun `reset issues POST with form-encoded type field`() = runTest {
        server.enqueue(
            MockResponse()
                .setHeader("Content-Type", "application/json")
                .setBody(
                    """
                    {
                      "reset": {
                        "server_ip": "123.123.123.123",
                        "server_number": 321,
                        "type": ["hw"]
                      }
                    }
                    """.trimIndent(),
                ),
        )

        api.reset(serverNumber = 321L, type = "hw")

        val recorded = server.takeRequest()
        assertEquals("POST", recorded.method)
        assertEquals("/reset/321", recorded.path)
        // FormUrlEncoded body uses application/x-www-form-urlencoded
        val contentType = recorded.getHeader("Content-Type") ?: ""
        assertTrue(
            "Expected form-encoded content type, got $contentType",
            contentType.startsWith("application/x-www-form-urlencoded"),
        )
        assertEquals("type=hw", recorded.body.readUtf8())
    }
}
