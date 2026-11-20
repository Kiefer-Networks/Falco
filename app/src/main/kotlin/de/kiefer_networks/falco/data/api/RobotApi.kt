// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.RobotFailoverEnvelope
import de.kiefer_networks.falco.data.dto.RobotResetEnvelope
import de.kiefer_networks.falco.data.dto.RobotServerEnvelope
import de.kiefer_networks.falco.data.dto.RobotVSwitch
import retrofit2.http.Field
import retrofit2.http.FormUrlEncoded
import retrofit2.http.GET
import retrofit2.http.HTTP
import retrofit2.http.POST
import retrofit2.http.Path

/**
 * Hetzner Robot Webservice (https://robot-ws.your-server.de/) — HTTP Basic auth.
 *
 * Storage Box endpoints used to live here too but Hetzner removed them on
 * 2025-07-30. Storage Boxes are now served by the Cloud API (api.hetzner.com)
 * and consumed via [CloudApi] / [StorageBoxApi]. Do not reintroduce
 * /storagebox endpoints — they will return 404.
 */
interface RobotApi {
    @GET("server")
    suspend fun listServers(): List<RobotServerEnvelope>

    @GET("server/{number}")
    suspend fun getServer(@Path("number") serverNumber: Long): RobotServerEnvelope

    @GET("reset/{number}")
    suspend fun resetOptions(@Path("number") serverNumber: Long): RobotResetEnvelope

    @FormUrlEncoded
    @POST("reset/{number}")
    suspend fun reset(
        @Path("number") serverNumber: Long,
        @Field("type") type: String,
    ): RobotResetEnvelope

    @POST("wol/{number}")
    suspend fun wakeOnLan(@Path("number") serverNumber: Long)

    @GET("failover")
    suspend fun listFailoverIps(): List<RobotFailoverEnvelope>

    @FormUrlEncoded
    @POST("failover/{ip}")
    suspend fun routeFailover(
        @Path("ip") ip: String,
        @Field("active_server_ip") targetServerIp: String,
    ): RobotFailoverEnvelope

    @retrofit2.http.DELETE("failover/{ip}")
    suspend fun unrouteFailover(@Path("ip") ip: String)

    // ---- Reverse DNS -----------------------------------------------------

    @GET("rdns")
    suspend fun listRdns(): List<de.kiefer_networks.falco.data.dto.RobotRdnsEnvelope>

    @GET("rdns/{ip}")
    suspend fun getRdns(@Path("ip") ip: String): de.kiefer_networks.falco.data.dto.RobotRdnsEnvelope

    // POST creates or updates; PUT is create only (409 RDNS_ALREADY_EXISTS).
    @FormUrlEncoded
    @POST("rdns/{ip}")
    suspend fun setRdns(
        @Path("ip") ip: String,
        @Field("ptr") ptr: String,
    ): de.kiefer_networks.falco.data.dto.RobotRdnsEnvelope

    @retrofit2.http.DELETE("rdns/{ip}")
    suspend fun deleteRdns(@Path("ip") ip: String)

    // ---- vSwitch CRUD ----------------------------------------------------

    // vSwitch endpoints return bare objects/arrays, no envelope.
    @GET("vswitch")
    suspend fun listVSwitches(): List<RobotVSwitch>

    @GET("vswitch/{id}")
    suspend fun getVSwitch(@Path("id") id: Long): RobotVSwitch

    @FormUrlEncoded
    @POST("vswitch")
    suspend fun createVSwitch(
        @Field("name") name: String,
        @Field("vlan") vlan: Int,
    ): RobotVSwitch

    /** No response body. */
    @FormUrlEncoded
    @POST("vswitch/{id}")
    suspend fun updateVSwitch(
        @Path("id") id: Long,
        @Field("name") name: String,
        @Field("vlan") vlan: Int,
    )

    /** [cancellationDate] is `yyyy-MM-dd` or `now`, sent form-encoded. */
    @FormUrlEncoded
    @HTTP(method = "DELETE", path = "vswitch/{id}", hasBody = true)
    suspend fun deleteVSwitch(
        @Path("id") id: Long,
        @Field("cancellation_date") cancellationDate: String,
    )

    @FormUrlEncoded
    @POST("vswitch/{id}/server")
    suspend fun attachServerToVSwitch(
        @Path("id") id: Long,
        @Field("server[]") serverNumber: Long,
    )

    @FormUrlEncoded
    @HTTP(method = "DELETE", path = "vswitch/{id}/server", hasBody = true)
    suspend fun detachServerFromVSwitch(
        @Path("id") id: Long,
        @Field("server[]") serverNumber: Long,
    )

    // ---- Rescue / Boot ---------------------------------------------------

    @GET("boot/{number}")
    suspend fun bootOptions(@Path("number") serverNumber: Long): de.kiefer_networks.falco.data.dto.RobotBootEnvelope

    @GET("boot/{number}/rescue")
    suspend fun rescueOptions(@Path("number") serverNumber: Long): de.kiefer_networks.falco.data.dto.RobotRescueEnvelope

    @FormUrlEncoded
    @POST("boot/{number}/rescue")
    suspend fun enableRescue(
        @Path("number") serverNumber: Long,
        @Field("os") os: String = "linux",
        @Field("authorized_key[]") authorizedKeys: List<String> = emptyList(),
    ): de.kiefer_networks.falco.data.dto.RobotRescueEnvelope

    @retrofit2.http.DELETE("boot/{number}/rescue")
    suspend fun disableRescue(@Path("number") serverNumber: Long)

    // ---- Cancellation ----------------------------------------------------

    @GET("server/{number}/cancellation")
    suspend fun getCancellation(@Path("number") serverNumber: Long): de.kiefer_networks.falco.data.dto.RobotCancellationEnvelope

    @FormUrlEncoded
    @POST("server/{number}/cancellation")
    suspend fun cancelServer(
        @Path("number") serverNumber: Long,
        @Field("cancellation_date") cancellationDate: String,
        @Field("cancellation_reason") reason: String? = null,
        @Field("reserve_location") reserveLocation: Boolean? = null,
    ): de.kiefer_networks.falco.data.dto.RobotCancellationEnvelope

    @retrofit2.http.DELETE("server/{number}/cancellation")
    suspend fun withdrawCancellation(@Path("number") serverNumber: Long)

    // ---- Traffic ---------------------------------------------------------

    @GET("traffic")
    suspend fun listTraffic(): de.kiefer_networks.falco.data.dto.RobotTrafficResponse

    /**
     * Hetzner Robot `/traffic` query. Per the official docs the endpoint is a
     * form-encoded POST with `ip[]` repeated per address (`subnet[]` for v6
     * subnets) plus a `type`+`from`+`to` window. Unparameterised GET returns
     * a generic envelope without per-IP rows.
     */
    @FormUrlEncoded
    @POST("traffic")
    suspend fun queryTraffic(
        @Field("type") type: String,
        @Field("from") from: String,
        @Field("to") to: String,
        @Field("ip[]") ips: List<String>,
    ): de.kiefer_networks.falco.data.dto.RobotTrafficResponse

    @GET("key")
    suspend fun listKeys(): List<de.kiefer_networks.falco.data.dto.RobotKeyEnvelope>

    @FormUrlEncoded
    @POST("key")
    suspend fun createKey(
        @Field("name") name: String,
        @Field("data") data: String,
    ): de.kiefer_networks.falco.data.dto.RobotKeyEnvelope

    @retrofit2.http.DELETE("key/{fp}")
    suspend fun deleteKey(@Path("fp") fingerprint: String)
}
