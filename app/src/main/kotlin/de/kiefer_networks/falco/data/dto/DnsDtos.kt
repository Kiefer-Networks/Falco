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
