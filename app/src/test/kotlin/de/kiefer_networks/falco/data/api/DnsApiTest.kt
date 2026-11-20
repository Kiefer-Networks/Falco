// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.DnsAddRecordsRequest
import de.kiefer_networks.falco.data.dto.DnsRRValue
import de.kiefer_networks.falco.data.dto.DnsZonefile
import de.kiefer_networks.falco.data.dto.toRecords
import kotlinx.coroutines.test.runTest
import kotlinx.serialization.json.Json
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.MediaType.Companion.toMediaType
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory

class DnsApiTest {

    private lateinit var server: MockWebServer
    private lateinit var api: DnsApi

    // Mirrors HttpClientFactory.json.
    private val json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
        encodeDefaults = false
    }

    private val action = """
        {"action": {"id": 7, "command": "add_rrset_records", "status": "running", "progress": 0,
         "started": "2025-01-01T00:00:00Z", "finished": null, "resources": [{"id": 42, "type": "zone"}], "error": null}}
    """.trimIndent()

    @Before
    fun setUp() {
        server = MockWebServer()
        server.start()
        api = Retrofit.Builder()
            .baseUrl(server.url("/v1/"))
            .addConverterFactory(json.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(DnsApi::class.java)
    }

    @After
    fun tearDown() {
        server.close()
    }

    private fun enqueue(body: String) = server.enqueue(
        MockResponse.Builder().setHeader("Content-Type", "application/json").body(body).build(),
    )

    @Test
    fun `listZones parses cloud zones and pagination`() = runTest {
        enqueue(
            """
            {
              "zones": [
                {"id": 42, "name": "example.com", "mode": "primary", "ttl": 3600, "registrar": "hetzner",
                 "status": "ok", "record_count": 5, "labels": {}, "protection": {"delete": false},
                 "primary_nameservers": [], "authoritative_nameservers": {"assigned": [], "delegated": []}},
                {"id": 43, "name": "sec.example", "mode": "secondary", "ttl": 3600, "status": "updating",
                 "record_count": 0, "primary_nameservers": [{"address": "198.51.100.1", "port": 53}]}
              ],
              "meta": {"pagination": {"page": 1, "per_page": 50, "previous_page": null, "next_page": null,
                       "last_page": 1, "total_entries": 2}}
            }
            """.trimIndent(),
        )

        val list = api.listZones()
        assertEquals(42L, list.zones[0].id)
        assertEquals(5, list.zones[0].recordsCount)
        assertEquals("secondary", list.zones[1].mode)
        assertEquals("198.51.100.1:53", list.zones[1].primaryNameservers!!.single().id)
        assertEquals(1, list.meta?.pagination?.lastPage)

        val recorded = server.takeRequest()
        assertEquals("GET", recorded.method)
        assertEquals("/v1/zones?page=1&per_page=50", recorded.target)
    }

    @Test
    fun `listRRSets flattens rrsets into records`() = runTest {
        enqueue(
            """
            {"rrsets": [{"id": "www/A", "name": "www", "type": "A", "ttl": null, "labels": {},
                         "protection": {"change": false}, "zone": 42,
                         "records": [{"value": "192.0.2.1"}, {"value": "192.0.2.2", "comment": "x"}]}],
             "meta": {"pagination": {"page": 1, "per_page": 50, "last_page": 1, "total_entries": 1}}}
            """.trimIndent(),
        )

        val records = api.listRRSets("42").rrsets.flatMap { it.toRecords("42") }
        assertEquals(2, records.size)
        assertEquals("www/A/192.0.2.2", records[1].id)
        assertNull(records[0].ttl)
        assertEquals("/v1/zones/42/rrsets?page=1&per_page=50", server.takeRequest().target)
    }

    @Test
    fun `addRecords posts to rrset action and parses action`() = runTest {
        enqueue(action)

        val resp = api.addRecords("42", "www", "A", DnsAddRecordsRequest(listOf(DnsRRValue("192.0.2.1")), ttl = 600))
        assertEquals(7L, resp.action.id)
        assertEquals("running", resp.action.status)

        val recorded = server.takeRequest()
        assertEquals("POST", recorded.method)
        assertEquals("/v1/zones/42/rrsets/www/A/actions/add_records", recorded.target)
        assertEquals("""{"records":[{"value":"192.0.2.1"}],"ttl":600}""", recorded.body!!.utf8())
    }

    @Test
    fun `import and export use zonefile json body`() = runTest {
        enqueue(action)
        enqueue("""{"zonefile": "${'$'}ORIGIN example.com.\n"}""")

        api.importZonefile("42", DnsZonefile("@ 3600 IN A 192.0.2.1\n"))
        val zonefile = api.exportZonefile("42").zonefile

        val imp = server.takeRequest()
        assertEquals("/v1/zones/42/actions/import_zonefile", imp.target)
        assertEquals("""{"zonefile":"@ 3600 IN A 192.0.2.1\n"}""", imp.body!!.utf8())
        assertEquals("/v1/zones/42/zonefile", server.takeRequest().target)
        assertEquals("\$ORIGIN example.com.\n", zonefile)
    }
}
