// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.S3Client
import de.kiefer_networks.falco.data.auth.AccountManager
import kotlinx.coroutines.flow.first
import javax.inject.Inject
import javax.inject.Singleton

class S3CredentialsMissingException : RuntimeException(
    "Active Cloud project has no Object Storage credentials configured.",
)

@Singleton
class S3Repo @Inject constructor(private val accounts: AccountManager) {

    private suspend fun client(): S3Client {
        val project = accounts.activeCloudProject.first()
            ?: throw S3CredentialsMissingException()
        if (!project.hasS3) throw S3CredentialsMissingException()
        return S3Client(
            endpoint = project.s3Endpoint!!,
            region = project.s3Region,
            accessKey = project.s3AccessKey!!,
            secretKey = project.s3SecretKey!!,
        )
    }

    suspend fun listBuckets() = client().listBuckets()
    suspend fun listObjects(bucket: String, prefix: String = "") = client().listObjects(bucket, prefix)
    suspend fun delete(bucket: String, key: String) = client().deleteObject(bucket, key)
    suspend fun deleteAll(bucket: String, keys: List<String>) = client().deleteObjects(bucket, keys)
    suspend fun shareLink(bucket: String, key: String, hours: Int): String =
        client().presignedDownloadUrl(bucket, key, clampShareHours(hours) * 3600)
    suspend fun uploadLink(bucket: String, key: String, hours: Int): String =
        client().presignedUploadUrl(bucket, key, clampUploadHours(hours) * 3600)

    /**
     * SigV4 caps presigned URL expiry at 7 days (604800s). Downloads can use
     * the full window; uploads have a hard 1 h cap because a leaked PUT URL
     * lets the holder overwrite an arbitrary object until expiry — far more
     * dangerous than a leaked GET URL on existing data.
     */
    private fun clampShareHours(hours: Int): Int {
        require(hours in 1..168) { "Share link expiry must be 1..168 hours" }
        return hours
    }

    private fun clampUploadHours(hours: Int): Int {
        require(hours in 1..1) { "Upload link expiry must be 1 hour" }
        return hours
    }

    suspend fun bucketExists(bucket: String) = client().bucketExists(bucket)
    suspend fun createBucket(bucket: String, region: String? = null) = client().createBucket(bucket, region)
    suspend fun deleteBucket(bucket: String) = client().deleteBucket(bucket)
    suspend fun copy(srcBucket: String, srcKey: String, dstBucket: String, dstKey: String) =
        client().copyObject(srcBucket, srcKey, dstBucket, dstKey)
    suspend fun stat(bucket: String, key: String) = client().stat(bucket, key)

    suspend fun versioningStatus(bucket: String) = client().getBucketVersioning(bucket)
    suspend fun setVersioning(bucket: String, enabled: Boolean) = client().setBucketVersioning(bucket, enabled)

}
