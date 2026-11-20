// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.DnsApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.fetchAllPages
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.dto.ActionEnvelope
import de.kiefer_networks.falco.data.dto.CreateDnsRecord
import de.kiefer_networks.falco.data.dto.CreateDnsZoneRequest
import de.kiefer_networks.falco.data.dto.DnsAddRecordsRequest
import de.kiefer_networks.falco.data.dto.DnsPrimaryServer
import de.kiefer_networks.falco.data.dto.DnsPrimaryServersRequest
import de.kiefer_networks.falco.data.dto.DnsRRValue
import de.kiefer_networks.falco.data.dto.DnsRecord
import de.kiefer_networks.falco.data.dto.DnsRecordsRequest
import de.kiefer_networks.falco.data.dto.DnsTtlRequest
import de.kiefer_networks.falco.data.dto.DnsZone
import de.kiefer_networks.falco.data.dto.DnsZonefile
import de.kiefer_networks.falco.data.dto.toRecords
import javax.inject.Inject
import javax.inject.Singleton
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.first

/**
 * A BIND zone file is sent in one request. Real zones are tiny (typically
 * <16 KiB); a multi MiB upload is malformed input. Capping at 1 MiB keeps the
 * failure local and fast.
 */
private const val MAX_BIND_FILE_BYTES: Int = 1 * 1024 * 1024

class BindFileTooLargeException(val sizeBytes: Int) :
    IllegalArgumentException("BIND zone file is $sizeBytes bytes; max ${MAX_BIND_FILE_BYTES / 1024} KiB")

private fun requireBindFileWithinLimit(text: String) {
    val size = text.toByteArray(Charsets.UTF_8).size
    if (size > MAX_BIND_FILE_BYTES) throw BindFileTooLargeException(size)
}

/** The Cloud DNS API expects TXT values quoted; accept the unquoted form users type. */
internal fun normalizeValue(type: String, value: String): String =
    if (type == "TXT" && !value.startsWith("\"")) "\"" + value.replace("\"", "\\\"") + "\"" else value

/**
 * DNS lives in the Hetzner Cloud API since the standalone DNS API was shut
 * down. Authentication is the active Cloud project's token; the legacy DNS
 * Console token is no longer accepted anywhere.
 */
@Singleton
class DnsRepo @Inject constructor(private val accounts: AccountManager) {

    private suspend fun api(): DnsApi {
        val token = requireNotNull(accounts.activeCloudProject.first()?.cloudToken) {
            "DNS needs a Cloud project token"
        }
        return HttpClientFactory.cloudRetrofit(token).create(DnsApi::class.java)
    }

    /** Wait for a DNS action so the following refresh shows the result; on timeout the caller refreshes anyway. */
    private suspend fun DnsApi.await(action: ActionEnvelope?) {
        var a = action ?: return
        repeat(30) {
            when (a.status) {
                "success" -> return
                "error" -> error(a.error?.message ?: "DNS action ${a.command} failed")
            }
            delay(1_000)
            a = getAction(a.id).action
        }
    }

    // ---- Zones -----------------------------------------------------------

    suspend fun listZones(): List<DnsZone> {
        val api = api()
        return fetchAllPages { p -> api.listZones(page = p).let { it.zones to it.meta } }
    }

    suspend fun getZone(id: String): DnsZone = api().getZone(id).zone

    suspend fun createZone(name: String, ttl: Int? = null): DnsZone {
        val api = api()
        val resp = api.createZone(CreateDnsZoneRequest(name = name, ttl = ttl))
        api.await(resp.action)
        return resp.zone
    }

    /** The zone name is immutable in the Cloud API; only the default TTL can change. */
    suspend fun changeZoneTtl(id: String, ttl: Int) {
        val api = api()
        api.await(api.changeZoneTtl(id, DnsTtlRequest(ttl)).action)
    }

    suspend fun deleteZone(id: String) {
        val api = api()
        api.await(api.deleteZone(id).action)
    }

    // ---- Records (flattened RRSets) -------------------------------------

    suspend fun listRecords(zoneId: String): List<DnsRecord> {
        val api = api()
        return fetchAllPages { p -> api.listRRSets(zoneId, page = p).let { it.rrsets to it.meta } }
            .flatMap { it.toRecords(zoneId) }
    }

