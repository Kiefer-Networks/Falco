// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.nav

import androidx.navigation.NavController
import de.kiefer_networks.falco.data.auth.HetznerAccount

private val SYSTEM_ROUTES = listOf(Routes.SEARCH, Routes.ACCOUNTS, Routes.SETTINGS)

/** Top level service routes the account has credentials for, in drawer order. */
internal fun serviceRoutesFor(account: HetznerAccount): List<String> = buildList {
    if (account.cloudProjectCount > 0) add(Routes.CLOUD)
    if (account.hasRobot) add(Routes.ROBOT)
    if (account.hasDns) add(Routes.DNS)
    if (account.hasS3) add(Routes.S3)
}

/**
 * Where to land after the active account changed: stay on the current top
 * level route when it is still usable for [account], otherwise open its first
 * service (a Robot only account lands on Robot, not on an empty Cloud tab).
 */
internal fun landingRouteFor(account: HetznerAccount, currentRoute: String?): String {
    val services = serviceRoutesFor(account)
    if (currentRoute != null && (currentRoute in services || currentRoute in SYSTEM_ROUTES)) {
        return currentRoute
    }
    return services.firstOrNull() ?: Routes.ACCOUNTS
}

/**
 * Drops the whole back stack, including the states saved by tab switches, and
 * opens [route]. Top level ViewModels load their data only once, so after an
 * account switch they must be recreated instead of restored.
 */
internal fun NavController.resetTo(route: String) {
    val tabs = listOf(Routes.CLOUD, Routes.ROBOT, Routes.DNS, Routes.S3) + SYSTEM_ROUTES
    tabs.forEach { tab ->
        val onStack = runCatching { getBackStackEntry(tab) }.isSuccess
        if (!onStack) clearBackStack(tab)
    }
    navigate(route) {
        popUpTo(graph.id) { inclusive = true }
        launchSingleTop = true
    }
}
