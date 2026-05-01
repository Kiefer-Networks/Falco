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

    fun copySensitive(ctx: Context, label: String, value: String) {
        val cm = ctx.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText(label, value)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            clip.description.extras = PersistableBundle().apply {
                putBoolean(ClipDescription.EXTRA_IS_SENSITIVE, true)
            }
        }
        cm.setPrimaryClip(clip)
        scheduleClear(cm, value)
    }

    private fun scheduleClear(cm: ClipboardManager, originalValue: String) {
        Handler(Looper.getMainLooper()).postDelayed({
            // Only clear if the user hasn't replaced the clip with something else.
            val currentText = cm.primaryClip?.getItemAt(0)?.text?.toString()
            if (currentText == originalValue) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    cm.clearPrimaryClip()
                } else {
                    cm.setPrimaryClip(ClipData.newPlainText("", ""))
                }
            }
        }, WIPE_AFTER_MS)
    }
}
