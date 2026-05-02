// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import okhttp3.Request

/**
 * Thrown by [PermissionInterceptor] when a mutating request returns 401 or
 * 403 — the response means the user's Hetzner credential lacks the rights
 * required for that action. Three concrete sources:
 *
 *  * Hetzner Cloud token issued with the **read-only** scope is denied any
 *    POST/PUT/DELETE.
 *  * Hetzner Robot HTTP-Basic credential belongs to a sub-user without the
 *    requisite per-resource permission (cancellation, reset, vSwitch CRUD).
 *  * Hetzner DNS token rotated / revoked / scoped to a different account.
 *
 * Falco's [sanitizeError] maps this to a localized hint instead of the
 * generic "HTTP 403" so the user understands why the action was rejected.
 */
class PermissionDeniedException(
    val request: Request,
    val httpCode: Int,
) : RuntimeException(
    "HTTP $httpCode for ${request.method} ${request.url} — credential lacks the rights for this action.",
)
