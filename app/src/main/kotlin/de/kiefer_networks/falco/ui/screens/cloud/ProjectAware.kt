// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.cloud

/**
 * Pairs a Cloud-API resource with the project it was fetched from.
 *
 * In aggregate-projects mode the resource list shown in the hub is a union of
 * resources from every Cloud project on the active account. Each card therefore
 * needs to remember which project owned it, so that opening a project-scoped
 * detail screen can switch the active Cloud project before navigating —
 * otherwise the detail screen's repo reads the wrong project's token.
 *
 * In non-aggregate mode the wrapper still carries the active project's id, which
 * lets call-sites use a single code path: `selectProjectThen` becomes a no-op
 * when the source project is already active.
 */
data class ProjectAware<T>(
    val projectId: String?,
    val item: T,
)
