// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.util

import android.content.ClipData
import android.content.ClipDescription
import android.content.ClipboardManager
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PersistableBundle

/**
 * Centralised clipboard helpers. All callers that copy potentially sensitive
 * content (tokens, presigned URLs, root passwords, IPs) MUST go through here.
 *
 * - Marks the clip as `EXTRA_IS_SENSITIVE` on Android 13+ so the system UI
 *   suppresses the preview banner.
 * - Schedules a wipe after [WIPE_AFTER_MS] so a forgotten copy doesn't sit on
 *   the clipboard indefinitely.
 */
object Clipboard {
    private const val WIPE_AFTER_MS = 60_000L

    /** Stamp of our most recent copy; a newer copy supersedes an older pending wipe. */
    @Volatile private var lastCopyStamp = 0L

    fun copySensitive(ctx: Context, label: String, value: String) {
        val cm = ctx.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText(label, value)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            clip.description.extras = PersistableBundle().apply {
                putBoolean(ClipDescription.EXTRA_IS_SENSITIVE, true)
            }
        }
        cm.setPrimaryClip(clip)
        val stamp = System.nanoTime()
        lastCopyStamp = stamp
        scheduleClear(cm, value, stamp)
    }

    private fun scheduleClear(cm: ClipboardManager, originalValue: String, stamp: Long) {
        Handler(Looper.getMainLooper()).postDelayed({
            // From API 29 a backgrounded app reads primaryClip as null, so an
            // unreadable clip must not block the wipe. Skip only when we can
            // read the clip and see the user replaced it.
            val currentText = runCatching { cm.primaryClip?.getItemAt(0)?.text?.toString() }.getOrNull()
            if (shouldClear(stamp, lastCopyStamp, currentText, originalValue)) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    cm.clearPrimaryClip()
                } else {
                    cm.setPrimaryClip(ClipData.newPlainText("", ""))
                }
            }
        }, WIPE_AFTER_MS)
    }

    /** Pure decision for the delayed wipe; [currentText] is null when unreadable. */
    internal fun shouldClear(stamp: Long, latestStamp: Long, currentText: String?, originalValue: String): Boolean =
        stamp == latestStamp && (currentText == null || currentText == originalValue)
}
