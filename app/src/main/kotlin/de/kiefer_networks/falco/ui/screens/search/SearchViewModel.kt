// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.search

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.api.CloudApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.StorageBoxApi
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.dto.CloudCertificate
import de.kiefer_networks.falco.data.dto.CloudFirewall
import de.kiefer_networks.falco.data.dto.CloudFloatingIp
import de.kiefer_networks.falco.data.dto.CloudLoadBalancer
import de.kiefer_networks.falco.data.dto.CloudNetwork
import de.kiefer_networks.falco.data.dto.CloudPlacementGroup
import de.kiefer_networks.falco.data.dto.CloudPrimaryIp
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudSshKey
import de.kiefer_networks.falco.data.dto.CloudStorageBox
import de.kiefer_networks.falco.data.dto.CloudVolume
import de.kiefer_networks.falco.data.dto.DnsZone
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.repo.DnsRepo
import de.kiefer_networks.falco.data.repo.RobotRepo
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import javax.inject.Inject

enum class ResultKind {
    CloudServer, RobotServer, Volume, Network, FloatingIp, Firewall,
    StorageBox, DnsZone, SshKey, LoadBalancer, Certificate, PlacementGroup,
    PrimaryIp, Computer,
}

data class SearchHit(
    val kind: ResultKind,
    val id: String,
    val title: String,
    val subtitle: String,
    val projectId: String? = null,
)

private data class ProjectIndex(
    val projectId: String,
    val cloudServers: List<CloudServer> = emptyList(),
    val volumes: List<CloudVolume> = emptyList(),
    val networks: List<CloudNetwork> = emptyList(),
    val floatingIps: List<CloudFloatingIp> = emptyList(),
    val firewalls: List<CloudFirewall> = emptyList(),
    val storageBoxes: List<CloudStorageBox> = emptyList(),
    val sshKeys: List<CloudSshKey> = emptyList(),
    val loadBalancers: List<CloudLoadBalancer> = emptyList(),
    val certificates: List<CloudCertificate> = emptyList(),
    val placementGroups: List<CloudPlacementGroup> = emptyList(),
    val primaryIps: List<CloudPrimaryIp> = emptyList(),
)

private data class SearchCache(
    val projects: List<ProjectIndex> = emptyList(),
    val robotServers: List<RobotServer> = emptyList(),
    val dnsZones: List<DnsZone> = emptyList(),
)

data class SearchUiState(
    val query: String = "",
    val indexing: Boolean = true,
    val results: List<SearchHit> = emptyList(),
)

