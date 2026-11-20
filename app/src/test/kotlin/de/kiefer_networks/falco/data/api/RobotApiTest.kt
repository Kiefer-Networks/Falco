// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import kotlinx.coroutines.test.runTest
import kotlinx.serialization.json.Json
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.MediaType.Companion.toMediaType
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
        server.close()
    }

    @Test
    fun `listServers parses envelope-wrapped response`() = runTest {
        server.enqueue(
            MockResponse.Builder()
                .setHeader("Content-Type", "application/json")
                .body(
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
                )
                .build(),
        )

        val servers = api.listServers()
        assertEquals(2, servers.size)
        assertEquals(321L, servers[0].server.serverNumber)
        assertEquals("server1", servers[0].server.serverName)
        assertEquals("EX 41-SSD", servers[0].server.product)
        assertEquals(421L, servers[1].server.serverNumber)

        val recorded = server.takeRequest()
        assertEquals("GET", recorded.method)
        assertEquals("/server", recorded.target)
    }

    // Storage Box endpoints on robot-ws were removed by Hetzner on 2025-07-30 —
    // the corresponding test was deleted. Storage Boxes now live on api.hetzner.com
    // (see CloudApi/StorageBoxApi).

    @Test
    fun `reset issues POST with form-encoded type field`() = runTest {
        server.enqueue(
            MockResponse.Builder()
                .setHeader("Content-Type", "application/json")
                .body(
                    """
                    {
                      "reset": {
                        "server_ip": "123.123.123.123",
                        "server_number": 321,
                        "type": ["hw"]
                      }
                    }
                    """.trimIndent(),
                )
                .build(),
        )

        api.reset(serverNumber = 321L, type = "hw")

        val recorded = server.takeRequest()
        assertEquals("POST", recorded.method)
        assertEquals("/reset/321", recorded.target)
        // FormUrlEncoded body uses application/x-www-form-urlencoded
        val contentType = recorded.headers["Content-Type"] ?: ""
        assertTrue(
            "Expected form-encoded content type, got $contentType",
            contentType.startsWith("application/x-www-form-urlencoded"),
        )
        assertEquals("type=hw", recorded.body?.utf8())
    }

    private fun jsonResponse(body: String, code: Int = 200) =
        MockResponse.Builder().code(code).setHeader("Content-Type", "application/json").body(body).build()

    @Test
    fun `setRdns uses POST for create or update`() = runTest {
        server.enqueue(jsonResponse("""{"rdns":{"ip":"1.2.3.4","ptr":"a.example.com"}}"""))
        api.setRdns("1.2.3.4", "a.example.com")
        val recorded = server.takeRequest()
        assertEquals("POST", recorded.method)
        assertEquals("/rdns/1.2.3.4", recorded.target)
        assertEquals("ptr=a.example.com", recorded.body?.utf8())
    }

    @Test
    fun `cancelServer sends cancellation_reason and reserve_location`() = runTest {
        server.enqueue(jsonResponse("""{"cancellation":{"server_number":321,"cancelled":true,"cancellation_date":"2026-12-31","cancellation_reason":"Upgrade"}}"""))
        val c = api.cancelServer(321L, "2026-12-31", "Upgrade", reserveLocation = false).cancellation
        assertEquals(listOf("Upgrade"), c.cancellationReason)
        val body = server.takeRequest().body?.utf8()
        assertEquals("cancellation_date=2026-12-31&cancellation_reason=Upgrade&reserve_location=false", body)
    }

    @Test
    fun `enableRescue sends key fingerprints as authorized_key array`() = runTest {
        server.enqueue(jsonResponse("""{"rescue":{"server_number":321,"os":"linux","active":true,"password":"x"}}"""))
        api.enableRescue(321L, "linux", listOf("aa:bb", "cc:dd"))
        val body = server.takeRequest().body?.utf8()
        assertEquals("os=linux&authorized_key%5B%5D=aa%3Abb&authorized_key%5B%5D=cc%3Add", body)
    }

    @Test
    fun `vSwitch endpoints decode bare responses`() = runTest {
        server.enqueue(jsonResponse("""[{"id":4321,"name":"vs1","vlan":4000,"cancelled":false}]"""))
        assertEquals(4321L, api.listVSwitches().single().id)

        server.enqueue(jsonResponse("""{"id":4321,"name":"vs1","vlan":4000,"cancelled":false,"server":[{"server_ip":"1.2.3.4","server_ipv6_net":null,"server_number":321,"status":"ready"}],"subnet":[],"cloud_network":[]}"""))
        assertEquals(321L, api.getVSwitch(4321L).server.single().serverNumber)

        server.enqueue(MockResponse.Builder().code(200).build())
        api.updateVSwitch(4321L, "vs2", 4001)
        server.takeRequest(); server.takeRequest()
        val update = server.takeRequest()
        assertEquals("POST", update.method)
        assertEquals("name=vs2&vlan=4001", update.body?.utf8())
    }

    @Test
    fun `deleteVSwitch sends cancellation_date as form body`() = runTest {
        server.enqueue(MockResponse.Builder().code(200).build())
        api.deleteVSwitch(4321L, "now")
        val recorded = server.takeRequest()
        assertEquals("DELETE", recorded.method)
        assertEquals("/vswitch/4321", recorded.target)
        assertEquals("cancellation_date=now", recorded.body?.utf8())
    }

    @Test(expected = retrofit2.HttpException::class)
    fun `no body endpoints throw on HTTP errors`() = runTest {
        server.enqueue(jsonResponse("""{"error":{"status":404,"code":"NOT_FOUND"}}""", code = 404))
        api.deleteRdns("1.2.3.4")
    }
}
