// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.material3.ExperimentalMaterial3Api::class,
    androidx.compose.material3.windowsizeclass.ExperimentalMaterial3WindowSizeClassApi::class,
)
package de.kiefer_networks.falco.ui.nav

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.ExpandMore
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.DrawerState
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.NavigationDrawerItem
import androidx.compose.material3.NavigationDrawerItemDefaults
import androidx.compose.material3.NavigationRail
import androidx.compose.material3.NavigationRailItem
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.PermanentDrawerSheet
import androidx.compose.material3.PermanentNavigationDrawer
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberDrawerState
import androidx.compose.material3.windowsizeclass.WindowSizeClass
import androidx.compose.material3.windowsizeclass.WindowWidthSizeClass
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import de.kiefer_networks.falco.BuildConfig
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.auth.HetznerAccount
import de.kiefer_networks.falco.ui.theme.Spacing
import kotlinx.coroutines.launch

/** Provides drawer-open access to nested screens (so a TopAppBar hamburger can open it). */
val LocalNavDrawer = compositionLocalOf<NavDrawerHandle> { NavDrawerHandle.None }

interface NavDrawerHandle {
    val isCompact: Boolean
    fun open()

    object None : NavDrawerHandle {
        override val isCompact: Boolean = false
        override fun open() {}
    }
}

private data class DrawerEntry(
    val route: String,
    val labelRes: Int,
    val icon: ImageVector,
)

private val ALL_SERVICES = listOf(
    DrawerEntry(Routes.CLOUD, R.string.nav_cloud, Icons.Filled.Cloud),
    DrawerEntry(Routes.ROBOT, R.string.nav_robot, Icons.Filled.Memory),
    DrawerEntry(Routes.DNS, R.string.nav_dns, Icons.Filled.Dns),
    DrawerEntry(Routes.S3, R.string.nav_storage, Icons.Filled.Storage),
)

private val SYSTEM = listOf(
    DrawerEntry(Routes.SEARCH, R.string.nav_search, Icons.Filled.Search),
    DrawerEntry(Routes.ACCOUNTS, R.string.nav_accounts, Icons.Filled.Person),
    DrawerEntry(Routes.SETTINGS, R.string.nav_settings, Icons.Filled.Settings),
)

private val ALL_ENTRIES = ALL_SERVICES + SYSTEM
private val TAB_ROUTES = ALL_ENTRIES.map { it.route }.toSet()

private fun servicesFor(account: HetznerAccount?): List<DrawerEntry> {
    if (account == null) return ALL_SERVICES
    return ALL_SERVICES.filter { entry ->
        when (entry.route) {
            Routes.CLOUD -> account.cloudProjectCount > 0
            Routes.ROBOT -> account.hasRobot
            Routes.DNS -> account.hasDns
            Routes.S3 -> account.hasS3
            else -> true
        }
    }
}

@Composable
fun NavShell(
    windowSizeClass: WindowSizeClass,
    currentRoute: String?,
    accounts: List<HetznerAccount>,
    activeAccount: HetznerAccount?,
    onSelectAccount: (String) -> Unit,
    onAddAccount: () -> Unit,
    onSelect: (String) -> Unit,
    content: @Composable () -> Unit,
) {
    val isTopLevel = currentRoute in TAB_ROUTES
    val visibleServices = servicesFor(activeAccount)
    when (windowSizeClass.widthSizeClass) {
        WindowWidthSizeClass.Compact -> CompactShell(
            currentRoute, onSelect, isTopLevel,
            accounts, activeAccount, onSelectAccount, onAddAccount,
            visibleServices, content,
        )
        WindowWidthSizeClass.Medium -> MediumShell(
            currentRoute, onSelect, isTopLevel,
            visibleServices, content,
        )
        else -> ExpandedShell(
            currentRoute, onSelect,
            accounts, activeAccount, onSelectAccount, onAddAccount,
            visibleServices, content,
        )
    }
}

@Composable
private fun CompactShell(
    currentRoute: String?,
    onSelect: (String) -> Unit,
    isTopLevel: Boolean,
    accounts: List<HetznerAccount>,
    activeAccount: HetznerAccount?,
    onSelectAccount: (String) -> Unit,
    onAddAccount: () -> Unit,
    visibleServices: List<DrawerEntry>,
    content: @Composable () -> Unit,
) {
    val drawerState = rememberDrawerState(DrawerValue.Closed)
    val scope = rememberCoroutineScope()
    val handle = remember(drawerState, isTopLevel) {
        object : NavDrawerHandle {
            override val isCompact: Boolean = true
            override fun open() {
                if (isTopLevel) scope.launch { drawerState.open() }
            }
        }
    }
    ModalNavigationDrawer(
        drawerState = drawerState,
        gesturesEnabled = isTopLevel,
        drawerContent = {
            ModalDrawerSheet {
                DrawerContent(
                    currentRoute = currentRoute,
                    accounts = accounts,
                    activeAccount = activeAccount,
                    onSelectAccount = { id ->
                        onSelectAccount(id)
                    },
                    onAddAccount = {
                        scope.launch { drawerState.close() }
                        onAddAccount()
                    },
                    visibleServices = visibleServices,
                    onSelect = { route ->
                        scope.launch { drawerState.close() }
                        onSelect(route)
                    },
                )
            }
        },
    ) {
        CompositionLocalProvider(LocalNavDrawer provides handle) {
            content()
        }
    }
}

