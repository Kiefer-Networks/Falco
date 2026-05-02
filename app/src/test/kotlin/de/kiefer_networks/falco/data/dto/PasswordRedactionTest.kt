// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.dto

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/**
 * Guards against accidental password leakage via `toString()` — log lines,
 * crash reports, and debug snapshots all funnel through it. Each DTO with a
 * password / root_password field must redact the secret while still printing
 * its surrounding context for diagnosis.
 */
class PasswordRedactionTest {

    private val secret = "hunter2-do-not-leak"

    @Test
    fun `RequestConsoleResponse hides password`() {
        val s = RequestConsoleResponse(
            action = ActionEnvelope(1, "request_console", "running"),
            wssUrl = "wss://x",
            password = secret,
        ).toString()
        assertNoSecret(s)
    }

    @Test
    fun `CloudServerActionResponse hides root_password`() {
        val s = CloudServerActionResponse(
            action = ActionEnvelope(1, "reset_password", "running"),
            rootPassword = secret,
        ).toString()
        assertNoSecret(s)
    }

    @Test
    fun `CloudServerActionResponse keeps null literal`() {
        val s = CloudServerActionResponse(
            action = ActionEnvelope(1, "noop", "success"),
            rootPassword = null,
        ).toString()
        assertTrue(s.contains("rootPassword=null"))
    }

    @Test
    fun `CreateServerResponse hides root_password`() {
        val server = CloudServer(id = 1, name = "n", status = "running", created = "2026-01-01")
        val s = CreateServerResponse(server = server, rootPassword = secret).toString()
        assertNoSecret(s)
    }

    @Test
    fun `CreateStorageBoxRequest hides password`() {
        val s = CreateStorageBoxRequest(
            name = "box",
            storageBoxType = "bx11",
            location = "fsn1",
            password = secret,
        ).toString()
        assertNoSecret(s)
    }

    @Test
    fun `CreateStorageBoxSubaccount hides password`() {
        val s = CreateStorageBoxSubaccount(
            password = secret,
            homeDirectory = "/home/x",
        ).toString()
        assertNoSecret(s)
    }

    @Test
    fun `ResetSubaccountPasswordRequest hides password`() {
        assertNoSecret(ResetSubaccountPasswordRequest(secret).toString())
    }

    @Test
    fun `ResetStorageBoxPasswordRequest hides password`() {
        assertNoSecret(ResetStorageBoxPasswordRequest(secret).toString())
    }

    @Test
    fun `RobotRescue hides password`() {
        val s = RobotRescue(serverNumber = 1, active = true, password = secret).toString()
        assertNoSecret(s)
    }

    @Test
    fun `CreateCertificateRequest hides privateKey`() {
        // F-002: TLS private key must never reach toString in raw form.
        val pem = "-----BEGIN PRIVATE KEY-----\n$secret\n-----END PRIVATE KEY-----"
        val s = CreateCertificateRequest(
            name = "wildcard.example.com",
            certificate = "cert-pem-body",
            privateKey = pem,
        ).toString()
        assertFalse("toString leaked private key body: $s", s.contains(secret))
        assertFalse("toString leaked PEM marker: $s", s.contains("BEGIN PRIVATE KEY"))
        assertTrue("toString must mark redaction with ***: $s", s.contains("***"))
    }

    @Test
    fun `CreateServerRequest masks userData length-only`() {
        // F-008: cloud-init scripts may carry bootstrap secrets. Only a length
        // hint may leak — never the body.
        val cloudInit = "#cloud-config\nruncmd:\n  - echo \"$secret\" > /root/.token\n"
        val s = CreateServerRequest(
            name = "web-1",
            serverType = "cx21",
            image = "debian-12",
            userData = cloudInit,
        ).toString()
        assertFalse("toString leaked user_data body: $s", s.contains(secret))
        assertFalse("toString leaked cloud-config marker: $s", s.contains("#cloud-config"))
        assertTrue(
            "toString should report a length hint instead of body",
            s.contains("chars"),
        )
    }

    private fun assertNoSecret(s: String) {
        assertFalse("toString leaked password: $s", s.contains(secret))
        assertTrue("toString must mark redaction with ***: $s", s.contains("***"))
    }
}
