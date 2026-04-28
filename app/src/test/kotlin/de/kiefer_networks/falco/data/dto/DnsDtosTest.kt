// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.json.Json
import org.junit.Assert.assertEquals
import org.junit.Test

class DnsDtosTest {

    private val json = Json { ignoreUnknownKeys = true }

    private val dnsZoneListJson = """
        {
          "zones": [
            {
              "id": "1abc2def3",
              "name": "example.com",
              "ttl": 86400,
              "registrar": "hetzner",
              "status": "verified",
              "records_count": 5,
              "verified": "2025-01-01T00:00:00Z",
              "created": "2024-06-01T12:00:00Z",
              "modified": "2025-01-01T00:00:00Z",
              "extra_unknown_field": "ignored"
            }
          ]
        }
    """.trimIndent()

    private val dnsRecordListJson = """
        {
          "records": [
            {
              "id": "rec123",
              "zone_id": "1abc2def3",
              "name": "@",
              "type": "A",
              "value": "1.2.3.4",
              "ttl": 3600,
              "created": "2024-06-01T12:00:00Z",
              "modified": "2025-01-01T00:00:00Z"
            },
            {
              "zone_id": "1abc2def3",
              "name": "www",
              "type": "CNAME",
              "value": "example.com."
            }
          ]
        }
    """.trimIndent()

    @Test
    fun `parses DnsZoneList`() {
        val list = json.decodeFromString(DnsZoneList.serializer(), dnsZoneListJson)
        assertEquals(1, list.zones.size)
        val zone = list.zones.first()
        assertEquals("1abc2def3", zone.id)
        assertEquals("example.com", zone.name)
        assertEquals(86400, zone.ttl)
        assertEquals("hetzner", zone.registrar)
        assertEquals("verified", zone.status)
        assertEquals(5, zone.recordsCount)
    }

    @Test
    fun `round-trips DnsZoneList`() {
        val original = json.decodeFromString(DnsZoneList.serializer(), dnsZoneListJson)
        val encoded = json.encodeToString(DnsZoneList.serializer(), original)
        val again = json.decodeFromString(DnsZoneList.serializer(), encoded)
        assertEquals(original.zones.size, again.zones.size)
        assertEquals(original.zones.first().id, again.zones.first().id)
        assertEquals(original.zones.first().name, again.zones.first().name)
        assertEquals(original.zones.first().recordsCount, again.zones.first().recordsCount)
    }

    @Test
    fun `parses DnsRecordList including record without optional id`() {
        val list = json.decodeFromString(DnsRecordList.serializer(), dnsRecordListJson)
        assertEquals(2, list.records.size)

        val first = list.records[0]
        assertEquals("rec123", first.id)
        assertEquals("1abc2def3", first.zoneId)
        assertEquals("@", first.name)
        assertEquals("A", first.type)
        assertEquals("1.2.3.4", first.value)
        assertEquals(3600, first.ttl)

        val second = list.records[1]
        assertEquals(null, second.id)
        assertEquals("CNAME", second.type)
        assertEquals("www", second.name)
    }

    @Test
    fun `round-trips DnsRecordList`() {
        val original = json.decodeFromString(DnsRecordList.serializer(), dnsRecordListJson)
        val encoded = json.encodeToString(DnsRecordList.serializer(), original)
        val again = json.decodeFromString(DnsRecordList.serializer(), encoded)
        assertEquals(original.records.size, again.records.size)
        assertEquals(original.records[0].id, again.records[0].id)
        assertEquals(original.records[0].value, again.records[0].value)
        assertEquals(original.records[1].id, again.records[1].id)
    }
}
