package de.kiefer_networks.falco

import android.content.ClipData
import android.content.ClipboardManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.view.WindowManager

class MainActivity : FlutterFragmentActivity() {
    private val handler = Handler(Looper.getMainLooper())

    // The expiry passed; the clip is cleared once it is readable.
    private var clearPending = false

    // Screenshots and the recents preview are blocked from the first frame
    // (SET-014); Dart turns it off when the user disables the setting.
    override fun onCreate(savedInstanceState: Bundle?) {
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        super.onCreate(savedInstanceState)
    }

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
                // Only Android 13+ honours the sensitive flag (SET-020).
                result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "falco/screen")
            .setMethodCallHandler { call, result ->
                if (call.method != "setSecure") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                if (call.arguments as? Boolean != false) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                }
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
        clearPending = false
        handler.removeCallbacksAndMessages(null)
        handler.postDelayed({
            clearPending = true
            clearIfOurs()
        }, expirySeconds * 1000L)
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) clearIfOurs()
    }

    // Without focus Android 10+ hides the clip (null): that says nothing
    // about whose it is, so the check waits for Falco's next focus and
    // never wipes a foreign clip.
    private fun clearIfOurs() {
        if (!clearPending) return
        val clipboard = getSystemService(ClipboardManager::class.java)
        val description = clipboard.primaryClipDescription
        if (description == null && !hasWindowFocus()) return
        clearPending = false
        if (description?.label != LABEL) return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            clipboard.clearPrimaryClip()
        } else {
            clipboard.setPrimaryClip(ClipData.newPlainText("", ""))
        }
    }

    private companion object {
        const val LABEL = "falco-secret"
    }
}
