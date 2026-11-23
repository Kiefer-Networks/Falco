package de.kiefer_networks.falco

import android.app.KeyguardManager
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
        // The vault stays unbound below Android 11, and a Keystore key made
        // without a screen lock is replaced once there is one
        // (secret_store.dart).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "falco/device")
            .setMethodCallHandler { call, result ->
                if (call.method != "info") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val keyguard = getSystemService(KeyguardManager::class.java)
                result.success(
                    mapOf(
                        "sdk" to Build.VERSION.SDK_INT,
                        "secure" to (keyguard?.isDeviceSecure ?: false),
                    ),
                )
            }
    }

    // Marks the clip as sensitive (hidden in the clipboard preview on
    // Android 13+) and clears it after the expiry if it is still ours.
    private fun setSensitive(text: String, expirySeconds: Int) {
        val clipboard = applicationContext.getSystemService(ClipboardManager::class.java)
        val clip = ClipData.newPlainText(LABEL, text)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            clip.description.extras = PersistableBundle().apply {
                putBoolean("android.content.extra.IS_SENSITIVE", true)
            }
        }
        clipboard.setPrimaryClip(clip)
        // Read back in the foreground: the system's copy time tells this
        // clip apart from a later one with the same label. Without focus the
        // read back is null; then the label alone has to match.
        copiedAt = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            clipboard.primaryClipDescription?.timestamp
        } else {
            null
        }
        handler.removeCallbacksAndMessages(null)
        handler.postDelayed({ clearIfOurs(clipboard) }, expirySeconds * 1000L)
    }

    // Process wide, so a recreated or finished activity still clears.
    private companion object {
        const val LABEL = "falco-secret"
        val handler = Handler(Looper.getMainLooper())

        // Copy time of our clip on Android 8+; null matches by label only.
        var copiedAt: Long? = null

        // In background Android 10+ hides the clip (null description). Like
        // Falco 2 (SET-019) an unreadable clip is cleared anyway: a foreign
        // clip copied meanwhile may be wiped, but a secret must not outlive
        // its expiry because Falco was not in front. A readable clip is
        // cleared only when label and copy time prove it ours.
        fun clearIfOurs(clipboard: ClipboardManager) {
            val description = clipboard.primaryClipDescription
            if (description != null) {
                if (description.label != LABEL) return
                val at = copiedAt
                if (at != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                    description.timestamp != at
                ) {
                    return
                }
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                clipboard.clearPrimaryClip()
            } else {
                clipboard.setPrimaryClip(ClipData.newPlainText("", ""))
            }
        }
    }
}
