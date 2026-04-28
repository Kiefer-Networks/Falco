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
}
