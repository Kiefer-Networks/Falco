// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.RobotFailoverEnvelope
import de.kiefer_networks.falco.data.dto.RobotResetEnvelope
import de.kiefer_networks.falco.data.dto.RobotServerEnvelope
import de.kiefer_networks.falco.data.dto.RobotSnapshotEnvelope
import de.kiefer_networks.falco.data.dto.RobotStorageBoxEnvelope
import de.kiefer_networks.falco.data.dto.RobotSubaccountEnvelope
import de.kiefer_networks.falco.data.dto.RobotVSwitchEnvelope
import retrofit2.http.Field
import retrofit2.http.FormUrlEncoded
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path

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
    suspend fun wakeOnLan(@Path("number") serverNumber: Long): retrofit2.Response<Unit>

    @GET("storagebox")
    suspend fun listStorageBoxes(): List<RobotStorageBoxEnvelope>

    @GET("storagebox/{id}")
    suspend fun getStorageBox(@Path("id") id: Long): RobotStorageBoxEnvelope

    @GET("storagebox/{id}/snapshot")
    suspend fun listSnapshots(@Path("id") id: Long): List<RobotSnapshotEnvelope>

    @POST("storagebox/{id}/snapshot")
    suspend fun createSnapshot(@Path("id") id: Long): RobotSnapshotEnvelope

    @GET("storagebox/{id}/subaccount")
    suspend fun listSubaccounts(@Path("id") id: Long): List<RobotSubaccountEnvelope>

    @POST("storagebox/{id}/password")
    suspend fun resetStorageBoxPassword(@Path("id") id: Long): retrofit2.Response<Unit>

    @GET("failover")
    suspend fun listFailoverIps(): List<RobotFailoverEnvelope>

    @GET("vswitch")
    suspend fun listVSwitches(): List<RobotVSwitchEnvelope>
}