@Composable
private fun MediumShell(
    currentRoute: String?,
    onSelect: (String) -> Unit,
    isTopLevel: Boolean,
    visibleServices: List<DrawerEntry>,
    content: @Composable () -> Unit,
) {
    val railEntries = visibleServices + SYSTEM
    Row(modifier = Modifier.fillMaxSize()) {
        if (isTopLevel) {
            NavigationRail {
                railEntries.forEach { entry ->
                    NavigationRailItem(
                        selected = currentRoute == entry.route,
                        onClick = { onSelect(entry.route) },
                        icon = { Icon(entry.icon, contentDescription = null) },
                        label = { Text(stringResource(entry.labelRes)) },
                    )
                }
            }
        }
        CompositionLocalProvider(LocalNavDrawer provides NavDrawerHandle.None) {
            content()
        }
    }
}

@Composable
private fun ExpandedShell(
    currentRoute: String?,
    onSelect: (String) -> Unit,
    accounts: List<HetznerAccount>,
    activeAccount: HetznerAccount?,
    onSelectAccount: (String) -> Unit,
    onAddAccount: () -> Unit,
    visibleServices: List<DrawerEntry>,
    content: @Composable () -> Unit,
) {
    PermanentNavigationDrawer(
        drawerContent = {
            PermanentDrawerSheet(modifier = Modifier.fillMaxWidth(0.22f)) {
                DrawerContent(
                    currentRoute = currentRoute,
                    accounts = accounts,
                    activeAccount = activeAccount,
                    onSelectAccount = onSelectAccount,
                    onAddAccount = onAddAccount,
                    visibleServices = visibleServices,
                    onSelect = onSelect,
                )
            }
        },
    ) {
        CompositionLocalProvider(LocalNavDrawer provides NavDrawerHandle.None) {
            content()
        }
    }
}

@Composable
private fun DrawerContent(
    currentRoute: String?,
    accounts: List<HetznerAccount>,
    activeAccount: HetznerAccount?,
    onSelectAccount: (String) -> Unit,
    onAddAccount: () -> Unit,
    visibleServices: List<DrawerEntry>,
    onSelect: (String) -> Unit,
) {
    Column(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState()),
        ) {
            BrandHeader()
            AccountRow(
                accounts = accounts,
                activeAccount = activeAccount,
                onSelectAccount = onSelectAccount,
                onAddAccount = onAddAccount,
            )
            HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
            Spacer(Modifier.height(Spacing.md))
            Column(modifier = Modifier.padding(horizontal = Spacing.sm)) {
                if (visibleServices.isNotEmpty()) {
                    SectionHeader(stringResource(R.string.nav_section_services))
                    visibleServices.forEach { entry -> DrawerItem(entry, currentRoute, onSelect) }
                    Spacer(Modifier.height(Spacing.md))
                    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
                    Spacer(Modifier.height(Spacing.md))
                }
                SectionHeader(stringResource(R.string.nav_section_system))
                SYSTEM.forEach { entry -> DrawerItem(entry, currentRoute, onSelect) }
                Spacer(Modifier.height(Spacing.lg))
            }
        }
        DrawerFooter(onAbout = { onSelect(Routes.ABOUT) })
    }
}

