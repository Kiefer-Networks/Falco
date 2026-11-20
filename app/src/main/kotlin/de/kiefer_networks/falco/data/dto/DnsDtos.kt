// SPDX-License-Identifier: GPL-3.0-or-later
@file:Suppress("PropertyName")
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// Hetzner Cloud DNS API (https://api.hetzner.cloud/v1/zones).

@Serializable data class DnsZoneList(val zones: List<DnsZone>, val meta: Meta? = null)
@Serializable data class DnsZone(
    val id: Long,
    val name: String,
    /** "primary" or "secondary". */
    val mode: String? = null,
    val ttl: Int? = null,
    val registrar: String? = null,
    val status: String? = null,
    @SerialName("record_count") val recordsCount: Int? = null,
    val created: String? = null,
    val labels: Map<String, String>? = null,
    @SerialName("primary_nameservers") val primaryNameservers: List<DnsPrimaryServer>? = null,
)
@Serializable data class DnsZoneEnvelope(val zone: DnsZone)
@Serializable data class DnsZoneCreateResponse(val zone: DnsZone, val action: ActionEnvelope? = null)

@Serializable data class CreateDnsZoneRequest(
    val name: String,
    @EncodeDefault val mode: String = "primary",
    val ttl: Int? = null,
)
@Serializable data class DnsTtlRequest(val ttl: Int)

@Serializable data class DnsRRSetList(val rrsets: List<DnsRRSet>, val meta: Meta? = null)
@Serializable data class DnsRRSet(
    val id: String? = null,
    val name: String,
    val type: String,
    val ttl: Int? = null,
    val records: List<DnsRRValue> = emptyList(),
)
@Serializable data class DnsRRValue(val value: String, val comment: String? = null)
@Serializable data class DnsRecordsRequest(val records: List<DnsRRValue>)
@Serializable data class DnsAddRecordsRequest(val records: List<DnsRRValue>, val ttl: Int? = null)

@Serializable data class DnsZonefile(val zonefile: String)

/** Primary nameserver of a secondary zone. Edited as a whole list. */
@Serializable data class DnsPrimaryServer(
    val address: String,
    @EncodeDefault val port: Int = 53,
    @SerialName("tsig_key") val tsigKey: String? = null,
    @SerialName("tsig_algorithm") val tsigAlgorithm: String? = null,
) {
    /** Stable key for UI lists; not serialized (no backing field). */
    val id: String get() = "$address:$port"
}
@Serializable data class DnsPrimaryServersRequest(
    @SerialName("primary_nameservers") val primaryNameservers: List<DnsPrimaryServer>,
)

/**
 * UI model: one value of an RRSet, flattened so the record list can keep its
 * one row per record layout. [id] is synthetic: name/type/value.
 */
data class DnsRecord(
    val id: String? = null,
    val zoneId: String,
    val name: String,
    val type: String,
    val value: String,
    val ttl: Int? = null,
)

data class CreateDnsRecord(
    val zoneId: String,
    val name: String,
    val type: String,
    val value: String,
    val ttl: Int? = null,
)

fun DnsRRSet.toRecords(zoneId: String): List<DnsRecord> = records.map {
    DnsRecord(id = "$name/$type/${it.value}", zoneId = zoneId, name = name, type = type, value = it.value, ttl = ttl)
}
