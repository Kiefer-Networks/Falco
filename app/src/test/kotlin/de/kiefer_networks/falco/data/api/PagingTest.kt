// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.Meta
import de.kiefer_networks.falco.data.dto.Pagination
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class PagingTest {

    @Test
    fun `collects every page until last_page`() = runTest {
        val requested = mutableListOf<Int>()
        val all = fetchAllPages { page ->
            requested += page
            listOf(page * 10, page * 10 + 1) to Meta(Pagination(page = page, perPage = 2, lastPage = 3))
        }
        assertEquals(listOf(1, 2, 3), requested)
        assertEquals(listOf(10, 11, 20, 21, 30, 31), all)
    }

    @Test
    fun `stops after one page without pagination meta`() = runTest {
        var calls = 0
        val all = fetchAllPages { _ -> calls++; listOf("a") to null }
        assertEquals(1, calls)
        assertEquals(listOf("a"), all)
    }
}
