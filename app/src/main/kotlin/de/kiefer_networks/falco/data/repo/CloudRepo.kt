// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.CloudApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.dto.CloudServer
import de.kiefer_networks.falco.data.dto.CloudVolume
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class CloudRepo @Inject constructor(private val accounts: AccountManager) {

    private suspend fun api(): CloudApi {
        val token = requireNotNull(accounts.activeSecrets()?.cloudToken) {
            "No Cloud API token configured for active account"
        }
        return HttpClientFactory.cloudRetrofit(token).create(CloudApi::class.java)
    }

    suspend fun listServers(): List<CloudServer> = api().listServers().servers
    suspend fun listVolumes(): List<CloudVolume> = api().listVolumes().volumes

    suspend fun powerOn(id: Long) = api().powerOn(id)
    suspend fun powerOff(id: Long) = api().powerOff(id)
    suspend fun reboot(id: Long) = api().reboot(id)
    suspend fun shutdown(id: Long) = api().shutdown(id)
    suspend fun reset(id: Long) = api().reset(id)
    suspend fun snapshot(id: Long) = api().snapshot(id)
}
