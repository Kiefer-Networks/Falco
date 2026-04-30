// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.auth

import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

/**
 * Unlock-gate. Accepts Class-3 biometrics OR the device credential
 * (PIN/pattern/password). If biometrics are enrolled, the system prompt
 * will offer them as the primary affordance and fall back to the device PIN
 * via the built-in "Use PIN" link inside the prompt.
 *
 * Trade-off note: A previous revision bound the prompt to a Keystore-backed
 * `CryptoObject` so the unlock proved key-possession rather than just user-
 * presence. The user explicitly requested PIN as a sufficient unlock with
 * biometrics merely suggested, so the CryptoObject binding is removed.
 * Credentials remain encrypted at rest via [CredentialStore]
 * (EncryptedSharedPreferences with a Keystore master key); this gate
 * controls only access to the running session.
 */
class BiometricGate(private val activity: FragmentActivity) {

    enum class Availability { AVAILABLE, NO_HARDWARE, NONE_ENROLLED, UNAVAILABLE }

    fun availability(): Availability {
        val mgr = BiometricManager.from(activity)
        // Either Class-3 biometric or the device credential satisfies the gate.
        val combined = BiometricManager.Authenticators.BIOMETRIC_STRONG or
            BiometricManager.Authenticators.DEVICE_CREDENTIAL
        return when (mgr.canAuthenticate(combined)) {
            BiometricManager.BIOMETRIC_SUCCESS -> Availability.AVAILABLE
            BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE,
            BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE -> {
                // No biometric hardware — but a device PIN/pattern still works.
                if (mgr.canAuthenticate(BiometricManager.Authenticators.DEVICE_CREDENTIAL) ==
                    BiometricManager.BIOMETRIC_SUCCESS
                ) Availability.AVAILABLE else Availability.NO_HARDWARE
            }
            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> {
                // No biometrics enrolled — fall through if device credential is set.
                if (mgr.canAuthenticate(BiometricManager.Authenticators.DEVICE_CREDENTIAL) ==
                    BiometricManager.BIOMETRIC_SUCCESS
                ) Availability.AVAILABLE else Availability.NONE_ENROLLED
            }
            else -> Availability.UNAVAILABLE
        }
    }

    suspend fun authenticate(title: String, subtitle: String, negative: String): Result =
        suspendCancellableCoroutine { cont ->
            val executor = ContextCompat.getMainExecutor(activity)
            val callback = object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    if (cont.isActive) cont.resume(Result.Succeeded)
                }
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    if (cont.isActive) cont.resume(Result.Error(errorCode, errString.toString()))
                }
                override fun onAuthenticationFailed() = Unit
            }
            val prompt = BiometricPrompt(activity, executor, callback)

            // BiometricPrompt forbids `setNegativeButtonText` together with
            // DEVICE_CREDENTIAL — the system supplies the cancel affordance.
            val info = BiometricPrompt.PromptInfo.Builder()
                .setTitle(title)
                .setSubtitle(subtitle)
                .setAllowedAuthenticators(
                    BiometricManager.Authenticators.BIOMETRIC_STRONG or
                        BiometricManager.Authenticators.DEVICE_CREDENTIAL,
                )
                .setConfirmationRequired(true)
                .build()

            prompt.authenticate(info)
            cont.invokeOnCancellation { prompt.cancelAuthentication() }
        }

    sealed interface Result {
        data object Succeeded : Result
        data class Error(val code: Int, val message: String) : Result
    }
}
