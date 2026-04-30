// SPDX-License-Identifier: GPL-3.0-or-later
@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
package de.kiefer_networks.falco.ui.screens.cloud

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Public
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.FilledIconButton
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.TextUnitType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.dto.FirewallRule

private val PROTOCOLS = listOf("tcp", "udp", "icmp", "esp", "gre")

@Composable
fun FirewallRuleDialog(
    initial: FirewallRule?,
    onDismiss: () -> Unit,
    onConfirm: (FirewallRule) -> Unit,
) {
    var direction by remember { mutableStateOf(initial?.direction ?: "in") }
    var protocol by remember { mutableStateOf(initial?.protocol ?: "tcp") }
    var port by remember { mutableStateOf(initial?.port ?: "") }
    var description by remember { mutableStateOf(initial?.description ?: "") }
    val initialIps = if ((initial?.direction ?: "in") == "in") {
        initial?.sourceIps.orEmpty()
    } else {
        initial?.destinationIps.orEmpty()
    }
    val ips = remember { mutableStateListOf<String>().apply { addAll(initialIps) } }
    var ipDraft by remember { mutableStateOf("") }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false),
    ) {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background,
        ) {
            Scaffold(
                topBar = {
                    CenterAlignedTopAppBar(
                        title = {
                            Text(
                                if (initial == null) {
                                    stringResource(R.string.firewall_rule_new)
                                } else {
                                    stringResource(R.string.firewall_rule_edit)
                                },
                            )
                        },
                        navigationIcon = {
                            IconButton(onClick = onDismiss) {
                                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                            }
                        },
                        actions = {
                            TextButton(
                                enabled = ips.isNotEmpty(),
                                onClick = {
                                    val rule = FirewallRule(
                                        direction = direction,
                                        protocol = protocol,
                                        port = port.takeIf { (protocol == "tcp" || protocol == "udp") && it.isNotBlank() },
                                        sourceIps = if (direction == "in") ips.toList() else emptyList(),
                                        destinationIps = if (direction == "out") ips.toList() else emptyList(),
                                        description = description.takeIf(String::isNotBlank),
                                    )
                                    onConfirm(rule)
                                },
                            ) { Text(stringResource(R.string.save)) }
                        },
                    )
                },
            ) { padding ->
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(padding)
                        .verticalScroll(rememberScrollState())
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    verticalArrangement = Arrangement.spacedBy(20.dp),
                ) {
                    // Direction + Protocol grouped in one card
                    SectionCard {
                        SectionLabel(stringResource(R.string.firewall_rule_direction))
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.padding(top = 8.dp)) {
                            FilterChip(
                                selected = direction == "in",
                                onClick = { direction = "in" },
                                label = { Text(stringResource(R.string.firewall_dir_in)) },
                            )
                            FilterChip(
                                selected = direction == "out",
                                onClick = { direction = "out" },
                                label = { Text(stringResource(R.string.firewall_dir_out)) },
                            )
                        }
                        Spacer(Modifier.size(16.dp))
                        SectionLabel(stringResource(R.string.firewall_rule_protocol))
                        Row(horizontalArrangement = Arrangement.spacedBy(6.dp), modifier = Modifier.padding(top = 8.dp)) {
                            PROTOCOLS.forEach { p ->
                                FilterChip(
                                    selected = protocol == p,
                                    onClick = { protocol = p },
                                    label = { Text(p.uppercase()) },
                                )
                            }
                        }
                        if (protocol == "tcp" || protocol == "udp") {
                            Spacer(Modifier.size(16.dp))
                            OutlinedTextField(
                                value = port,
                                onValueChange = { port = it },
                                label = { Text(stringResource(R.string.firewall_rule_port_hint)) },
                                singleLine = true,
                                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Text),
                                modifier = Modifier.fillMaxWidth(),
                            )
                        }
                    }

                    // Description
                    SectionCard {
                        OutlinedTextField(
                            value = description,
                            onValueChange = { description = it },
                            label = { Text(stringResource(R.string.firewall_rule_description)) },
                            singleLine = true,
                            modifier = Modifier.fillMaxWidth(),
                        )
                    }

                    // Source / Destination IPs
                    SectionCard {
                        SectionLabel(
                            if (direction == "in") {
                                stringResource(R.string.firewall_rule_source_ips)
                            } else {
                                stringResource(R.string.firewall_rule_destination_ips)
                            },
                        )
                        Spacer(Modifier.size(8.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            AssistChip(
                                onClick = {
                                    if (!ips.contains("0.0.0.0/0")) ips.add("0.0.0.0/0")
                                },
                                leadingIcon = {
                                    Icon(
                                        Icons.Filled.Public,
                                        contentDescription = null,
                                        modifier = Modifier.size(AssistChipDefaults.IconSize),
                                    )
                                },
                                label = { Text(stringResource(R.string.firewall_rule_any_ipv4)) },
                            )
                            AssistChip(
                                onClick = {
                                    if (!ips.contains("::/0")) ips.add("::/0")
                                },
                                leadingIcon = {
                                    Icon(
                                        Icons.Filled.Public,
                                        contentDescription = null,
                                        modifier = Modifier.size(AssistChipDefaults.IconSize),
                                    )
                                },
                                label = { Text(stringResource(R.string.firewall_rule_any_ipv6)) },
                            )
                        }
                        Spacer(Modifier.size(12.dp))
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            OutlinedTextField(
                                value = ipDraft,
                                onValueChange = { ipDraft = it },
                                label = { Text("0.0.0.0/0") },
                                singleLine = true,
                                modifier = Modifier.weight(1f),
                            )
                            Spacer(Modifier.width(8.dp))
                            FilledIconButton(
                                enabled = ipDraft.isNotBlank(),
                                onClick = {
                                    ips.add(ipDraft.trim())
                                    ipDraft = ""
                                },
                            ) {
                                Icon(Icons.Filled.Add, contentDescription = stringResource(R.string.add))
                            }
                        }
                        if (ips.isNotEmpty()) {
                            Spacer(Modifier.size(12.dp))
                            HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
                            ips.forEachIndexed { i, ip ->
                                IpListRow(
                                    ip = ip,
                                    onRemove = { ips.removeAt(i) },
                                )
                                if (i != ips.lastIndex) {
                                    HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant)
                                }
                            }
                        }
                    }
                    Spacer(Modifier.size(8.dp))
                }
            }
        }
    }
}

