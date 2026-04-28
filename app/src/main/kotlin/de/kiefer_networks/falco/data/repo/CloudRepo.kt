// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.CloudApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.StorageBoxApi
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.dto.CloudFirewall
import de.kiefer_networks.falco.data.dto.CloudFloatingIp
import de.kiefer_networks.falco.data.dto.CloudNetwork
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudStorageBox
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
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class CloudRepo @Inject constructor(private val accounts: AccountManager) {

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

    suspend fun listServers(): List<CloudServer> = api().listServers().servers
    suspend fun listVolumes(): List<CloudVolume> = api().listVolumes().volumes
    suspend fun listFirewalls(): List<CloudFirewall> = api().listFirewalls().firewalls
    suspend fun listFloatingIps(): List<CloudFloatingIp> = api().listFloatingIps().floatingIps
    suspend fun listNetworks(): List<CloudNetwork> = api().listNetworks().networks
    suspend fun listStorageBoxes(): List<CloudStorageBox> = storageBoxApi().listStorageBoxes().storageBoxes

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
}
