// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Request and response shapes the Hetzner APIs require, checked against the
 * same Json configuration HttpClientFactory uses (explicitNulls = false,
 * encodeDefaults = false), which silently drops defaults and nulls.
 */
class WireFormatTest {

    private val json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
        encodeDefaults = false
    }

    private fun encode(value: Any): JsonObject = when (value) {
        is ChangeDnsPtrRequest -> json.encodeToJsonElement(ChangeDnsPtrRequest.serializer(), value)
        is AssignPrimaryIpRequest -> json.encodeToJsonElement(AssignPrimaryIpRequest.serializer(), value)
        is ChangeServerTypeRequest -> json.encodeToJsonElement(ChangeServerTypeRequest.serializer(), value)
        is ChangeLbAlgorithmRequest -> json.encodeToJsonElement(ChangeLbAlgorithmRequest.serializer(), value)
        is CreateStorageBoxSubaccount -> json.encodeToJsonElement(CreateStorageBoxSubaccount.serializer(), value)
        else -> error("unsupported")
    }.jsonObject

    @Test
    fun `reset PTR sends dns_ptr as explicit null`() {
        val body = encode(ChangeDnsPtrRequest(ip = "1.2.3.4", dnsPtr = null))
        assertEquals("1.2.3.4", body["ip"]!!.jsonPrimitive.content)
        assertTrue("dns_ptr must be present", body.containsKey("dns_ptr"))
        assertEquals(JsonNull, body["dns_ptr"])
    }

    @Test
    fun `required defaults are encoded`() {
        assertEquals("server", encode(AssignPrimaryIpRequest(assigneeId = 42))["assignee_type"]!!.jsonPrimitive.content)
        assertEquals("false", encode(ChangeServerTypeRequest("cx32"))["upgrade_disk"]!!.jsonPrimitive.content)
        val sub = encode(CreateStorageBoxSubaccount(password = "x", homeDirectory = "/h"))
        assertEquals("true", sub["access_settings"]!!.jsonObject["ssh_enabled"]!!.jsonPrimitive.content)
    }

    @Test
    fun `change_algorithm body has top level type`() {
        assertEquals("least_connections", encode(ChangeLbAlgorithmRequest("least_connections"))["type"]!!.jsonPrimitive.content)
    }

    @Test
    fun `POST reset returns type as a string`() {
        val env = json.decodeFromString(
            RobotResetEnvelope.serializer(),
            """{"reset":{"server_ip":"1.2.3.4","server_number":321,"type":"hw"}}""",
        )
        assertEquals(listOf("hw"), env.reset.type)
    }

    @Test
    fun `unrouted failover IP decodes`() {
        val env = json.decodeFromString(
            RobotFailoverEnvelope.serializer(),
            """{"failover":{"ip":"1.2.3.4","netmask":"255.255.255.255","server_ip":"5.6.7.8","server_number":1,"active_server_ip":null}}""",
        )
        assertNull(env.failover.activeServerIp)
    }

    @Test
    fun `private ISO without name and subaccount create without username decode`() {
        val iso = json.decodeFromString(CloudIsoList.serializer(), """{"isos":[{"id":7,"name":null,"type":"private"}]}""")
        assertEquals("", iso.isos.single().name)
        val sub = json.decodeFromString(
            CloudStorageBoxSubaccountEnvelope.serializer(),
            """{"subaccount":{"id":5,"storage_box":9}}""",
        )
        assertEquals(5L, sub.subaccount.id)
    }
}
