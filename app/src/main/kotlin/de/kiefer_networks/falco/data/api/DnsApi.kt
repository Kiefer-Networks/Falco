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
}
