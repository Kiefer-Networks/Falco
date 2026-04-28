// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.model

import kotlinx.serialization.Serializable

/**
 * A Hetzner Cloud project. Tokens in the Hetzner Cloud Console are scoped to a
 * single project, so an account holding multiple projects keeps a token list.
 *
 * S3 (Object Storage) credentials are also project-scoped on the Hetzner side
 * — they're created in the same Cloud Console under the project — so they
 * live as optional fields on the project. A project may opt out of S3 by
 * leaving the keys null.
 */
@Serializable
data class CloudProject(
    val id: String,
    val name: String,
    val cloudToken: String,
    val s3Endpoint: String? = null,
    val s3Region: String? = null,
    val s3AccessKey: String? = null,
    val s3SecretKey: String? = null,
) {
    val hasS3: Boolean
        get() = !s3Endpoint.isNullOrBlank() &&
            !s3AccessKey.isNullOrBlank() &&
            !s3SecretKey.isNullOrBlank()
}
