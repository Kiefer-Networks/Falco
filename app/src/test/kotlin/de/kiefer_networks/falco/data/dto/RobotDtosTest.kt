// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Test

class RobotDtosTest {

    private val json = Json { ignoreUnknownKeys = true }

    @Test
    fun `deserialises list of RobotServerEnvelope and unwraps to RobotServer`() {
        val payload = """
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
        """.trimIndent()

        val list = json.decodeFromString(
            ListSerializer(RobotServerEnvelope.serializer()),
            payload,
        )

        assertEquals(2, list.size)
        val first = list.first().server
        assertEquals(321L, first.serverNumber)
        assertEquals("123.123.123.123", first.serverIp)
        assertEquals("server1", first.serverName)
        assertEquals("EX 41-SSD", first.product)
        assertEquals("FSN1-DC18", first.dc)
        assertEquals("ready", first.status)
        assertFalse(first.cancelled)
        assertEquals("2026-12-31", first.paidUntil)

        val second = list[1].server
        assertEquals(421L, second.serverNumber)
        assertEquals("server2", second.serverName)
        // optional fields default to null
        assertEquals(null, second.product)
    }

    @Test
    fun `deserialises list of RobotStorageBoxEnvelope and unwraps to RobotStorageBox`() {
        val payload = """
            [
              {
                "storagebox": {
                  "id": 1234,
                  "login": "u12345",
                  "name": "Backup HD 1",
                  "product": "BX10",
                  "cancelled": false,
                  "locked": false,
                  "location": "FSN1",
                  "linked_server": 321,
                  "paid_until": "2026-12-31",
                  "disk_quota": 107374182400,
                  "disk_usage": 5242880,
                  "webdav": true,
                  "samba": true,
                  "ssh": true,
                  "external_reachability": false,
                  "zfs": false
                }
              }
            ]
        """.trimIndent()

        val list = json.decodeFromString(
            ListSerializer(RobotStorageBoxEnvelope.serializer()),
            payload,
        )

        assertEquals(1, list.size)
        val box = list.first().storageBox
        assertEquals(1234L, box.id)
        assertEquals("u12345", box.login)
        assertEquals("Backup HD 1", box.name)
        assertEquals("BX10", box.product)
        assertEquals("FSN1", box.location)
        assertEquals(321L, box.linkedServer)
        assertEquals(107374182400L, box.diskQuota)
        assertEquals(5242880L, box.diskUsage)
        assertEquals(true, box.webdav)
        assertEquals(true, box.samba)
        assertEquals(true, box.ssh)
        assertEquals(false, box.externalReachability)
        assertEquals(false, box.zfs)
    }

    @Test
    fun `RobotResetEnvelope parses available reset types`() {
        val payload = """
            {
              "reset": {
                "server_ip": "123.123.123.123",
                "server_number": 321,
                "type": ["sw", "hw", "man"],
                "operating_status": "not supported"
              }
            }
        """.trimIndent()
        val env = json.decodeFromString(RobotResetEnvelope.serializer(), payload)
        assertNotNull(env.reset)
        assertEquals(listOf("sw", "hw", "man"), env.reset.type)
        assertEquals(321L, env.reset.serverNumber)
    }
}
