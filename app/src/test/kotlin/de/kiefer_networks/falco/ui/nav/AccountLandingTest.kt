// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.nav

import de.kiefer_networks.falco.data.auth.HetznerAccount
import org.junit.Assert.assertEquals
import org.junit.Test

class AccountLandingTest {
    private fun account(cloud: Int = 0, robot: Boolean = false, dns: Boolean = false, s3: Boolean = false) =
        HetznerAccount(
            id = "a", displayName = "A", description = null,
            cloudProjectCount = cloud, activeCloudProjectId = null,
            hasRobot = robot, hasDns = dns, hasS3 = s3,
        )

    @Test fun robotOnlyAccountLeavesCloudForRobot() =
        assertEquals(Routes.ROBOT, landingRouteFor(account(robot = true), Routes.CLOUD))

    @Test fun dnsOnlyAccountLandsOnDns() =
        assertEquals(Routes.DNS, landingRouteFor(account(dns = true), null))

    @Test fun keepsUsableServiceRoute() =
        assertEquals(Routes.DNS, landingRouteFor(account(cloud = 1, dns = true), Routes.DNS))

    @Test fun keepsSystemRoute() =
        assertEquals(Routes.SETTINGS, landingRouteFor(account(robot = true), Routes.SETTINGS))

    @Test fun detailRouteFallsBackToFirstService() =
        assertEquals(Routes.CLOUD, landingRouteFor(account(cloud = 2, robot = true), Routes.ROBOT_SERVER_DETAIL))

    @Test fun accountWithoutServicesLandsOnAccounts() =
        assertEquals(Routes.ACCOUNTS, landingRouteFor(account(), Routes.CLOUD))
}
