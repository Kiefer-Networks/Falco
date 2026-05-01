// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

/**
 * Certificate pins for Hetzner endpoints, expressed as SPKI SHA-256 (base64).
 *
 * Strategy: pin the live issuing intermediate plus the long-lived trust-anchor
 * root. `CertificatePinner` matches if ANY pin in the set validates, so a
 * rotated leaf still works while the intermediate stands, and a rotated
 * intermediate still works as long as the chain shares its root.
 *
 * Live observations (regenerate via `scripts/fetch_pins.sh` before every tag):
 *   - api.hetzner.cloud, *.your-objectstorage.com  → Let's Encrypt E7  (ECDSA → ISRG Root X2)
 *   - dns.hetzner.com                              → Let's Encrypt R13 (RSA   → ISRG Root X1)
 *   - api.hetzner.com, robot-ws.your-server.de     → Thawte TLS RSA CA G1 (DigiCert chain)
 */
internal object Pins {
    // Long-lived roots — primary trust anchors.
    private const val ISRG_ROOT_X1 = "C5+lpZ7tcVwmwQIMcRtPbsQtWLABXhQzejna0wHFr8M="
    private const val ISRG_ROOT_X2 = "diGVwiVYbubAI3RW4hB9xU8e/CH2GnkuvVFZE8zmgzI="
    private const val DIGICERT_GLOBAL_ROOT_CA = "r/mIkG3eEpVdm+u/ko/cwxzOMo1bk4TyHIlByibiA5E="

    // Live issuing intermediates — pinned because the server may omit the root
    // from the chain it presents, and to give us redundancy if Android's
    // system trust store lacks a given root.
    private const val LE_E7 = "y7xVm0TVJNahMr2sZydE2jQH8SquXV9yLF9seROHHHU="
    private const val LE_R13 = "AlSQhgtJirc8ahLyekmtX+Iw+v46yPYRLJt9Cq1GlB0="
    private const val THAWTE_TLS_RSA_CA_G1 = "42b9RNOnyb3tlC0KYtNPA3KKpJluskyU6aG+CipUmaM="

    private val letsEncryptRoots = listOf(ISRG_ROOT_X1, ISRG_ROOT_X2)
    private val digiCertChain = listOf(DIGICERT_GLOBAL_ROOT_CA, THAWTE_TLS_RSA_CA_G1)

    val cloud: List<String> = letsEncryptRoots + LE_E7              // api.hetzner.cloud
    val hetznerApi: List<String> = digiCertChain                    // api.hetzner.com (Storage Box)
    val robot: List<String> = digiCertChain                         // robot-ws.your-server.de
    val dns: List<String> = letsEncryptRoots + LE_R13               // dns.hetzner.com
    val objectStorage: List<String> = letsEncryptRoots + LE_E7      // *.your-objectstorage.com (fsn1/hel1/nbg1)

    fun all(): Map<String, List<String>> = mapOf(
        "api.hetzner.cloud" to cloud,
        "api.hetzner.com" to hetznerApi,
        "robot-ws.your-server.de" to robot,
        "dns.hetzner.com" to dns,
        "fsn1.your-objectstorage.com" to objectStorage,
        "hel1.your-objectstorage.com" to objectStorage,
        "nbg1.your-objectstorage.com" to objectStorage,
    )
}
