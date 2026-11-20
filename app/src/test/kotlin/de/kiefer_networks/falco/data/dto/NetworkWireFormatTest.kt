// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.dto

import de.kiefer_networks.falco.data.repo.MetricSeries
import de.kiefer_networks.falco.data.repo.byteRateUnit
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.boolean
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.json.long
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Test

/** Network request bodies and metric helpers, with the HttpClientFactory Json settings. */
class NetworkWireFormatTest {

    private val json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
        encodeDefaults = false
    }

    private fun create(r: CreateNetworkRequest): JsonObject =
        json.encodeToJsonElement(CreateNetworkRequest.serializer(), r).jsonObject

    @Test
    fun `create network sends subnets with vswitch id in the POST body`() {
        val body = create(
            CreateNetworkRequest(
                name = "net",
                ipRange = "10.0.0.0/16",
                subnets = listOf(
                    AddSubnetRequest(type = "vswitch", networkZone = "eu-central", ipRange = "10.0.1.0/24", vswitchId = 42),
                ),
            ),
        )
        assertEquals(setOf("name", "ip_range", "subnets"), body.keys)
        val subnet = body["subnets"]!!.jsonArray.single().jsonObject
        assertEquals("vswitch", subnet["type"]!!.jsonPrimitive.content)
        assertEquals("eu-central", subnet["network_zone"]!!.jsonPrimitive.content)
        assertEquals(42L, subnet["vswitch_id"]!!.jsonPrimitive.long)
    }

    @Test
    fun `create network without subnet sends only required fields`() {
        val body = create(CreateNetworkRequest(name = "net", ipRange = "10.0.0.0/16"))
        assertEquals(setOf("name", "ip_range"), body.keys)
    }

    @Test
    fun `cloud subnet omits vswitch id`() {
        val body = json.encodeToJsonElement(
            AddSubnetRequest.serializer(),
            AddSubnetRequest(type = "cloud", networkZone = "eu-central"),
        ).jsonObject
        assertFalse(body.containsKey("vswitch_id"))
    }

    @Test
    fun `expose routes is a PUT field`() {
        val body = json.encodeToJsonElement(
            UpdateNetworkRequest.serializer(),
            UpdateNetworkRequest(exposeRoutesToVswitch = false),
        ).jsonObject
        assertEquals(setOf("expose_routes_to_vswitch"), body.keys)
        assertFalse(body["expose_routes_to_vswitch"]!!.jsonPrimitive.boolean)
    }

    @Test
    fun `metric series are picked by suffix`() {
        val s = MetricSeries(
            mapOf(
                "disk.0.iops.read" to listOf(1L to 1.0),
                "disk.0.bandwidth.read" to listOf(1L to 2.0),
                "disk.0.bandwidth.write" to listOf(1L to 3.0),
            ),
        )
        assertEquals(listOf(1L to 2.0), s.bySuffix("bandwidth.read"))
        assertEquals(listOf(1L to 3.0), s.bySuffix("bandwidth.write"))
        assertEquals(emptyList<Pair<Long, Double>>(), s.bySuffix("bandwidth.in"))
    }

    @Test
    fun `byte rate unit scales by magnitude`() {
        assertEquals(1.0 to " B/s", byteRateUnit(999.0))
        assertEquals(1e3 to " kB/s", byteRateUnit(1_500.0))
        assertEquals(1e6 to " MB/s", byteRateUnit(2e6))
        assertEquals(1e9 to " GB/s", byteRateUnit(3e9))
    }
}
