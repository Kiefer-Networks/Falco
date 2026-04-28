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
    suspend fun shareLink(bucket: String, key: String, hours: Int): String =
        client().presignedDownloadUrl(bucket, key, hours * 3600)
}