@Composable
private fun SectionLabel(text: String) {
    Text(
        text.uppercase(),
        style = MaterialTheme.typography.labelSmall.copy(
            letterSpacing = TextUnit(1.2f, TextUnitType.Sp),
        ),
        color = MaterialTheme.colorScheme.onSurfaceVariant,
    )
}

@Composable
private fun SectionCard(content: @Composable () -> Unit) {
    OutlinedCard(modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            content()
        }
    }
}

@Composable
private fun IpListRow(ip: String, onRemove: () -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
    ) {
        Box(
            modifier = Modifier
                .size(28.dp)
                .padding(end = 0.dp),
            contentAlignment = Alignment.Center,
        ) {
            Surface(
                shape = CircleShape,
                color = MaterialTheme.colorScheme.secondaryContainer,
                modifier = Modifier.size(28.dp),
            ) {
                Box(contentAlignment = Alignment.Center, modifier = Modifier.fillMaxSize()) {
                    Icon(
                        Icons.Filled.Public,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSecondaryContainer,
                        modifier = Modifier.size(16.dp),
                    )
                }
            }
        }
        Spacer(Modifier.width(12.dp))
        Text(
            ip,
            modifier = Modifier.weight(1f),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurface,
        )
        IconButton(onClick = onRemove) {
            Icon(
                Icons.Filled.Close,
                contentDescription = stringResource(R.string.delete),
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}
