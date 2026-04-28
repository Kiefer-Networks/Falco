// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.json.Json
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test

class CloudDtosTest {

    private val json = Json { ignoreUnknownKeys = true }

    /**
     * Realistic minimal payload modelled after the Hetzner Cloud API v1
     * `GET /servers` response. Includes a smattering of unknown fields that
     * we expect kotlinx-serialization to ignore.
     */
    private val cloudServerListJson = """
        {
          "servers": [
            {
              "id": 42,
              "name": "my-server",
              "status": "running",
              "created": "2016-01-30T23:55:00+00:00",
              "public_net": {
                "ipv4": {
                  "ip": "1.2.3.4",
                  "blocked": false,
                  "dns_ptr": "static.1.2.3.4.clients.your-server.de"
                },
                "ipv6": {
                  "ip": "2001:db8::/64",
                  "blocked": false
                }
              },
              "private_net": [
                { "network": 4711, "ip": "10.0.0.2" }
              ],
              "server_type": {
                "id": 1,
                "name": "cx22",
                "cores": 2,
                "memory": 4.0,
                "disk": 40,
                "extra_field_we_dont_care_about": "ignored"
              },
              "datacenter": {
                "id": 1,
                "name": "fsn1-dc8",
                "location": {
                  "id": 1,
                  "name": "fsn1",
                  "city": "Falkenstein",
                  "country": "DE"
                }
              },
              "image": { "id": 4711, "name": "ubuntu-22.04", "description": "Ubuntu 22.04" },
              "labels": { "env": "prod" },
              "locked": false,
              "outgoing_traffic": 123456
            }
          ],
          "meta": {
            "pagination": {
              "page": 1,
              "per_page": 50,
              "total_entries": 1,
              "last_page": 1
            }
          }
        }
    """.trimIndent()

    @Test
    fun `parses representative CloudServerList payload`() {
        val list = json.decodeFromString(CloudServerList.serializer(), cloudServerListJson)

        assertEquals(1, list.servers.size)
        val server = list.servers.first()
        assertEquals(42L, server.id)
        assertEquals("my-server", server.name)
        assertEquals("running", server.status)
        assertEquals("1.2.3.4", server.publicNet?.ipv4?.ip)
        assertEquals(
            "static.1.2.3.4.clients.your-server.de",
            server.publicNet?.ipv4?.dnsPtr,
        )
        assertEquals(1, server.privateNet.size)
        assertEquals(4711L, server.privateNet.first().network)
        assertEquals("cx22", server.serverType?.name)
        assertEquals(2, server.serverType?.cores)
        assertEquals(4.0, server.serverType?.memory ?: 0.0, 0.0001)
        assertEquals("fsn1-dc8", server.datacenter?.name)
        assertEquals("Falkenstein", server.datacenter?.location?.city)
        assertEquals("ubuntu-22.04", server.image?.name)
        assertEquals(mapOf("env" to "prod"), server.labels)
        assertEquals(false, server.locked)

        assertNotNull(list.meta?.pagination)
        assertEquals(1, list.meta?.pagination?.page)
        assertEquals(50, list.meta?.pagination?.perPage)
        assertEquals(1, list.meta?.pagination?.totalEntries)
    }

    @Test
    fun `round-trip CloudServerList preserves key fields`() {
        val original = json.decodeFromString(CloudServerList.serializer(), cloudServerListJson)
        val encoded = json.encodeToString(CloudServerList.serializer(), original)
        val again = json.decodeFromString(CloudServerList.serializer(), encoded)

        assertEquals(original.servers.size, again.servers.size)
        assertEquals(original.servers.first().id, again.servers.first().id)
        assertEquals(original.servers.first().name, again.servers.first().name)
        assertEquals(
            original.servers.first().publicNet?.ipv4?.ip,
            again.servers.first().publicNet?.ipv4?.ip,
        )
        assertEquals(
            original.servers.first().serverType?.cores,
            again.servers.first().serverType?.cores,
        )
        assertEquals(original.meta?.pagination?.page, again.meta?.pagination?.page)
    }

    @Test
    fun `parses ServerAction envelope`() {
        val payload = """
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
        """.trimIndent()
        val action = json.decodeFromString(ServerAction.serializer(), payload)
        assertEquals(13L, action.action.id)
        assertEquals("reboot_server", action.action.command)
        assertEquals("running", action.action.status)
        assertTrue(action.action.finished == null)
    }
}
