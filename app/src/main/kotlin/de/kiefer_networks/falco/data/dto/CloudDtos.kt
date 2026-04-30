// SPDX-License-Identifier: GPL-3.0-or-later
@file:Suppress("PropertyName")
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

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
    @SerialName("backup_window") val backupWindow: String? = null,
    @SerialName("rescue_enabled") val rescueEnabled: Boolean = false,
    val iso: CloudIso? = null,
    val protection: CloudServerProtection? = null,
    @SerialName("included_traffic") val includedTraffic: Long? = null,
    @SerialName("outgoing_traffic") val outgoingTraffic: Long? = null,
    @SerialName("ingoing_traffic") val ingoingTraffic: Long? = null,
    @SerialName("primary_disk_size") val primaryDiskSize: Int? = null,
    val volumes: List<Long> = emptyList(),
    val firewalls: List<CloudServerFirewall> = emptyList(),
    @SerialName("load_balancers") val loadBalancers: List<Long> = emptyList(),
)

@Serializable data class CloudServerFirewall(
    val firewall: ResourceRef,
    val status: String? = null,
)

@Serializable data class CloudServerProtection(val delete: Boolean = false, val rebuild: Boolean = false)

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
    val protection: CloudServerProtection? = null,
    @SerialName("linux_device") val linuxDevice: String? = null,
    val created: String? = null,
)
@Serializable data class CloudVolumeEnvelope(val volume: CloudVolume)

@Serializable data class CreateVolumeRequest(
    val name: String,
    val size: Int,
    val location: String? = null,
    val server: Long? = null,
    val format: String? = null,
    val automount: Boolean? = null,
)
@Serializable data class CreateVolumeResponse(
    val volume: CloudVolume,
    val action: ActionEnvelope? = null,
)
@Serializable data class UpdateVolumeRequest(val name: String)
@Serializable data class AttachVolumeRequest(val server: Long, val automount: Boolean? = null)
@Serializable data class ResizeVolumeRequest(val size: Int)

@Serializable data class CloudFirewallList(val firewalls: List<CloudFirewall>)
@Serializable data class CloudFirewall(
    val id: Long,
    val name: String,
    val rules: List<FirewallRule> = emptyList(),
    @SerialName("applied_to") val appliedTo: List<FirewallApplication> = emptyList(),
    val labels: Map<String, String> = emptyMap(),
    val created: String? = null,
)
@Serializable data class FirewallRule(
    val direction: String,
    val protocol: String,
    val port: String? = null,
    @SerialName("source_ips") val sourceIps: List<String> = emptyList(),
    @SerialName("destination_ips") val destinationIps: List<String> = emptyList(),
    val description: String? = null,
)
@Serializable data class FirewallApplication(val type: String, val server: ResourceRef? = null)
@Serializable data class ResourceRef(val id: Long)

@Serializable data class CloudFirewallEnvelope(val firewall: CloudFirewall)
@Serializable data class CloudFirewallActionsResponse(val actions: List<ActionEnvelope> = emptyList())
@Serializable data class SetFirewallRulesRequest(val rules: List<FirewallRule>)
@Serializable data class FirewallApplyTarget(val type: String, val server: ResourceRef? = null)
@Serializable data class ApplyFirewallRequest(@SerialName("apply_to") val applyTo: List<FirewallApplyTarget>)
@Serializable data class RemoveFirewallRequest(@SerialName("remove_from") val removeFrom: List<FirewallApplyTarget>)
@Serializable data class UpdateFirewallRequest(val name: String? = null, val labels: Map<String, String>? = null)

@Serializable data class ChangeDnsPtrRequest(
    val ip: String,
    @SerialName("dns_ptr") val dnsPtr: String? = null,
)
@Serializable data class RequestConsoleResponse(
    val action: ActionEnvelope,
    @SerialName("wss_url") val wssUrl: String,
    val password: String,
)
@Serializable data class CreateFirewallRequest(
    val name: String,
    val rules: List<FirewallRule> = emptyList(),
    val labels: Map<String, String> = emptyMap(),
)
@Serializable data class CreateFirewallResponse(val firewall: CloudFirewall)

