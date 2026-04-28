// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.RobotApi
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.dto.RobotFailover
import de.kiefer_networks.falco.data.dto.RobotServer
import de.kiefer_networks.falco.data.dto.RobotStorageBox
import de.kiefer_networks.falco.data.dto.RobotVSwitch
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
    suspend fun listStorageBoxes(): List<RobotStorageBox> = api().listStorageBoxes().map { it.storageBox }

    suspend fun reset(serverNumber: Long, type: String) = api().reset(serverNumber, type).reset
    suspend fun wakeOnLan(serverNumber: Long) = api().wakeOnLan(serverNumber)

    suspend fun snapshots(boxId: Long) = api().listSnapshots(boxId).map { it.snapshot }
    suspend fun createSnapshot(boxId: Long) = api().createSnapshot(boxId).snapshot
    suspend fun subaccounts(boxId: Long) = api().listSubaccounts(boxId).map { it.subaccount }

    suspend fun listFailoverIps(): List<RobotFailover> = api().listFailoverIps().map { it.failover }
    suspend fun listVSwitches(): List<RobotVSwitch> = api().listVSwitches().map { it.vswitch }
}
