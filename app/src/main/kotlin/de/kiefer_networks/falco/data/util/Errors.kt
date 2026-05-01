// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.util

import de.kiefer_networks.falco.data.api.CleartextS3EndpointException
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
    is HttpException -> "HTTP ${t.code()}"
    is IOException -> "Network error"
    else -> "Error"
}
