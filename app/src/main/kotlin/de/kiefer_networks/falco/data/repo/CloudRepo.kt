// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.CloudApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.StorageBoxApi
import de.kiefer_networks.falco.data.api.fetchAllPages
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.auth.SecurityPreferences
import de.kiefer_networks.falco.data.dto.ActionEnvelope
import de.kiefer_networks.falco.data.dto.ApplyFirewallRequest
import de.kiefer_networks.falco.data.dto.AttachIsoRequest
import de.kiefer_networks.falco.data.dto.ChangeProtectionRequest
import de.kiefer_networks.falco.data.dto.ChangeServerTypeRequest
import de.kiefer_networks.falco.data.dto.CloudFirewall
import de.kiefer_networks.falco.data.dto.CloudFloatingIp
import de.kiefer_networks.falco.data.dto.CloudImage
import de.kiefer_networks.falco.data.dto.CloudIso
import de.kiefer_networks.falco.data.dto.CloudNetwork
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudServerType
import de.kiefer_networks.falco.data.dto.CloudStorageBox
import de.kiefer_networks.falco.data.dto.CloudStorageBoxSnapshot
import de.kiefer_networks.falco.data.dto.CloudStorageBoxSubaccount
import de.kiefer_networks.falco.data.dto.CloudSubaccountAccessSettings
import de.kiefer_networks.falco.data.dto.CloudVolume
import de.kiefer_networks.falco.data.dto.CreateStorageBoxSnapshot
import de.kiefer_networks.falco.data.dto.CreateStorageBoxSubaccount
import de.kiefer_networks.falco.data.dto.EnableRescueRequest
import de.kiefer_networks.falco.data.dto.FirewallApplyTarget
import de.kiefer_networks.falco.data.dto.FirewallRule
import de.kiefer_networks.falco.data.dto.RebuildServerRequest
import de.kiefer_networks.falco.data.dto.RemoveFirewallRequest
import de.kiefer_networks.falco.data.dto.ResetStorageBoxPasswordRequest
import de.kiefer_networks.falco.data.dto.ResetSubaccountPasswordRequest
import de.kiefer_networks.falco.data.dto.ResourceRef
import de.kiefer_networks.falco.data.dto.RollbackStorageBoxSnapshotRequest
import de.kiefer_networks.falco.data.dto.SetFirewallRulesRequest
import de.kiefer_networks.falco.data.dto.UpdateFirewallRequest
import de.kiefer_networks.falco.data.dto.UpdateServerRequest
import de.kiefer_networks.falco.data.dto.UpdateStorageBoxAccessSettings
import de.kiefer_networks.falco.data.dto.UpdateStorageBoxSubaccount
import javax.inject.Inject
import javax.inject.Singleton
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.first
import kotlin.coroutines.cancellation.CancellationException
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.contentOrNull
import kotlinx.serialization.json.doubleOrNull

enum class MetricType(val apiKey: String) { Cpu("cpu"), Disk("disk"), Network("network") }
enum class MetricPeriod(val secondsBack: Long, val step: Int) {
    H1(3600L, 60),
    H24(86_400L, 600),
    D7(604_800L, 3600),
    D30(2_592_000L, 21_600),
}
data class MetricSeries(val series: Map<String, List<Pair<Long, Double>>>) {
    /** Series whose name ends with [suffix]; Hetzner names them e.g. `disk.0.bandwidth.read`. */
    fun bySuffix(suffix: String): List<Pair<Long, Double>> =
        series.entries.firstOrNull { it.key.endsWith(suffix) }?.value.orEmpty()
}

/** Divisor and unit label for a bytes per second magnitude. */
fun byteRateUnit(maxBytesPerSecond: Double): Pair<Double, String> = when {
    maxBytesPerSecond >= 1e9 -> 1e9 to " GB/s"
    maxBytesPerSecond >= 1e6 -> 1e6 to " MB/s"
    maxBytesPerSecond >= 1e3 -> 1e3 to " kB/s"
    else -> 1.0 to " B/s"
}

