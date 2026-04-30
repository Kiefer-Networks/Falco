// SPDX-License-Identifier: GPL-3.0-or-later
@file:Suppress("PropertyName")
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// Hetzner Robot wraps each entity in a single-key envelope, e.g.
// `[{"server": {...}}, {"server": {...}}]`. We model the envelope explicitly.

@Serializable data class RobotServerEnvelope(val server: RobotServer)
@Serializable data class RobotServer(
    @SerialName("server_ip") val serverIp: String? = null,
    @SerialName("server_ipv6_net") val serverIpv6Net: String? = null,
    @SerialName("server_number") val serverNumber: Long,
    @SerialName("server_name") val serverName: String? = null,
    val product: String? = null,
    val dc: String? = null,
    val traffic: String? = null,
    val status: String? = null,
    val cancelled: Boolean = false,
    @SerialName("paid_until") val paidUntil: String? = null,
)

@Serializable data class RobotStorageBoxEnvelope(@SerialName("storagebox") val storageBox: RobotStorageBox)
@Serializable data class RobotStorageBox(
    val id: Long,
    val login: String,
    val name: String? = null,
    val product: String? = null,
    val cancelled: Boolean = false,
    val locked: Boolean = false,
    val location: String? = null,
    @SerialName("linked_server") val linkedServer: Long? = null,
    @SerialName("paid_until") val paidUntil: String? = null,
    @SerialName("disk_quota") val diskQuota: Long? = null,
    @SerialName("disk_usage") val diskUsage: Long? = null,
    val webdav: Boolean? = null,
    val samba: Boolean? = null,
    val ssh: Boolean? = null,
    @SerialName("external_reachability") val externalReachability: Boolean? = null,
    val zfs: Boolean? = null,
)

@Serializable data class RobotSnapshotEnvelope(val snapshot: RobotSnapshot)
@Serializable data class RobotSnapshot(
    val name: String,
    val timestamp: String,
    val size: Long? = null,
    val filesystem: String? = null,
    val automatic: Boolean = false,
)

@Serializable data class RobotSubaccountEnvelope(val subaccount: RobotSubaccount)
@Serializable data class RobotSubaccount(
    val username: String,
    @SerialName("homedirectory") val homeDirectory: String? = null,
    val samba: Boolean = false,
    val ssh: Boolean = false,
    val webdav: Boolean = false,
    val readonly: Boolean = false,
    val createtime: String? = null,
    val comment: String? = null,
)

@Serializable data class RobotResetEnvelope(val reset: RobotReset)
@Serializable data class RobotReset(
    @SerialName("server_ip") val serverIp: String? = null,
    @SerialName("server_number") val serverNumber: Long? = null,
    val type: List<String> = emptyList(),
    @SerialName("operating_status") val operatingStatus: String? = null,
)

@Serializable data class RobotFailoverEnvelope(val failover: RobotFailover)
@Serializable data class RobotFailover(
    val ip: String,
    @SerialName("server_ip") val serverIp: String,
    @SerialName("server_number") val serverNumber: Long,
    @SerialName("active_server_ip") val activeServerIp: String,
    val netmask: String? = null,
)

@Serializable data class RobotKeyEnvelope(val key: RobotSshKey)
@Serializable data class RobotSshKey(
    val name: String,
    val fingerprint: String,
    val type: String? = null,
    val size: Int? = null,
    val data: String,
    @SerialName("created_at") val createdAt: String? = null,
)

@Serializable data class RobotVSwitchEnvelope(val vswitch: RobotVSwitch)
@Serializable data class RobotVSwitch(
    val id: Long,
    val name: String,
    val vlan: Int,
    val cancelled: Boolean = false,
    val server: List<RobotVSwitchServer> = emptyList(),
)

@Serializable data class RobotVSwitchServer(
    @SerialName("server_number") val serverNumber: Long? = null,
    @SerialName("server_ip") val serverIp: String? = null,
    val status: String? = null,
)

@Serializable data class RobotRdnsEnvelope(val rdns: RobotRdns)
@Serializable data class RobotRdns(
    val ip: String,
    val ptr: String,
)

@Serializable data class RobotBootEnvelope(val boot: RobotBoot)
@Serializable data class RobotBoot(
    val rescue: RobotRescue? = null,
    val linux: kotlinx.serialization.json.JsonElement? = null,
)

@Serializable data class RobotRescueEnvelope(val rescue: RobotRescue)
@Serializable data class RobotRescue(
    @SerialName("server_ip") val serverIp: String? = null,
    @SerialName("server_number") val serverNumber: Long? = null,
    val active: Boolean = false,
    val password: String? = null,
    @SerialName("authorized_key") val authorizedKey: kotlinx.serialization.json.JsonElement? = null,
    val os: kotlinx.serialization.json.JsonElement? = null,
)

@Serializable data class RobotCancellationEnvelope(val cancellation: RobotCancellation)
@Serializable data class RobotCancellation(
    @SerialName("server_ip") val serverIp: String? = null,
    @SerialName("server_number") val serverNumber: Long? = null,
    @SerialName("server_name") val serverName: String? = null,
    val cancelled: Boolean = false,
    @SerialName("cancellation_date") val cancellationDate: String? = null,
    val reason: String? = null,
)

@Serializable data class RobotTrafficResponse(
    val traffic: kotlinx.serialization.json.JsonElement? = null,
)
