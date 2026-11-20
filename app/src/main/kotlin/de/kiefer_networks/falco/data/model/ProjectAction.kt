// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.data.model

import de.kiefer_networks.falco.data.dto.ActionEnvelope

/**
 * One Hetzner action in the project activity feed, tagged with the project it
 * came from and the resource collection it was listed under (e.g. "servers").
 */
data class ProjectAction(
    val projectId: String?,
    val projectName: String?,
    val resourceType: String,
    val action: ActionEnvelope,
)