@Singleton
class CloudRepo @Inject constructor(
    private val accounts: AccountManager,
    private val prefs: SecurityPreferences,
) {

    private suspend fun api(): CloudApi = api(null)

    /**
     * Cloud API for a specific project, falling back to the active project when
     * [projectId] is null. Used by create / update / delete paths so the user
     * can target a project explicitly while in aggregate-projects mode.
     */
    private suspend fun api(projectId: String?): CloudApi {
        val token = tokenFor(projectId)
            ?: error("No Cloud project token available")
        return HttpClientFactory.cloudRetrofit(token).create(CloudApi::class.java)
    }

    private suspend fun storageBoxApi(): StorageBoxApi = storageBoxApi(null)

    private suspend fun storageBoxApi(projectId: String?): StorageBoxApi {
        val token = tokenFor(projectId)
            ?: error("No Cloud project token available")
        return HttpClientFactory.storageBoxRetrofit(token).create(StorageBoxApi::class.java)
    }

    private suspend fun tokenFor(projectId: String?): String? {
        if (projectId == null) {
            return accounts.activeCloudProject.first()?.cloudToken
        }
        val accountId = accounts.activeAccountId.first() ?: return null
        return accounts.cloudProjects(accountId).firstOrNull { it.id == projectId }?.cloudToken
    }

    /**
     * Returns either [api] alone or a fan-out across every Cloud project of
     * the active account, depending on [SecurityPreferences.aggregateProjects].
     * Used by list endpoints so the UI can show a unified view without forcing
     * the user to switch projects.
     */
    private suspend fun apis(): List<CloudApi> = apisWithProjectIds().map { it.second }

    private suspend fun storageBoxApis(): List<StorageBoxApi> =
        storageBoxApisWithProjectIds().map { it.second }

    /**
     * Fan-out variant that pairs each Cloud API with the project id it was
     * built for — used by `*Aware` list endpoints so callers can tag each item
     * with its source project. In non-aggregate mode the active project's id
     * is paired (or `null` if the active project cannot be resolved).
     */
    private suspend fun apisWithProjectIds(): List<Pair<String?, CloudApi>> {
        if (!prefs.aggregateProjectsNow()) {
            val active = accounts.activeCloudProject.first()
            return listOf(active?.id to api())
        }
        val accountId = accounts.activeAccountId.first()
            ?: return listOf(accounts.activeCloudProject.first()?.id to api())
        val projects = accounts.cloudProjects(accountId)
        if (projects.isEmpty()) {
            return listOf(accounts.activeCloudProject.first()?.id to api())
        }
        return projects.map {
            it.id to HttpClientFactory.cloudRetrofit(it.cloudToken).create(CloudApi::class.java)
        }
    }

    private suspend fun storageBoxApisWithProjectIds(): List<Pair<String?, StorageBoxApi>> {
        if (!prefs.aggregateProjectsNow()) {
            val active = accounts.activeCloudProject.first()
            return listOf(active?.id to storageBoxApi())
        }
        val accountId = accounts.activeAccountId.first()
            ?: return listOf(accounts.activeCloudProject.first()?.id to storageBoxApi())
        val projects = accounts.cloudProjects(accountId)
        if (projects.isEmpty()) {
            return listOf(accounts.activeCloudProject.first()?.id to storageBoxApi())
        }
        return projects.map {
            it.id to HttpClientFactory.storageBoxRetrofit(it.cloudToken).create(StorageBoxApi::class.java)
        }
    }


    /** Fan-out list tagged with the source project id (see [apisWithProjectIds]). */
    private suspend fun <T> listAware(
        fetch: suspend (CloudApi, Int) -> Pair<List<T>, de.kiefer_networks.falco.data.dto.Meta?>,
    ): List<Pair<String?, T>> = apisWithProjectIds().flatMap { (pid, api) ->
        fetchAllPages { p -> fetch(api, p) }.map { pid to it }
    }

    /** List of exactly one project (null = active), for pickers whose choice must live there. */
    private suspend fun <T> listIn(
        projectId: String?,
        fetch: suspend (CloudApi, Int) -> Pair<List<T>, de.kiefer_networks.falco.data.dto.Meta?>,
    ): List<T> {
        val api = api(projectId)
        return fetchAllPages { p -> fetch(api, p) }
    }

    /** DELETE endpoints return an empty body; surface non 2xx as [retrofit2.HttpException]. */
    private fun <T> retrofit2.Response<T>.orThrow(): retrofit2.Response<T> {
        if (!isSuccessful) throw retrofit2.HttpException(this)
        return this
    }

    suspend fun listServersIn(projectId: String?): List<CloudServer> =
        listIn(projectId) { a, p -> a.listServers(page = p).let { it.servers to it.meta } }
    suspend fun listSshKeysIn(projectId: String?): List<de.kiefer_networks.falco.data.dto.CloudSshKey> =
        listIn(projectId) { a, p -> a.listSshKeys(page = p).let { it.sshKeys to it.meta } }
    suspend fun listNetworksIn(projectId: String?): List<CloudNetwork> =
        listIn(projectId) { a, p -> a.listNetworks(page = p).let { it.networks to it.meta } }
    suspend fun listPlacementGroupsIn(projectId: String?): List<de.kiefer_networks.falco.data.dto.CloudPlacementGroup> =
        listIn(projectId) { a, p -> a.listPlacementGroups(page = p).let { it.placementGroups to it.meta } }
    suspend fun listFirewallsIn(projectId: String?): List<CloudFirewall> =
        listIn(projectId) { a, p -> a.listFirewalls(page = p).let { it.firewalls to it.meta } }

    suspend fun listSshKeysAware(): List<Pair<String?, de.kiefer_networks.falco.data.dto.CloudSshKey>> =
        listAware { a, p -> a.listSshKeys(page = p).let { it.sshKeys to it.meta } }
    suspend fun listPrimaryIpsAware(): List<Pair<String?, de.kiefer_networks.falco.data.dto.CloudPrimaryIp>> =
        listAware { a, p -> a.listPrimaryIps(page = p).let { it.primaryIps to it.meta } }
    suspend fun listNetworksAware(): List<Pair<String?, CloudNetwork>> =
        listAware { a, p -> a.listNetworks(page = p).let { it.networks to it.meta } }
    suspend fun listLoadBalancersAware(): List<Pair<String?, de.kiefer_networks.falco.data.dto.CloudLoadBalancer>> =
        listAware { a, p -> a.listLoadBalancers(page = p).let { it.loadBalancers to it.meta } }
    suspend fun listCertificatesAware(): List<Pair<String?, de.kiefer_networks.falco.data.dto.CloudCertificate>> =
        listAware { a, p -> a.listCertificates(page = p).let { it.certificates to it.meta } }
    suspend fun listPlacementGroupsAware(): List<Pair<String?, de.kiefer_networks.falco.data.dto.CloudPlacementGroup>> =
        listAware { a, p -> a.listPlacementGroups(page = p).let { it.placementGroups to it.meta } }

    suspend fun listServers(): List<CloudServer> = apis().flatMap { fetchAllPages { p -> it.listServers(page = p).let { r -> r.servers to r.meta } } }

    /**
     * Like [listServers] but tags every server with the project id it came
     * from. Used by hub UIs that may need to switch the active Cloud project
     * before opening a project-scoped detail screen (the detail repo otherwise
     * reads the previous project's token in aggregate-projects mode).
     */
    suspend fun listServersAware(): List<Pair<String?, CloudServer>> =
        apisWithProjectIds().flatMap { (pid, api) ->
            fetchAllPages { p -> api.listServers(page = p).let { r -> r.servers to r.meta } }.map { pid to it }
        }

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
        projectId: String? = null,
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
        return api(projectId).createServer(body)
    }

    suspend fun listVolumes(): List<CloudVolume> = apis().flatMap { fetchAllPages { p -> it.listVolumes(page = p).let { r -> r.volumes to r.meta } } }
    suspend fun listVolumesAware(): List<Pair<String?, CloudVolume>> =
        apisWithProjectIds().flatMap { (pid, api) ->
            fetchAllPages { p -> api.listVolumes(page = p).let { r -> r.volumes to r.meta } }.map { pid to it }
        }
    suspend fun getVolume(id: Long): CloudVolume = api().getVolume(id).volume

    suspend fun createVolume(
        name: String,
        size: Int,
        location: String? = null,
        serverId: Long? = null,
        format: String? = null,
        automount: Boolean? = null,
        projectId: String? = null,
    ): CloudVolume = api(projectId).createVolume(
        de.kiefer_networks.falco.data.dto.CreateVolumeRequest(
            name = name, size = size, location = location, server = serverId,
            format = format, automount = automount,
        ),
    ).volume

    suspend fun renameVolume(id: Long, name: String): CloudVolume =
        api().updateVolume(id, de.kiefer_networks.falco.data.dto.UpdateVolumeRequest(name = name)).volume

    suspend fun deleteVolume(id: Long) = api().deleteVolume(id).orThrow()

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
    suspend fun listFirewalls(): List<CloudFirewall> = apis().flatMap { fetchAllPages { p -> it.listFirewalls(page = p).let { r -> r.firewalls to r.meta } } }
    suspend fun listFirewallsAware(): List<Pair<String?, CloudFirewall>> =
        apisWithProjectIds().flatMap { (pid, api) ->
            fetchAllPages { p -> api.listFirewalls(page = p).let { r -> r.firewalls to r.meta } }.map { pid to it }
        }

    suspend fun createFirewall(name: String, projectId: String? = null): CloudFirewall =
        api(projectId).createFirewall(de.kiefer_networks.falco.data.dto.CreateFirewallRequest(name = name)).firewall

    suspend fun getFirewall(id: Long): CloudFirewall = api().getFirewall(id).firewall
    suspend fun renameFirewall(id: Long, name: String): CloudFirewall =
        api().updateFirewall(id, UpdateFirewallRequest(name = name)).firewall
    suspend fun deleteFirewall(id: Long) = api().deleteFirewall(id).orThrow()
    suspend fun setFirewallRules(id: Long, rules: List<FirewallRule>) =
        api().setFirewallRules(id, SetFirewallRulesRequest(rules))
    suspend fun applyFirewallToServer(id: Long, serverId: Long, projectId: String? = null) =
        api(projectId).applyFirewall(
            id,
            ApplyFirewallRequest(listOf(FirewallApplyTarget("server", ResourceRef(serverId)))),
        )
    suspend fun removeFirewallFromServer(id: Long, serverId: Long) =
        api().removeFirewall(
            id,
            RemoveFirewallRequest(listOf(FirewallApplyTarget("server", ResourceRef(serverId)))),
        )
    suspend fun listFloatingIps(): List<CloudFloatingIp> = apis().flatMap { fetchAllPages { p -> it.listFloatingIps(page = p).let { r -> r.floatingIps to r.meta } } }
    suspend fun listFloatingIpsAware(): List<Pair<String?, CloudFloatingIp>> =
        apisWithProjectIds().flatMap { (pid, api) ->
            fetchAllPages { p -> api.listFloatingIps(page = p).let { r -> r.floatingIps to r.meta } }.map { pid to it }
        }
    suspend fun getFloatingIp(id: Long): CloudFloatingIp = api().getFloatingIp(id).floatingIp
    suspend fun createFloatingIp(
        type: String,
        name: String? = null,
        description: String? = null,
        homeLocation: String? = null,
        serverId: Long? = null,
        projectId: String? = null,
    ): CloudFloatingIp = api(projectId).createFloatingIp(
        de.kiefer_networks.falco.data.dto.CreateFloatingIpRequest(
            type = type, name = name, description = description,
            homeLocation = homeLocation, server = serverId,
        ),
    ).floatingIp
    suspend fun renameFloatingIp(id: Long, name: String): CloudFloatingIp =
        api().updateFloatingIp(id, de.kiefer_networks.falco.data.dto.UpdateFloatingIpRequest(name = name)).floatingIp
    suspend fun deleteFloatingIp(id: Long) = api().deleteFloatingIp(id).orThrow()
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

    suspend fun listNetworks(): List<CloudNetwork> = apis().flatMap { fetchAllPages { p -> it.listNetworks(page = p).let { r -> r.networks to r.meta } } }
    suspend fun getNetwork(id: Long): CloudNetwork = api().getNetwork(id).network
    suspend fun createNetwork(
        name: String,
        ipRange: String,
        subnets: List<de.kiefer_networks.falco.data.dto.AddSubnetRequest>? = null,
        projectId: String? = null,
    ): CloudNetwork =
        api(projectId).createNetwork(
            de.kiefer_networks.falco.data.dto.CreateNetworkRequest(name = name, ipRange = ipRange, subnets = subnets),
        ).network
    suspend fun renameNetwork(id: Long, name: String): CloudNetwork =
        api().updateNetwork(id, de.kiefer_networks.falco.data.dto.UpdateNetworkRequest(name = name)).network
    suspend fun deleteNetwork(id: Long) = api().deleteNetwork(id).orThrow()
    suspend fun addNetworkSubnet(
        id: Long,
        type: String,
        networkZone: String,
        ipRange: String? = null,
        vswitchId: Long? = null,
    ) =
        api().addNetworkSubnet(
            id,
            de.kiefer_networks.falco.data.dto.AddSubnetRequest(
                type = type, networkZone = networkZone, ipRange = ipRange, vswitchId = vswitchId,
            ),
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

    /** `expose_routes_to_vswitch` is a field of PUT /networks/{id}, not an action. */
    suspend fun setNetworkExposeRoutesToVSwitch(id: Long, expose: Boolean): CloudNetwork =
        api().updateNetwork(
            id,
            de.kiefer_networks.falco.data.dto.UpdateNetworkRequest(exposeRoutesToVswitch = expose),
        ).network

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

    /**
     * Project wide activity: the newest actions of every Cloud resource
     * collection plus storage boxes, for the active project or every project
     * in aggregate mode, newest first. A collection the token may not read
     * is skipped; only if every request fails is the first error thrown.
     */
    suspend fun listProjectActivity(limit: Int = 150): List<de.kiefer_networks.falco.data.model.ProjectAction> =
        kotlinx.coroutines.coroutineScope {
            val accountId = accounts.activeAccountId.first()
            val names = accountId?.let { id -> accounts.cloudProjects(id).associate { it.id to it.name } }.orEmpty()
            val cloudJobs = apisWithProjectIds().flatMap { (pid, api) ->
                ACTIVITY_COLLECTIONS.map { collection ->
                    async { runCatching { api.listCollectionActions(collection).actions }.map { Triple(pid, collection, it) } }
                }
            }
            val boxJobs = storageBoxApisWithProjectIds().map { (pid, api) ->
                async { runCatching { api.listStorageBoxActions().actions }.map { Triple(pid, "storage_boxes", it) } }
            }
            val results = (cloudJobs + boxJobs).awaitAll()
            results.forEach { r -> r.exceptionOrNull()?.let { if (it is CancellationException) throw it } }
            if (results.none { it.isSuccess }) throw results.first().exceptionOrNull()!!
            results.mapNotNull { it.getOrNull() }
                .flatMap { (pid, collection, actions) ->
                    actions.map { de.kiefer_networks.falco.data.model.ProjectAction(pid, names[pid], collection, it) }
                }
                .sortedByDescending { it.action.started.orEmpty() }
                .take(limit)
        }

    suspend fun listServerActions(serverId: Long): List<de.kiefer_networks.falco.data.dto.ActionEnvelope> =
        api().listServerActions(serverId).actions

    suspend fun listVolumeActions(volumeId: Long): List<de.kiefer_networks.falco.data.dto.ActionEnvelope> =
        api().listVolumeActions(volumeId).actions

    // ---- SSH Keys ---------------------------------------------------------

    suspend fun listSshKeys(): List<de.kiefer_networks.falco.data.dto.CloudSshKey> =
        apis().flatMap { fetchAllPages { p -> it.listSshKeys(page = p).let { r -> r.sshKeys to r.meta } } }
    suspend fun createSshKey(
        name: String,
        publicKey: String,
        projectId: String? = null,
    ): de.kiefer_networks.falco.data.dto.CloudSshKey =
        api(projectId).createSshKey(
            de.kiefer_networks.falco.data.dto.CreateSshKeyRequest(name = name, publicKey = publicKey),
        ).sshKey
    suspend fun renameSshKey(id: Long, name: String, projectId: String? = null): de.kiefer_networks.falco.data.dto.CloudSshKey =
        api(projectId).updateSshKey(
            id,
            de.kiefer_networks.falco.data.dto.UpdateSshKeyRequest(name = name),
        ).sshKey
    suspend fun deleteSshKey(id: Long, projectId: String? = null) = api(projectId).deleteSshKey(id).orThrow()

    // ---- Primary IPs ------------------------------------------------------

    suspend fun listPrimaryIps(): List<de.kiefer_networks.falco.data.dto.CloudPrimaryIp> =
        apis().flatMap { fetchAllPages { p -> it.listPrimaryIps(page = p).let { r -> r.primaryIps to r.meta } } }
    suspend fun getPrimaryIp(id: Long): de.kiefer_networks.falco.data.dto.CloudPrimaryIp =
        api().getPrimaryIp(id).primaryIp
    suspend fun createPrimaryIp(
        name: String,
        type: String,
        assigneeType: String,
        location: String? = null,
        projectId: String? = null,
    ): de.kiefer_networks.falco.data.dto.CloudPrimaryIp = api(projectId).createPrimaryIp(
        de.kiefer_networks.falco.data.dto.CreatePrimaryIpRequest(
            name = name, type = type, assigneeType = assigneeType, location = location,
        ),
    ).primaryIp
    suspend fun deletePrimaryIp(id: Long) = api().deletePrimaryIp(id).orThrow()
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
    suspend fun listStorageBoxes(): List<CloudStorageBox> = storageBoxApis().flatMap { fetchAllPages { p -> it.listStorageBoxes(page = p).let { r -> r.storageBoxes to r.meta } } }
    suspend fun listStorageBoxesAware(): List<Pair<String?, CloudStorageBox>> =
        storageBoxApisWithProjectIds().flatMap { (pid, api) ->
            fetchAllPages { p -> api.listStorageBoxes(page = p).let { r -> r.storageBoxes to r.meta } }.map { pid to it }
        }

    suspend fun listStorageBoxTypes(): List<de.kiefer_networks.falco.data.dto.CloudStorageBoxType> {
        val api = storageBoxApi()
        return fetchAllPages { p -> api.listStorageBoxTypes(page = p).let { r -> r.storageBoxTypes to r.meta } }
    }

    /**
     * api.hetzner.com has no `/locations`; a type's `prices` list the
     * locations it can be ordered in. City and country come from the Cloud
     * `/locations` (same names), falling back to the bare name.
     */
    suspend fun listStorageBoxLocations(
        types: List<de.kiefer_networks.falco.data.dto.CloudStorageBoxType>,
    ): List<de.kiefer_networks.falco.data.dto.Location> {
        val details = runCatching { listLocations() }
            .onFailure { if (it is CancellationException) throw it }
            .getOrDefault(emptyList())
            .associateBy { it.name }
        return types.flatMap { t -> t.prices.map { it.location } }
            .distinct()
            .map { details[it] ?: de.kiefer_networks.falco.data.dto.Location(id = 0, name = it) }
    }

    suspend fun createStorageBox(
        name: String,
        storageBoxType: String,
        location: String,
        password: String,
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

    /**
     * Storage Box writes are asynchronous. Wait for the action so the
     * following refresh shows the result and a failed action is reported
     * instead of a silent "done".
     */
    private suspend fun StorageBoxApi.awaitAction(action: ActionEnvelope?) {
        var a = action ?: return
        // Fixed 1 s poll for at most ~60 s; on timeout the caller refreshes anyway.
        repeat(60) {
            when (a.status) {
                "success" -> return
                "error" -> error("Storage Box action ${a.command} failed")
            }
            delay(1_000)
            a = getStorageBoxAction(a.id).action
        }
    }

    private suspend fun storageBoxAction(block: suspend (StorageBoxApi) -> ActionEnvelope?) {
        val api = storageBoxApi()
        api.awaitAction(block(api))
    }

    suspend fun resetStorageBoxPassword(id: Long, password: String) = storageBoxAction {
        it.resetStorageBoxPassword(id, ResetStorageBoxPasswordRequest(password)).action
    }

    suspend fun updateStorageBoxAccessSettings(
        id: Long,
        sambaEnabled: Boolean? = null,
        sshEnabled: Boolean? = null,
        webdavEnabled: Boolean? = null,
        zfsEnabled: Boolean? = null,
        reachableExternally: Boolean? = null,
    ) = storageBoxAction {
        it.updateStorageBoxAccessSettings(
            id,
            UpdateStorageBoxAccessSettings(
                sambaEnabled = sambaEnabled,
                sshEnabled = sshEnabled,
                webdavEnabled = webdavEnabled,
                zfsEnabled = zfsEnabled,
                reachableExternally = reachableExternally,
            ),
        ).action
    }

    // Not paginated by the API.
    suspend fun listStorageBoxSnapshots(id: Long): List<CloudStorageBoxSnapshot> =
        storageBoxApi().listStorageBoxSnapshots(id).snapshots

    suspend fun createStorageBoxSnapshot(id: Long, description: String? = null) = storageBoxAction {
        it.createStorageBoxSnapshot(id, CreateStorageBoxSnapshot(description)).action
    }

    suspend fun deleteStorageBoxSnapshot(id: Long, snapshotId: Long) = storageBoxAction {
        it.deleteStorageBoxSnapshot(id, snapshotId).action
    }

    /** [snapshot] is the snapshot ID or name. */
    suspend fun rollbackStorageBoxSnapshot(id: Long, snapshot: String) = storageBoxAction {
        it.rollbackStorageBoxSnapshot(id, RollbackStorageBoxSnapshotRequest(snapshot)).action
    }

    // Not paginated by the API.
    suspend fun listStorageBoxSubaccounts(id: Long): List<CloudStorageBoxSubaccount> =
        storageBoxApi().listStorageBoxSubaccounts(id).subaccounts

    /** The create response has no username; callers refresh the list afterwards. */
    suspend fun createStorageBoxSubaccount(
        id: Long,
        password: String,
        homeDirectory: String,
        access: CloudSubaccountAccessSettings,
        description: String? = null,
    ) = storageBoxAction {
        it.createStorageBoxSubaccount(
            id,
            CreateStorageBoxSubaccount(
                password = password,
                homeDirectory = homeDirectory,
                accessSettings = access,
                description = description,
            ),
        ).action
    }

    suspend fun deleteStorageBoxSubaccount(id: Long, subaccountId: Long) = storageBoxAction {
        it.deleteStorageBoxSubaccount(id, subaccountId).action
    }

    suspend fun updateStorageBoxSubaccount(
        id: Long,
        subaccountId: Long,
        description: String? = null,
    ): CloudStorageBoxSubaccount = storageBoxApi().updateStorageBoxSubaccount(
        id, subaccountId, UpdateStorageBoxSubaccount(description = description),
    ).subaccount

    suspend fun resetSubaccountPassword(id: Long, subaccountId: Long, password: String) = storageBoxAction {
        it.resetSubaccountPassword(id, subaccountId, ResetSubaccountPasswordRequest(password)).action
    }

    suspend fun powerOn(id: Long, projectId: String? = null) = api(projectId).powerOn(id)
    suspend fun powerOff(id: Long, projectId: String? = null) = api(projectId).powerOff(id)
    suspend fun reboot(id: Long, projectId: String? = null) = api(projectId).reboot(id)
    suspend fun shutdown(id: Long, projectId: String? = null) = api(projectId).shutdown(id)
    suspend fun reset(id: Long, projectId: String? = null) = api(projectId).reset(id)
    suspend fun snapshot(id: Long, projectId: String? = null) = api(projectId).snapshot(id)

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
        fetchAllPages { p -> api().listImages(type = type, page = p).let { r -> r.images to r.meta } }

    suspend fun listServerTypes(): List<CloudServerType> = fetchAllPages { p -> api().listServerTypes(page = p).let { r -> r.serverTypes to r.meta } }

    suspend fun listIsos(): List<CloudIso> = fetchAllPages { p -> api().listIsos(page = p).let { r -> r.isos to r.meta } }

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
        apis().flatMap { fetchAllPages { p -> it.listLoadBalancers(page = p).let { r -> r.loadBalancers to r.meta } } }

    suspend fun getLoadBalancer(id: Long): de.kiefer_networks.falco.data.dto.CloudLoadBalancer =
        api().getLoadBalancer(id).loadBalancer

    suspend fun createLoadBalancer(
        name: String,
        type: String,
        location: String? = null,
        networkZone: String? = null,
        algorithm: String = "round_robin",
        publicInterface: Boolean = true,
        projectId: String? = null,
    ): de.kiefer_networks.falco.data.dto.CloudLoadBalancer = api(projectId).createLoadBalancer(
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

    suspend fun deleteLoadBalancer(id: Long, projectId: String? = null) = api(projectId).deleteLoadBalancer(id).orThrow()

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
        de.kiefer_networks.falco.data.dto.ChangeLbAlgorithmRequest(type = algorithm),
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
            de.kiefer_networks.falco.data.dto.ChangeDnsPtrRequest(ip = ip, dnsPtr = dnsPtr?.takeIf { it.isNotBlank() }),
        )

    suspend fun listLoadBalancerTypes(): List<de.kiefer_networks.falco.data.dto.CloudLoadBalancerType> =
        api().listLoadBalancerTypes().loadBalancerTypes

    // ---- Certificates ------------------------------------------------------

    suspend fun listCertificates(): List<de.kiefer_networks.falco.data.dto.CloudCertificate> =
        apis().flatMap { fetchAllPages { p -> it.listCertificates(page = p).let { r -> r.certificates to r.meta } } }

    suspend fun getCertificate(id: Long): de.kiefer_networks.falco.data.dto.CloudCertificate =
        api().getCertificate(id).certificate

    suspend fun uploadCertificate(
        name: String,
        certificate: String,
        privateKey: String,
        projectId: String? = null,
    ) =
        api(projectId).createCertificate(
            de.kiefer_networks.falco.data.dto.CreateCertificateRequest(
                name = name,
                type = "uploaded",
                certificate = certificate,
                privateKey = privateKey,
            ),
        ).certificate

    suspend fun requestManagedCertificate(
        name: String,
        domainNames: List<String>,
        projectId: String? = null,
    ) =
        api(projectId).createCertificate(
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

    suspend fun deleteCertificate(id: Long, projectId: String? = null) = api(projectId).deleteCertificate(id).orThrow()
    suspend fun retryCertificate(id: Long) = api().retryCertificate(id)

    // ---- Placement Groups --------------------------------------------------

    suspend fun listPlacementGroups(): List<de.kiefer_networks.falco.data.dto.CloudPlacementGroup> =
        apis().flatMap { fetchAllPages { p -> it.listPlacementGroups(page = p).let { r -> r.placementGroups to r.meta } } }

    suspend fun getPlacementGroup(id: Long): de.kiefer_networks.falco.data.dto.CloudPlacementGroup =
        api().getPlacementGroup(id).placementGroup

    suspend fun createPlacementGroup(
        name: String,
        type: String = "spread",
        projectId: String? = null,
    ) =
        api(projectId).createPlacementGroup(
            de.kiefer_networks.falco.data.dto.CreatePlacementGroupRequest(name = name, type = type),
        ).placementGroup

    suspend fun renamePlacementGroup(id: Long, name: String) = api().updatePlacementGroup(
        id,
        de.kiefer_networks.falco.data.dto.UpdatePlacementGroupRequest(name = name),
    ).placementGroup

    suspend fun deletePlacementGroup(id: Long, projectId: String? = null) = api(projectId).deletePlacementGroup(id).orThrow()

    // ---- ISO detail --------------------------------------------------------

    suspend fun getIso(id: Long): de.kiefer_networks.falco.data.dto.CloudIso = api().getIso(id).iso

    private companion object {
        val ACTIVITY_COLLECTIONS = listOf(
            "servers", "volumes", "networks", "firewalls", "floating_ips",
            "primary_ips", "load_balancers", "certificates", "images",
        )
    }

}
