// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import io.minio.BucketExistsArgs
import io.minio.CopyObjectArgs
import io.minio.CopySource
import io.minio.GetBucketVersioningArgs
import io.minio.GetPresignedObjectUrlArgs
import io.minio.ListObjectsArgs
import io.minio.MakeBucketArgs
import io.minio.MinioClient
import io.minio.PutObjectArgs
import io.minio.RemoveBucketArgs
import io.minio.RemoveObjectArgs
import io.minio.RemoveObjectsArgs
import io.minio.SetBucketVersioningArgs
import io.minio.StatObjectArgs
import io.minio.http.Method
import io.minio.messages.DeleteObject
import io.minio.messages.VersioningConfiguration
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.InputStream
import java.net.URI
import java.util.concurrent.TimeUnit

/** Thrown when the S3 endpoint host is not in the pin map. */
class UnpinnedS3EndpointException(host: String) :
    SecurityException("S3 endpoint $host is not pinned; refusing to connect")

/** Thrown when the user explicitly typed a cleartext `http://` S3 endpoint. */
class CleartextS3EndpointException :
    SecurityException("S3 endpoint must use https://; cleartext http:// is not allowed")

/**
 * Allow-list of Hetzner Object Storage hosts that match our pin map in [Pins].
 * Any endpoint outside this set bypasses cert pinning and must be rejected.
 */
private val ALLOWED_S3_HOST_REGEX = Regex("^(fsn1|hel1|nbg1)\\.your-objectstorage\\.com$")

/**
 * Normalises a user-typed endpoint to `https://<host>`, rejecting cleartext
 * schemes and hosts not covered by [Pins.objectStorage].
 */
internal fun validateAndNormalizeS3Endpoint(endpoint: String): String {
    val trimmed = endpoint.trim()
    val lower = trimmed.lowercase()
    if (lower.startsWith("http://")) throw CleartextS3EndpointException()
    val withScheme = if (lower.startsWith("https://")) trimmed else "https://$trimmed"
    val host = runCatching { URI(withScheme).host }.getOrNull()
        ?: throw UnpinnedS3EndpointException(trimmed)
    if (!ALLOWED_S3_HOST_REGEX.matches(host)) throw UnpinnedS3EndpointException(host)
    return withScheme
}

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
        .endpoint(validateAndNormalizeS3Endpoint(endpoint))
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

    suspend fun presignedUploadUrl(bucket: String, key: String, expirySeconds: Int): String =
        withContext(Dispatchers.IO) {
            client.getPresignedObjectUrl(
                GetPresignedObjectUrlArgs.builder()
                    .method(Method.PUT)
                    .bucket(bucket)
                    .`object`(key)
                    .expiry(expirySeconds, TimeUnit.SECONDS)
                    .build(),
            )
        }

    suspend fun bucketExists(bucket: String): Boolean = withContext(Dispatchers.IO) {
        client.bucketExists(BucketExistsArgs.builder().bucket(bucket).build())
    }

    suspend fun createBucket(bucket: String, region: String? = null) = withContext(Dispatchers.IO) {
        val builder = MakeBucketArgs.builder().bucket(bucket)
        if (!region.isNullOrBlank()) builder.region(region)
        client.makeBucket(builder.build())
    }

    suspend fun deleteBucket(bucket: String) = withContext(Dispatchers.IO) {
        client.removeBucket(RemoveBucketArgs.builder().bucket(bucket).build())
    }

    suspend fun deleteObjects(bucket: String, keys: List<String>): List<String> =
        withContext(Dispatchers.IO) {
            if (keys.isEmpty()) return@withContext emptyList()
            val args = RemoveObjectsArgs.builder()
                .bucket(bucket)
                .objects(keys.map { DeleteObject(it) })
                .build()
            client.removeObjects(args).mapNotNull {
                runCatching { it.get().objectName() }.getOrNull()
            }
        }

    suspend fun copyObject(
        srcBucket: String,
        srcKey: String,
        dstBucket: String,
        dstKey: String,
    ) = withContext(Dispatchers.IO) {
        val args = CopyObjectArgs.builder()
            .bucket(dstBucket)
            .`object`(dstKey)
            .source(CopySource.builder().bucket(srcBucket).`object`(srcKey).build())
            .build()
        client.copyObject(args)
    }

    suspend fun getBucketVersioning(bucket: String): String = withContext(Dispatchers.IO) {
        client.getBucketVersioning(GetBucketVersioningArgs.builder().bucket(bucket).build())
            .status()?.toString() ?: "Off"
    }

    suspend fun setBucketVersioning(bucket: String, enabled: Boolean) = withContext(Dispatchers.IO) {
        val cfg = VersioningConfiguration(
            if (enabled) VersioningConfiguration.Status.ENABLED else VersioningConfiguration.Status.SUSPENDED,
            false,
        )
        client.setBucketVersioning(
            SetBucketVersioningArgs.builder().bucket(bucket).config(cfg).build(),
        )
    }

}
