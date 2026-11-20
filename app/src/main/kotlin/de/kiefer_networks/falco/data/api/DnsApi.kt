// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.ActionResponse
import de.kiefer_networks.falco.data.dto.CreateDnsZoneRequest
import de.kiefer_networks.falco.data.dto.DnsAddRecordsRequest
import de.kiefer_networks.falco.data.dto.DnsPrimaryServersRequest
import de.kiefer_networks.falco.data.dto.DnsRRSetList
import de.kiefer_networks.falco.data.dto.DnsRecordsRequest
import de.kiefer_networks.falco.data.dto.DnsTtlRequest
import de.kiefer_networks.falco.data.dto.DnsZoneCreateResponse
import de.kiefer_networks.falco.data.dto.DnsZoneEnvelope
import de.kiefer_networks.falco.data.dto.DnsZoneList
import de.kiefer_networks.falco.data.dto.DnsZonefile
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query

/** DNS part of the Hetzner Cloud API; built on the Cloud retrofit. */
interface DnsApi {
    @GET("zones")
    suspend fun listZones(
        @Query("page") page: Int = 1,
        @Query("per_page") perPage: Int = 50,
    ): DnsZoneList

    @GET("zones/{zone}")
    suspend fun getZone(@Path("zone") zone: String): DnsZoneEnvelope

    @POST("zones")
    suspend fun createZone(@Body body: CreateDnsZoneRequest): DnsZoneCreateResponse

    @DELETE("zones/{zone}")
    suspend fun deleteZone(@Path("zone") zone: String): ActionResponse

    @POST("zones/{zone}/actions/change_ttl")
    suspend fun changeZoneTtl(@Path("zone") zone: String, @Body body: DnsTtlRequest): ActionResponse

    @GET("zones/{zone}/zonefile")
    suspend fun exportZonefile(@Path("zone") zone: String): DnsZonefile

    @POST("zones/{zone}/actions/import_zonefile")
    suspend fun importZonefile(@Path("zone") zone: String, @Body body: DnsZonefile): ActionResponse

    @POST("zones/{zone}/actions/change_primary_nameservers")
    suspend fun changePrimaryNameservers(
        @Path("zone") zone: String,
        @Body body: DnsPrimaryServersRequest,
    ): ActionResponse

    @GET("zones/actions/{id}")
    suspend fun getAction(@Path("id") id: Long): ActionResponse

    @GET("zones/{zone}/rrsets")
    suspend fun listRRSets(
        @Path("zone") zone: String,
        @Query("page") page: Int = 1,
        @Query("per_page") perPage: Int = 50,
    ): DnsRRSetList

    @POST("zones/{zone}/rrsets/{name}/{type}/actions/add_records")
    suspend fun addRecords(
        @Path("zone") zone: String,
        @Path("name") name: String,
        @Path("type") type: String,
        @Body body: DnsAddRecordsRequest,
    ): ActionResponse

    @POST("zones/{zone}/rrsets/{name}/{type}/actions/set_records")
    suspend fun setRecords(
        @Path("zone") zone: String,
        @Path("name") name: String,
        @Path("type") type: String,
        @Body body: DnsRecordsRequest,
    ): ActionResponse

    @POST("zones/{zone}/rrsets/{name}/{type}/actions/remove_records")
    suspend fun removeRecords(
        @Path("zone") zone: String,
        @Path("name") name: String,
        @Path("type") type: String,
        @Body body: DnsRecordsRequest,
    ): ActionResponse

    @POST("zones/{zone}/rrsets/{name}/{type}/actions/change_ttl")
    suspend fun changeRRSetTtl(
        @Path("zone") zone: String,
        @Path("name") name: String,
        @Path("type") type: String,
        @Body body: DnsTtlRequest,
    ): ActionResponse
}