@Serializable data class CloudFloatingIpList(@SerialName("floating_ips") val floatingIps: List<CloudFloatingIp>)
@Serializable data class CloudFloatingIp(
    val id: Long,
    val name: String? = null,
    val description: String? = null,
    val ip: String,
    val type: String,
    val server: Long? = null,
    @SerialName("home_location") val homeLocation: Location? = null,
    val protection: CloudServerProtection? = null,
    @SerialName("dns_ptr") val dnsPtr: List<FloatingIpDnsPtr> = emptyList(),
    val created: String? = null,
)
@Serializable data class FloatingIpDnsPtr(val ip: String, @SerialName("dns_ptr") val dnsPtr: String)
@Serializable data class CloudFloatingIpEnvelope(@SerialName("floating_ip") val floatingIp: CloudFloatingIp)
@Serializable data class CreateFloatingIpRequest(
    val type: String,
    val name: String? = null,
    val description: String? = null,
    @SerialName("home_location") val homeLocation: String? = null,
    val server: Long? = null,
    val labels: Map<String, String> = emptyMap(),
)
@Serializable data class CreateFloatingIpResponse(
    @SerialName("floating_ip") val floatingIp: CloudFloatingIp,
    val action: ActionEnvelope? = null,
)
@Serializable data class UpdateFloatingIpRequest(
    val name: String? = null,
    val description: String? = null,
    val labels: Map<String, String>? = null,
)
@Serializable data class AssignFloatingIpRequest(val server: Long)

@Serializable data class CloudNetworkList(val networks: List<CloudNetwork>)
@Serializable data class CloudNetwork(
    val id: Long,
    val name: String,
    @SerialName("ip_range") val ipRange: String,
    val subnets: List<NetworkSubnet> = emptyList(),
    val routes: List<NetworkRoute> = emptyList(),
    val servers: List<Long> = emptyList(),
    val protection: CloudServerProtection? = null,
    val labels: Map<String, String> = emptyMap(),
    val created: String? = null,
)
@Serializable data class NetworkSubnet(
    val type: String,
    @SerialName("ip_range") val ipRange: String,
    @SerialName("network_zone") val networkZone: String,
    val gateway: String? = null,
    @SerialName("vswitch_id") val vswitchId: Long? = null,
)
@Serializable data class NetworkRoute(val destination: String, val gateway: String)
@Serializable data class CloudNetworkEnvelope(val network: CloudNetwork)
@Serializable data class CreateNetworkRequest(
    val name: String,
    @SerialName("ip_range") val ipRange: String,
    val subnets: List<NetworkSubnet> = emptyList(),
    val routes: List<NetworkRoute> = emptyList(),
    val labels: Map<String, String> = emptyMap(),
)
@Serializable data class UpdateNetworkRequest(
    val name: String? = null,
    val labels: Map<String, String>? = null,
)
@Serializable data class AddSubnetRequest(
    val type: String,
    @SerialName("network_zone") val networkZone: String,
    @SerialName("ip_range") val ipRange: String? = null,
    @SerialName("vswitch_id") val vswitchId: Long? = null,
)
@Serializable data class DeleteSubnetRequest(@SerialName("ip_range") val ipRange: String)

// ---- SSH Keys -----------------------------------------------------------

@Serializable data class CloudSshKeyList(@SerialName("ssh_keys") val sshKeys: List<CloudSshKey>)
@Serializable data class CloudSshKey(
    val id: Long,
    val name: String,
    val fingerprint: String,
    @SerialName("public_key") val publicKey: String,
    val labels: Map<String, String> = emptyMap(),
    val created: String? = null,
)
@Serializable data class CloudSshKeyEnvelope(@SerialName("ssh_key") val sshKey: CloudSshKey)
@Serializable data class CreateSshKeyRequest(
    val name: String,
    @SerialName("public_key") val publicKey: String,
    val labels: Map<String, String> = emptyMap(),
)
@Serializable data class UpdateSshKeyRequest(
    val name: String? = null,
    val labels: Map<String, String>? = null,
)

// ---- Primary IPs --------------------------------------------------------

