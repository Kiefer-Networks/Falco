// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.CloudApi
import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.StorageBoxApi
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.dto.ActionEnvelope
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
    suspend fun enableBackup(id: Long) = api().enableBackup(id)
    suspend fun disableBackup(id: Long) = api().disableBackup(id)
    suspend fun attachIso(id: Long, iso: String) = api().attachIso(id, AttachIsoRequest(iso))
    suspend fun detachIso(id: Long) = api().detachIso(id)

    suspend fun changeServerType(id: Long, type: String, upgradeDisk: Boolean = false) =
        api().changeServerType(id, ChangeServerTypeRequest(type, upgradeDisk))

    suspend fun setServerProtection(id: Long, delete: Boolean? = null, rebuild: Boolean? = null) =
        api().changeServerProtection(id, ChangeProtectionRequest(delete, rebuild))

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
}
