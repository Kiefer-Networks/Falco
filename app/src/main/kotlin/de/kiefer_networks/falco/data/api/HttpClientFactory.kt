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
import java.util.concurrent.TimeUnit

object HttpClientFactory {

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
            .retryOnConnectionFailure(true)
            .apply { extra.forEach(::addInterceptor) }
            .build()

    fun cloudRetrofit(token: String): Retrofit = retrofit(
        baseUrl = "https://api.hetzner.cloud/v1/",
        client = baseClient(listOf(BearerInterceptor(token), UserAgentInterceptor)),
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

private object UserAgentInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain) = chain.proceed(
        chain.request().newBuilder()
            .header("User-Agent", "Falco/0.1 (F-Droid; Android)")
            .header("Accept", "application/json")
            .build(),
    )
}

/**
 * Robot enforces a hard cap (200/h queries, 50/h resets). When we see 403/429
 * we surface a typed exception so the UI can render the rate-limit message
 * instead of a generic auth error.
 */
private class RobotRateLimitInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): okhttp3.Response {
        val response = chain.proceed(chain.request())
        if (response.code == 429 || (response.code == 403 && response.body?.contentLength() == 0L)) {
            response.close()
            throw RobotRateLimitException(chain.request())
        }
        return response
    }
}

class RobotRateLimitException(val request: Request) : RuntimeException("Hetzner Robot rate limit exceeded")
