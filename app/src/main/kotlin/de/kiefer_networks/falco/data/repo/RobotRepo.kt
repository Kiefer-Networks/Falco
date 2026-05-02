// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.RobotApi
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.dto.RobotFailover
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.dto.RobotVSwitch
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.contentOrNull
import kotlinx.serialization.json.doubleOrNull
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class RobotRepo @Inject constructor(private val accounts: AccountManager) {

    private suspend fun api(): RobotApi {
        val s = accounts.activeSecrets()
        val user = requireNotNull(s?.robotUser) { "Robot user missing" }
        val pass = requireNotNull(s.robotPass) { "Robot password missing" }
        return HttpClientFactory.robotRetrofit(user, pass).create(RobotApi::class.java)
    }

    suspend fun listServers(): List<RobotServer> = api().listServers().map { it.server }
    suspend fun getServer(serverNumber: Long): RobotServer = api().getServer(serverNumber).server

    suspend fun reset(serverNumber: Long, type: String) = api().reset(serverNumber, type).reset
    suspend fun wakeOnLan(serverNumber: Long) = api().wakeOnLan(serverNumber)
    suspend fun resetOptions(serverNumber: Long) = api().resetOptions(serverNumber).reset

    suspend fun listFailoverIps(): List<RobotFailover> = api().listFailoverIps().map { it.failover }
    suspend fun listVSwitches(): List<RobotVSwitch> = api().listVSwitches().map { it.vswitch }

    suspend fun listSshKeys(): List<de.kiefer_networks.falco.data.dto.RobotSshKey> =
        api().listKeys().map { it.key }
    suspend fun createSshKey(name: String, data: String): de.kiefer_networks.falco.data.dto.RobotSshKey =
        api().createKey(name, data).key
    suspend fun deleteSshKey(fingerprint: String) = api().deleteKey(fingerprint)

    // ---- Failover routing -------------------------------------------------

    suspend fun routeFailover(failoverIp: String, targetServerIp: String) =
        api().routeFailover(failoverIp, targetServerIp).failover
    suspend fun unrouteFailover(failoverIp: String) = api().unrouteFailover(failoverIp)

    // ---- Reverse DNS ------------------------------------------------------

    suspend fun listRdns(): List<de.kiefer_networks.falco.data.dto.RobotRdns> =
        api().listRdns().map { it.rdns }
    suspend fun getRdns(ip: String): de.kiefer_networks.falco.data.dto.RobotRdns = api().getRdns(ip).rdns
    suspend fun setRdns(ip: String, ptr: String) = api().setRdns(ip, ptr).rdns
    suspend fun deleteRdns(ip: String) = api().deleteRdns(ip)

    // ---- vSwitch CRUD -----------------------------------------------------

    suspend fun getVSwitch(id: Long): RobotVSwitch = api().getVSwitch(id).vswitch
    suspend fun createVSwitch(name: String, vlan: Int): RobotVSwitch = api().createVSwitch(name, vlan).vswitch
    suspend fun updateVSwitch(id: Long, name: String, vlan: Int): RobotVSwitch =
        api().updateVSwitch(id, name, vlan).vswitch
    suspend fun deleteVSwitch(id: Long, cancellationDate: String? = null) =
        api().deleteVSwitch(id, cancellationDate)
    suspend fun attachServerToVSwitch(vswitchId: Long, serverNumber: Long) =
        api().attachServerToVSwitch(vswitchId, serverNumber)
    suspend fun detachServerFromVSwitch(vswitchId: Long, serverNumber: Long) =
        api().detachServerFromVSwitch(vswitchId, serverNumber)

    // ---- Rescue / Boot ---------------------------------------------------

    suspend fun bootOptions(serverNumber: Long): de.kiefer_networks.falco.data.dto.RobotBoot =
        api().bootOptions(serverNumber).boot
    suspend fun rescueOptions(serverNumber: Long): de.kiefer_networks.falco.data.dto.RobotRescue =
        api().rescueOptions(serverNumber).rescue
    suspend fun enableRescue(serverNumber: Long, os: String = "linux", authorizedKey: String? = null) =
        api().enableRescue(serverNumber, os, authorizedKey).rescue
    suspend fun disableRescue(serverNumber: Long) = api().disableRescue(serverNumber)

    // ---- Cancellation ----------------------------------------------------

    suspend fun getCancellation(serverNumber: Long): de.kiefer_networks.falco.data.dto.RobotCancellation =
        api().getCancellation(serverNumber).cancellation
    suspend fun cancelServer(serverNumber: Long, cancellationDate: String, reason: String? = null) =
        api().cancelServer(serverNumber, cancellationDate, reason).cancellation
    suspend fun withdrawCancellation(serverNumber: Long) = api().withdrawCancellation(serverNumber)

    // ---- Traffic ---------------------------------------------------------

    suspend fun listTraffic(): de.kiefer_networks.falco.data.dto.RobotTrafficResponse = api().listTraffic()

    /**
     * Per-IP traffic consumption (in/out/sum, GB) for the current calendar
     * month. Parses the loosely-typed `/traffic` envelope. Returns an empty
     * map when the response shape doesn't match — Hetzner Robot responds with
     * a flat error body inside the `traffic` field for IPs that have no data
     * yet. Caller passes the IPv4 list to query.
     */
    suspend fun monthlyTraffic(ips: List<String>): Map<String, TrafficStats> {
        if (ips.isEmpty()) return emptyMap()
        val now = java.time.LocalDate.now()
        val from = now.withDayOfMonth(1).toString()
        val to = now.toString()
        val raw = api().queryTraffic("month", from, to, ips).traffic ?: return emptyMap()
        val obj = (raw as? JsonObject) ?: return emptyMap()
        val data = (obj["data"] as? JsonObject) ?: return emptyMap()
        return data.mapValues { (_, value) ->
            val v = (value as? JsonObject) ?: return@mapValues TrafficStats()
            fun field(name: String): Double =
                (v[name] as? JsonPrimitive)?.doubleOrNull
                    ?: (v[name] as? JsonPrimitive)?.contentOrNull?.toDoubleOrNull()
                    ?: 0.0
            TrafficStats(inGb = field("in"), outGb = field("out"), sumGb = field("sum"))
        }
    }
}

/** Traffic counts in GB. Hetzner Robot reports per IPv4. */
data class TrafficStats(val inGb: Double = 0.0, val outGb: Double = 0.0, val sumGb: Double = 0.0)
