// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.api

import okhttp3.CertificatePinner
import okhttp3.ConnectionSpec
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.TlsVersion
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import java.util.UUID
import java.util.concurrent.TimeUnit

object HttpClientFactory {

    init {
        // Release builds must ship non-empty SPKI pin sets. An empty Pins.kt
        // silently degrades to system-trust-only (still TLS-enforced, but
        // unpinned) — which is a CA-compromise vector. Fail closed so a
        // forgotten `scripts/fetch_pins.sh` run before release blocks startup
        // instead of shipping unpinned binaries to F-Droid.
        if (!de.kiefer_networks.falco.BuildConfig.DEBUG) {
            val empty = Pins.all().filterValues { it.isEmpty() }
            require(empty.isEmpty()) {
                "Certificate pins missing for release: ${empty.keys}. " +
                    "Run scripts/fetch_pins.sh and rebuild."
            }
        }
    }

    private val json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
        encodeDefaults = false
    }

    private val tlsOnly = ConnectionSpec.Builder(ConnectionSpec.RESTRICTED_TLS)
        .tlsVersions(TlsVersion.TLS_1_3, TlsVersion.TLS_1_2)
        .build()

    private fun pinner(): CertificatePinner {
        val builder = CertificatePinner.Builder()
        Pins.all().forEach { (host, pins) ->
            pins.forEach { pin -> builder.add(host, "sha256/$pin") }
        }
        return builder.build()
    }

    private fun baseClient(extra: Iterable<Interceptor> = emptyList()): OkHttpClient =
        OkHttpClient.Builder()
            .connectionSpecs(listOf(tlsOnly))
            .certificatePinner(pinner())
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .followRedirects(false)
            .followSslRedirects(false)
            // POST replay danger; OkHttp's retry-on-connection-failure is not
            // idempotency-aware — leave to caller-level retry policy.
            // (Cloud action endpoints — snapshot, reset, reset_password,
            // create_* — must never be silently re-issued. The same client
            // serves GETs and mutating POSTs, so disable across the board.
            // Server-side idempotency keys would be the right answer but
            // that's beyond this fix.)
            .retryOnConnectionFailure(false)
            .apply { extra.forEach(::addInterceptor) }
            // Permission-denied detection runs LAST in the chain so it sees
            // the response after the auth/header/idempotency layers have
            // built the request — and after RobotRateLimitInterceptor has
            // had its chance to flag throttling, since 403 + Retry-After is
            // a rate-limit signal we must not mis-classify as a permission
            // problem.
            .addInterceptor(PermissionInterceptor)
            .build()

    fun cloudRetrofit(token: String): Retrofit = retrofit(
        baseUrl = "https://api.hetzner.cloud/v1/",
        client = baseClient(
            listOf(
                BearerInterceptor(token),
                IdempotencyKeyInterceptor,
                UserAgentInterceptor,
            ),
        ),
    )

    /**
     * Hetzner moved the Storage Box endpoints to a separate base URL on
     * 2025-06-25 (api.hetzner.com instead of api.hetzner.cloud). Same Bearer
     * token, different host, so it gets its own Retrofit / OkHttp pin set.
     */
    fun storageBoxRetrofit(token: String): Retrofit = retrofit(
        baseUrl = "https://api.hetzner.com/v1/",
        client = baseClient(
            listOf(
                BearerInterceptor(token),
                IdempotencyKeyInterceptor,
                UserAgentInterceptor,
            ),
        ),
    )

    fun robotRetrofit(user: String, pass: String): Retrofit = retrofit(
        baseUrl = "https://robot-ws.your-server.de/",
        client = baseClient(
            listOf(
                BasicAuthInterceptor(user, pass),
                RobotRateLimitInterceptor(),
                UserAgentInterceptor,
            ),
        ),
    )

    fun dnsRetrofit(token: String): Retrofit = retrofit(
        baseUrl = "https://dns.hetzner.com/api/v1/",
        client = baseClient(listOf(HeaderInterceptor("Auth-API-Token", token), UserAgentInterceptor)),
    )

    fun s3OkHttp(): OkHttpClient = baseClient(listOf(UserAgentInterceptor))

    private fun retrofit(baseUrl: String, client: OkHttpClient): Retrofit = Retrofit.Builder()
        .baseUrl(baseUrl)
        .client(client)
        .addConverterFactory(json.asConverterFactory("application/json".toMediaType()))
        .build()
}

private class BearerInterceptor(private val token: String) : Interceptor {
    override fun intercept(chain: Interceptor.Chain) = chain.proceed(
        chain.request().newBuilder().header("Authorization", "Bearer $token").build(),
    )
}