@Serializable data class CloudPrimaryIpList(@SerialName("primary_ips") val primaryIps: List<CloudPrimaryIp>)
@Serializable data class CloudPrimaryIp(
    val id: Long,
    val name: String,
    val ip: String,
    val type: String,
    @SerialName("assignee_id") val assigneeId: Long? = null,
    @SerialName("assignee_type") val assigneeType: String? = null,
    @SerialName("auto_delete") val autoDelete: Boolean = false,
    val datacenter: Datacenter? = null,
    val protection: CloudServerProtection? = null,
    @SerialName("dns_ptr") val dnsPtr: List<FloatingIpDnsPtr> = emptyList(),
    val created: String? = null,
)
@Serializable data class CloudPrimaryIpEnvelope(@SerialName("primary_ip") val primaryIp: CloudPrimaryIp)
@Serializable data class CreatePrimaryIpRequest(
    val name: String,
    val type: String,
    @SerialName("assignee_type") val assigneeType: String,
    @SerialName("assignee_id") val assigneeId: Long? = null,
    val datacenter: String? = null,
    @SerialName("auto_delete") val autoDelete: Boolean = false,
    val labels: Map<String, String> = emptyMap(),
)
@Serializable data class AssignPrimaryIpRequest(
    @SerialName("assignee_id") val assigneeId: Long,
    @SerialName("assignee_type") val assigneeType: String = "server",
)

// ---- Locations / Datacenters / Action read ----------------------------

@Serializable data class CloudLocationList(val locations: List<Location> = emptyList())
@Serializable data class CloudDatacenterList(val datacenters: List<Datacenter> = emptyList())
@Serializable data class ActionResponse(val action: ActionEnvelope)

// Cloud Server detail / action support (v0.5)
@Serializable data class CloudServerEnvelope(val server: CloudServer)
@Serializable data class CloudServerActionResponse(
    val action: ActionEnvelope,
    @SerialName("root_password") val rootPassword: String? = null,
)

@Serializable data class CreateServerRequest(
    val name: String,
    @SerialName("server_type") val serverType: String,
    val image: String,
    val location: String? = null,
    val datacenter: String? = null,
    @SerialName("ssh_keys") val sshKeys: List<Long>? = null,
    @SerialName("user_data") val userData: String? = null,
    val firewalls: List<CreateServerFirewallRef>? = null,
    val networks: List<Long>? = null,
    val volumes: List<Long>? = null,
    val automount: Boolean? = null,
    @SerialName("start_after_create") val startAfterCreate: Boolean = true,
    val labels: Map<String, String>? = null,
    @SerialName("public_net") val publicNet: CreateServerPublicNet? = null,
)
@Serializable data class CreateServerFirewallRef(val firewall: Long)
@Serializable data class CreateServerPublicNet(
    @SerialName("enable_ipv4") val enableIpv4: Boolean = true,
    @SerialName("enable_ipv6") val enableIpv6: Boolean = true,
)
@Serializable data class CreateServerResponse(
    val server: CloudServer,
    val action: ActionEnvelope? = null,
    @SerialName("next_actions") val nextActions: List<ActionEnvelope> = emptyList(),
    @SerialName("root_password") val rootPassword: String? = null,
)

@Serializable data class CloudImageList(val images: List<CloudImage>, val meta: Meta? = null)
@Serializable data class CloudImage(
    val id: Long,
    val type: String,
    val status: String,
    val name: String? = null,
    val description: String? = null,
    @SerialName("os_flavor")  val osFlavor: String? = null,
    @SerialName("os_version") val osVersion: String? = null,
    val architecture: String? = null,
    @SerialName("image_size") val imageSize: Double? = null,
    @SerialName("disk_size")  val diskSize: Double? = null,
    @SerialName("created_from") val createdFrom: ResourceRef? = null,
    val deprecated: String? = null,
    val labels: Map<String, String> = emptyMap(),
)

@Serializable data class CloudServerTypeList(@SerialName("server_types") val serverTypes: List<CloudServerType>)
@Serializable data class CloudServerType(
    val id: Long,
    val name: String,
    val description: String,
    val cores: Int,
    val memory: Double,
    val disk: Int,
    @SerialName("cpu_type") val cpuType: String? = null,
    val architecture: String? = null,
    val deprecated: Boolean = false,
)

@Serializable data class CloudIsoList(val isos: List<CloudIso>, val meta: Meta? = null)
@Serializable data class CloudIso(
    val id: Long,
    val name: String,
    val description: String? = null,
    val type: String? = null,
    val deprecated: String? = null,
)

