package de.kiefer_networks.falco

import android.content.ClipData
import android.content.ClipboardManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val handler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "falco/clipboard")
            .setMethodCallHandler { call, result ->
                if (call.method != "setSensitive") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                setSensitive(
                    call.argument<String>("text").orEmpty(),
                    call.argument<Int>("expirySeconds") ?: 60,
                )
                result.success(null)
            }
    }

    // Marks the clip as sensitive (hidden in the clipboard preview on
    // Android 13+) and clears it after the expiry if it is still ours.
    private fun setSensitive(text: String, expirySeconds: Int) {
        val clipboard = getSystemService(ClipboardManager::class.java)
        val clip = ClipData.newPlainText(LABEL, text)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            clip.description.extras = PersistableBundle().apply {
                putBoolean("android.content.extra.IS_SENSITIVE", true)
            }
        }
        clipboard.setPrimaryClip(clip)
        handler.removeCallbacksAndMessages(null)
        handler.postDelayed({
            if (clipboard.primaryClipDescription?.label == LABEL) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    clipboard.clearPrimaryClip()
                } else {
                    clipboard.setPrimaryClip(ClipData.newPlainText("", ""))
                }
            }
        }, expirySeconds * 1000L)
    }

    private companion object {
        const val LABEL = "falco-secret"
    }
}
