// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.CreateDnsRecord
import de.kiefer_networks.falco.data.dto.DnsRecord
import de.kiefer_networks.falco.data.dto.DnsRecordList
import de.kiefer_networks.falco.data.dto.DnsZoneList
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Path
import retrofit2.http.Query

interface DnsApi {
    @GET("zones")
    suspend fun listZones(
        @Query("page") page: Int = 1,
        @Query("per_page") perPage: Int = 100,
    ): DnsZoneList

    @GET("records")
    suspend fun listRecords(@Query("zone_id") zoneId: String): DnsRecordList

    @POST("records")
    suspend fun createRecord(@Body record: CreateDnsRecord): DnsRecord

    @PUT("records/{id}")
    suspend fun updateRecord(@Path("id") id: String, @Body record: CreateDnsRecord): DnsRecord

    @DELETE("records/{id}")
    suspend fun deleteRecord(@Path("id") id: String): retrofit2.Response<Unit>

    @GET("zones/{id}")
    suspend fun getZone(@Path("id") id: String): de.kiefer_networks.falco.data.dto.DnsZoneEnvelope

    @POST("zones")
    suspend fun createZone(@Body body: de.kiefer_networks.falco.data.dto.CreateDnsZoneRequest): de.kiefer_networks.falco.data.dto.DnsZoneEnvelope

    @PUT("zones/{id}")
    suspend fun updateZone(
        @Path("id") id: String,
        @Body body: de.kiefer_networks.falco.data.dto.CreateDnsZoneRequest,
    ): de.kiefer_networks.falco.data.dto.DnsZoneEnvelope

    @DELETE("zones/{id}")
    suspend fun deleteZone(@Path("id") id: String): retrofit2.Response<Unit>

    @GET("records/{id}")
    suspend fun getRecord(@Path("id") id: String): de.kiefer_networks.falco.data.dto.DnsRecordEnvelope

    @POST("records/bulk")
    suspend fun bulkCreateRecords(
        @Body body: de.kiefer_networks.falco.data.dto.BulkRecordsRequest,
    ): de.kiefer_networks.falco.data.dto.BulkCreateRecordsResponse

    @PUT("records/bulk")
    suspend fun bulkUpdateRecords(
        @Body body: de.kiefer_networks.falco.data.dto.BulkUpdateRecordsRequest,
    ): de.kiefer_networks.falco.data.dto.BulkUpdateRecordsResponse

    @GET("zones/{id}/export")
    @retrofit2.http.Headers("Accept: text/plain")
    suspend fun exportZone(@Path("id") id: String): retrofit2.Response<okhttp3.ResponseBody>

    @POST("zones/file/import")
    suspend fun importZoneFile(
        @Query("zone_id") zoneId: String,
        @Body body: okhttp3.RequestBody,
    ): de.kiefer_networks.falco.data.dto.DnsZoneEnvelope

    @POST("zones/{id}/validate")
    suspend fun validateZone(
        @Path("id") id: String,
        @Body body: okhttp3.RequestBody,
    ): de.kiefer_networks.falco.data.dto.DnsValidateResponse

    @GET("primary_servers")
    suspend fun listPrimaryServers(@Query("zone_id") zoneId: String? = null): de.kiefer_networks.falco.data.dto.DnsPrimaryServerList

    @POST("primary_servers")
    suspend fun createPrimaryServer(@Body body: de.kiefer_networks.falco.data.dto.CreateDnsPrimaryServerRequest): de.kiefer_networks.falco.data.dto.DnsPrimaryServerEnvelope

    @PUT("primary_servers/{id}")
    suspend fun updatePrimaryServer(
        @Path("id") id: String,
        @Body body: de.kiefer_networks.falco.data.dto.CreateDnsPrimaryServerRequest,
    ): de.kiefer_networks.falco.data.dto.DnsPrimaryServerEnvelope

    @DELETE("primary_servers/{id}")
    suspend fun deletePrimaryServer(@Path("id") id: String): retrofit2.Response<Unit>
}