@HiltViewModel
class SearchViewModel @Inject constructor(
    private val accounts: AccountManager,
    private val robot: RobotRepo,
    private val dns: DnsRepo,
) : ViewModel() {

    private val _state = MutableStateFlow(SearchUiState())
    val state: StateFlow<SearchUiState> = _state.asStateFlow()

    private var cache = SearchCache()

    init { refresh() }

    fun refresh() {
        _state.value = _state.value.copy(indexing = true)
        viewModelScope.launch {
            cache = loadAll()
            _state.value = _state.value.copy(indexing = false)
            applyFilter(_state.value.query)
        }
    }

    fun onQueryChange(value: String) {
        _state.value = _state.value.copy(query = value)
        applyFilter(value)
    }

    /**
     * Switch the active Cloud project, then run [onCommitted] on the main thread.
     *
     * The DataStore write is async — callers that navigate to a project-scoped
     * detail screen must wait for the commit, otherwise the new screen's
     * Hilt-injected repo will read the previous project's token. Run nav inside
     * [onCommitted] (not after this call) so it observes the new value.
     */
    fun selectProjectThen(projectId: String, onCommitted: () -> Unit) {
        viewModelScope.launch {
            val accountId = accounts.activeAccountId.first()
            if (accountId != null) {
                accounts.setActiveCloudProject(accountId, projectId)
            }
            onCommitted()
        }
    }

    private fun applyFilter(query: String) {
        if (query.isBlank()) {
            _state.value = _state.value.copy(results = emptyList())
            return
        }
        val needle = query.trim().lowercase()
        val hits = mutableListOf<SearchHit>()

        cache.projects.forEach { idx ->
            idx.cloudServers.forEach { s ->
                if (s.name.lowercase().contains(needle) ||
                    s.publicNet?.ipv4?.ip?.contains(needle) == true ||
                    s.publicNet?.ipv6?.ip?.lowercase()?.contains(needle) == true
                ) {
                    hits += SearchHit(
                        kind = ResultKind.CloudServer,
                        id = s.id.toString(),
                        title = s.name,
                        subtitle = listOfNotNull(
                            s.serverType?.name,
                            s.datacenter?.location?.city ?: s.datacenter?.location?.name,
                            s.publicNet?.ipv4?.ip,
                        ).joinToString(" · "),
                        projectId = idx.projectId,
                    )
                }
            }
            idx.volumes.forEach { v ->
                if (v.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        ResultKind.Volume, v.id.toString(), v.name,
                        "${v.size} GB · ${v.status}", idx.projectId,
                    )
                }
            }
            idx.networks.forEach { n ->
                if (n.name.lowercase().contains(needle) || n.ipRange.contains(needle)) {
                    hits += SearchHit(ResultKind.Network, n.id.toString(), n.name, n.ipRange, idx.projectId)
                }
            }
            idx.floatingIps.forEach { fip ->
                val name = fip.name ?: fip.ip
                if (name.lowercase().contains(needle) || fip.ip.contains(needle)) {
                    hits += SearchHit(
                        ResultKind.FloatingIp, fip.id.toString(), name,
                        "${fip.type.uppercase()} · ${fip.ip}", idx.projectId,
                    )
                }
            }
            idx.firewalls.forEach { fw ->
                if (fw.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        ResultKind.Firewall, fw.id.toString(), fw.name,
                        "${fw.rules.size} rules", idx.projectId,
                    )
                }
            }
            idx.storageBoxes.forEach { sb ->
                val username = sb.username.orEmpty()
                if (sb.name.lowercase().contains(needle) || username.lowercase().contains(needle)) {
                    hits += SearchHit(
                        ResultKind.StorageBox, sb.id.toString(), sb.name, username, idx.projectId,
                    )
                }
            }
            idx.loadBalancers.forEach { lb ->
                if (lb.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        ResultKind.LoadBalancer, lb.id.toString(), lb.name,
                        listOfNotNull(lb.type?.name, lb.location?.name).joinToString(" · "),
                        idx.projectId,
                    )
                }
            }
            idx.certificates.forEach { c ->
                if (c.name.lowercase().contains(needle) ||
                    c.domainNames.any { it.lowercase().contains(needle) }
                ) {
                    hits += SearchHit(
                        ResultKind.Certificate, c.id.toString(), c.name,
                        c.domainNames.joinToString(", ").take(48),
                        idx.projectId,
                    )
                }
            }
            idx.placementGroups.forEach { pg ->
                if (pg.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        ResultKind.PlacementGroup, pg.id.toString(), pg.name,
                        "${pg.type} · ${pg.servers.size} servers",
                        idx.projectId,
                    )
                }
            }
            idx.sshKeys.forEach { sk ->
                if (sk.name.lowercase().contains(needle) || sk.fingerprint.lowercase().contains(needle)) {
                    hits += SearchHit(
                        ResultKind.SshKey, sk.id.toString(), sk.name, sk.fingerprint, idx.projectId,
                    )
                }
            }
            idx.primaryIps.forEach { p ->
                if (p.name.lowercase().contains(needle) || p.ip.contains(needle)) {
                    hits += SearchHit(
                        ResultKind.PrimaryIp, p.id.toString(), p.name,
                        "${p.type.uppercase()} · ${p.ip}", idx.projectId,
                    )
                }
            }
        }

        cache.robotServers.forEach { s ->
            val title = s.serverName ?: s.serverIp ?: "#${s.serverNumber}"
            if (title.lowercase().contains(needle) ||
                s.serverIp?.contains(needle) == true ||
                s.serverIpv6Net?.lowercase()?.contains(needle) == true
            ) {
                hits += SearchHit(
                    ResultKind.RobotServer, s.serverNumber.toString(), title,
                    listOfNotNull(s.product, s.dc, s.serverIp).joinToString(" · "),
                )
            }
        }

        cache.dnsZones.forEach { z ->
            if (z.name.lowercase().contains(needle)) {
                hits += SearchHit(ResultKind.DnsZone, z.id, z.name, "${z.recordsCount ?: 0} records")
            }
        }

        val priority = listOf(
            ResultKind.CloudServer, ResultKind.RobotServer, ResultKind.Volume,
            ResultKind.FloatingIp, ResultKind.PrimaryIp, ResultKind.Network,
            ResultKind.Firewall, ResultKind.LoadBalancer, ResultKind.Certificate,
            ResultKind.PlacementGroup, ResultKind.StorageBox, ResultKind.SshKey,
            ResultKind.DnsZone,
        )
        val ordered = hits.sortedWith(compareBy({ priority.indexOf(it.kind) }, { it.title.lowercase() }))
        _state.value = _state.value.copy(results = ordered)
    }

    private suspend fun loadAll(): SearchCache = coroutineScope {
        val accountId = accounts.activeAccountId.first()
        val projects = if (accountId == null) emptyList() else accounts.cloudProjects(accountId)

        val perProjectAsync = projects.map { p ->
            async {
                val api = HttpClientFactory.cloudRetrofit(p.cloudToken).create(CloudApi::class.java)
                val sbApi = HttpClientFactory.storageBoxRetrofit(p.cloudToken).create(StorageBoxApi::class.java)
                ProjectIndex(
                    projectId = p.id,
                    cloudServers = runCatching { api.listServers().servers }.getOrDefault(emptyList()),
                    volumes = runCatching { api.listVolumes().volumes }.getOrDefault(emptyList()),
                    networks = runCatching { api.listNetworks().networks }.getOrDefault(emptyList()),
                    floatingIps = runCatching { api.listFloatingIps().floatingIps }.getOrDefault(emptyList()),
                    firewalls = runCatching { api.listFirewalls().firewalls }.getOrDefault(emptyList()),
                    storageBoxes = runCatching { sbApi.listStorageBoxes().storageBoxes }.getOrDefault(emptyList()),
                    sshKeys = runCatching { api.listSshKeys().sshKeys }.getOrDefault(emptyList()),
                    loadBalancers = runCatching { api.listLoadBalancers().loadBalancers }.getOrDefault(emptyList()),
                    certificates = runCatching { api.listCertificates().certificates }.getOrDefault(emptyList()),
                    placementGroups = runCatching { api.listPlacementGroups().placementGroups }.getOrDefault(emptyList()),
                    primaryIps = runCatching { api.listPrimaryIps().primaryIps }.getOrDefault(emptyList()),
                )
            }
        }
        val robotServersAsync = async { runCatching { robot.listServers() }.getOrDefault(emptyList()) }
        val dnsZonesAsync = async { runCatching { dns.listZones() }.getOrDefault(emptyList()) }

        SearchCache(
            projects = perProjectAsync.awaitAll(),
            robotServers = robotServersAsync.await(),
            dnsZones = dnsZonesAsync.await(),
        )
    }
}