@Composable
private fun DrawerFooter(onAbout: () -> Unit) {
    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
    Surface(
        onClick = onAbout,
        color = androidx.compose.ui.graphics.Color.Transparent,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Row(
            modifier = Modifier.padding(horizontal = Spacing.lg, vertical = Spacing.md),
            verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
        ) {
            Icon(
                Icons.Filled.Info,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(18.dp),
            )
            Spacer(Modifier.size(Spacing.sm))
            Text(
                stringResource(R.string.about_title),
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurface,
                modifier = Modifier.weight(1f),
            )
            Text(
                "v${BuildConfig.VERSION_NAME}",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

@Composable
private fun AccountRow(
    accounts: List<HetznerAccount>,
    activeAccount: HetznerAccount?,
    onSelectAccount: (String) -> Unit,
    onAddAccount: () -> Unit,
) {
    var expanded by remember { mutableStateOf(false) }
    Column(modifier = Modifier.fillMaxWidth().padding(horizontal = Spacing.md, vertical = Spacing.sm)) {
        Surface(
            shape = RoundedCornerShape(12.dp),
            color = MaterialTheme.colorScheme.surfaceVariant,
            onClick = { expanded = !expanded },
            modifier = Modifier.fillMaxWidth(),
        ) {
            Row(
                modifier = Modifier.padding(Spacing.md),
                verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
            ) {
                Box(
                    modifier = Modifier
                        .size(28.dp)
                        .background(MaterialTheme.colorScheme.primary, RoundedCornerShape(50)),
                    contentAlignment = androidx.compose.ui.Alignment.Center,
                ) {
                    Icon(
                        Icons.Filled.Person,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onPrimary,
                        modifier = Modifier.size(18.dp),
                    )
                }
                Spacer(Modifier.size(Spacing.sm))
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        activeAccount?.displayName ?: stringResource(R.string.accounts_empty),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                    )
                    Text(
                        capabilitySummary(activeAccount),
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
                Icon(Icons.Filled.ExpandMore, contentDescription = null)
            }
        }
        if (expanded) {
            Spacer(Modifier.height(Spacing.xs))
            accounts.forEach { acc ->
                AccountPickerRow(
                    account = acc,
                    isActive = acc.id == activeAccount?.id,
                    onClick = {
                        onSelectAccount(acc.id)
                        expanded = false
                    },
                )
            }
            Surface(
                onClick = onAddAccount,
                shape = RoundedCornerShape(8.dp),
                color = androidx.compose.ui.graphics.Color.Transparent,
                modifier = Modifier.fillMaxWidth().padding(top = Spacing.xs),
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = Spacing.md, vertical = Spacing.sm),
                    verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
                ) {
                    Icon(
                        Icons.Filled.Add,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(18.dp),
                    )
                    Spacer(Modifier.size(Spacing.sm))
                    Text(
                        stringResource(R.string.account_add),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.primary,
                    )
                }
            }
        }
    }
}

@Composable
private fun AccountPickerRow(account: HetznerAccount, isActive: Boolean, onClick: () -> Unit) {
    Surface(
        onClick = onClick,
        shape = RoundedCornerShape(8.dp),
        color = if (isActive) {
            MaterialTheme.colorScheme.primaryContainer
        } else {
            androidx.compose.ui.graphics.Color.Transparent
        },
        modifier = Modifier.fillMaxWidth(),
    ) {
        Row(
            modifier = Modifier.padding(horizontal = Spacing.md, vertical = Spacing.sm),
            verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
        ) {
            Text(
                account.displayName,
                style = MaterialTheme.typography.bodyMedium,
                color = if (isActive) {
                    MaterialTheme.colorScheme.onPrimaryContainer
                } else {
                    MaterialTheme.colorScheme.onSurface
                },
                modifier = Modifier.weight(1f),
            )
            if (isActive) {
                Icon(
                    Icons.Filled.Check,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onPrimaryContainer,
                    modifier = Modifier.size(18.dp),
                )
            }
        }
    }
}

@Composable
private fun capabilitySummary(account: HetznerAccount?): String {
    if (account == null) return ""
    val parts = buildList {
        if (account.cloudProjectCount > 0) add(stringResource(R.string.nav_cloud))
        if (account.hasRobot) add(stringResource(R.string.nav_robot))
        if (account.hasDns) add(stringResource(R.string.nav_dns))
        if (account.hasS3) add(stringResource(R.string.nav_storage))
    }
    return parts.joinToString(" · ")
}

@Composable
private fun BrandHeader() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = Spacing.md, vertical = Spacing.lg),
        verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
    ) {
        Box(
            modifier = Modifier
                .size(36.dp)
                .background(MaterialTheme.colorScheme.primary, RoundedCornerShape(8.dp)),
            contentAlignment = androidx.compose.ui.Alignment.Center,
        ) {
            Text(
                "F",
                color = MaterialTheme.colorScheme.onPrimary,
                style = MaterialTheme.typography.titleLarge,
            )
        }
        Spacer(Modifier.size(Spacing.sm))
        Column {
            Text(
                "FALCO",
                style = MaterialTheme.typography.titleMedium.copy(letterSpacing = 2.sp),
                color = MaterialTheme.colorScheme.onSurface,
            )
            Text(
                stringResource(R.string.app_tagline),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
}

@Composable
private fun SectionHeader(text: String) {
    Text(
        text.uppercase(),
        style = MaterialTheme.typography.labelSmall.copy(letterSpacing = 1.5.sp),
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        modifier = Modifier.padding(start = Spacing.md, top = Spacing.sm, bottom = Spacing.xs),
    )
}

@Composable
private fun DrawerItem(entry: DrawerEntry, currentRoute: String?, onSelect: (String) -> Unit) {
    NavigationDrawerItem(
        selected = currentRoute == entry.route,
        onClick = { onSelect(entry.route) },
        icon = { Icon(entry.icon, contentDescription = null) },
        label = { Text(stringResource(entry.labelRes)) },
        colors = NavigationDrawerItemDefaults.colors(
            selectedContainerColor = MaterialTheme.colorScheme.primaryContainer,
            selectedIconColor = MaterialTheme.colorScheme.primary,
            selectedTextColor = MaterialTheme.colorScheme.primary,
        ),
        modifier = Modifier.padding(NavigationDrawerItemDefaults.ItemPadding),
    )
}

