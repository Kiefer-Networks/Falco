// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(
    androidx.compose.material3.ExperimentalMaterial3Api::class,
    androidx.compose.material3.windowsizeclass.ExperimentalMaterial3WindowSizeClassApi::class,
)
package de.kiefer_networks.falco.ui

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.windowsizeclass.WindowSizeClass
import androidx.compose.ui.Modifier
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import de.kiefer_networks.falco.ui.nav.NavShell
import de.kiefer_networks.falco.ui.nav.Routes
import de.kiefer_networks.falco.ui.nav.landingRouteFor
import de.kiefer_networks.falco.ui.nav.resetTo
import de.kiefer_networks.falco.ui.screens.accounts.AccountWizardScreen
import de.kiefer_networks.falco.ui.screens.accounts.AccountsScreen
import de.kiefer_networks.falco.ui.screens.accounts.HetznerService
import de.kiefer_networks.falco.ui.screens.cloud.CloudHubScreen
import de.kiefer_networks.falco.ui.screens.dns.DnsScreen
import de.kiefer_networks.falco.ui.screens.dns.ZoneDetailScreen
import de.kiefer_networks.falco.ui.screens.robot.RobotScreen
import de.kiefer_networks.falco.ui.screens.robot.ServerDetailScreen
import de.kiefer_networks.falco.ui.screens.s3.ObjectBrowserScreen
import de.kiefer_networks.falco.ui.screens.s3.S3Screen
import de.kiefer_networks.falco.ui.screens.settings.SettingsScreen
import de.kiefer_networks.falco.ui.screens.welcome.OnboardingScreen

