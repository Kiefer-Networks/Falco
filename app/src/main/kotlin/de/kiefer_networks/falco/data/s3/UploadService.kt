// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.s3

import android.annotation.SuppressLint
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
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.IntentCompat
import dagger.hilt.android.AndroidEntryPoint
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.repo.S3Repo
import de.kiefer_networks.falco.data.util.sanitizeError
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.concurrent.atomic.AtomicInteger
import javax.inject.Inject

/**
 * Foreground service for S3 uploads. Files >5 MiB stream as multipart and the
 * upload survives the user backgrounding the app. Cancellable via the
 * notification action.
 */
@AndroidEntryPoint
class UploadService : Service() {

    @Inject lateinit var s3: S3Repo

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    override fun onBind(intent: Intent?): IBinder? = null

    /** Uploads still running. Only touched on the main thread. */
    private var active = 0

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // startForegroundService() obliges us to call startForeground() even
        // when the extras turn out to be invalid, so do it first.
        startInForeground(buildNotification(getString(R.string.s3_upload_running)))

        val bucket = intent?.getStringExtra(EXTRA_BUCKET)?.takeIf { isValidBucket(it) }
        val key = intent?.getStringExtra(EXTRA_KEY)?.takeIf { isValidObjectKey(it) }
        val source = intent
            ?.let { IntentCompat.getParcelableExtra(it, EXTRA_SOURCE_URI, Uri::class.java) }
            ?.takeIf { isLocalContentUri(it) }
        if (bucket == null || key == null || source == null) {
            stopIfIdle()
            return START_NOT_STICKY
        }
        val mime = intent?.getStringExtra(EXTRA_MIME)
            ?.takeIf { it.matches(MIME_REGEX) }
            ?: "application/octet-stream"

        active++
        scope.launch {
            val result = runCatching {
                val resolver = applicationContext.contentResolver
                val size = resolver.openFileDescriptor(source, "r")?.use { it.statSize } ?: -1L
                val input = requireNotNull(resolver.openInputStream(source)) {
                    "Cannot open input stream for $source"
                }
                input.use { s3.putObject(bucket, key, mime, size, it) }
            }
            if (result.isFailure && result.exceptionOrNull() is CancellationException) return@launch
            val name = key.substringAfterLast('/')
            notifyResult(
                if (result.isSuccess) {
                    getString(R.string.s3_upload_done, name)
                } else {
                    getString(R.string.s3_upload_failed, name, sanitizeError(result.exceptionOrNull()!!))
                },
                success = result.isSuccess,
            )
            withContext(Dispatchers.Main) {
                active--
                stopIfIdle()
            }
        }
        return START_NOT_STICKY
    }

    private fun stopIfIdle() {
        if (active > 0) return
        ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    /** Posts a dismissible result notification (no op without POST_NOTIFICATIONS). */
    @SuppressLint("MissingPermission")
    private fun notifyResult(text: String, success: Boolean) {
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(getString(R.string.s3_upload))
            .setContentText(text)
            .setStyle(NotificationCompat.BigTextStyle().bigText(text))
            .setSmallIcon(if (success) android.R.drawable.stat_sys_upload_done else android.R.drawable.stat_notify_error)
            .setAutoCancel(true)
            .build()
        val nm = NotificationManagerCompat.from(this)
        if (nm.areNotificationsEnabled()) {
            runCatching { nm.notify(resultIds.incrementAndGet(), notification) }
        }
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

    /** Only accept content:// from the local resolver — never file:// or opaque/remote schemes. */
    private fun isLocalContentUri(uri: Uri): Boolean = uri.scheme == "content"

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
            val channel = NotificationChannel(CHANNEL_ID, getString(R.string.s3_upload), NotificationManager.IMPORTANCE_LOW)
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
        private val resultIds = AtomicInteger(NOTIFICATION_ID)
        private val MIME_REGEX = "^[\\w.+-]+/[\\w.+-]+$".toRegex()
    }
}
