// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui

import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.ui.nav.Routes
import de.kiefer_networks.falco.ui.screens.accounts.AccountFormScreen
import de.kiefer_networks.falco.ui.screens.accounts.AccountsScreen
import de.kiefer_networks.falco.ui.screens.cloud.CloudHubScreen
import de.kiefer_networks.falco.ui.screens.dns.DnsScreen
import de.kiefer_networks.falco.ui.screens.dns.ZoneDetailScreen
import de.kiefer_networks.falco.ui.screens.robot.RobotScreen
import de.kiefer_networks.falco.ui.screens.robot.ServerDetailScreen
import de.kiefer_networks.falco.ui.screens.robot.StorageBoxDetailScreen
import de.kiefer_networks.falco.ui.screens.s3.ObjectBrowserScreen
import de.kiefer_networks.falco.ui.screens.s3.S3Screen
import de.kiefer_networks.falco.ui.screens.settings.SettingsScreen
import de.kiefer_networks.falco.ui.screens.welcome.WelcomeScreen

@Composable
fun FalcoRoot(viewModel: FalcoRootViewModel) {
    val nav = rememberNavController()
    val backStack by nav.currentBackStackEntryAsState()
    val currentRoute = backStack?.destination?.route
    val hasAccount by viewModel.hasAccount.collectAsState()

    Scaffold(
        bottomBar = {
            if (hasAccount && currentRoute in TAB_ROUTES) {
                NavigationBar {
                    TABS.forEach { tab ->
                        NavigationBarItem(
                            selected = backStack?.destination?.hierarchy?.any { it.route == tab.route } == true,
                            onClick = {
                                nav.navigate(tab.route) {
                                    popUpTo(nav.graph.findStartDestination().id) { saveState = true }
                                    launchSingleTop = true
                                    restoreState = true
                                }
                            },
                            icon = { Icon(tab.icon, contentDescription = null) },
                            label = { Text(stringResource(tab.label)) },
                        )
                    }
                }
            }
        },
    ) { padding ->
        NavHost(
            navController = nav,
            startDestination = if (hasAccount) Routes.CLOUD else Routes.WELCOME,
            modifier = Modifier.padding(padding),
        ) {
            composable(Routes.WELCOME) { WelcomeScreen(onContinue = { nav.navigate(Routes.ACCOUNT_NEW) }) }
            composable(Routes.ACCOUNTS) { AccountsScreen(onAdd = { nav.navigate(Routes.ACCOUNT_NEW) }) }
            composable(Routes.ACCOUNT_NEW) { AccountFormScreen(onDone = { nav.popBackStack() }) }
            composable(Routes.CLOUD) { CloudHubScreen() }
            composable(Routes.ROBOT) {
                RobotScreen(
                    onServerClick = { number -> nav.navigate(Routes.robotServerDetail(number)) },
                    onStorageBoxClick = { id -> nav.navigate(Routes.robotStorageBoxDetail(id)) },
                )
            }
            composable(
                route = Routes.ROBOT_SERVER_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_SERVER_NUMBER) { type = NavType.LongType }),
            ) { ServerDetailScreen() }
            composable(
                route = Routes.ROBOT_STORAGE_BOX_DETAIL,
                arguments = listOf(navArgument(Routes.ARG_STORAGE_BOX_ID) { type = NavType.LongType }),
            ) { StorageBoxDetailScreen() }
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
            composable(Routes.SETTINGS) { SettingsScreen() }
        }
    }
}

private data class Tab(val route: String, val label: Int, val icon: androidx.compose.ui.graphics.vector.ImageVector)

private val TABS = listOf(
    Tab(Routes.CLOUD, R.string.nav_cloud, Icons.Filled.Cloud),
    Tab(Routes.ROBOT, R.string.nav_robot, Icons.Filled.Memory),
    Tab(Routes.DNS, R.string.nav_dns, Icons.Filled.Dns),
    Tab(Routes.S3, R.string.nav_storage, Icons.Filled.Storage),
    Tab(Routes.ACCOUNTS, R.string.nav_accounts, Icons.Filled.Person),
    Tab(Routes.SETTINGS, R.string.nav_settings, Icons.Filled.Settings),
)

private val TAB_ROUTES = TABS.map { it.route }.toSet()
