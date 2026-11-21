// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.repo

import de.kiefer_networks.falco.data.api.S3Client
import de.kiefer_networks.falco.data.api.validateAndNormalizeS3Endpoint
import de.kiefer_networks.falco.data.auth.AccountManager
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.withContext
import java.io.InputStream
import java.io.OutputStream
import java.util.concurrent.ConcurrentHashMap
import javax.inject.Inject
import javax.inject.Singleton

class S3CredentialsMissingException : RuntimeException(
    "Active Cloud project has no Object Storage credentials configured.",
)

class S3BucketNotFoundException(bucket: String) : RuntimeException("Bucket $bucket not found in any location")

/** Hetzner Object Storage locations. The S3 region equals the location name. */
val HETZNER_S3_LOCATIONS = listOf("fsn1", "nbg1", "hel1")

data class S3Bucket(val name: String, val location: String)

/**
 * Locations to query for a project. No endpoint (the default) means every
 * Hetzner location; an explicit endpoint (older projects) pins it to the
 * location of that host. The endpoint validator only admits the three
 * Hetzner hosts, so the host prefix is always a location name.
 */
internal fun s3LocationsFor(endpoint: String?): List<String> =
    if (endpoint.isNullOrBlank()) {
        HETZNER_S3_LOCATIONS
    } else {
        listOf(validateAndNormalizeS3Endpoint(endpoint).removePrefix("https://").substringBefore('.'))
    }

/**
 * Merges per location ListBuckets results. A failing location is skipped;
 * only when every location failed the first error is rethrown. On a duplicate
 * name the first location in [results] order wins.
 */
internal fun mergeBucketListings(results: List<Pair<String, Result<List<String>>>>): List<S3Bucket> {
    if (results.isNotEmpty() && results.all { it.second.isFailure }) {
        throw results.first().second.exceptionOrNull()!!
    }
    return results
        .flatMap { (loc, r) -> r.getOrDefault(emptyList()).map { S3Bucket(it, loc) } }
        .distinctBy { it.name }
}

/** Location of [bucket], or null when it has to be looked up by listing. */
internal fun resolveBucketLocation(bucket: String, locations: List<String>, known: Map<String, String>?): String? =
    locations.singleOrNull() ?: known?.get(bucket)

@Singleton
class S3Repo @Inject constructor(private val accounts: AccountManager) {

    private data class Creds(
        val projectId: String,
        val accessKey: String,
        val secretKey: String,
        val region: String?,
        val locations: List<String>,
    )

    private val clients = ConcurrentHashMap<Pair<Creds, String>, S3Client>()
    private val bucketLocations = ConcurrentHashMap<Creds, Map<String, String>>()

    private suspend fun creds(): Creds {
        val project = accounts.activeCloudProject.first()
            ?: throw S3CredentialsMissingException()
        if (!project.hasS3) throw S3CredentialsMissingException()
        return Creds(
            projectId = project.id,
            accessKey = project.s3AccessKey!!,
            secretKey = project.s3SecretKey!!,
            region = project.s3Region?.takeIf { it.isNotBlank() },
            locations = s3LocationsFor(project.s3Endpoint),
        )
    }

    private fun client(c: Creds, location: String): S3Client = clients.getOrPut(c to location) {
        S3Client(
            endpoint = "https://$location.your-objectstorage.com",
            region = c.region ?: location,
            accessKey = c.accessKey,
            secretKey = c.secretKey,
        )
    }

    private suspend fun listAll(c: Creds): List<S3Bucket> {
        val results = coroutineScope {
            c.locations.map { loc ->
                async { loc to runCatching { client(c, loc).listBuckets() } }
            }.awaitAll()
        }
        return mergeBucketListings(results).also { merged ->
            bucketLocations[c] = merged.associate { it.name to it.location }
        }
    }

    private suspend fun locate(bucket: String): Pair<String, S3Client> {
        val c = creds()
        val loc = resolveBucketLocation(bucket, c.locations, bucketLocations[c])
            ?: listAll(c).firstOrNull { it.name == bucket }?.location
            ?: throw S3BucketNotFoundException(bucket)
        return loc to client(c, loc)
    }

    private suspend fun clientFor(bucket: String): S3Client = locate(bucket).second

    suspend fun listBuckets(): List<S3Bucket> = listAll(creds())
    suspend fun listObjects(bucket: String, prefix: String = "") = clientFor(bucket).listObjects(bucket, prefix)
    suspend fun delete(bucket: String, key: String) = clientFor(bucket).deleteObject(bucket, key)
    suspend fun deleteAll(bucket: String, keys: List<String>) = clientFor(bucket).deleteObjects(bucket, keys)
    suspend fun shareLink(bucket: String, key: String, hours: Int): String =
        clientFor(bucket).presignedDownloadUrl(bucket, key, clampShareHours(hours) * 3600)
    suspend fun uploadLink(bucket: String, key: String, hours: Int): String =
        clientFor(bucket).presignedUploadUrl(bucket, key, clampUploadHours(hours) * 3600)

    suspend fun putObject(bucket: String, key: String, contentType: String, size: Long, stream: InputStream) =
        clientFor(bucket).putObject(bucket, key, contentType, size, stream)

    /** Streams the object body to [output] and returns the number of bytes copied. */
    suspend fun download(bucket: String, key: String, output: OutputStream): Long {
        val client = clientFor(bucket)
        return withContext(Dispatchers.IO) { client.getObject(bucket, key).use { it.copyTo(output) } }
    }

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

    /** Creates [bucket] in [location]. Projects pinned to one endpoint ignore [location]. */
    suspend fun createBucket(bucket: String, location: String) {
        val c = creds()
        val loc = c.locations.singleOrNull() ?: location.also { require(it in c.locations) { "Unknown location $it" } }
        client(c, loc).createBucket(bucket, c.region ?: loc)
        bucketLocations[c] = bucketLocations[c].orEmpty() + (bucket to loc)
    }

    suspend fun deleteBucket(bucket: String) {
        clientFor(bucket).deleteBucket(bucket)
        val c = creds()
        bucketLocations[c]?.let { bucketLocations[c] = it - bucket }
    }

    /**
     * Server side copy within one location. Across locations the object is
     * streamed through the device, since a location cannot read another's
     * buckets.
     */
    suspend fun copy(srcBucket: String, srcKey: String, dstBucket: String, dstKey: String) {
        val (srcLoc, src) = locate(srcBucket)
        val (dstLoc, dst) = locate(dstBucket)
        if (srcLoc == dstLoc) {
            src.copyObject(srcBucket, srcKey, dstBucket, dstKey)
            return
        }
        val stat = src.stat(srcBucket, srcKey)
        src.getObject(srcBucket, srcKey).use { input ->
            dst.putObject(
                dstBucket,
                dstKey,
                stat.contentType() ?: "application/octet-stream",
                stat.size(),
                input,
            )
        }
    }

    suspend fun stat(bucket: String, key: String) = clientFor(bucket).stat(bucket, key)

    suspend fun versioningStatus(bucket: String) = clientFor(bucket).getBucketVersioning(bucket)
    suspend fun setVersioning(bucket: String, enabled: Boolean) = clientFor(bucket).setBucketVersioning(bucket, enabled)
}
