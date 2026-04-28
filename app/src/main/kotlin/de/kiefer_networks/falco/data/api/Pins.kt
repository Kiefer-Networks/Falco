// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

/**
 * Certificate pins for Hetzner endpoints, expressed as SPKI SHA-256 (base64).
 *
 * **Rotation policy**: pin to issuer/intermediate public keys, not leaves.
 * Each host gets at least two pins so that a single rotation event can't lock
 * the app out. Update via `scripts/fetch_pins.sh` before each release.
 *
 * If a host's pin set is empty, [HttpClientFactory] falls back to system trust
 * only (still TLS-enforced, just unpinned). Releases must ship non-empty sets.
 */
internal object Pins {
    // Fill via scripts/fetch_pins.sh, then re-build. The strings below are
    // intentional placeholders that won't validate any real connection.
    val cloud: List<String> = emptyList()       // api.hetzner.cloud
    val robot: List<String> = emptyList()       // robot-ws.your-server.de
    val dns: List<String> = emptyList()         // dns.hetzner.com
    val objectStorage: List<String> = emptyList() // *.your-objectstorage.com

    fun all(): Map<String, List<String>> = mapOf(
        "api.hetzner.cloud" to cloud,
        "robot-ws.your-server.de" to robot,
        "dns.hetzner.com" to dns,
        "fsn1.your-objectstorage.com" to objectStorage,
        "hel1.your-objectstorage.com" to objectStorage,
        "nbg1.your-objectstorage.com" to objectStorage,
    )
}
