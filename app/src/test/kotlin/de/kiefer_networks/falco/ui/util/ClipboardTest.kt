// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.util

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class ClipboardTest {
    @Test fun clearsWhenClipUnreadableInBackground() =
        assertTrue(Clipboard.shouldClear(1, 1, null, "secret"))

    @Test fun clearsWhenClipStillOurs() =
        assertTrue(Clipboard.shouldClear(1, 1, "secret", "secret"))

    @Test fun keepsUserReplacedClip() =
        assertFalse(Clipboard.shouldClear(1, 1, "other", "secret"))

    @Test fun olderWipeDoesNotClearNewerCopy() =
        assertFalse(Clipboard.shouldClear(1, 2, null, "secret"))
}
