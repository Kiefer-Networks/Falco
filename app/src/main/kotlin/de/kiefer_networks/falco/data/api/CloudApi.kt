// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.AttachIsoRequest
import de.kiefer_networks.falco.data.dto.ChangeProtectionRequest
import de.kiefer_networks.falco.data.dto.ChangeServerTypeRequest
import de.kiefer_networks.falco.data.dto.CloudFirewallList
import de.kiefer_networks.falco.data.dto.CloudFloatingIpList
import de.kiefer_networks.falco.data.dto.CloudImageList
import de.kiefer_networks.falco.data.dto.CloudIsoList
import de.kiefer_networks.falco.data.dto.CloudMetricsResponse
import de.kiefer_networks.falco.data.dto.CloudNetworkList
import de.kiefer_networks.falco.data.dto.CloudServerActionResponse
import de.kiefer_networks.falco.data.dto.CloudServerEnvelope
import de.kiefer_networks.falco.data.dto.CloudServerList
import de.kiefer_networks.falco.data.dto.CloudServerTypeList
import de.kiefer_networks.falco.data.dto.CloudVolumeList
import de.kiefer_networks.falco.data.dto.EnableRescueRequest
import de.kiefer_networks.falco.data.dto.RebuildServerRequest
import de.kiefer_networks.falco.data.dto.ServerAction
import de.kiefer_networks.falco.data.dto.UpdateServerRequest
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.PUT
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query

interface CloudApi {
    @GET("servers")
    suspend fun listServers(
        @Query("page") page: Int = 1,
        @Query("per_page") perPage: Int = 50,
    ): CloudServerList

    @POST("servers")
    suspend fun createServer(
        @Body body: de.kiefer_networks.falco.data.dto.CreateServerRequest,
    ): de.kiefer_networks.falco.data.dto.CreateServerResponse

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

