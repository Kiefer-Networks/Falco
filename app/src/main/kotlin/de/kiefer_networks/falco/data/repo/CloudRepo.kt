// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.CloudApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.StorageBoxApi
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.auth.SecurityPreferences
import de.kiefer_networks.falco.data.dto.ActionEnvelope
import de.kiefer_networks.falco.data.dto.AttachIsoRequest
import de.kiefer_networks.falco.data.dto.ChangeProtectionRequest
import de.kiefer_networks.falco.data.dto.ChangeServerTypeRequest
import de.kiefer_networks.falco.data.dto.ApplyFirewallRequest
import de.kiefer_networks.falco.data.dto.CloudFirewall
import de.kiefer_networks.falco.data.dto.FirewallApplyTarget
import de.kiefer_networks.falco.data.dto.FirewallRule
import de.kiefer_networks.falco.data.dto.RemoveFirewallRequest
import de.kiefer_networks.falco.data.dto.ResourceRef
import de.kiefer_networks.falco.data.dto.SetFirewallRulesRequest
import de.kiefer_networks.falco.data.dto.UpdateFirewallRequest
import de.kiefer_networks.falco.data.dto.CloudFloatingIp
import de.kiefer_networks.falco.data.dto.CloudImage
import de.kiefer_networks.falco.data.dto.CloudIso
import de.kiefer_networks.falco.data.dto.CloudNetwork
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudServerType
import de.kiefer_networks.falco.data.dto.CloudStorageBox
import de.kiefer_networks.falco.data.dto.EnableRescueRequest
import de.kiefer_networks.falco.data.dto.RebuildServerRequest
import de.kiefer_networks.falco.data.dto.UpdateServerRequest
import de.kiefer_networks.falco.data.dto.CloudStorageBoxSnapshot
import de.kiefer_networks.falco.data.dto.CloudStorageBoxSubaccount
import de.kiefer_networks.falco.data.dto.CloudSubaccountAccessSettings
import de.kiefer_networks.falco.data.dto.CloudVolume
import de.kiefer_networks.falco.data.dto.CreateStorageBoxSnapshot
import de.kiefer_networks.falco.data.dto.CreateStorageBoxSubaccount
import de.kiefer_networks.falco.data.dto.ResetStorageBoxPasswordRequest
import de.kiefer_networks.falco.data.dto.ResetSubaccountPasswordRequest
import de.kiefer_networks.falco.data.dto.UpdateStorageBoxAccessSettings
import de.kiefer_networks.falco.data.dto.UpdateStorageBoxSubaccount
import kotlinx.coroutines.flow.first
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.contentOrNull
import kotlinx.serialization.json.doubleOrNull
import javax.inject.Inject
import javax.inject.Singleton

enum class MetricType(val apiKey: String) { Cpu("cpu"), Disk("disk"), Network("network") }
enum class MetricPeriod(val secondsBack: Long, val step: Int) {
    H1(3600L, 60),
    H24(86_400L, 600),
    D7(604_800L, 3600),
    D30(2_592_000L, 21_600),
}
data class MetricSeries(val series: Map<String, List<Pair<Long, Double>>>)

