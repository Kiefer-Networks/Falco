// SPDX-License-Identifier: GPL-3.0-or-later
@file:Suppress("PropertyName")
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable data class CloudServerList(val servers: List<CloudServer>, val meta: Meta? = null)
@Serializable data class CloudServer(
    val id: Long,
    val name: String,
    val status: String,
    val created: String,
    @SerialName("public_net") val publicNet: PublicNet? = null,
    @SerialName("private_net") val privateNet: List<PrivateNet> = emptyList(),
    @SerialName("server_type") val serverType: ServerType? = null,
    val datacenter: Datacenter? = null,
    val image: Image? = null,
    val labels: Map<String, String> = emptyMap(),
    val locked: Boolean = false,
)

@Serializable data class PublicNet(val ipv4: Ipv4? = null, val ipv6: Ipv6? = null)
@Serializable data class Ipv4(val ip: String, val blocked: Boolean = false, @SerialName("dns_ptr") val dnsPtr: String? = null)
@Serializable data class Ipv6(val ip: String, val blocked: Boolean = false)
@Serializable data class PrivateNet(val network: Long, val ip: String?)
@Serializable data class ServerType(val id: Long, val name: String, val cores: Int, val memory: Double, val disk: Int)
@Serializable data class Datacenter(val id: Long, val name: String, val location: Location? = null)
@Serializable data class Location(val id: Long, val name: String, val city: String? = null, val country: String? = null)
@Serializable data class Image(val id: Long? = null, val name: String? = null, val description: String? = null)

@Serializable data class Meta(val pagination: Pagination? = null)
@Serializable data class Pagination(
    val page: Int,
    @SerialName("per_page") val perPage: Int,
    @SerialName("total_entries") val totalEntries: Int? = null,
    @SerialName("last_page") val lastPage: Int? = null,
)

@Serializable data class ServerAction(val action: ActionEnvelope)
@Serializable data class ActionEnvelope(
    val id: Long,
    val command: String,
    val status: String,
    val progress: Int = 0,
    val started: String? = null,
    val finished: String? = null,
)

@Serializable data class CloudVolumeList(val volumes: List<CloudVolume>)
@Serializable data class CloudVolume(
    val id: Long,
    val name: String,
    val size: Int,
    val status: String,
    val server: Long? = null,
    val location: Location? = null,
    val format: String? = null,
)

@Serializable data class CloudFirewallList(val firewalls: List<CloudFirewall>)
@Serializable data class CloudFirewall(
    val id: Long,
    val name: String,
    val rules: List<FirewallRule> = emptyList(),
    @SerialName("applied_to") val appliedTo: List<FirewallApplication> = emptyList(),
)
@Serializable data class FirewallRule(
    val direction: String,
    val protocol: String,
    val port: String? = null,
    @SerialName("source_ips") val sourceIps: List<String> = emptyList(),
    @SerialName("destination_ips") val destinationIps: List<String> = emptyList(),
)
@Serializable data class FirewallApplication(val type: String, val server: ResourceRef? = null)
@Serializable data class ResourceRef(val id: Long)

@Serializable data class CloudFloatingIpList(@SerialName("floating_ips") val floatingIps: List<CloudFloatingIp>)
@Serializable data class CloudFloatingIp(
    val id: Long,
    val description: String? = null,
    val ip: String,
    val type: String,
    val server: Long? = null,
    @SerialName("home_location") val homeLocation: Location? = null,
)

@Serializable data class CloudNetworkList(val networks: List<CloudNetwork>)
@Serializable data class CloudNetwork(
    val id: Long,
    val name: String,
    @SerialName("ip_range") val ipRange: String,
    val subnets: List<NetworkSubnet> = emptyList(),
    val servers: List<Long> = emptyList(),
)
@Serializable data class NetworkSubnet(val type: String, @SerialName("ip_range") val ipRange: String, @SerialName("network_zone") val networkZone: String)

@Serializable data class CloudStorageBoxList(@SerialName("storage_boxes") val storageBoxes: List<CloudStorageBox>)

@Serializable data class CloudStorageBox(
    val id: Long,
    val name: String,
    val username: String? = null,
    val status: String? = null,
    val created: String? = null,
    @SerialName("storage_box_type") val storageBoxType: CloudStorageBoxType? = null,
    val location: Location? = null,
    val accessible: Boolean = true,
    val protection: CloudStorageBoxProtection? = null,
    @SerialName("linked_resources") val linkedResources: List<CloudLinkedResource> = emptyList(),
    val labels: Map<String, String> = emptyMap(),
)

@Serializable data class CloudStorageBoxType(
    val name: String,
    val description: String? = null,
    val size: Long? = null,
    @SerialName("snapshot_limit") val snapshotLimit: Int? = null,
    @SerialName("automatic_snapshot_limit") val automaticSnapshotLimit: Int? = null,
    @SerialName("subaccounts_limit") val subaccountsLimit: Int? = null,
)

@Serializable data class CloudStorageBoxProtection(val delete: Boolean = false)

@Serializable data class CloudLinkedResource(
    val type: String,
    val id: Long? = null,
)
