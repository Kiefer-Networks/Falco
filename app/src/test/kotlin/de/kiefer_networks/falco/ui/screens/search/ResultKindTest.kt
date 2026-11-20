// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.search

import org.junit.Assert.assertEquals
import org.junit.Test

class ResultKindTest {
    @Test fun onlyKindsWithDetailScreenAreNavigable() {
        val navigable = ResultKind.entries.filter { it.hasDetailScreen }.toSet()
        assertEquals(
            setOf(
                ResultKind.CloudServer, ResultKind.RobotServer, ResultKind.Volume,
                ResultKind.Network, ResultKind.FloatingIp, ResultKind.Firewall,
                ResultKind.StorageBox, ResultKind.DnsZone, ResultKind.LoadBalancer,
                ResultKind.PrimaryIp,
            ),
            navigable,
        )
    }
}