@Serializable data class CloudMetricsResponse(val metrics: CloudMetrics)
@Serializable data class CloudMetrics(
    val start: String,
    val end: String,
    val step: Float,
    @SerialName("time_series") val timeSeries: Map<String, CloudTimeSeries> = emptyMap(),
)
@Serializable data class CloudTimeSeries(val values: List<List<JsonElement>> = emptyList())

@Serializable data class RebuildServerRequest(val image: String)
@Serializable data class EnableRescueRequest(
    val type: String = "linux64",
    @SerialName("ssh_keys") val sshKeys: List<Long>? = null,
)
@Serializable data class AttachIsoRequest(val iso: String)
@Serializable data class ChangeServerTypeRequest(
    @SerialName("server_type") val serverType: String,
    @SerialName("upgrade_disk") val upgradeDisk: Boolean = false,
)
@Serializable data class ChangeProtectionRequest(val delete: Boolean? = null, val rebuild: Boolean? = null)
@Serializable data class UpdateServerRequest(val name: String? = null, val labels: Map<String, String>? = null)

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
    @SerialName("access_settings") val accessSettings: CloudStorageBoxAccessSettings? = null,
    val stats: CloudStorageBoxStats? = null,
    val server: String? = null,
    val system: String? = null,
)

/**
 * Box-level access toggles. Hetzner enforces these as a master gate — a
 * subaccount may only use protocols enabled here. The subaccount-level
 * `access_settings` further restricts a single subaccount within that gate.
 */
@Serializable data class CloudStorageBoxAccessSettings(
    @SerialName("samba_enabled") val sambaEnabled: Boolean = false,
    @SerialName("ssh_enabled") val sshEnabled: Boolean = true,
    @SerialName("webdav_enabled") val webdavEnabled: Boolean = false,
    @SerialName("zfs_enabled") val zfsEnabled: Boolean = false,
    @SerialName("reachable_externally") val reachableExternally: Boolean = false,
)

@Serializable data class CloudStorageBoxStats(
    val size: Long? = null,
    @SerialName("size_data") val sizeData: Long? = null,
    @SerialName("size_snapshots") val sizeSnapshots: Long? = null,
)

