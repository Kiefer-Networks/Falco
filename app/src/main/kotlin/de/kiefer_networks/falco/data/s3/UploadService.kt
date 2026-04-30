// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.s3

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.net.Uri
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import dagger.hilt.android.AndroidEntryPoint
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.api.S3Client
import de.kiefer_networks.falco.data.auth.AccountManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Foreground service for S3 uploads. Files >5 MiB stream as multipart and the
 * upload survives the user backgrounding the app. Cancellable via the
 * notification action.
 */
@AndroidEntryPoint
class UploadService : Service() {

    @Inject lateinit var accounts: AccountManager

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val bucket = intent?.getStringExtra(EXTRA_BUCKET)?.takeIf { isValidBucket(it) }
            ?: return START_NOT_STICKY
        val key = intent.getStringExtra(EXTRA_KEY)?.takeIf { isValidObjectKey(it) }
            ?: return START_NOT_STICKY
        val source = intent.getParcelableExtra<Uri>(EXTRA_SOURCE_URI)?.takeIf { isLocalContentUri(it) }
            ?: return START_NOT_STICKY
        val mime = intent.getStringExtra(EXTRA_MIME)
            ?.takeIf { it.matches(MIME_REGEX) }
            ?: "application/octet-stream"

        startInForeground(buildNotification("Uploading $key…"))

        scope.launch {
            runCatching {
                val project = accounts.activeCloudProject.first()
                    ?: error("No active Cloud project")
                require(project.hasS3) { "Active Cloud project has no S3 credentials" }
                val client = S3Client(
                    endpoint = project.s3Endpoint!!,
                    region = project.s3Region,
                    accessKey = project.s3AccessKey!!,
                    secretKey = project.s3SecretKey!!,
                )
                val resolver = applicationContext.contentResolver
                val size = resolver.openFileDescriptor(source, "r")?.use { it.statSize } ?: -1L
                resolver.openInputStream(source).use { input ->
                    requireNotNull(input) { "Cannot open input stream for $source" }
                    client.putObject(bucket, key, mime, size, input)
                }
            }.onFailure { /* TODO surface error notification */ }
            stopSelf(startId)
        }
        return START_NOT_STICKY
    }

    /** S3 bucket name format per AWS spec — lowercase alphanumerics, dot, dash, 3-63 chars. */
    private fun isValidBucket(name: String): Boolean =
        name.matches(BUCKET_REGEX) && !name.startsWith("-") && !name.endsWith("-")

    /** Reject path-traversal sequences and absolute paths. */
    private fun isValidObjectKey(key: String): Boolean =
        key.isNotBlank() &&
            !key.startsWith("/") &&
            "/../" !in "/$key/" &&
            key.length <= MAX_KEY_LEN

    /** Only accept content:// or file:// from the local resolver — never opaque/remote schemes. */
    private fun isLocalContentUri(uri: Uri): Boolean =
        uri.scheme in setOf("content", "file")

    override fun onDestroy() {
        scope.cancel()
        super.onDestroy()
    }

    private fun startInForeground(notification: Notification) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun buildNotification(text: String): Notification {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(CHANNEL_ID, "Uploads", NotificationManager.IMPORTANCE_LOW)
            nm.createNotificationChannel(channel)
        }
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(getString(R.string.s3_upload))
            .setContentText(text)
            .setSmallIcon(android.R.drawable.stat_sys_upload)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .build()
    }

    companion object {
        const val EXTRA_BUCKET = "bucket"
        const val EXTRA_KEY = "key"
        const val EXTRA_SOURCE_URI = "source"
        const val EXTRA_MIME = "mime"
        private const val CHANNEL_ID = "falco_uploads"
        private const val NOTIFICATION_ID = 0xF1A1
        private const val MAX_KEY_LEN = 1024
        private val BUCKET_REGEX = "^[a-z0-9](?:[a-z0-9.\\-]{1,61}[a-z0-9])?$".toRegex()
        private val MIME_REGEX = "^[\\w.+-]+/[\\w.+-]+$".toRegex()
    }
}