@Singleton
class CloudRepo @Inject constructor(
    private val accounts: AccountManager,
    private val prefs: SecurityPreferences,
) {

    private suspend fun api(): CloudApi {
        val project = accounts.activeCloudProject.first()
            ?: error("No active Cloud project for the current account")
        return HttpClientFactory.cloudRetrofit(project.cloudToken).create(CloudApi::class.java)
    }

    private suspend fun storageBoxApi(): StorageBoxApi {
        val project = accounts.activeCloudProject.first()
            ?: error("No active Cloud project for the current account")
        return HttpClientFactory.storageBoxRetrofit(project.cloudToken).create(StorageBoxApi::class.java)
    }

    /**
     * Returns either [api] alone or a fan-out across every Cloud project of
     * the active account, depending on [SecurityPreferences.aggregateProjects].
     * Used by list endpoints so the UI can show a unified view without forcing
     * the user to switch projects.
     */
    private suspend fun apis(): List<CloudApi> {
        if (!prefs.aggregateProjectsNow()) return listOf(api())
        val accountId = accounts.activeAccountId.first() ?: return listOf(api())
        val projects = accounts.cloudProjects(accountId)
        if (projects.isEmpty()) return listOf(api())
        return projects.map {
            HttpClientFactory.cloudRetrofit(it.cloudToken).create(CloudApi::class.java)
        }
    }

    private suspend fun storageBoxApis(): List<StorageBoxApi> {
        if (!prefs.aggregateProjectsNow()) return listOf(storageBoxApi())
        val accountId = accounts.activeAccountId.first() ?: return listOf(storageBoxApi())
        val projects = accounts.cloudProjects(accountId)
        if (projects.isEmpty()) return listOf(storageBoxApi())
        return projects.map {
            HttpClientFactory.storageBoxRetrofit(it.cloudToken).create(StorageBoxApi::class.java)
        }
    }

    suspend fun listServers(): List<CloudServer> = apis().flatMap { it.listServers().servers }

    suspend fun createServer(
        name: String,
        serverType: String,
        image: String,
        location: String? = null,
        datacenter: String? = null,
        sshKeyIds: List<Long>? = null,
        userData: String? = null,
        firewallIds: List<Long>? = null,
        networkIds: List<Long>? = null,
        volumeIds: List<Long>? = null,
        automount: Boolean? = null,
        startAfterCreate: Boolean = true,
        labels: Map<String, String>? = null,
        enableIpv4: Boolean = true,
        enableIpv6: Boolean = true,
    ): de.kiefer_networks.falco.data.dto.CreateServerResponse {
        val body = de.kiefer_networks.falco.data.dto.CreateServerRequest(
            name = name,
            serverType = serverType,
            image = image,
            location = location,
            datacenter = datacenter,
            sshKeys = sshKeyIds,
            userData = userData,
            firewalls = firewallIds?.map { de.kiefer_networks.falco.data.dto.CreateServerFirewallRef(it) },
            networks = networkIds,
            volumes = volumeIds,
            automount = automount,
            startAfterCreate = startAfterCreate,
            labels = labels,
            publicNet = if (!enableIpv4 || !enableIpv6) {
                de.kiefer_networks.falco.data.dto.CreateServerPublicNet(enableIpv4, enableIpv6)
            } else null,
        )
        return api().createServer(body)
    }

    suspend fun listVolumes(): List<CloudVolume> = apis().flatMap { it.listVolumes().volumes }
    suspend fun getVolume(id: Long): CloudVolume = api().getVolume(id).volume

    suspend fun createVolume(
        name: String,
        size: Int,
        location: String? = null,
        serverId: Long? = null,
        format: String? = null,
        automount: Boolean? = null,
    ): CloudVolume = api().createVolume(
        de.kiefer_networks.falco.data.dto.CreateVolumeRequest(
            name = name, size = size, location = location, server = serverId,
            format = format, automount = automount,
        ),
    ).volume

    suspend fun renameVolume(id: Long, name: String): CloudVolume =
        api().updateVolume(id, de.kiefer_networks.falco.data.dto.UpdateVolumeRequest(name = name)).volume

    suspend fun deleteVolume(id: Long) = api().deleteVolume(id)

    suspend fun attachVolume(id: Long, serverId: Long, automount: Boolean? = null) =
        api().attachVolume(
            id,
            de.kiefer_networks.falco.data.dto.AttachVolumeRequest(server = serverId, automount = automount),
        )

    suspend fun detachVolume(id: Long) = api().detachVolume(id)

    suspend fun resizeVolume(id: Long, size: Int) =
        api().resizeVolume(id, de.kiefer_networks.falco.data.dto.ResizeVolumeRequest(size = size))

    suspend fun setVolumeProtection(id: Long, delete: Boolean? = null) =
        api().changeVolumeProtection(id, ChangeProtectionRequest(delete = delete))
    suspend fun listFirewalls(): List<CloudFirewall> = apis().flatMap { it.listFirewalls().firewalls }

    suspend fun createFirewall(name: String): CloudFirewall =
        api().createFirewall(de.kiefer_networks.falco.data.dto.CreateFirewallRequest(name = name)).firewall

    suspend fun getFirewall(id: Long): CloudFirewall = api().getFirewall(id).firewall
    suspend fun renameFirewall(id: Long, name: String): CloudFirewall =
        api().updateFirewall(id, UpdateFirewallRequest(name = name)).firewall
    suspend fun deleteFirewall(id: Long) = api().deleteFirewall(id)
    suspend fun setFirewallRules(id: Long, rules: List<FirewallRule>) =
        api().setFirewallRules(id, SetFirewallRulesRequest(rules))
    suspend fun applyFirewallToServer(id: Long, serverId: Long) =
        api().applyFirewall(
            id,
            ApplyFirewallRequest(listOf(FirewallApplyTarget("server", ResourceRef(serverId)))),
        )
    suspend fun removeFirewallFromServer(id: Long, serverId: Long) =
        api().removeFirewall(
            id,
            RemoveFirewallRequest(listOf(FirewallApplyTarget("server", ResourceRef(serverId)))),
        )
    suspend fun listFloatingIps(): List<CloudFloatingIp> = apis().flatMap { it.listFloatingIps().floatingIps }
    suspend fun getFloatingIp(id: Long): CloudFloatingIp = api().getFloatingIp(id).floatingIp
    suspend fun createFloatingIp(
        type: String,
        name: String? = null,
        description: String? = null,
        homeLocation: String? = null,
        serverId: Long? = null,
    ): CloudFloatingIp = api().createFloatingIp(
        de.kiefer_networks.falco.data.dto.CreateFloatingIpRequest(
            type = type, name = name, description = description,
            homeLocation = homeLocation, server = serverId,
        ),
    ).floatingIp
    suspend fun renameFloatingIp(id: Long, name: String): CloudFloatingIp =
        api().updateFloatingIp(id, de.kiefer_networks.falco.data.dto.UpdateFloatingIpRequest(name = name)).floatingIp
    suspend fun deleteFloatingIp(id: Long) = api().deleteFloatingIp(id)
    suspend fun assignFloatingIp(id: Long, serverId: Long) =
        api().assignFloatingIp(id, de.kiefer_networks.falco.data.dto.AssignFloatingIpRequest(server = serverId))
    suspend fun unassignFloatingIp(id: Long) = api().unassignFloatingIp(id)
    suspend fun changeFloatingIpDnsPtr(id: Long, ip: String, ptr: String?) =
        api().changeFloatingIpDnsPtr(
            id,
            de.kiefer_networks.falco.data.dto.ChangeDnsPtrRequest(ip, ptr?.takeIf { it.isNotBlank() }),
        )
    suspend fun setFloatingIpProtection(id: Long, delete: Boolean? = null) =
        api().changeFloatingIpProtection(id, ChangeProtectionRequest(delete = delete))

    suspend fun listNetworks(): List<CloudNetwork> = apis().flatMap { it.listNetworks().networks }
    suspend fun getNetwork(id: Long): CloudNetwork = api().getNetwork(id).network
    suspend fun createNetwork(name: String, ipRange: String): CloudNetwork =
        api().createNetwork(
            de.kiefer_networks.falco.data.dto.CreateNetworkRequest(name = name, ipRange = ipRange),
        ).network
    suspend fun renameNetwork(id: Long, name: String): CloudNetwork =
        api().updateNetwork(id, de.kiefer_networks.falco.data.dto.UpdateNetworkRequest(name = name)).network
    suspend fun deleteNetwork(id: Long) = api().deleteNetwork(id)
    suspend fun addNetworkSubnet(id: Long, type: String, networkZone: String, ipRange: String? = null) =
        api().addNetworkSubnet(
            id,
            de.kiefer_networks.falco.data.dto.AddSubnetRequest(type = type, networkZone = networkZone, ipRange = ipRange),
        )
    suspend fun deleteNetworkSubnet(id: Long, ipRange: String) =
        api().deleteNetworkSubnet(id, de.kiefer_networks.falco.data.dto.DeleteSubnetRequest(ipRange = ipRange))
    suspend fun setNetworkProtection(id: Long, delete: Boolean? = null) =
        api().changeNetworkProtection(id, ChangeProtectionRequest(delete = delete))

    suspend fun addNetworkRoute(id: Long, destination: String, gateway: String) =
        api().addNetworkRoute(id, de.kiefer_networks.falco.data.dto.NetworkRouteRequest(destination, gateway))

    suspend fun deleteNetworkRoute(id: Long, destination: String, gateway: String) =
        api().deleteNetworkRoute(id, de.kiefer_networks.falco.data.dto.NetworkRouteRequest(destination, gateway))

    suspend fun changeNetworkIpRange(id: Long, ipRange: String) =
        api().changeNetworkIpRange(id, de.kiefer_networks.falco.data.dto.ChangeIpRangeRequest(ipRange))

    suspend fun exposeNetworkToVSwitch(id: Long, vswitchId: Long, expose: Boolean = true) =
        api().exposeNetworkRoutesToVSwitch(id, de.kiefer_networks.falco.data.dto.ExposeRoutesRequest(vswitchId, expose))

    // ---- Server <-> Network actions ---------------------------------------

    suspend fun attachServerToNetwork(serverId: Long, networkId: Long, ip: String? = null, aliasIps: List<String>? = null) =
        api().attachServerToNetwork(
            serverId,
            de.kiefer_networks.falco.data.dto.AttachToNetworkRequest(networkId, ip, aliasIps),
        )

    suspend fun detachServerFromNetwork(serverId: Long, networkId: Long) =
        api().detachServerFromNetwork(serverId, de.kiefer_networks.falco.data.dto.DetachFromNetworkRequest(networkId))

    suspend fun changeServerAliasIps(serverId: Long, networkId: Long, aliasIps: List<String>) =
        api().changeServerAliasIps(
            serverId,
            de.kiefer_networks.falco.data.dto.ChangeAliasIpsRequest(networkId, aliasIps),
        )

    suspend fun addServerToPlacementGroup(serverId: Long, placementGroupId: Long) =
        api().addServerToPlacementGroup(
            serverId,
            de.kiefer_networks.falco.data.dto.AddToPlacementGroupRequest(placementGroupId),
        )

    suspend fun removeServerFromPlacementGroup(serverId: Long) =
        api().removeServerFromPlacementGroup(serverId)

    // ---- Action history ----------------------------------------------------

    suspend fun listServerActions(serverId: Long): List<de.kiefer_networks.falco.data.dto.ActionEnvelope> =
        api().listServerActions(serverId).actions

    suspend fun listVolumeActions(volumeId: Long): List<de.kiefer_networks.falco.data.dto.ActionEnvelope> =
        api().listVolumeActions(volumeId).actions

    // ---- SSH Keys ---------------------------------------------------------

    suspend fun listSshKeys(): List<de.kiefer_networks.falco.data.dto.CloudSshKey> =
        apis().flatMap { it.listSshKeys().sshKeys }
    suspend fun createSshKey(name: String, publicKey: String): de.kiefer_networks.falco.data.dto.CloudSshKey =
        api().createSshKey(
            de.kiefer_networks.falco.data.dto.CreateSshKeyRequest(name = name, publicKey = publicKey),
        ).sshKey
    suspend fun renameSshKey(id: Long, name: String): de.kiefer_networks.falco.data.dto.CloudSshKey =
        api().updateSshKey(
            id,
            de.kiefer_networks.falco.data.dto.UpdateSshKeyRequest(name = name),
        ).sshKey
    suspend fun deleteSshKey(id: Long) = api().deleteSshKey(id)

    // ---- Primary IPs ------------------------------------------------------

    suspend fun listPrimaryIps(): List<de.kiefer_networks.falco.data.dto.CloudPrimaryIp> =
        apis().flatMap { it.listPrimaryIps().primaryIps }
    suspend fun getPrimaryIp(id: Long): de.kiefer_networks.falco.data.dto.CloudPrimaryIp =
        api().getPrimaryIp(id).primaryIp
    suspend fun createPrimaryIp(
        name: String,
        type: String,
        assigneeType: String,
        datacenter: String? = null,
    ): de.kiefer_networks.falco.data.dto.CloudPrimaryIp = api().createPrimaryIp(
        de.kiefer_networks.falco.data.dto.CreatePrimaryIpRequest(
            name = name, type = type, assigneeType = assigneeType, datacenter = datacenter,
        ),
    ).primaryIp
    suspend fun deletePrimaryIp(id: Long) = api().deletePrimaryIp(id)
    suspend fun assignPrimaryIp(id: Long, serverId: Long) =
        api().assignPrimaryIp(id, de.kiefer_networks.falco.data.dto.AssignPrimaryIpRequest(assigneeId = serverId))
    suspend fun unassignPrimaryIp(id: Long) = api().unassignPrimaryIp(id)
    suspend fun setPrimaryIpProtection(id: Long, delete: Boolean? = null) =
        api().changePrimaryIpProtection(id, ChangeProtectionRequest(delete = delete))

    // ---- Locations / Datacenters / Action read ---------------------------

    suspend fun listLocations() = api().listLocations().locations
    suspend fun listDatacenters() = api().listDatacenters().datacenters
    suspend fun getPricing(): de.kiefer_networks.falco.data.dto.CloudPricing = api().getPricing().pricing
    suspend fun getAction(id: Long): de.kiefer_networks.falco.data.dto.ActionEnvelope =
        api().getAction(id).action
    suspend fun listStorageBoxes(): List<CloudStorageBox> = storageBoxApis().flatMap { it.listStorageBoxes().storageBoxes }

    suspend fun listStorageBoxTypes(): List<de.kiefer_networks.falco.data.dto.CloudStorageBoxType> =
        storageBoxApi().listStorageBoxTypes().storageBoxTypes

    suspend fun listStorageBoxLocations(): List<de.kiefer_networks.falco.data.dto.Location> =
        storageBoxApi().listStorageBoxLocations().locations

    suspend fun createStorageBox(
        name: String,
        storageBoxType: String,
        location: String,
        password: String? = null,
        sshKeys: List<String>? = null,
    ): de.kiefer_networks.falco.data.dto.CreateStorageBoxResponse =
        storageBoxApi().createStorageBox(
            de.kiefer_networks.falco.data.dto.CreateStorageBoxRequest(
                name = name,
                storageBoxType = storageBoxType,
                location = location,
                password = password,
                sshKeys = sshKeys,
            ),
        )

    suspend fun getStorageBox(id: Long): CloudStorageBox =
        storageBoxApi().getStorageBox(id).storageBox

    suspend fun resetStorageBoxPassword(id: Long, password: String) =
        storageBoxApi().resetStorageBoxPassword(id, ResetStorageBoxPasswordRequest(password))

    suspend fun updateStorageBoxAccessSettings(
        id: Long,
        sambaEnabled: Boolean? = null,
        sshEnabled: Boolean? = null,
        webdavEnabled: Boolean? = null,
        zfsEnabled: Boolean? = null,
        reachableExternally: Boolean? = null,
    ) = storageBoxApi().updateStorageBoxAccessSettings(
        id,
        UpdateStorageBoxAccessSettings(
            sambaEnabled = sambaEnabled,
            sshEnabled = sshEnabled,
            webdavEnabled = webdavEnabled,
            zfsEnabled = zfsEnabled,
            reachableExternally = reachableExternally,
        ),
    )

    suspend fun listStorageBoxSnapshots(id: Long): List<CloudStorageBoxSnapshot> =
        storageBoxApi().listStorageBoxSnapshots(id).snapshots

    suspend fun createStorageBoxSnapshot(id: Long, description: String? = null): CloudStorageBoxSnapshot =
        storageBoxApi().createStorageBoxSnapshot(id, CreateStorageBoxSnapshot(description)).snapshot

    suspend fun deleteStorageBoxSnapshot(id: Long, snapshotId: Long) =
        storageBoxApi().deleteStorageBoxSnapshot(id, snapshotId)

    suspend fun rollbackStorageBoxSnapshot(id: Long, snapshotId: Long) =
        storageBoxApi().rollbackStorageBoxSnapshot(id, snapshotId)

    suspend fun listStorageBoxSubaccounts(id: Long): List<CloudStorageBoxSubaccount> =
        storageBoxApi().listStorageBoxSubaccounts(id).subaccounts

    suspend fun createStorageBoxSubaccount(
        id: Long,
        password: String,
        homeDirectory: String,
        access: CloudSubaccountAccessSettings,
        description: String? = null,
    ): CloudStorageBoxSubaccount = storageBoxApi().createStorageBoxSubaccount(
        id,
        CreateStorageBoxSubaccount(
            password = password,
            homeDirectory = homeDirectory,
            accessSettings = access,
            description = description,
        ),
    ).subaccount

    suspend fun deleteStorageBoxSubaccount(id: Long, subaccountId: Long) =
        storageBoxApi().deleteStorageBoxSubaccount(id, subaccountId)

    suspend fun updateStorageBoxSubaccount(
        id: Long,
        subaccountId: Long,
        description: String? = null,
    ): CloudStorageBoxSubaccount = storageBoxApi().updateStorageBoxSubaccount(
        id, subaccountId, UpdateStorageBoxSubaccount(description = description),
    ).subaccount

    suspend fun resetSubaccountPassword(id: Long, subaccountId: Long, password: String) =
        storageBoxApi().resetSubaccountPassword(id, subaccountId, ResetSubaccountPasswordRequest(password))

    suspend fun powerOn(id: Long) = api().powerOn(id)
    suspend fun powerOff(id: Long) = api().powerOff(id)
    suspend fun reboot(id: Long) = api().reboot(id)
    suspend fun shutdown(id: Long) = api().shutdown(id)
    suspend fun reset(id: Long) = api().reset(id)
    suspend fun snapshot(id: Long) = api().snapshot(id)

    // ---- Server detail ---------------------------------------------------

    suspend fun getServer(id: Long): CloudServer = api().getServer(id).server

    suspend fun deleteServer(id: Long): ActionEnvelope =
        api().deleteServer(id).action

    suspend fun renameServer(id: Long, name: String): CloudServer =
        api().updateServer(id, UpdateServerRequest(name = name)).server

    suspend fun rebuildServer(id: Long, imageIdOrName: String) =
        api().rebuildServer(id, RebuildServerRequest(imageIdOrName))

    suspend fun enableRescue(id: Long, type: String = "linux64", sshKeys: List<Long>? = null) =
        api().enableRescue(id, EnableRescueRequest(type, sshKeys))

    suspend fun disableRescue(id: Long) = api().disableRescue(id)
    suspend fun resetServerPassword(id: Long) = api().resetServerPassword(id)
    suspend fun enableBackup(id: Long) = api().enableBackup(id)
    suspend fun disableBackup(id: Long) = api().disableBackup(id)
    suspend fun attachIso(id: Long, iso: String) = api().attachIso(id, AttachIsoRequest(iso))
    suspend fun detachIso(id: Long) = api().detachIso(id)

    suspend fun changeServerType(id: Long, type: String, upgradeDisk: Boolean = false) =
        api().changeServerType(id, ChangeServerTypeRequest(type, upgradeDisk))

    suspend fun setServerProtection(id: Long, delete: Boolean? = null, rebuild: Boolean? = null) =
        api().changeServerProtection(id, ChangeProtectionRequest(delete, rebuild))

    suspend fun changeServerDnsPtr(id: Long, ip: String, ptr: String?) =
        api().changeServerDnsPtr(
            id,
            de.kiefer_networks.falco.data.dto.ChangeDnsPtrRequest(ip = ip, dnsPtr = ptr?.takeIf { it.isNotBlank() }),
        )

    suspend fun requestServerConsole(id: Long) = api().requestServerConsole(id)

    suspend fun listImages(type: String = "system"): List<CloudImage> =
        api().listImages(type = type).images

    suspend fun listServerTypes(): List<CloudServerType> = api().listServerTypes().serverTypes

    suspend fun listIsos(): List<CloudIso> = api().listIsos().isos

    /** Hetzner Cloud `/servers/{id}/metrics`. Coerces JSON `[ts, "value"]` into
     *  `(epochSeconds, value)`-pairs grouped by series name. */
    suspend fun serverMetrics(id: Long, type: MetricType, period: MetricPeriod): MetricSeries {
        val nowEpoch = System.currentTimeMillis() / 1000
        val startEpoch = nowEpoch - period.secondsBack
        // ISO-8601 in UTC, the format Hetzner expects.
        fun fmt(epoch: Long): String =
            java.time.Instant.ofEpochSecond(epoch).toString()
        val response = api().serverMetrics(
            id = id,
            type = type.apiKey,
            start = fmt(startEpoch),
            end = fmt(nowEpoch),
            step = period.step,
        )
        val out = response.metrics.timeSeries.mapValues { entry ->
            entry.value.values.mapNotNull { tuple ->
                if (tuple.size < 2) return@mapNotNull null
                val ts = (tuple[0] as? JsonPrimitive)?.doubleOrNull?.toLong()
                    ?: return@mapNotNull null
                val v = (tuple[1] as? JsonPrimitive)?.let {
                    it.contentOrNull?.toDoubleOrNull() ?: it.doubleOrNull
                } ?: return@mapNotNull null
                ts to v
            }
        }
        return MetricSeries(out)
    }

    // ---- Load Balancers ----------------------------------------------------

    suspend fun listLoadBalancers(): List<de.kiefer_networks.falco.data.dto.CloudLoadBalancer> =
        apis().flatMap { it.listLoadBalancers().loadBalancers }

    suspend fun getLoadBalancer(id: Long): de.kiefer_networks.falco.data.dto.CloudLoadBalancer =
        api().getLoadBalancer(id).loadBalancer

    suspend fun createLoadBalancer(
        name: String,
        type: String,
        location: String? = null,
        networkZone: String? = null,
        algorithm: String = "round_robin",
        publicInterface: Boolean = true,
    ): de.kiefer_networks.falco.data.dto.CloudLoadBalancer = api().createLoadBalancer(
        de.kiefer_networks.falco.data.dto.CreateLoadBalancerRequest(
            name = name,
            loadBalancerType = type,
            location = location,
            networkZone = networkZone,
            algorithm = de.kiefer_networks.falco.data.dto.LoadBalancerAlgorithm(algorithm),
            publicInterface = publicInterface,
        ),
    ).loadBalancer

    suspend fun renameLoadBalancer(id: Long, name: String) = api().updateLoadBalancer(
        id,
        de.kiefer_networks.falco.data.dto.UpdateLoadBalancerRequest(name = name),
    ).loadBalancer

    suspend fun deleteLoadBalancer(id: Long) = api().deleteLoadBalancer(id)

    suspend fun addLoadBalancerService(id: Long, service: de.kiefer_networks.falco.data.dto.LoadBalancerService) =
        api().addLoadBalancerService(id, service)

    suspend fun updateLoadBalancerService(
        id: Long,
        listenPort: Int,
        protocol: String? = null,
        destinationPort: Int? = null,
        proxyprotocol: Boolean? = null,
    ) = api().updateLoadBalancerService(
        id,
        de.kiefer_networks.falco.data.dto.UpdateLoadBalancerServiceRequest(
            listenPort = listenPort,
            protocol = protocol,
            destinationPort = destinationPort,
            proxyprotocol = proxyprotocol,
        ),
    )

    suspend fun deleteLoadBalancerService(id: Long, listenPort: Int) = api().deleteLoadBalancerService(
        id,
        de.kiefer_networks.falco.data.dto.DeleteLoadBalancerServiceRequest(listenPort),
    )

    suspend fun addLoadBalancerTarget(id: Long, target: de.kiefer_networks.falco.data.dto.LoadBalancerTarget) =
        api().addLoadBalancerTarget(id, target)

    suspend fun removeLoadBalancerTarget(id: Long, target: de.kiefer_networks.falco.data.dto.LoadBalancerTarget) =
        api().removeLoadBalancerTarget(id, target)

    suspend fun changeLoadBalancerAlgorithm(id: Long, algorithm: String) = api().changeLoadBalancerAlgorithm(
        id,
        de.kiefer_networks.falco.data.dto.ChangeLbAlgorithmRequest(de.kiefer_networks.falco.data.dto.LoadBalancerAlgorithm(algorithm)),
    )

    suspend fun changeLoadBalancerType(id: Long, type: String) = api().changeLoadBalancerType(
        id,
        de.kiefer_networks.falco.data.dto.ChangeLbTypeRequest(type),
    )

    suspend fun attachLoadBalancerToNetwork(id: Long, networkId: Long, ip: String? = null) =
        api().attachLoadBalancerToNetwork(
            id,
            de.kiefer_networks.falco.data.dto.AttachToNetworkRequest(networkId, ip),
        )

    suspend fun detachLoadBalancerFromNetwork(id: Long, networkId: Long) =
        api().detachLoadBalancerFromNetwork(
            id,
            de.kiefer_networks.falco.data.dto.DetachFromNetworkRequest(networkId),
        )

    suspend fun enableLoadBalancerPublic(id: Long) = api().enableLoadBalancerPublicInterface(id)
    suspend fun disableLoadBalancerPublic(id: Long) = api().disableLoadBalancerPublicInterface(id)

    suspend fun setLoadBalancerProtection(id: Long, delete: Boolean? = null) =
        api().changeLoadBalancerProtection(id, ChangeProtectionRequest(delete = delete))

    suspend fun changeLoadBalancerDnsPtr(id: Long, ip: String, dnsPtr: String?) =
        api().changeLoadBalancerDnsPtr(
            id,
            de.kiefer_networks.falco.data.dto.ChangeDnsPtrRequest(ip = ip, dnsPtr = dnsPtr),
        )

    suspend fun listLoadBalancerTypes(): List<de.kiefer_networks.falco.data.dto.CloudLoadBalancerType> =
        api().listLoadBalancerTypes().loadBalancerTypes

    // ---- Certificates ------------------------------------------------------

    suspend fun listCertificates(): List<de.kiefer_networks.falco.data.dto.CloudCertificate> =
        apis().flatMap { it.listCertificates().certificates }

    suspend fun getCertificate(id: Long): de.kiefer_networks.falco.data.dto.CloudCertificate =
        api().getCertificate(id).certificate

    suspend fun uploadCertificate(name: String, certificate: String, privateKey: String) =
        api().createCertificate(
            de.kiefer_networks.falco.data.dto.CreateCertificateRequest(
                name = name,
                type = "uploaded",
                certificate = certificate,
                privateKey = privateKey,
            ),
        ).certificate

    suspend fun requestManagedCertificate(name: String, domainNames: List<String>) =
        api().createCertificate(
            de.kiefer_networks.falco.data.dto.CreateCertificateRequest(
                name = name,
                type = "managed",
                domainNames = domainNames,
            ),
        ).certificate

    suspend fun renameCertificate(id: Long, name: String) = api().updateCertificate(
        id,
        de.kiefer_networks.falco.data.dto.UpdateCertificateRequest(name = name),
    ).certificate

    suspend fun deleteCertificate(id: Long) = api().deleteCertificate(id)
    suspend fun retryCertificate(id: Long) = api().retryCertificate(id)

    // ---- Placement Groups --------------------------------------------------

    suspend fun listPlacementGroups(): List<de.kiefer_networks.falco.data.dto.CloudPlacementGroup> =
        apis().flatMap { it.listPlacementGroups().placementGroups }

    suspend fun getPlacementGroup(id: Long): de.kiefer_networks.falco.data.dto.CloudPlacementGroup =
        api().getPlacementGroup(id).placementGroup

    suspend fun createPlacementGroup(name: String, type: String = "spread") =
        api().createPlacementGroup(
            de.kiefer_networks.falco.data.dto.CreatePlacementGroupRequest(name = name, type = type),
        ).placementGroup

    suspend fun renamePlacementGroup(id: Long, name: String) = api().updatePlacementGroup(
        id,
        de.kiefer_networks.falco.data.dto.UpdatePlacementGroupRequest(name = name),
    ).placementGroup

    suspend fun deletePlacementGroup(id: Long) = api().deletePlacementGroup(id)

    // ---- ISO detail --------------------------------------------------------

    suspend fun getIso(id: Long): de.kiefer_networks.falco.data.dto.CloudIso = api().getIso(id).iso
}
