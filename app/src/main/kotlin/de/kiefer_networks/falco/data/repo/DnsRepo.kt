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

@Singleton
class DnsRepo @Inject constructor(private val accounts: AccountManager) {

    private suspend fun api(): DnsApi {
        val token = requireNotNull(accounts.activeSecrets()?.dnsToken) { "DNS token missing" }
        return HttpClientFactory.dnsRetrofit(token).create(DnsApi::class.java)
    }

    suspend fun listZones(): List<DnsZone> = api().listZones().zones
    suspend fun listRecords(zoneId: String): List<DnsRecord> = api().listRecords(zoneId).records
    suspend fun createRecord(record: CreateDnsRecord): DnsRecord = api().createRecord(record)
    suspend fun deleteRecord(id: String) = api().deleteRecord(id)
}
