// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.util

import de.kiefer_networks.falco.data.api.CleartextS3EndpointException
import de.kiefer_networks.falco.data.api.PermissionDeniedException
import de.kiefer_networks.falco.data.api.UnpinnedS3EndpointException
import retrofit2.HttpException
import java.io.IOException
import kotlin.coroutines.cancellation.CancellationException

/**
 * Maps a thrown [Throwable] to a short, sanitised user-facing label that is
 * safe to surface in toasts/snackbars. Avoids leaking backend response bodies,
 * stack traces, or string-formatted exception details that may contain server
 * paths, request IDs, or echoed credentials.
 *
 * Re-throws [CancellationException] so structured cancellation keeps working.
 */
fun sanitizeError(t: Throwable): String = when (t) {
    is CancellationException -> throw t
    is CleartextS3EndpointException -> "S3 endpoint must use https://"
    is UnpinnedS3EndpointException -> "S3 endpoint host is not pinned"
    // Read-only Cloud token, Robot sub-user without the per-resource right,
    // or DNS token rotated/scoped elsewhere — surface a clear hint instead
    // of a generic HTTP 403 toast that leaves the user guessing.
    is PermissionDeniedException -> "Insufficient permissions for this action — credential is read-only or scoped narrower than required."
    is HttpException -> "HTTP ${t.code()}"
    is IOException -> "Network error"
    else -> "Error"
}