    @GET("volumes/{id}")
    suspend fun getVolume(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudVolumeEnvelope

    @POST("volumes")
    suspend fun createVolume(
        @Body body: de.kiefer_networks.falco.data.dto.CreateVolumeRequest,
    ): de.kiefer_networks.falco.data.dto.CreateVolumeResponse

    @PUT("volumes/{id}")
    suspend fun updateVolume(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdateVolumeRequest,
    ): de.kiefer_networks.falco.data.dto.CloudVolumeEnvelope

    @DELETE("volumes/{id}")
    suspend fun deleteVolume(@Path("id") id: Long): retrofit2.Response<Unit>

    @POST("volumes/{id}/actions/attach")
    suspend fun attachVolume(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.AttachVolumeRequest,
    ): CloudServerActionResponse

    @POST("volumes/{id}/actions/detach")
    suspend fun detachVolume(@Path("id") id: Long): CloudServerActionResponse

    @POST("volumes/{id}/actions/resize")
    suspend fun resizeVolume(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ResizeVolumeRequest,
    ): CloudServerActionResponse

    @POST("volumes/{id}/actions/change_protection")
    suspend fun changeVolumeProtection(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ChangeProtectionRequest,
    ): CloudServerActionResponse

    @GET("firewalls")
    suspend fun listFirewalls(): CloudFirewallList

    @POST("firewalls")
    suspend fun createFirewall(
        @Body body: de.kiefer_networks.falco.data.dto.CreateFirewallRequest,
    ): de.kiefer_networks.falco.data.dto.CreateFirewallResponse

    @GET("floating_ips")
    suspend fun listFloatingIps(): CloudFloatingIpList

    @GET("networks")
    suspend fun listNetworks(): CloudNetworkList

    @GET("servers/{id}")
    suspend fun getServer(@Path("id") id: Long): CloudServerEnvelope

    @PUT("servers/{id}")
    suspend fun updateServer(
        @Path("id") id: Long,
        @Body body: UpdateServerRequest,
    ): CloudServerEnvelope

    @DELETE("servers/{id}")
    suspend fun deleteServer(@Path("id") id: Long): CloudServerActionResponse

    @POST("servers/{id}/actions/reset_password")
    suspend fun resetServerPassword(@Path("id") id: Long): CloudServerActionResponse

    @POST("servers/{id}/actions/rebuild")
    suspend fun rebuildServer(
        @Path("id") id: Long,
        @Body body: RebuildServerRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/enable_rescue")
    suspend fun enableRescue(
        @Path("id") id: Long,
        @Body body: EnableRescueRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/disable_rescue")
    suspend fun disableRescue(@Path("id") id: Long): CloudServerActionResponse

    @POST("servers/{id}/actions/enable_backup")
    suspend fun enableBackup(@Path("id") id: Long): CloudServerActionResponse

    @POST("servers/{id}/actions/disable_backup")
    suspend fun disableBackup(@Path("id") id: Long): CloudServerActionResponse

    @POST("servers/{id}/actions/attach_iso")
    suspend fun attachIso(
        @Path("id") id: Long,
        @Body body: AttachIsoRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/detach_iso")
    suspend fun detachIso(@Path("id") id: Long): CloudServerActionResponse

    @POST("servers/{id}/actions/change_type")
    suspend fun changeServerType(
        @Path("id") id: Long,
        @Body body: ChangeServerTypeRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/change_protection")
    suspend fun changeServerProtection(
        @Path("id") id: Long,
        @Body body: ChangeProtectionRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/attach_to_network")
    suspend fun attachServerToNetwork(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.AttachToNetworkRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/detach_from_network")
    suspend fun detachServerFromNetwork(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.DetachFromNetworkRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/change_alias_ips")
    suspend fun changeServerAliasIps(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ChangeAliasIpsRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/add_to_placement_group")
    suspend fun addServerToPlacementGroup(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.AddToPlacementGroupRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/remove_from_placement_group")
    suspend fun removeServerFromPlacementGroup(@Path("id") id: Long): CloudServerActionResponse

    @GET("servers/{id}/actions")
    suspend fun listServerActions(
        @Path("id") id: Long,
        @Query("per_page") perPage: Int = 50,
        @Query("sort") sort: String = "id:desc",
    ): de.kiefer_networks.falco.data.dto.ActionListResponse

    @POST("servers/{id}/actions/change_dns_ptr")
    suspend fun changeServerDnsPtr(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ChangeDnsPtrRequest,
    ): CloudServerActionResponse

    @POST("servers/{id}/actions/request_console")
    suspend fun requestServerConsole(
        @Path("id") id: Long,
    ): de.kiefer_networks.falco.data.dto.RequestConsoleResponse

    @GET("servers/{id}/metrics")
    suspend fun serverMetrics(
        @Path("id") id: Long,
        @Query("type") type: String,
        @Query("start") start: String,
        @Query("end") end: String,
        @Query("step") step: Int,
    ): CloudMetricsResponse

    @GET("images")
    suspend fun listImages(
        @Query("type") type: String = "system",
        @Query("architecture") architecture: String? = null,
        @Query("sort") sort: String = "name",
        @Query("per_page") perPage: Int = 100,
    ): CloudImageList

    @GET("server_types")
    suspend fun listServerTypes(@Query("per_page") perPage: Int = 100): CloudServerTypeList

    @GET("isos")
    suspend fun listIsos(@Query("per_page") perPage: Int = 100): CloudIsoList

    @GET("firewalls/{id}")
    suspend fun getFirewall(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudFirewallEnvelope

    @PUT("firewalls/{id}")
    suspend fun updateFirewall(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdateFirewallRequest,
    ): de.kiefer_networks.falco.data.dto.CloudFirewallEnvelope

    @DELETE("firewalls/{id}")
    suspend fun deleteFirewall(@Path("id") id: Long): retrofit2.Response<Unit>

    @POST("firewalls/{id}/actions/set_rules")
    suspend fun setFirewallRules(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.SetFirewallRulesRequest,
    ): de.kiefer_networks.falco.data.dto.CloudFirewallActionsResponse

    @POST("firewalls/{id}/actions/apply_to_resources")
    suspend fun applyFirewall(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ApplyFirewallRequest,
    ): de.kiefer_networks.falco.data.dto.CloudFirewallActionsResponse

    @POST("firewalls/{id}/actions/remove_from_resources")
    suspend fun removeFirewall(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.RemoveFirewallRequest,
    ): de.kiefer_networks.falco.data.dto.CloudFirewallActionsResponse

    // ---- SSH Keys ----------------------------------------------------------

    @GET("ssh_keys")
    suspend fun listSshKeys(@Query("per_page") perPage: Int = 50): de.kiefer_networks.falco.data.dto.CloudSshKeyList

    @POST("ssh_keys")
    suspend fun createSshKey(
        @Body body: de.kiefer_networks.falco.data.dto.CreateSshKeyRequest,
    ): de.kiefer_networks.falco.data.dto.CloudSshKeyEnvelope

    @PUT("ssh_keys/{id}")
    suspend fun updateSshKey(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdateSshKeyRequest,
    ): de.kiefer_networks.falco.data.dto.CloudSshKeyEnvelope

    @DELETE("ssh_keys/{id}")
    suspend fun deleteSshKey(@Path("id") id: Long): retrofit2.Response<Unit>

    // ---- Floating IPs ------------------------------------------------------

    @POST("floating_ips")
    suspend fun createFloatingIp(
        @Body body: de.kiefer_networks.falco.data.dto.CreateFloatingIpRequest,
    ): de.kiefer_networks.falco.data.dto.CreateFloatingIpResponse

    @GET("floating_ips/{id}")
    suspend fun getFloatingIp(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudFloatingIpEnvelope

    @PUT("floating_ips/{id}")
    suspend fun updateFloatingIp(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdateFloatingIpRequest,
    ): de.kiefer_networks.falco.data.dto.CloudFloatingIpEnvelope

    @DELETE("floating_ips/{id}")
    suspend fun deleteFloatingIp(@Path("id") id: Long): retrofit2.Response<Unit>

    @POST("floating_ips/{id}/actions/assign")
    suspend fun assignFloatingIp(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.AssignFloatingIpRequest,
    ): CloudServerActionResponse

    @POST("floating_ips/{id}/actions/unassign")
    suspend fun unassignFloatingIp(@Path("id") id: Long): CloudServerActionResponse

    @POST("floating_ips/{id}/actions/change_dns_ptr")
    suspend fun changeFloatingIpDnsPtr(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ChangeDnsPtrRequest,
    ): CloudServerActionResponse

    @POST("floating_ips/{id}/actions/change_protection")
    suspend fun changeFloatingIpProtection(
        @Path("id") id: Long,
        @Body body: ChangeProtectionRequest,
    ): CloudServerActionResponse

    // ---- Networks ----------------------------------------------------------

    @GET("networks/{id}")
    suspend fun getNetwork(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudNetworkEnvelope

    @POST("networks")
    suspend fun createNetwork(
        @Body body: de.kiefer_networks.falco.data.dto.CreateNetworkRequest,
    ): de.kiefer_networks.falco.data.dto.CloudNetworkEnvelope

    @PUT("networks/{id}")
    suspend fun updateNetwork(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdateNetworkRequest,
    ): de.kiefer_networks.falco.data.dto.CloudNetworkEnvelope

    @DELETE("networks/{id}")
    suspend fun deleteNetwork(@Path("id") id: Long): retrofit2.Response<Unit>

    @POST("networks/{id}/actions/add_subnet")
    suspend fun addNetworkSubnet(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.AddSubnetRequest,
    ): CloudServerActionResponse

    @POST("networks/{id}/actions/delete_subnet")
    suspend fun deleteNetworkSubnet(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.DeleteSubnetRequest,
    ): CloudServerActionResponse

    @POST("networks/{id}/actions/change_protection")
    suspend fun changeNetworkProtection(
        @Path("id") id: Long,
        @Body body: ChangeProtectionRequest,
    ): CloudServerActionResponse

    @POST("networks/{id}/actions/add_route")
    suspend fun addNetworkRoute(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.NetworkRouteRequest,
    ): CloudServerActionResponse

    @POST("networks/{id}/actions/delete_route")
    suspend fun deleteNetworkRoute(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.NetworkRouteRequest,
    ): CloudServerActionResponse

    @POST("networks/{id}/actions/change_ip_range")
    suspend fun changeNetworkIpRange(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ChangeIpRangeRequest,
    ): CloudServerActionResponse

    @POST("networks/{id}/actions/expose_routes_to_vswitch")
    suspend fun exposeNetworkRoutesToVSwitch(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ExposeRoutesRequest,
    ): CloudServerActionResponse

    @GET("volumes/{id}/actions")
    suspend fun listVolumeActions(
        @Path("id") id: Long,
        @Query("per_page") perPage: Int = 50,
        @Query("sort") sort: String = "id:desc",
    ): de.kiefer_networks.falco.data.dto.ActionListResponse

    // ---- Primary IPs -------------------------------------------------------

    @GET("primary_ips")
    suspend fun listPrimaryIps(@Query("per_page") perPage: Int = 50): de.kiefer_networks.falco.data.dto.CloudPrimaryIpList

    @GET("primary_ips/{id}")
    suspend fun getPrimaryIp(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudPrimaryIpEnvelope

    @POST("primary_ips")
    suspend fun createPrimaryIp(
        @Body body: de.kiefer_networks.falco.data.dto.CreatePrimaryIpRequest,
    ): de.kiefer_networks.falco.data.dto.CloudPrimaryIpEnvelope

    @DELETE("primary_ips/{id}")
    suspend fun deletePrimaryIp(@Path("id") id: Long): retrofit2.Response<Unit>

    @POST("primary_ips/{id}/actions/assign")
    suspend fun assignPrimaryIp(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.AssignPrimaryIpRequest,
    ): CloudServerActionResponse

    @POST("primary_ips/{id}/actions/unassign")
    suspend fun unassignPrimaryIp(@Path("id") id: Long): CloudServerActionResponse

    @POST("primary_ips/{id}/actions/change_protection")
    suspend fun changePrimaryIpProtection(
        @Path("id") id: Long,
        @Body body: ChangeProtectionRequest,
    ): CloudServerActionResponse

    // ---- Locations / Datacenters ------------------------------------------

    @GET("locations")
    suspend fun listLocations(): de.kiefer_networks.falco.data.dto.CloudLocationList

    @GET("datacenters")
    suspend fun listDatacenters(): de.kiefer_networks.falco.data.dto.CloudDatacenterList

    // ---- Actions (read-only, for status polling) --------------------------

    @GET("actions/{id}")
    suspend fun getAction(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.ActionResponse

    // ---- Load Balancers ---------------------------------------------------

    @GET("load_balancers")
    suspend fun listLoadBalancers(@Query("per_page") perPage: Int = 50): de.kiefer_networks.falco.data.dto.CloudLoadBalancerList

    @GET("load_balancers/{id}")
    suspend fun getLoadBalancer(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudLoadBalancerEnvelope

    @POST("load_balancers")
    suspend fun createLoadBalancer(
        @Body body: de.kiefer_networks.falco.data.dto.CreateLoadBalancerRequest,
    ): de.kiefer_networks.falco.data.dto.CloudLoadBalancerEnvelope

    @PUT("load_balancers/{id}")
    suspend fun updateLoadBalancer(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdateLoadBalancerRequest,
    ): de.kiefer_networks.falco.data.dto.CloudLoadBalancerEnvelope

    @DELETE("load_balancers/{id}")
    suspend fun deleteLoadBalancer(@Path("id") id: Long): retrofit2.Response<Unit>

    @POST("load_balancers/{id}/actions/add_service")
    suspend fun addLoadBalancerService(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.LoadBalancerService,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/update_service")
    suspend fun updateLoadBalancerService(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdateLoadBalancerServiceRequest,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/delete_service")
    suspend fun deleteLoadBalancerService(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.DeleteLoadBalancerServiceRequest,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/add_target")
    suspend fun addLoadBalancerTarget(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.LoadBalancerTarget,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/remove_target")
    suspend fun removeLoadBalancerTarget(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.LoadBalancerTarget,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/change_algorithm")
    suspend fun changeLoadBalancerAlgorithm(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ChangeLbAlgorithmRequest,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/change_type")
    suspend fun changeLoadBalancerType(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ChangeLbTypeRequest,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/attach_to_network")
    suspend fun attachLoadBalancerToNetwork(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.AttachToNetworkRequest,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/detach_from_network")
    suspend fun detachLoadBalancerFromNetwork(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.DetachFromNetworkRequest,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/enable_public_interface")
    suspend fun enableLoadBalancerPublicInterface(@Path("id") id: Long): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/disable_public_interface")
    suspend fun disableLoadBalancerPublicInterface(@Path("id") id: Long): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/change_protection")
    suspend fun changeLoadBalancerProtection(
        @Path("id") id: Long,
        @Body body: ChangeProtectionRequest,
    ): CloudServerActionResponse

    @POST("load_balancers/{id}/actions/change_dns_ptr")
    suspend fun changeLoadBalancerDnsPtr(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.ChangeDnsPtrRequest,
    ): CloudServerActionResponse

    @GET("load_balancer_types")
    suspend fun listLoadBalancerTypes(@Query("per_page") perPage: Int = 50): de.kiefer_networks.falco.data.dto.CloudLoadBalancerTypeList

    @GET("load_balancers/{id}/metrics")
    suspend fun loadBalancerMetrics(
        @Path("id") id: Long,
        @Query("type") type: String,
        @Query("start") start: String,
        @Query("end") end: String,
        @Query("step") step: Int,
    ): CloudMetricsResponse

    // ---- Certificates -----------------------------------------------------

    @GET("certificates")
    suspend fun listCertificates(@Query("per_page") perPage: Int = 50): de.kiefer_networks.falco.data.dto.CloudCertificateList

    @GET("certificates/{id}")
    suspend fun getCertificate(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudCertificateEnvelope

    @POST("certificates")
    suspend fun createCertificate(
        @Body body: de.kiefer_networks.falco.data.dto.CreateCertificateRequest,
    ): de.kiefer_networks.falco.data.dto.CloudCertificateEnvelope

    @PUT("certificates/{id}")
    suspend fun updateCertificate(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdateCertificateRequest,
    ): de.kiefer_networks.falco.data.dto.CloudCertificateEnvelope

    @DELETE("certificates/{id}")
    suspend fun deleteCertificate(@Path("id") id: Long): retrofit2.Response<Unit>

    @POST("certificates/{id}/actions/retry")
    suspend fun retryCertificate(@Path("id") id: Long): CloudServerActionResponse

    // ---- Placement Groups -------------------------------------------------

    @GET("placement_groups")
    suspend fun listPlacementGroups(@Query("per_page") perPage: Int = 50): de.kiefer_networks.falco.data.dto.CloudPlacementGroupList

    @GET("placement_groups/{id}")
    suspend fun getPlacementGroup(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudPlacementGroupEnvelope

    @POST("placement_groups")
    suspend fun createPlacementGroup(
        @Body body: de.kiefer_networks.falco.data.dto.CreatePlacementGroupRequest,
    ): de.kiefer_networks.falco.data.dto.CloudPlacementGroupEnvelope

    @PUT("placement_groups/{id}")
    suspend fun updatePlacementGroup(
        @Path("id") id: Long,
        @Body body: de.kiefer_networks.falco.data.dto.UpdatePlacementGroupRequest,
    ): de.kiefer_networks.falco.data.dto.CloudPlacementGroupEnvelope

    @DELETE("placement_groups/{id}")
    suspend fun deletePlacementGroup(@Path("id") id: Long): retrofit2.Response<Unit>

    // ---- ISO detail -------------------------------------------------------

    @GET("isos/{id}")
    suspend fun getIso(@Path("id") id: Long): de.kiefer_networks.falco.data.dto.CloudIsoEnvelope

    // ---- Pricing ----------------------------------------------------------

    @GET("pricing")
    suspend fun getPricing(): de.kiefer_networks.falco.data.dto.CloudPricingResponse
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

    @retrofit2.http.POST("storage_boxes")
    suspend fun createStorageBox(
        @retrofit2.http.Body body: de.kiefer_networks.falco.data.dto.CreateStorageBoxRequest,
    ): de.kiefer_networks.falco.data.dto.CreateStorageBoxResponse

    @GET("storage_box_types")
    suspend fun listStorageBoxTypes(): de.kiefer_networks.falco.data.dto.CloudStorageBoxTypeList

    @GET("locations")
    suspend fun listStorageBoxLocations(): de.kiefer_networks.falco.data.dto.CloudLocationList

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
