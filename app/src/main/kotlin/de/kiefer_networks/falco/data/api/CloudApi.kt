// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.CloudFirewallList
import de.kiefer_networks.falco.data.dto.CloudFloatingIpList
import de.kiefer_networks.falco.data.dto.CloudNetworkList
import de.kiefer_networks.falco.data.dto.CloudServerList
import de.kiefer_networks.falco.data.dto.CloudVolumeList
import de.kiefer_networks.falco.data.dto.ServerAction
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query

interface CloudApi {
    @GET("servers")
    suspend fun listServers(
        @Query("page") page: Int = 1,
        @Query("per_page") perPage: Int = 50,
    ): CloudServerList

    @POST("servers/{id}/actions/poweron")
    suspend fun powerOn(@Path("id") id: Long): ServerAction

    @POST("servers/{id}/actions/poweroff")
    suspend fun powerOff(@Path("id") id: Long): ServerAction

    @POST("servers/{id}/actions/reboot")
    suspend fun reboot(@Path("id") id: Long): ServerAction

    @POST("servers/{id}/actions/shutdown")
    suspend fun shutdown(@Path("id") id: Long): ServerAction

    @POST("servers/{id}/actions/reset")
    suspend fun reset(@Path("id") id: Long): ServerAction

    @POST("servers/{id}/actions/create_image")
    suspend fun snapshot(@Path("id") id: Long): ServerAction

    @GET("volumes")
    suspend fun listVolumes(): CloudVolumeList

    @GET("firewalls")
    suspend fun listFirewalls(): CloudFirewallList

    @GET("floating_ips")
    suspend fun listFloatingIps(): CloudFloatingIpList

    @GET("networks")
    suspend fun listNetworks(): CloudNetworkList
}

/**
 * Storage Box endpoints. Hetzner moved Storage Boxes to a separate base URL
 * (`api.hetzner.com`) on 2025-06-25 — same Bearer token, different host.
 * Kept as its own Retrofit interface so [HttpClientFactory] routes it through
 * a dedicated client.
 */
interface StorageBoxApi {
    @GET("storage_boxes")
    suspend fun listStorageBoxes(): de.kiefer_networks.falco.data.dto.CloudStorageBoxList

    @GET("storage_boxes/{id}")
    suspend fun getStorageBox(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudStorageBoxEnvelope

    @retrofit2.http.POST("storage_boxes/{id}/actions/reset_password")
    suspend fun resetStorageBoxPassword(
        @Path("id") id: Long,
        @retrofit2.http.Body body: de.kiefer_networks.falco.data.dto.ResetStorageBoxPasswordRequest,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxActionResponse

    @retrofit2.http.POST("storage_boxes/{id}/actions/update_access_settings")
    suspend fun updateStorageBoxAccessSettings(
        @Path("id") id: Long,
        @retrofit2.http.Body body: de.kiefer_networks.falco.data.dto.UpdateStorageBoxAccessSettings,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxActionResponse

    @GET("storage_boxes/{id}/snapshots")
    suspend fun listStorageBoxSnapshots(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudStorageBoxSnapshotList

    @retrofit2.http.POST("storage_boxes/{id}/snapshots")
    suspend fun createStorageBoxSnapshot(
        @Path("id") id: Long,
        @retrofit2.http.Body body: de.kiefer_networks.falco.data.dto.CreateStorageBoxSnapshot,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxSnapshotEnvelope

    @retrofit2.http.DELETE("storage_boxes/{id}/snapshots/{snap}")
    suspend fun deleteStorageBoxSnapshot(
        @Path("id") id: Long,
        @Path("snap") snapshotId: Long,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxActionResponse

    @retrofit2.http.POST("storage_boxes/{id}/snapshots/{snap}/actions/rollback")
    suspend fun rollbackStorageBoxSnapshot(
        @Path("id") id: Long,
        @Path("snap") snapshotId: Long,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxActionResponse

    @GET("storage_boxes/{id}/subaccounts")
    suspend fun listStorageBoxSubaccounts(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudStorageBoxSubaccountList

    @retrofit2.http.POST("storage_boxes/{id}/subaccounts")
    suspend fun createStorageBoxSubaccount(
        @Path("id") id: Long,
        @retrofit2.http.Body body: de.kiefer_networks.falco.data.dto.CreateStorageBoxSubaccount,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxSubaccountEnvelope

    @retrofit2.http.DELETE("storage_boxes/{id}/subaccounts/{sub}")
    suspend fun deleteStorageBoxSubaccount(
        @Path("id") id: Long,
        @Path("sub") subaccountId: Long,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxActionResponse

    @retrofit2.http.PUT("storage_boxes/{id}/subaccounts/{sub}")
    suspend fun updateStorageBoxSubaccount(
        @Path("id") id: Long,
        @Path("sub") subaccountId: Long,
        @retrofit2.http.Body body: de.kiefer_networks.falco.data.dto.UpdateStorageBoxSubaccount,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxSubaccountEnvelope

    @retrofit2.http.POST("storage_boxes/{id}/subaccounts/{sub}/actions/reset_subaccount_password")
    suspend fun resetSubaccountPassword(
        @Path("id") id: Long,
        @Path("sub") subaccountId: Long,
        @retrofit2.http.Body body: de.kiefer_networks.falco.data.dto.ResetSubaccountPasswordRequest,
    ): de.kiefer_networks.falco.data.dto.CloudStorageBoxActionResponse
}
