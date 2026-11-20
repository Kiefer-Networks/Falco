// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.dto

import de.kiefer_networks.falco.data.repo.normalizeValue
import kotlinx.serialization.json.Json
import org.junit.Assert.assertEquals
import org.junit.Test

class DnsDtosTest {

    // Mirrors HttpClientFactory.json.
    private val json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
        encodeDefaults = false
    }

    @Test
    fun `create zone request always sends required mode`() {
        assertEquals(
            """{"name":"example.com","mode":"primary"}""",
            json.encodeToString(CreateDnsZoneRequest.serializer(), CreateDnsZoneRequest(name = "example.com")),
        )
    }

    @Test
    fun `primary server encodes default port and omits null tsig`() {
        assertEquals(
            """{"primary_nameservers":[{"address":"198.51.100.1","port":53}]}""",
            json.encodeToString(
                DnsPrimaryServersRequest.serializer(),
                DnsPrimaryServersRequest(listOf(DnsPrimaryServer("198.51.100.1"))),
            ),
        )
    }

    @Test
    fun `zone tolerates null rrset ttl and missing optional fields`() {
        val z = json.decodeFromString(DnsZone.serializer(), """{"id": 1, "name": "a.example"}""")
        assertEquals(1L, z.id)
        val rr = json.decodeFromString(
            DnsRRSet.serializer(),
            """{"name": "@", "type": "MX", "ttl": null, "records": [{"value": "10 mx.a.example."}]}""",
        )
        assertEquals(null, rr.ttl)
        assertEquals("@/MX/10 mx.a.example.", rr.toRecords("1").single().id)
    }

    @Test
    fun `TXT values get quoted once`() {
        assertEquals("\"v=spf1 -all\"", normalizeValue("TXT", "v=spf1 -all"))
        assertEquals("\"already\"", normalizeValue("TXT", "\"already\""))
        assertEquals("192.0.2.1", normalizeValue("A", "192.0.2.1"))
    }
}
