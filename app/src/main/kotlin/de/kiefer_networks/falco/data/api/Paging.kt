// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import de.kiefer_networks.falco.data.dto.Meta

/** Hard stop so a misbehaving `last_page` can never loop forever. */
private const val MAX_PAGES = 100

/**
 * Collects every page of a Hetzner list endpoint. The API returns at most
 * 50 items per page (default 25); reading only page 1 silently truncated
 * lists for larger projects.
 */
suspend fun <T> fetchAllPages(fetch: suspend (page: Int) -> Pair<List<T>, Meta?>): List<T> {
    val out = mutableListOf<T>()
    var page = 1
    while (true) {
        val (items, meta) = fetch(page)
        out += items
        val lastPage = meta?.pagination?.lastPage ?: break
        if (items.isEmpty() || page >= lastPage || page >= MAX_PAGES) break
        page++
    }
    return out
}
