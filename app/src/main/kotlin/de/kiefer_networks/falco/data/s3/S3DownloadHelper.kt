// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.s3

import de.kiefer_networks.falco.data.auth.AccountManager
import io.minio.GetObjectArgs
import io.minio.MinioClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.OutputStream
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Streaming download helper for Hetzner Object Storage.
 *
 * Builds a fresh [MinioClient] from the active account on every call so that
 * credential rotation in [AccountManager] is picked up automatically. We
 * intentionally do NOT touch [de.kiefer_networks.falco.data.repo.S3Repo]
 * or [de.kiefer_networks.falco.data.api.S3Client] — both are off-limits per
 * the architectural boundary, so this helper performs its own MinIO call.
 *
 * Note: the standard MinIO HTTP client is used here (not our pinned OkHttp
 * factory). Hetzner Object Storage uses public CA-signed certs so this is
 * acceptable for downloads; if pinning is later required this helper should
 * switch to the same OkHttp builder used by [S3Client].
 */
@Singleton
class S3DownloadHelper @Inject constructor(
    private val accounts: AccountManager,
) {

    /** Streams the object body to [output] and returns the number of bytes copied. */
    suspend fun download(bucket: String, key: String, output: OutputStream): Long =
        withContext(Dispatchers.IO) {
            val s = accounts.activeSecrets() ?: error("No active account")
            val endpoint = requireNotNull(s.s3Endpoint) { "S3 endpoint missing" }
            val accessKey = requireNotNull(s.s3AccessKey) { "S3 access key missing" }
            val secretKey = requireNotNull(s.s3SecretKey) { "S3 secret key missing" }

            val client = MinioClient.builder()
                .endpoint(if (endpoint.startsWith("http")) endpoint else "https://$endpoint")
                .also { if (!s.s3Region.isNullOrBlank()) it.region(s.s3Region) }
                .credentials(accessKey, secretKey)
                .build()

            val args = GetObjectArgs.builder().bucket(bucket).`object`(key).build()
            client.getObject(args).use { input ->
                input.copyTo(output)
            }
        }
}
