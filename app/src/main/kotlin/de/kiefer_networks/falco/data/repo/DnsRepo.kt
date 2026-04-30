// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.DnsApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.dto.CreateDnsRecord
import de.kiefer_networks.falco.data.dto.DnsRecord
import de.kiefer_networks.falco.data.dto.DnsZone
import javax.inject.Inject
import javax.inject.Singleton
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody

@Singleton
class DnsRepo @Inject constructor(private val accounts: AccountManager) {

    private suspend fun api(): DnsApi {
        val token = requireNotNull(accounts.activeSecrets()?.dnsToken) { "DNS token missing" }
        return HttpClientFactory.dnsRetrofit(token).create(DnsApi::class.java)
    }

    suspend fun listZones(): List<DnsZone> = api().listZones().zones
    suspend fun listRecords(zoneId: String): List<DnsRecord> = api().listRecords(zoneId).records
    suspend fun createRecord(record: CreateDnsRecord): DnsRecord = api().createRecord(record)
    suspend fun updateRecord(id: String, record: CreateDnsRecord): DnsRecord = api().updateRecord(id, record)
    suspend fun deleteRecord(id: String) = api().deleteRecord(id)

    // ---- Zones CRUD ------------------------------------------------------

    suspend fun getZone(id: String): DnsZone = api().getZone(id).zone
    suspend fun createZone(name: String, ttl: Int? = null): DnsZone =
        api().createZone(de.kiefer_networks.falco.data.dto.CreateDnsZoneRequest(name, ttl)).zone
    suspend fun updateZone(id: String, name: String, ttl: Int? = null): DnsZone =
        api().updateZone(id, de.kiefer_networks.falco.data.dto.CreateDnsZoneRequest(name, ttl)).zone
    suspend fun deleteZone(id: String) = api().deleteZone(id)

    suspend fun getRecord(id: String): DnsRecord = api().getRecord(id).record

    // ---- Bulk records ----------------------------------------------------

    suspend fun bulkCreateRecords(records: List<CreateDnsRecord>) =
        api().bulkCreateRecords(de.kiefer_networks.falco.data.dto.BulkRecordsRequest(records))

    suspend fun bulkUpdateRecords(records: List<DnsRecord>) =
        api().bulkUpdateRecords(de.kiefer_networks.falco.data.dto.BulkUpdateRecordsRequest(records))

    // ---- BIND import / export -------------------------------------------

    suspend fun exportZone(id: String): String =
        api().exportZone(id).body()?.string() ?: ""

    suspend fun importZoneFile(zoneId: String, bindFileText: String): DnsZone {
        val body = bindFileText.toRequestBody("text/plain".toMediaType())
        return api().importZoneFile(zoneId, body).zone
    }

    suspend fun validateZone(zoneId: String, bindFileText: String) =
        api().validateZone(zoneId, bindFileText.toRequestBody("text/plain".toMediaType()))

    // ---- Primary servers ------------------------------------------------

    suspend fun listPrimaryServers(zoneId: String? = null) =
        api().listPrimaryServers(zoneId).primaryServers

    suspend fun createPrimaryServer(address: String, port: Int, zoneId: String) =
        api().createPrimaryServer(
            de.kiefer_networks.falco.data.dto.CreateDnsPrimaryServerRequest(address, port, zoneId),
        ).primaryServer

    suspend fun updatePrimaryServer(id: String, address: String, port: Int, zoneId: String) =
        api().updatePrimaryServer(
            id,
            de.kiefer_networks.falco.data.dto.CreateDnsPrimaryServerRequest(address, port, zoneId),
        ).primaryServer

    suspend fun deletePrimaryServer(id: String) = api().deletePrimaryServer(id)
}
