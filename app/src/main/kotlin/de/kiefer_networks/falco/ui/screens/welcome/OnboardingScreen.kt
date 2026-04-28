// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.welcome

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
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Cloud
import androidx.compose.material.icons.filled.Dns
import androidx.compose.material.icons.filled.Fingerprint
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Memory
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import kotlinx.coroutines.launch

private const val TOTAL_PAGES = 4

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun OnboardingScreen(
    viewModel: OnboardingViewModel = hiltViewModel(),
    onAddAccount: () -> Unit,
) {
    val locale by viewModel.locale.collectAsState()
    val pagerState = rememberPagerState(pageCount = { TOTAL_PAGES })
    val scope = rememberCoroutineScope()

    Column(modifier = Modifier.fillMaxSize()) {
        HorizontalPager(
            state = pagerState,
            modifier = Modifier.weight(1f).fillMaxWidth(),
        ) { page ->
            when (page) {
                0 -> PageLanguage(currentTag = locale, onPick = viewModel::setLocale)
                1 -> PageFeatures()
                2 -> PageSecurity()
                else -> PageStart(onAddAccount = onAddAccount)
            }
        }

        // Indicator dots
        Row(
            modifier = Modifier.fillMaxWidth().padding(top = 4.dp, bottom = 8.dp),
            horizontalArrangement = Arrangement.Center,
        ) {
            repeat(TOTAL_PAGES) { i ->
                val active = pagerState.currentPage == i
                Surface(
                    shape = CircleShape,
                    color = if (active) {
                        MaterialTheme.colorScheme.primary
                    } else {
                        MaterialTheme.colorScheme.outlineVariant
                    },
                    modifier = Modifier.padding(horizontal = 4.dp).size(if (active) 10.dp else 8.dp),
                ) {}
            }
        }

        Row(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 12.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            if (pagerState.currentPage < TOTAL_PAGES - 1) {
                TextButton(onClick = {
                    scope.launch { pagerState.scrollToPage(TOTAL_PAGES - 1) }
                }) {
                    Text(stringResource(R.string.onboarding_skip))
                }
                Button(onClick = {
                    scope.launch { pagerState.animateScrollToPage(pagerState.currentPage + 1) }
                }) {
                    Text(stringResource(R.string.onboarding_next))
                }
            } else {
                TextButton(onClick = {
                    scope.launch { pagerState.animateScrollToPage(pagerState.currentPage - 1) }
                }) {
                    Text(stringResource(R.string.onboarding_back))
                }
                Button(onClick = onAddAccount) { Text(stringResource(R.string.account_add)) }
            }
        }
    }
}

@Composable
private fun PageLanguage(currentTag: String, onPick: (String) -> Unit) {
    Column(
        modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
    ) {
        Text(
            text = stringResource(R.string.app_name),
            style = MaterialTheme.typography.displaySmall,
            color = MaterialTheme.colorScheme.primary,
        )
        Text(
            text = stringResource(R.string.onboarding_step_language),
            style = MaterialTheme.typography.headlineSmall,
        )
        Text(
            text = stringResource(R.string.onboarding_language_caption),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Spacer(Modifier.height(8.dp))
        LanguagePicker(selectedTag = currentTag, onPersist = onPick)
    }
}

@Composable
private fun PageFeatures() {
    PageContent(
        title = stringResource(R.string.onboarding_step_features),
        body = stringResource(R.string.onboarding_features_caption),
        items = listOf(
            FeatureRow(Icons.Filled.Cloud, stringResource(R.string.onboarding_feature_cloud)),
            FeatureRow(Icons.Filled.Memory, stringResource(R.string.onboarding_feature_robot)),
            FeatureRow(Icons.Filled.Dns, stringResource(R.string.onboarding_feature_dns)),
            FeatureRow(Icons.Filled.Storage, stringResource(R.string.onboarding_feature_s3)),
        ),
    )
}

@Composable
private fun PageSecurity() {
    PageContent(
        title = stringResource(R.string.onboarding_step_security),
        body = stringResource(R.string.onboarding_security_caption),
        items = listOf(
            FeatureRow(Icons.Filled.Lock, stringResource(R.string.onboarding_security_encrypted)),
            FeatureRow(Icons.Filled.Fingerprint, stringResource(R.string.onboarding_security_biometric)),
            FeatureRow(Icons.Filled.Shield, stringResource(R.string.onboarding_security_pinning)),
        ),
    )
}

@Composable
private fun PageStart(onAddAccount: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxSize().padding(24.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Surface(
            shape = CircleShape,
            color = MaterialTheme.colorScheme.primaryContainer,
            modifier = Modifier.size(96.dp),
        ) {
            Box(contentAlignment = Alignment.Center) {
                Icon(
                    imageVector = Icons.Filled.Cloud,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onPrimaryContainer,
                    modifier = Modifier.size(56.dp),
                )
            }
        }
        Spacer(Modifier.height(24.dp))
        Text(
            text = stringResource(R.string.onboarding_step_start),
            style = MaterialTheme.typography.headlineSmall,
            textAlign = TextAlign.Center,
        )
        Spacer(Modifier.height(8.dp))
        Text(
            text = stringResource(R.string.onboarding_start_caption),
            style = MaterialTheme.typography.bodyMedium,
            textAlign = TextAlign.Center,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Spacer(Modifier.height(32.dp))
        Button(onClick = onAddAccount) { Text(stringResource(R.string.account_add)) }
    }
}

private data class FeatureRow(val icon: ImageVector, val text: String)

@Composable
private fun PageContent(title: String, body: String, items: List<FeatureRow>) {
    Column(
        modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
    ) {
        Text(text = title, style = MaterialTheme.typography.headlineSmall)
        Text(
            text = body,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Spacer(Modifier.height(8.dp))
        items.forEach { row ->
            Row(verticalAlignment = Alignment.CenterVertically) {
                Surface(
                    shape = CircleShape,
                    color = MaterialTheme.colorScheme.primaryContainer,
                    modifier = Modifier.size(44.dp),
                ) {
                    Box(contentAlignment = Alignment.Center) {
                        Icon(
                            imageVector = row.icon,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.onPrimaryContainer,
                        )
                    }
                }
                Spacer(Modifier.width(16.dp))
                Text(row.text, style = MaterialTheme.typography.bodyLarge)
            }
        }
    }
}
