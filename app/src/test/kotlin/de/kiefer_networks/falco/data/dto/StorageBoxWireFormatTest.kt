// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.dto

import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

/** Storage Box shapes from the api.hetzner.com OpenAPI spec. */
class StorageBoxWireFormatTest {

    private val json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
        encodeDefaults = false
    }

    @Test
    fun `rollback_snapshot body carries snapshot as string`() {
        val body = json.encodeToJsonElement(
            RollbackStorageBoxSnapshotRequest.serializer(),
            RollbackStorageBoxSnapshotRequest("my-snapshot"),
        ).jsonObject
        assertEquals(setOf("snapshot"), body.keys)
        assertEquals("my-snapshot", body["snapshot"]!!.jsonPrimitive.content)
        assertEquals(true, body["snapshot"]!!.jsonPrimitive.isString)
    }

    @Test
    fun `create storage box sends all required fields`() {
        val body = json.encodeToJsonElement(
            CreateStorageBoxRequest.serializer(),
            CreateStorageBoxRequest(name = "box", storageBoxType = "bx11", location = "fsn1", password = "pw"),
        ).jsonObject
        assertEquals(setOf("name", "storage_box_type", "location", "password"), body.keys)
    }

    @Test
    fun `storage box with nullable fields and status decodes`() {
        val box = json.decodeFromString(
            CloudStorageBoxEnvelope.serializer(),
            """{"storage_box":{"id":1,"name":"b","status":"initializing","username":null,"server":null,
              |"system":null,"snapshot_plan":null,"labels":{},"protection":{"delete":false},
              |"storage_box_type":{"id":2,"name":"bx11","description":"BX11","snapshot_limit":null,
              |"automatic_snapshot_limit":null,"subaccounts_limit":100,"size":1099511627776,
              |"prices":[{"location":"fsn1","price_hourly":{"net":"1","gross":"1"}}],"deprecation":null},
              |"location":{"id":1,"name":"fsn1","city":"Falkenstein","country":"DE"},
              |"access_settings":{"reachable_externally":false,"samba_enabled":false,"ssh_enabled":true,
              |"webdav_enabled":false,"zfs_enabled":false},
              |"stats":{"size":0,"size_data":0,"size_snapshots":0},"created":"2025-01-01T00:00:00Z"}}
            """.trimMargin(),
        ).storageBox
        assertEquals("initializing", box.status)
        assertNull(box.username)
        assertEquals("fsn1", box.storageBoxType!!.prices.single().location)
    }

    @Test
    fun `storage box types list is paginated`() {
        val list = json.decodeFromString(
            CloudStorageBoxTypeList.serializer(),
            """{"storage_box_types":[{"id":1,"name":"bx11","prices":[{"location":"hel1"}]}],
              |"meta":{"pagination":{"page":1,"per_page":25,"previous_page":null,"next_page":2,"last_page":2,"total_entries":30}}}
            """.trimMargin(),
        )
        assertEquals(2, list.meta!!.pagination!!.lastPage)
    }

    @Test
    fun `snapshot create response with only id and action decodes`() {
        val env = json.decodeFromString(
            CloudStorageBoxSnapshotEnvelope.serializer(),
            """{"snapshot":{"id":3,"storage_box":1},"action":{"id":9,"command":"create_snapshot",
              |"status":"running","started":"2025-01-01T00:00:00Z","finished":null,"progress":0,
              |"resources":[],"error":null}}
            """.trimMargin(),
        )
        assertEquals(3L, env.snapshot.id)
        assertEquals("running", env.action!!.status)
    }
}