    /** Adds the value to the RRSet name/type; the API creates the RRSet if missing. */
    suspend fun createRecord(record: CreateDnsRecord) {
        val api = api()
        api.addRecord(record)
    }

    private suspend fun DnsApi.addRecord(r: CreateDnsRecord) {
        await(
            addRecords(
                r.zoneId, r.name, r.type,
                DnsAddRecordsRequest(listOf(DnsRRValue(normalizeValue(r.type, r.value))), r.ttl),
            ).action,
        )
        // add_records only applies the TTL when it creates the RRSet.
        if (r.ttl != null) await(changeRRSetTtl(r.zoneId, r.name, r.type, DnsTtlRequest(r.ttl)).action)
    }

    /**
     * Replaces [old] with [new]. Same name and type: swap the value inside the
     * RRSet with set_records. Otherwise remove the old value and add the new one.
     */
    suspend fun updateRecord(old: DnsRecord, new: CreateDnsRecord, siblings: List<DnsRecord>) {
        val api = api()
        if (old.name == new.name && old.type == new.type) {
            val values = siblings
                .filter { it.name == old.name && it.type == old.type }
                .map { if (it.value == old.value) normalizeValue(new.type, new.value) else it.value }
            api.await(api.setRecords(old.zoneId, old.name, old.type, DnsRecordsRequest(values.map { DnsRRValue(it) })).action)
            if (new.ttl != null && new.ttl != old.ttl) {
                api.await(api.changeRRSetTtl(old.zoneId, old.name, old.type, DnsTtlRequest(new.ttl)).action)
            }
        } else {
            api.addRecord(new)
            api.await(api.removeRecords(old.zoneId, old.name, old.type, DnsRecordsRequest(listOf(DnsRRValue(old.value)))).action)
        }
    }

    /** Removes one value; the API deletes the RRSet when it becomes empty. */
    suspend fun deleteRecord(record: DnsRecord) {
        val api = api()
        api.await(
            api.removeRecords(record.zoneId, record.name, record.type, DnsRecordsRequest(listOf(DnsRRValue(record.value)))).action,
        )
    }

    /**
     * Bulk edit: [selected] grouped per RRSet. A new value replaces every
     * selected value of an RRSet (collapsing them into one); a new TTL applies
     * to the whole RRSet, since TTL is per RRSet. Returns the number of RRSets
     * that failed.
     */
    suspend fun bulkEdit(all: List<DnsRecord>, selected: List<DnsRecord>, newValue: String?, newTtl: Int?): Int {
        val api = api()
        var failed = 0
        selected.groupBy { it.name to it.type }.forEach { (key, recs) ->
            val (name, type) = key
            val zoneId = recs.first().zoneId
            val ok = runCatching {
                if (newValue != null) {
                    val selectedValues = recs.map { it.value }.toSet()
                    val kept = all.filter { it.name == name && it.type == type && it.value !in selectedValues }.map { it.value }
                    val values = (kept + normalizeValue(type, newValue)).distinct()
                    api.await(api.setRecords(zoneId, name, type, DnsRecordsRequest(values.map { DnsRRValue(it) })).action)
                }
                if (newTtl != null) api.await(api.changeRRSetTtl(zoneId, name, type, DnsTtlRequest(newTtl)).action)
            }.isSuccess
            if (!ok) failed++
        }
        return failed
    }

    // ---- BIND import / export -------------------------------------------

    suspend fun exportZone(id: String): String = api().exportZonefile(id).zonefile

    /** Replaces every record of the zone with the content of the zone file. */
    suspend fun importZoneFile(zoneId: String, bindFileText: String) {
        requireBindFileWithinLimit(bindFileText)
        val api = api()
        api.await(api.importZonefile(zoneId, DnsZonefile(bindFileText)).action)
    }

    // ---- Primary nameservers (secondary zones) --------------------------

    suspend fun setPrimaryServers(zoneId: String, servers: List<DnsPrimaryServer>) {
        val api = api()
        api.await(api.changePrimaryNameservers(zoneId, DnsPrimaryServersRequest(servers)).action)
    }
}