private class HeaderInterceptor(private val name: String, private val value: String) : Interceptor {
    override fun intercept(chain: Interceptor.Chain) = chain.proceed(
        chain.request().newBuilder().header(name, value).build(),
    )
}

private class BasicAuthInterceptor(user: String, pass: String) : Interceptor {
    private val credential = okhttp3.Credentials.basic(user, pass)
    override fun intercept(chain: Interceptor.Chain) = chain.proceed(
        chain.request().newBuilder().header("Authorization", credential).build(),
    )
}

/**
 * Injects `Idempotency-Key: <UUID v4>` on every state-changing request.
 *
 * Hetzner Cloud + Storage Box accept idempotency keys on action endpoints
 * (snapshot, reset, reset_password, create_*, delete) — duplicate requests
 * with the same key are deduplicated server-side, which protects against the
 * "double-tap snapshot" failure mode where a user retries before the first
 * response arrives. We do NOT retry transparently, so the key only matters
 * when the user (or a flaky network) issues the same mutating request twice.
 *
 * Skip if the caller already attached its own header (test / future overrides).
 */
private object IdempotencyKeyInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): okhttp3.Response {
        val request = chain.request()
        val needsKey = request.method in MUTATING_METHODS &&
            request.header("Idempotency-Key") == null
        return chain.proceed(
            if (needsKey) {
                request.newBuilder()
                    .header("Idempotency-Key", UUID.randomUUID().toString())
                    .build()
            } else {
                request
            },
        )
    }

    private val MUTATING_METHODS = setOf("POST", "PUT", "PATCH", "DELETE")
}

private object UserAgentInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain) = chain.proceed(
        chain.request().newBuilder()
            .header("User-Agent", "Falco/0.1 (F-Droid; Android)")
            .header("Accept", "application/json")
            .build(),
    )
}

/**
 * Robot enforces a hard cap (200/h queries, 50/h resets). We surface a typed
 * exception so the UI can render the rate-limit message instead of a generic
 * auth error.
 *
 * Detection rules (tightened per audit A-005):
 *   - 429 is always throttling.
 *   - 403 is throttling ONLY if Robot also sent `Retry-After`. A bare 403
 *     (e.g. `Content-Length: 0` with no Retry-After) means the Basic-auth
 *     credentials are wrong — let it propagate so sanitizeError can report
 *     an auth failure instead of misleading the user with a rate-limit
 *     dialog.
 */
private class RobotRateLimitInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): okhttp3.Response {
        val response = chain.proceed(chain.request())
        val retryAfter = response.header("Retry-After")
        val throttled = response.code == 429 ||
            (response.code == 403 && retryAfter != null)
        if (throttled) {
            response.close()
            throw RobotRateLimitException(chain.request(), retryAfter)
        }
        return response
    }
}

/**
 * Robot 429/throttle response. The optional [retryAfter] is the raw
 * `Retry-After` header value (may be a delta in seconds OR an HTTP-date,
 * per RFC 7231); UI code can surface it verbatim or parse as needed.
 */
class RobotRateLimitException(val request: Request, val retryAfter: String? = null) :
    RuntimeException(
        if (retryAfter != null) "Hetzner Robot rate limit exceeded; retry after $retryAfter"
        else "Hetzner Robot rate limit exceeded",
    )

/**
 * Translates 401 / 403 on a mutating verb into a typed
 * [PermissionDeniedException] the UI layer can map to a clear "your
 * credential lacks rights for this action" hint via [sanitizeError].
 *
 * Skipped for GET because Hetzner returns 401/403 on read endpoints for
 * different reasons (token typo, account locked) that should surface as
 * generic auth errors, not permission hints. A permission problem only
 * applies to write operations on a token / Robot sub-user that authenticated
 * successfully but is denied this specific action.
 *
 * Also skipped when the response carries `Retry-After` — that's the rate-
 * limit signal RobotRateLimitInterceptor already handled, so we never see
 * it here, but the guard is cheap and defensive.
 */
private object PermissionInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): okhttp3.Response {
        val request = chain.request()
        val response = chain.proceed(request)
        if (request.method !in MUTATING_METHODS) return response
        if (response.code != 401 && response.code != 403) return response
        if (response.header("Retry-After") != null) return response
        response.close()
        throw PermissionDeniedException(request, response.code)
    }

    private val MUTATING_METHODS = setOf("POST", "PUT", "PATCH", "DELETE")
}
