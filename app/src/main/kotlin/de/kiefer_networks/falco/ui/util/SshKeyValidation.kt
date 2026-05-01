// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.util

/**
 * Heuristic guard against accidentally uploading a private key. Hetzner only
 * stores public keys; if the user pastes a private blob (e.g. `id_ed25519`
 * instead of `id_ed25519.pub`) we reject before it reaches the API.
 *
 * Covers OpenSSH/PEM private keys, PuTTY (`PUTTY-USER-KEY-FILE`), the SSH2
 * encrypted variant, and OpenSSH certificates.
 */
fun looksLikePrivateKey(input: String): Boolean {
    val upper = input.uppercase()
    return upper.contains("BEGIN PRIVATE KEY") ||
        upper.contains("BEGIN OPENSSH PRIVATE KEY") ||
        upper.contains("BEGIN RSA PRIVATE KEY") ||
        upper.contains("BEGIN DSA PRIVATE KEY") ||
        upper.contains("BEGIN EC PRIVATE KEY") ||
        upper.contains("BEGIN ENCRYPTED PRIVATE KEY") ||
        upper.contains("BEGIN SSH2 ENCRYPTED PRIVATE KEY") ||
        upper.contains("BEGIN OPENSSH-CERTIFICATE") ||
        upper.contains("PUTTY-USER-KEY-FILE")
}

/**
 * Allow-list of recognised OpenSSH public-key prefixes. The trimmed input must
 * start with one of these tokens (followed by a space) to be considered a
 * public key. Anything else (PEM blobs, free-form text, Putty files, etc.)
 * is rejected by the AddKeySheet flows.
 */
private val PUBLIC_KEY_PREFIXES = listOf(
    "ssh-rsa ",
    "ssh-ed25519 ",
    "ssh-dss ",
    "ecdsa-sha2-nistp256 ",
    "ecdsa-sha2-nistp384 ",
    "ecdsa-sha2-nistp521 ",
    "sk-ecdsa-sha2-nistp256@openssh.com ",
    "sk-ssh-ed25519@openssh.com ",
)

/**
 * Returns `true` if `input` (after trimming) starts with a known OpenSSH
 * public-key algorithm prefix. Blank input returns `false`.
 */
fun looksLikePublicKey(input: String): Boolean {
    val trimmed = input.trimStart()
    if (trimmed.isBlank()) return false
    return PUBLIC_KEY_PREFIXES.any { trimmed.startsWith(it) }
}