@Serializable data class UpdateStorageBoxAccessSettings(
    @SerialName("samba_enabled") val sambaEnabled: Boolean? = null,
    @SerialName("ssh_enabled") val sshEnabled: Boolean? = null,
    @SerialName("webdav_enabled") val webdavEnabled: Boolean? = null,
    @SerialName("zfs_enabled") val zfsEnabled: Boolean? = null,
    @SerialName("reachable_externally") val reachableExternally: Boolean? = null,
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

@Serializable data class CloudStorageBoxTypeList(
    @SerialName("storage_box_types") val storageBoxTypes: List<CloudStorageBoxType> = emptyList(),
)

@Serializable data class CreateStorageBoxRequest(
    val name: String,
    @SerialName("storage_box_type") val storageBoxType: String,
    val location: String,
    val password: String? = null,
    @SerialName("ssh_keys") val sshKeys: List<String>? = null,
    @SerialName("access_settings") val accessSettings: UpdateStorageBoxAccessSettings? = null,
    val labels: Map<String, String>? = null,
)
@Serializable data class CreateStorageBoxResponse(
    @SerialName("storage_box") val storageBox: CloudStorageBox,
    val action: ActionEnvelope? = null,
)

@Serializable data class CloudLinkedResource(
    val type: String,
    val id: Long? = null,
)

// Single-entity envelopes returned by the Hetzner Storage Box API.
@Serializable data class CloudStorageBoxEnvelope(@SerialName("storage_box") val storageBox: CloudStorageBox)
@Serializable data class CloudStorageBoxActionResponse(val action: ActionEnvelope)

@Serializable data class CloudStorageBoxSnapshotList(val snapshots: List<CloudStorageBoxSnapshot>, val meta: Meta? = null)
@Serializable data class CloudStorageBoxSnapshotEnvelope(val snapshot: CloudStorageBoxSnapshot)
@Serializable data class CloudStorageBoxSnapshot(
    val id: Long,
    val name: String? = null,
    val description: String? = null,
    val stats: CloudStorageBoxSnapshotStats? = null,
    val created: String? = null,
    @SerialName("is_automatic") val isAutomatic: Boolean = false,
    val labels: Map<String, String> = emptyMap(),
    @SerialName("storage_box") val storageBox: Long? = null,
)
@Serializable data class CloudStorageBoxSnapshotStats(
    val size: Long? = null,
    @SerialName("size_filesystem") val sizeFilesystem: Long? = null,
)
@Serializable data class CreateStorageBoxSnapshot(val description: String? = null)

@Serializable data class CloudStorageBoxSubaccountList(val subaccounts: List<CloudStorageBoxSubaccount>, val meta: Meta? = null)
@Serializable data class CloudStorageBoxSubaccountEnvelope(val subaccount: CloudStorageBoxSubaccount)
@Serializable data class CloudStorageBoxSubaccount(
    val id: Long,
    val username: String,
    val server: String? = null,
    @SerialName("home_directory") val homeDirectory: String? = null,
    @SerialName("access_settings") val accessSettings: CloudSubaccountAccessSettings? = null,
    val description: String? = null,
    val created: String? = null,
    val labels: Map<String, String> = emptyMap(),
    @SerialName("storage_box") val storageBox: Long? = null,
)
@Serializable data class CloudSubaccountAccessSettings(
    @SerialName("samba_enabled") val sambaEnabled: Boolean = false,
    @SerialName("ssh_enabled") val sshEnabled: Boolean = true,
    @SerialName("webdav_enabled") val webdavEnabled: Boolean = false,
    @SerialName("readonly") val readonly: Boolean = false,
    @SerialName("reachable_externally") val reachableExternally: Boolean = false,
)
@Serializable data class CreateStorageBoxSubaccount(
    val password: String,
    @SerialName("home_directory") val homeDirectory: String,
    @SerialName("access_settings") val accessSettings: CloudSubaccountAccessSettings = CloudSubaccountAccessSettings(),
    val description: String? = null,
    val labels: Map<String, String> = emptyMap(),
)
@Serializable data class UpdateStorageBoxSubaccount(
    val description: String? = null,
    val labels: Map<String, String>? = null,
)
@Serializable data class ResetSubaccountPasswordRequest(val password: String)
@Serializable data class ResetStorageBoxPasswordRequest(val password: String)

// ---- Server / Network actions ------------------------------------------

@Serializable data class AttachToNetworkRequest(
    val network: Long,
    val ip: String? = null,
    @SerialName("alias_ips") val aliasIps: List<String>? = null,
)

@Serializable data class DetachFromNetworkRequest(val network: Long)

@Serializable data class ChangeAliasIpsRequest(
    val network: Long,
    @SerialName("alias_ips") val aliasIps: List<String>,
)

@Serializable data class AddToPlacementGroupRequest(
    @SerialName("placement_group") val placementGroup: Long,
)

@Serializable data class NetworkRouteRequest(
    val destination: String,
    val gateway: String,
)

@Serializable data class ChangeIpRangeRequest(
    @SerialName("ip_range") val ipRange: String,
)

@Serializable data class ExposeRoutesRequest(
    @SerialName("vswitch_id") val vswitchId: Long,
    val expose: Boolean = true,
)

@Serializable data class ActionListResponse(
    val actions: List<ActionEnvelope> = emptyList(),
    val meta: Meta? = null,
)

// ---- Load Balancers ----------------------------------------------------

@Serializable data class CloudLoadBalancerList(
    @SerialName("load_balancers") val loadBalancers: List<CloudLoadBalancer>,
    val meta: Meta? = null,
)

@Serializable data class CloudLoadBalancerEnvelope(
    @SerialName("load_balancer") val loadBalancer: CloudLoadBalancer,
)

@Serializable data class CloudLoadBalancer(
    val id: Long,
    val name: String,
    @SerialName("public_net") val publicNet: LoadBalancerPublicNet? = null,
    @SerialName("private_net") val privateNet: List<LoadBalancerPrivateNet> = emptyList(),
    val location: Location? = null,
    @SerialName("load_balancer_type") val type: CloudLoadBalancerType? = null,
    val protection: CloudServerProtection = CloudServerProtection(),
    val labels: Map<String, String> = emptyMap(),
    val created: String? = null,
    val services: List<LoadBalancerService> = emptyList(),
    val targets: List<LoadBalancerTarget> = emptyList(),
    val algorithm: LoadBalancerAlgorithm = LoadBalancerAlgorithm("round_robin"),
    @SerialName("outgoing_traffic") val outgoingTraffic: Long? = null,
    @SerialName("ingoing_traffic") val ingoingTraffic: Long? = null,
    @SerialName("included_traffic") val includedTraffic: Long? = null,
)

@Serializable data class LoadBalancerPublicNet(
    val enabled: Boolean = true,
    val ipv4: Ipv4? = null,
    val ipv6: Ipv6? = null,
)

@Serializable data class LoadBalancerPrivateNet(
    val network: Long,
    val ip: String? = null,
)

@Serializable data class LoadBalancerAlgorithm(val type: String)

@Serializable data class LoadBalancerService(
    val protocol: String,
    @SerialName("listen_port") val listenPort: Int,
    @SerialName("destination_port") val destinationPort: Int,
    val proxyprotocol: Boolean = false,
    @SerialName("health_check") val healthCheck: LoadBalancerHealthCheck? = null,
    val http: LoadBalancerHttp? = null,
)

@Serializable data class LoadBalancerHealthCheck(
    val protocol: String,
    val port: Int,
    val interval: Int = 15,
    val timeout: Int = 10,
    val retries: Int = 3,
    val http: LoadBalancerHealthCheckHttp? = null,
)

@Serializable data class LoadBalancerHealthCheckHttp(
    val domain: String? = null,
    val path: String = "/",
    val response: String? = null,
    @SerialName("status_codes") val statusCodes: List<String> = emptyList(),
    val tls: Boolean = false,
)

@Serializable data class LoadBalancerHttp(
    @SerialName("cookie_name") val cookieName: String? = null,
    @SerialName("cookie_lifetime") val cookieLifetime: Int? = null,
    val certificates: List<Long> = emptyList(),
    @SerialName("redirect_http") val redirectHttp: Boolean = false,
    @SerialName("sticky_sessions") val stickySessions: Boolean = false,
)

@Serializable data class LoadBalancerTarget(
    val type: String,
    val server: LoadBalancerTargetServer? = null,
    @SerialName("label_selector") val labelSelector: LoadBalancerTargetLabelSelector? = null,
    val ip: LoadBalancerTargetIp? = null,
    @SerialName("use_private_ip") val usePrivateIp: Boolean? = null,
)

@Serializable data class LoadBalancerTargetServer(val id: Long)
@Serializable data class LoadBalancerTargetLabelSelector(val selector: String)
@Serializable data class LoadBalancerTargetIp(val ip: String)

@Serializable data class CloudLoadBalancerTypeList(
    @SerialName("load_balancer_types") val loadBalancerTypes: List<CloudLoadBalancerType>,
    val meta: Meta? = null,
)

@Serializable data class CloudLoadBalancerType(
    val id: Long,
    val name: String,
    val description: String? = null,
    @SerialName("max_connections") val maxConnections: Int = 0,
    @SerialName("max_services") val maxServices: Int = 0,
    @SerialName("max_targets") val maxTargets: Int = 0,
    @SerialName("max_assigned_certificates") val maxAssignedCertificates: Int = 0,
)

@Serializable data class CreateLoadBalancerRequest(
    val name: String,
    @SerialName("load_balancer_type") val loadBalancerType: String,
    val location: String? = null,
    @SerialName("network_zone") val networkZone: String? = null,
    val algorithm: LoadBalancerAlgorithm? = null,
    val services: List<LoadBalancerService> = emptyList(),
    val targets: List<LoadBalancerTarget> = emptyList(),
    @SerialName("public_interface") val publicInterface: Boolean = true,
    val labels: Map<String, String> = emptyMap(),
)

@Serializable data class UpdateLoadBalancerRequest(
    val name: String? = null,
    val labels: Map<String, String>? = null,
)

@Serializable data class UpdateLoadBalancerServiceRequest(
    @SerialName("listen_port") val listenPort: Int,
    val protocol: String? = null,
    @SerialName("destination_port") val destinationPort: Int? = null,
    val proxyprotocol: Boolean? = null,
    @SerialName("health_check") val healthCheck: LoadBalancerHealthCheck? = null,
    val http: LoadBalancerHttp? = null,
)

@Serializable data class DeleteLoadBalancerServiceRequest(
    @SerialName("listen_port") val listenPort: Int,
)

@Serializable data class ChangeLbAlgorithmRequest(val algorithm: LoadBalancerAlgorithm)
@Serializable data class ChangeLbTypeRequest(
    @SerialName("load_balancer_type") val loadBalancerType: String,
)

// ---- Certificates ------------------------------------------------------

@Serializable data class CloudCertificateList(
    val certificates: List<CloudCertificate>,
    val meta: Meta? = null,
)

@Serializable data class CloudCertificateEnvelope(val certificate: CloudCertificate)

@Serializable data class CloudCertificate(
    val id: Long,
    val name: String,
    val type: String = "uploaded",
    val certificate: String? = null,
    val created: String? = null,
    @SerialName("not_valid_before") val notValidBefore: String? = null,
    @SerialName("not_valid_after") val notValidAfter: String? = null,
    @SerialName("domain_names") val domainNames: List<String> = emptyList(),
    val fingerprint: String? = null,
    val labels: Map<String, String> = emptyMap(),
    @SerialName("used_by") val usedBy: List<CertificateUsage> = emptyList(),
    val status: CertificateStatus? = null,
)

@Serializable data class CertificateUsage(val id: Long, val type: String)

@Serializable data class CertificateStatus(
    val issuance: String? = null,
    val renewal: String? = null,
    val error: CertificateError? = null,
)

@Serializable data class CertificateError(val code: String? = null, val message: String? = null)

@Serializable data class CreateCertificateRequest(
    val name: String,
    val type: String = "uploaded",
    val certificate: String? = null,
    @SerialName("private_key") val privateKey: String? = null,
    @SerialName("domain_names") val domainNames: List<String>? = null,
    val labels: Map<String, String> = emptyMap(),
)

@Serializable data class UpdateCertificateRequest(
    val name: String? = null,
    val labels: Map<String, String>? = null,
)

// ---- Placement Groups --------------------------------------------------

@Serializable data class CloudPlacementGroupList(
    @SerialName("placement_groups") val placementGroups: List<CloudPlacementGroup>,
    val meta: Meta? = null,
)

@Serializable data class CloudPlacementGroupEnvelope(
    @SerialName("placement_group") val placementGroup: CloudPlacementGroup,
)

@Serializable data class CloudPlacementGroup(
    val id: Long,
    val name: String,
    val type: String = "spread",
    val servers: List<Long> = emptyList(),
    val labels: Map<String, String> = emptyMap(),
    val created: String? = null,
)

@Serializable data class CreatePlacementGroupRequest(
    val name: String,
    val type: String = "spread",
    val labels: Map<String, String> = emptyMap(),
)

@Serializable data class UpdatePlacementGroupRequest(
    val name: String? = null,
    val labels: Map<String, String>? = null,
)

// ---- ISO single envelope -----------------------------------------------

@Serializable data class CloudIsoEnvelope(val iso: CloudIso)

// ---- Pricing -----------------------------------------------------------

@Serializable data class CloudPricingResponse(val pricing: CloudPricing)

@Serializable data class CloudPricing(
    val currency: String = "EUR",
    @SerialName("vat_rate") val vatRate: String = "0",
    val volume: VolumePricing? = null,
    @SerialName("floating_ips") val floatingIps: List<FloatingIpPricing> = emptyList(),
    @SerialName("primary_ips") val primaryIps: List<PrimaryIpPricing> = emptyList(),
)

@Serializable data class VolumePricing(
    @SerialName("price_per_gb_month") val pricePerGbMonth: PriceTier,
)

@Serializable data class FloatingIpPricing(
    val type: String,
    val prices: List<PriceLocation> = emptyList(),
)

@Serializable data class PrimaryIpPricing(
    val type: String,
    val prices: List<PrimaryIpPriceLocation> = emptyList(),
)

@Serializable data class PriceTier(
    val net: String,
    val gross: String,
)

@Serializable data class PriceLocation(
    val location: String,
    @SerialName("price_monthly") val priceMonthly: PriceTier? = null,
    @SerialName("price_hourly") val priceHourly: PriceTier? = null,
)

@Serializable data class PrimaryIpPriceLocation(
    val location: String,
    @SerialName("price_monthly") val priceMonthly: PriceTier? = null,
    @SerialName("price_hourly") val priceHourly: PriceTier? = null,
)
