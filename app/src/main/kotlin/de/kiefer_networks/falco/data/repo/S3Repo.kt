// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.S3Client
import de.kiefer_networks.falco.data.auth.AccountManager
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class S3Repo @Inject constructor(private val accounts: AccountManager) {

    private suspend fun client(): S3Client {
        val s = accounts.activeSecrets()
        val endpoint = requireNotNull(s?.s3Endpoint) { "S3 endpoint missing" }
        val ak = requireNotNull(s.s3AccessKey) { "S3 access key missing" }
        val sk = requireNotNull(s.s3SecretKey) { "S3 secret key missing" }
        return S3Client(endpoint, s.s3Region, ak, sk)
    }

    suspend fun listBuckets() = client().listBuckets()
    suspend fun listObjects(bucket: String, prefix: String = "") = client().listObjects(bucket, prefix)
    suspend fun delete(bucket: String, key: String) = client().deleteObject(bucket, key)
    suspend fun shareLink(bucket: String, key: String, hours: Int): String =
        client().presignedDownloadUrl(bucket, key, hours * 3600)
}
