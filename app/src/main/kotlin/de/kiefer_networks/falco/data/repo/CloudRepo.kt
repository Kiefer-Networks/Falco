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
import de.kiefer_networks.falco.data.dto.CloudVolume
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

    suspend fun powerOn(id: Long) = api().powerOn(id)
    suspend fun powerOff(id: Long) = api().powerOff(id)
    suspend fun reboot(id: Long) = api().reboot(id)
    suspend fun shutdown(id: Long) = api().shutdown(id)
    suspend fun reset(id: Long) = api().reset(id)
    suspend fun snapshot(id: Long) = api().snapshot(id)
}
