// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import io.minio.GetPresignedObjectUrlArgs
import io.minio.ListObjectsArgs
import io.minio.MinioClient
import io.minio.PutObjectArgs
import io.minio.RemoveObjectArgs
import io.minio.StatObjectArgs
import io.minio.http.Method
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.InputStream
import java.util.concurrent.TimeUnit

/**
 * Thin MinIO wrapper for Hetzner Object Storage.
 *
 * Hetzner ObjStor endpoints look like `https://<location>.your-objectstorage.com`
 * (e.g. `fsn1.your-objectstorage.com`). The S3 SDK handles SigV4; we still
 * route the underlying OkHttp through [HttpClientFactory] so the MinIO client
 * inherits our TLS + pinning policy.
 */
class S3Client(
    endpoint: String,
    region: String?,
    accessKey: String,
    secretKey: String,
) {
    private val client: MinioClient = MinioClient.builder()
        .endpoint(if (endpoint.startsWith("http")) endpoint else "https://$endpoint")
        .also { if (!region.isNullOrBlank()) it.region(region) }
        .credentials(accessKey, secretKey)
        .httpClient(HttpClientFactory.s3OkHttp())
        .build()

    data class S3ObjectMeta(val key: String, val size: Long, val isDir: Boolean, val lastModified: String?)

    suspend fun listBuckets(): List<String> = withContext(Dispatchers.IO) {
        client.listBuckets().map { it.name() }
    }

    suspend fun listObjects(bucket: String, prefix: String = "", recursive: Boolean = false): List<S3ObjectMeta> =
        withContext(Dispatchers.IO) {
            val args = ListObjectsArgs.builder()
                .bucket(bucket)
                .prefix(prefix)
                .recursive(recursive)
                .build()
            client.listObjects(args).map { item ->
                val o = item.get()
                S3ObjectMeta(
                    key = o.objectName(),
                    size = o.size(),
                    isDir = o.isDir,
                    lastModified = o.lastModified()?.toString(),
                )
            }
        }

    suspend fun putObject(
        bucket: String,
        key: String,
        contentType: String,
        size: Long,
        stream: InputStream,
    ) = withContext(Dispatchers.IO) {
        val partSize = 5L * 1024 * 1024 // 5 MiB minimum for multipart
        val args = PutObjectArgs.builder()
            .bucket(bucket)
            .`object`(key)
            .contentType(contentType)
            .stream(stream, size, if (size in 0..partSize) -1L else partSize)
            .build()
        client.putObject(args)
    }

    suspend fun deleteObject(bucket: String, key: String) = withContext(Dispatchers.IO) {
        client.removeObject(RemoveObjectArgs.builder().bucket(bucket).`object`(key).build())
    }

    suspend fun stat(bucket: String, key: String) = withContext(Dispatchers.IO) {
        client.statObject(StatObjectArgs.builder().bucket(bucket).`object`(key).build())
    }

    suspend fun presignedDownloadUrl(bucket: String, key: String, expirySeconds: Int): String =
        withContext(Dispatchers.IO) {
            client.getPresignedObjectUrl(
                GetPresignedObjectUrlArgs.builder()
                    .method(Method.GET)
                    .bucket(bucket)
                    .`object`(key)
                    .expiry(expirySeconds, TimeUnit.SECONDS)
                    .build(),
            )
        }
}