@Composable
fun FalcoRoot(viewModel: FalcoRootViewModel, windowSizeClass: WindowSizeClass) {
    val nav = rememberNavController()
    val backStack by nav.currentBackStackEntryAsState()
    val currentRoute = backStack?.destination?.route
    val hasAccount by viewModel.hasAccount.collectAsState()
    val accountsBar by viewModel.accountsBar.collectAsState()

    // Account whose data the back stack currently shows. When the active
    // account changes (drawer switch, removal, first account created) the
    // retained top level ViewModels still hold the old account's data, so the
    // stack is rebuilt. Skipped while the wizard is open so its Done step stays
    // visible; the wizard's onClose performs the reset itself.
    var shownAccountId by rememberSaveable { mutableStateOf<String?>(null) }
    val activeAccount = accountsBar.activeAccount
    val inWizard = currentRoute == Routes.ACCOUNT_NEW
    LaunchedEffect(activeAccount?.id, hasAccount, inWizard) {
        val account = activeAccount ?: return@LaunchedEffect
        if (!hasAccount || inWizard || account.id == shownAccountId) return@LaunchedEffect
        val firstLoad = shownAccountId == null
        shownAccountId = account.id
        val target = landingRouteFor(account, nav.currentDestination?.route)
        // On first load only redirect when the start tab is unusable.
        if (!firstLoad || target != nav.currentDestination?.route) nav.resetTo(target)
    }

    val navHost: @Composable () -> Unit = {
        NavHost(
            navController = nav,
            startDestination = if (hasAccount) Routes.CLOUD else Routes.WELCOME,
        ) {
            composable(Routes.WELCOME) {
                OnboardingScreen(onAddAccount = { nav.navigate(Routes.ACCOUNT_NEW) })
            }
            composable(Routes.ACCOUNTS) {
                AccountsScreen(
                    onAdd = { nav.navigate(Routes.ACCOUNT_NEW) },
                    onManageProjects = { nav.navigate(Routes.PROJECTS) },
                )
            }
            composable(Routes.ACCOUNT_NEW) {
                AccountWizardScreen(onClose = { firstService ->
                    val target = when (firstService) {
                        HetznerService.Cloud -> Routes.CLOUD
                        HetznerService.Robot -> Routes.ROBOT
                        null -> null
                    }
                    if (target != null) {
                        // The new account is active now: rebuild the stack so
                        // no screen keeps the previous account's data. WELCOME
                        // may not be on the stack, so popUpTo(WELCOME) is not
                        // enough.
                        shownAccountId = accountsBar.activeAccount?.id
                        nav.resetTo(target)
                    } else {
                        nav.popBackStack()
                    }
                })
            }
            composable(Routes.CLOUD) {
                CloudHubScreen(
                    onAddProject = { nav.navigate(Routes.PROJECT_NEW) },
                    onManageProjects = { nav.navigate(Routes.PROJECTS) },
                    onOpenActivity = { nav.navigate(Routes.CLOUD_ACTIVITY) },
                    onOpenStorageBox = { id -> nav.navigate(Routes.cloudStorageBoxDetail(id)) },
                    onOpenServer = { id -> nav.navigate(Routes.cloudServerDetail(id)) },
                    onOpenFirewall = { id -> nav.navigate(Routes.cloudFirewallDetail(id)) },
                    onOpenVolume = { id -> nav.navigate(Routes.cloudVolumeDetail(id)) },
                    onOpenFloatingIp = { id -> nav.navigate(Routes.cloudFloatingIpDetail(id)) },
                    onOpenLoadBalancer = { id -> nav.navigate(Routes.cloudLoadBalancerDetail(id)) },
                    onOpenPrimaryIp = { id -> nav.navigate(Routes.cloudPrimaryIpDetail(id)) },
                    onOpenNetwork = { id -> nav.navigate(Routes.cloudNetworkDetail(id)) },
                )
            }
            composable(
                route = Routes.CLOUD_SERVER_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_CLOUD_SERVER_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudServerDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(
                route = Routes.CLOUD_FIREWALL_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_FIREWALL_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudFirewallDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(
                route = Routes.CLOUD_VOLUME_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_VOLUME_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudVolumeDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(
                route = Routes.CLOUD_FLOATING_IP_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_FLOATING_IP_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudFloatingIpDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(
                route = Routes.CLOUD_NETWORK_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_CLOUD_NETWORK_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudNetworkDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(
                route = Routes.CLOUD_LOAD_BALANCER_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_LOAD_BALANCER_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudLoadBalancerDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(
                route = Routes.CLOUD_PRIMARY_IP_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_PRIMARY_IP_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudPrimaryIpDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(Routes.CLOUD_ACTIVITY) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudActivityScreen(onBack = { nav.popBackStack() })
            }
            composable(Routes.PROJECTS) {
                de.kiefer_networks.falco.ui.screens.cloud.ProjectManageScreen(
                    onBack = { nav.popBackStack() },
                    onAdd = { nav.navigate(Routes.PROJECT_NEW) },
                    onEdit = { id -> nav.navigate(Routes.projectEdit(id)) },
                )
            }
            composable(
                route = Routes.CLOUD_STORAGE_BOX_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_STORAGE_BOX_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.cloud.CloudStorageBoxDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(Routes.PROJECT_NEW) {
                de.kiefer_networks.falco.ui.screens.cloud.ProjectFormScreen(
                    projectId = null,
                    onClose = { nav.popBackStack() },
                )
            }
            composable(
                route = Routes.PROJECT_EDIT,
                arguments = listOf(navArgument(Routes.ARG_PROJECT_ID) { type = NavType.StringType }),
            ) { entry ->
                de.kiefer_networks.falco.ui.screens.cloud.ProjectFormScreen(
                    projectId = entry.arguments?.getString(Routes.ARG_PROJECT_ID),
                    onClose = { nav.popBackStack() },
                )
            }
            composable(Routes.ROBOT) {
                RobotScreen(
                    onServerClick = { number -> nav.navigate(Routes.robotServerDetail(number)) },
                    onVSwitchClick = { id -> nav.navigate(Routes.robotVSwitchDetail(id)) },
                )
            }
            composable(
                route = Routes.ROBOT_SERVER_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_SERVER_NUMBER) { type = NavType.LongType }),
            ) { ServerDetailScreen(onBack = { nav.popBackStack() }) }
            composable(
                route = Routes.ROBOT_VSWITCH_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_VSWITCH_ID) { type = NavType.LongType }),
            ) {
                de.kiefer_networks.falco.ui.screens.robot.RobotVSwitchDetailScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(Routes.DNS) {
                DnsScreen(onZoneClick = { id -> nav.navigate(Routes.dnsZoneDetail(id)) })
            }
            composable(
                route = Routes.DNS_ZONE_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_ZONE_ID) { type = NavType.StringType }),
            ) { ZoneDetailScreen(onBack = { nav.popBackStack() }) }
            composable(Routes.S3) {
                S3Screen(onOpenBucket = { bucket -> nav.navigate(Routes.s3Browser(bucket)) })
            }
            composable(
                route = Routes.S3_BROWSER,
                arguments = listOf(
                    navArgument(Routes.ARG_BUCKET) { type = NavType.StringType },
                    navArgument(Routes.ARG_PREFIX) {
                        type = NavType.StringType
                        defaultValue = ""
                    },
                ),
            ) {
                ObjectBrowserScreen(
                    onBack = { nav.popBackStack() },
                    onNavigateToPrefix = { bucket, prefix ->
                        nav.navigate(Routes.s3Browser(bucket, prefix))
                    },
                )
            }
            composable(Routes.SEARCH) {
                de.kiefer_networks.falco.ui.screens.search.SearchScreen(
                    onOpenServer = { id -> nav.navigate(Routes.cloudServerDetail(id)) },
                    onOpenVolume = { id -> nav.navigate(Routes.cloudVolumeDetail(id)) },
                    onOpenFloatingIp = { id -> nav.navigate(Routes.cloudFloatingIpDetail(id)) },
                    onOpenFirewall = { id -> nav.navigate(Routes.cloudFirewallDetail(id)) },
                    onOpenStorageBox = { id -> nav.navigate(Routes.cloudStorageBoxDetail(id)) },
                    onOpenNetwork = { id -> nav.navigate(Routes.cloudNetworkDetail(id)) },
                    onOpenLoadBalancer = { id -> nav.navigate(Routes.cloudLoadBalancerDetail(id)) },
                    onOpenPrimaryIp = { id -> nav.navigate(Routes.cloudPrimaryIpDetail(id)) },
                    onOpenRobot = { num -> nav.navigate(Routes.robotServerDetail(num)) },
                    onOpenDnsZone = { id -> nav.navigate(Routes.dnsZoneDetail(id)) },
                    onBack = { nav.popBackStack() },
                )
            }
            composable(Routes.SETTINGS) {
                SettingsScreen(
                    onAbout = { nav.navigate(Routes.ABOUT) },
                    onSecurity = { nav.navigate(Routes.SETTINGS_SECURITY) },
                    onAppearance = { nav.navigate(Routes.SETTINGS_APPEARANCE) },
                    onLanguage = { nav.navigate(Routes.SETTINGS_LANGUAGE) },
                )
            }
            composable(Routes.SETTINGS_SECURITY) {
                de.kiefer_networks.falco.ui.screens.settings.SecuritySettingsScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(Routes.SETTINGS_APPEARANCE) {
                de.kiefer_networks.falco.ui.screens.settings.AppearanceSettingsScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(Routes.SETTINGS_LANGUAGE) {
                de.kiefer_networks.falco.ui.screens.settings.LanguageSettingsScreen(
                    onBack = { nav.popBackStack() },
                )
            }
            composable(Routes.ABOUT) {
                de.kiefer_networks.falco.ui.screens.about.AboutScreen(onBack = { nav.popBackStack() })
            }
        }
    }

    if (hasAccount) {
        NavShell(
            windowSizeClass = windowSizeClass,
            currentRoute = currentRoute,
            accounts = accountsBar.accounts,
            activeAccount = accountsBar.activeAccount,
            onSelectAccount = viewModel::switchAccount,
            onAddAccount = { nav.navigate(Routes.ACCOUNT_NEW) },
            onSelect = { route ->
                nav.navigate(route) {
                    popUpTo(nav.graph.findStartDestination().id) { saveState = true }
                    launchSingleTop = true
                    restoreState = true
                }
            },
            content = navHost,
        )
    } else {
        Surface(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding(),
            color = MaterialTheme.colorScheme.background,
        ) {
            navHost()
        }
    }
}
