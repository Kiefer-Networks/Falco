// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Request
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Assert.fail
import org.junit.Before
import org.junit.Test

/**
 * Unit test for the rate-limit branch of [HttpClientFactory]'s Robot
 * client.
 *
 * NOTE: The production implementation lives inside `HttpClientFactory.kt`
 * as `private class RobotRateLimitInterceptor`. We are required not to
 * change production-code visibility, so we cannot instantiate the
 * production interceptor directly. Instead we hand-roll an interceptor
 * with the **same logic** the production code uses (mirrors the body of
 * `RobotRateLimitInterceptor.intercept`) and assert that
 * [RobotRateLimitException] — which IS public — is thrown for the same
 * response codes.
 *
 * TODO: When `RobotRateLimitInterceptor` is exposed (e.g. as `internal`
 * or moved to its own file), drop the local interceptor below and test
 * the production class directly.
 */
class RateLimitInterceptorTest {

    private lateinit var server: MockWebServer

    /** Mirrors the production logic in HttpClientFactory.kt verbatim. */
    private class TestRobotRateLimitInterceptor : Interceptor {
        override fun intercept(chain: Interceptor.Chain): okhttp3.Response {
            val response = chain.proceed(chain.request())
            if (response.code == 429 ||
                (response.code == 403 && response.body?.contentLength() == 0L)
            ) {
                response.close()
                throw RobotRateLimitException(chain.request())
            }
            return response
        }
    }

    @Before
    fun setUp() {
        server = MockWebServer()
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
    }

    private fun client(): OkHttpClient = OkHttpClient.Builder()
        .addInterceptor(TestRobotRateLimitInterceptor())
        .build()

    @Test
    fun `429 response throws RobotRateLimitException`() {
        server.enqueue(
            MockResponse.Builder()
                .code(429)
                .body("""{"error":{"status":429,"code":"RATE_LIMIT_EXCEEDED"}}""")
                .build(),
        )

        val request = Request.Builder().url(server.url("/server")).build()
        try {
            client().newCall(request).execute()
            fail("Expected RobotRateLimitException to be thrown for 429 response")
        } catch (e: RobotRateLimitException) {
            assertEquals(server.url("/server"), e.request.url)
        }
    }

    @Test
    fun `403 with empty body throws RobotRateLimitException`() {
        server.enqueue(
            MockResponse.Builder()
                .code(403)
                .setHeader("Content-Length", "0")
                .build(),
        )

        val request = Request.Builder().url(server.url("/server")).build()
        try {
            client().newCall(request).execute()
            fail("Expected RobotRateLimitException to be thrown for 403 with empty body")
        } catch (e: RobotRateLimitException) {
            assertTrue(true)
        }
    }

    @Test
    fun `200 response passes through without exception`() {
        server.enqueue(
            MockResponse.Builder()
                .code(200)
                .setHeader("Content-Type", "application/json")
                .body("[]")
                .build(),
        )

        val request = Request.Builder().url(server.url("/server")).build()
        client().newCall(request).execute().use { response ->
            assertEquals(200, response.code)
        }
    }

    @Test
    fun `403 with non-empty body does not throw`() {
        // The production interceptor only treats 403 as a rate limit when the
        // body is empty (typical Robot rate-limit signal). A 403 with a body
        // is a regular auth failure and must pass through.
        server.enqueue(
            MockResponse.Builder()
                .code(403)
                .setHeader("Content-Type", "application/json")
                .body("""{"error":{"status":403,"code":"FORBIDDEN"}}""")
                .build(),
        )

        val request = Request.Builder().url(server.url("/server")).build()
        client().newCall(request).execute().use { response ->
            assertEquals(403, response.code)
        }
    }
}
