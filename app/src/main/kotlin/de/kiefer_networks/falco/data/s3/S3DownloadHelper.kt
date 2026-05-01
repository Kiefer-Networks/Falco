// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.s3

import de.kiefer_networks.falco.data.api.HttpClientFactory
import de.kiefer_networks.falco.data.api.validateAndNormalizeS3Endpoint
import de.kiefer_networks.falco.data.auth.AccountManager
import io.minio.GetObjectArgs
import io.minio.MinioClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.withContext
import java.io.OutputStream
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Streaming download helper for Hetzner Object Storage.
 *
 * Builds a fresh [MinioClient] from the active Cloud project on every call so
 * that project switches in [AccountManager] are picked up automatically.
 */
@Singleton
class S3DownloadHelper @Inject constructor(
    private val accounts: AccountManager,
) {

    /** Streams the object body to [output] and returns the number of bytes copied. */
    suspend fun download(bucket: String, key: String, output: OutputStream): Long =
        withContext(Dispatchers.IO) {
            val project = accounts.activeCloudProject.first()
                ?: error("No active Cloud project")
            require(project.hasS3) { "Active Cloud project has no S3 credentials" }
            val endpoint = project.s3Endpoint!!
            val client = MinioClient.builder()
                .endpoint(validateAndNormalizeS3Endpoint(endpoint))
                .also { if (!project.s3Region.isNullOrBlank()) it.region(project.s3Region) }
                .credentials(project.s3AccessKey!!, project.s3SecretKey!!)
                .httpClient(HttpClientFactory.s3OkHttp())
                .build()

            val args = GetObjectArgs.builder().bucket(bucket).`object`(key).build()
            client.getObject(args).use { input ->
                input.copyTo(output)
            }
        }
}
