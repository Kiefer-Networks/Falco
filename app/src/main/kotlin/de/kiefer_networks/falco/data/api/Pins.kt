// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

/**
 * Certificate pins for Hetzner endpoints, expressed as SPKI SHA-256 (base64).
 *
 * **Strategy**: pin trust-anchor roots, not leaves or short-lived intermediates.
 * Let's Encrypt rotates leaves every ~60 days and intermediates every ~3 years,
 * so we pin ISRG Root X1 + X2 directly (10-year validity). Hetzner's DigiCert
 * stack ultimately chains to DigiCert Global Root CA — pin that plus the
 * Thawte G1 intermediate for redundancy.
 *
 * `CertificatePinner` matches if ANY pin in the set validates, so we ship two
 * roots per host where possible. Run `scripts/fetch_pins.sh` to verify.
 */
internal object Pins {
    // Roots (long-lived) — primary trust anchors.
    private const val ISRG_ROOT_X1 = "C5+lpZ7tcVwmwQIMcRtPbsQtWLABXhQzejna0wHFr8M="
    private const val ISRG_ROOT_X2 = "diGVwiVYbubAI3RW4hB9xU8e/CH2GnkuvVFZE8zmgzI="
    private const val DIGICERT_GLOBAL_ROOT_CA = "r/mIkG3eEpVdm+u/ko/cwxzOMo1bk4TyHIlByibiA5E="

    // Intermediates (rotate slowly) — secondary backup.
    private const val THAWTE_TLS_RSA_CA_G1 = "42b9RNOnyb3tlC0KYtNPA3KKpJluskyU6aG+CipUmaM="

    private val letsEncryptRoots = listOf(ISRG_ROOT_X1, ISRG_ROOT_X2)
    private val digiCertChain = listOf(DIGICERT_GLOBAL_ROOT_CA, THAWTE_TLS_RSA_CA_G1)

    val cloud: List<String> = letsEncryptRoots                    // api.hetzner.cloud
    // TODO(maintainer): Re-run scripts/fetch_pins.sh against api.hetzner.com
    //  before the next release. The audit (A-003) suspected this host actually
    //  serves a Let's Encrypt chain, not DigiCert as assumed below — if so,
    //  switch this list to `letsEncryptRoots`. Until verified live, the
    //  digiCertChain pin here may break Storage Box traffic in the field.
    val hetznerApi: List<String> = digiCertChain                  // api.hetzner.com (storage boxes)
    val robot: List<String> = digiCertChain                       // robot-ws.your-server.de
    val dns: List<String> = letsEncryptRoots                      // dns.hetzner.com
    val objectStorage: List<String> = letsEncryptRoots            // *.your-objectstorage.com (fsn1/hel1/nbg1 — all LE)

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
