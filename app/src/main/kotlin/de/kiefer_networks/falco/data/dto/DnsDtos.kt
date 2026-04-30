// SPDX-License-Identifier: GPL-3.0-or-later
@file:Suppress("PropertyName")
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable data class DnsZoneList(val zones: List<DnsZone>)
@Serializable data class DnsZone(
    val id: String,
    val name: String,
    val ttl: Int? = null,
    @SerialName("registrar") val registrar: String? = null,
    val status: String? = null,
    @SerialName("records_count") val recordsCount: Int? = null,
    val verified: String? = null,
    val created: String? = null,
    val modified: String? = null,
)

@Serializable data class DnsRecordList(val records: List<DnsRecord>)
@Serializable data class DnsRecord(
    val id: String? = null,
    @SerialName("zone_id") val zoneId: String,
    val name: String,
    val type: String,
    val value: String,
    val ttl: Int? = null,
    val created: String? = null,
    val modified: String? = null,
)

@Serializable data class CreateDnsRecord(
    @SerialName("zone_id") val zoneId: String,
    val name: String,
    val type: String,
    val value: String,
    val ttl: Int? = null,
)

@Serializable data class DnsZoneEnvelope(val zone: DnsZone)
@Serializable data class DnsRecordEnvelope(val record: DnsRecord)

@Serializable data class CreateDnsZoneRequest(
    val name: String,
    val ttl: Int? = null,
)

@Serializable data class BulkRecordsRequest(val records: List<CreateDnsRecord>)
@Serializable data class BulkUpdateRecordsRequest(val records: List<DnsRecord>)

@Serializable data class BulkCreateRecordsResponse(
    val records: List<DnsRecord> = emptyList(),
    @SerialName("invalid_records") val invalidRecords: List<DnsRecord> = emptyList(),
)

@Serializable data class BulkUpdateRecordsResponse(
    val records: List<DnsRecord> = emptyList(),
    @SerialName("failed_records") val failedRecords: List<DnsRecord> = emptyList(),
)

@Serializable data class DnsValidateResponse(
    @SerialName("parsed_records") val parsedRecords: Int = 0,
    @SerialName("valid_records") val validRecords: List<DnsRecord> = emptyList(),
    @SerialName("invalid_records") val invalidRecords: List<DnsRecord> = emptyList(),
)

@Serializable data class DnsPrimaryServerList(
    @SerialName("primary_servers") val primaryServers: List<DnsPrimaryServer>,
)

@Serializable data class DnsPrimaryServerEnvelope(
    @SerialName("primary_server") val primaryServer: DnsPrimaryServer,
)

@Serializable data class DnsPrimaryServer(
    val id: String,
    val address: String,
    val port: Int,
    @SerialName("zone_id") val zoneId: String,
    val created: String? = null,
    val modified: String? = null,
)

@Serializable data class CreateDnsPrimaryServerRequest(
    val address: String,
    val port: Int,
    @SerialName("zone_id") val zoneId: String,
)
