// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.search

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.repo.CloudRepo
import de.kiefer_networks.falco.data.repo.DnsRepo
import de.kiefer_networks.falco.data.repo.RobotRepo
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
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
)

data class SearchUiState(
    val query: String = "",
    val loading: Boolean = false,
    val results: List<SearchHit> = emptyList(),
)

@HiltViewModel
class SearchViewModel @Inject constructor(
    private val cloud: CloudRepo,
    private val robot: RobotRepo,
    private val dns: DnsRepo,
) : ViewModel() {

    private val _state = MutableStateFlow(SearchUiState())
    val state: StateFlow<SearchUiState> = _state.asStateFlow()

    private var debounceJob: Job? = null

    fun onQueryChange(value: String) {
        _state.value = _state.value.copy(query = value)
        debounceJob?.cancel()
        if (value.isBlank()) {
            _state.value = _state.value.copy(loading = false, results = emptyList())
            return
        }
        debounceJob = viewModelScope.launch {
            delay(250)
            runSearch(value)
        }
    }

    private suspend fun runSearch(q: String) {
        _state.value = _state.value.copy(loading = true)
        val needle = q.trim().lowercase()
        val hits = mutableListOf<SearchHit>()

        runCatching {
            cloud.listServers().forEach { s ->
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
                    )
                }
            }
        }

        runCatching {
            cloud.listVolumes().forEach { v ->
                if (v.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.Volume,
                        id = v.id.toString(),
                        title = v.name,
                        subtitle = "${v.size} GB · ${v.status}",
                    )
                }
            }
        }

        runCatching {
            cloud.listNetworks().forEach { n ->
                if (n.name.lowercase().contains(needle) || n.ipRange.contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.Network,
                        id = n.id.toString(),
                        title = n.name,
                        subtitle = n.ipRange,
                    )
                }
            }
        }

        runCatching {
            cloud.listFloatingIps().forEach { fip ->
                val name = fip.name ?: fip.ip
                if (name.lowercase().contains(needle) || fip.ip.contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.FloatingIp,
                        id = fip.id.toString(),
                        title = name,
                        subtitle = "${fip.type.uppercase()} · ${fip.ip}",
                    )
                }
            }
        }

        runCatching {
            cloud.listFirewalls().forEach { fw ->
                if (fw.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.Firewall,
                        id = fw.id.toString(),
                        title = fw.name,
                        subtitle = "${fw.rules.size} rules",
                    )
                }
            }
        }

        runCatching {
            cloud.listStorageBoxes().forEach { sb ->
                val username = sb.username.orEmpty()
                if (sb.name.lowercase().contains(needle) || username.lowercase().contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.StorageBox,
                        id = sb.id.toString(),
                        title = sb.name,
                        subtitle = username,
                    )
                }
            }
        }

        runCatching {
            cloud.listLoadBalancers().forEach { lb ->
                if (lb.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.LoadBalancer,
                        id = lb.id.toString(),
                        title = lb.name,
                        subtitle = listOfNotNull(lb.type?.name, lb.location?.name).joinToString(" · "),
                    )
                }
            }
        }

        runCatching {
            cloud.listCertificates().forEach { c ->
                if (c.name.lowercase().contains(needle) ||
                    c.domainNames.any { it.lowercase().contains(needle) }
                ) {
                    hits += SearchHit(
                        kind = ResultKind.Certificate,
                        id = c.id.toString(),
                        title = c.name,
                        subtitle = c.domainNames.joinToString(", ").take(48),
                    )
                }
            }
        }

        runCatching {
            cloud.listPlacementGroups().forEach { pg ->
                if (pg.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.PlacementGroup,
                        id = pg.id.toString(),
                        title = pg.name,
                        subtitle = "${pg.type} · ${pg.servers.size} servers",
                    )
                }
            }
        }

        runCatching {
            cloud.listSshKeys().forEach { sk ->
                if (sk.name.lowercase().contains(needle) || sk.fingerprint.lowercase().contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.SshKey,
                        id = sk.id.toString(),
                        title = sk.name,
                        subtitle = sk.fingerprint,
                    )
                }
            }
        }

        runCatching {
            cloud.listPrimaryIps().forEach { p ->
                if (p.name.lowercase().contains(needle) || p.ip.contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.PrimaryIp,
                        id = p.id.toString(),
                        title = p.name,
                        subtitle = "${p.type.uppercase()} · ${p.ip}",
                    )
                }
            }
        }

        runCatching {
            robot.listServers().forEach { s ->
                val title = s.serverName ?: s.serverIp ?: "#${s.serverNumber}"
                if (title.lowercase().contains(needle) ||
                    s.serverIp?.contains(needle) == true ||
                    s.serverIpv6Net?.lowercase()?.contains(needle) == true
                ) {
                    hits += SearchHit(
                        kind = ResultKind.RobotServer,
                        id = s.serverNumber.toString(),
                        title = title,
                        subtitle = listOfNotNull(s.product, s.dc, s.serverIp).joinToString(" · "),
                    )
                }
            }
        }

        runCatching {
            dns.listZones().forEach { z ->
                if (z.name.lowercase().contains(needle)) {
                    hits += SearchHit(
                        kind = ResultKind.DnsZone,
                        id = z.id,
                        title = z.name,
                        subtitle = "${z.recordsCount ?: 0} records",
                    )
                }
            }
        }

        // Stable order: most-likely-relevant kinds first.
        val priority = listOf(
            ResultKind.CloudServer, ResultKind.RobotServer, ResultKind.Volume,
            ResultKind.FloatingIp, ResultKind.PrimaryIp, ResultKind.Network,
            ResultKind.Firewall, ResultKind.LoadBalancer, ResultKind.Certificate,
            ResultKind.PlacementGroup, ResultKind.StorageBox, ResultKind.SshKey,
            ResultKind.DnsZone,
        )
        val ordered = hits.sortedWith(compareBy({ priority.indexOf(it.kind) }, { it.title.lowercase() }))

        _state.value = _state.value.copy(loading = false, results = ordered)
    }
}
