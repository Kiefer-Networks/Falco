// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.accounts

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import de.kiefer_networks.falco.R
import de.kiefer_networks.falco.data.auth.AccountSecrets

@Composable
fun AccountFormScreen(
    viewModel: AccountsViewModel = hiltViewModel(),
    onDone: () -> Unit,
) {
    var name by remember { mutableStateOf("") }
    var cloud by remember { mutableStateOf("") }
    var robotUser by remember { mutableStateOf("") }
    var robotPass by remember { mutableStateOf("") }
    var dns by remember { mutableStateOf("") }
    var s3Endpoint by remember { mutableStateOf("") }
    var s3Region by remember { mutableStateOf("") }
    var s3Access by remember { mutableStateOf("") }
    var s3Secret by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
    ) {
        OutlinedTextField(
            value = name,
            onValueChange = { name = it },
            label = { Text(stringResource(R.string.account_name)) },
            modifier = Modifier.fillMaxWidth(),
            singleLine = true,
        )
        Spacer(Modifier.height(12.dp))
        secret(label = stringResource(R.string.account_cloud_token), value = cloud) { cloud = it }
        Spacer(Modifier.height(12.dp))
        OutlinedTextField(
            value = robotUser,
            onValueChange = { robotUser = it },
            label = { Text(stringResource(R.string.account_robot_user)) },
            singleLine = true,
            modifier = Modifier.fillMaxWidth(),
        )
        Spacer(Modifier.height(12.dp))
        secret(label = stringResource(R.string.account_robot_pass), value = robotPass) { robotPass = it }
        Spacer(Modifier.height(12.dp))
        secret(label = stringResource(R.string.account_dns_token), value = dns) { dns = it }
        Spacer(Modifier.height(12.dp))
        OutlinedTextField(
            value = s3Endpoint,
            onValueChange = { s3Endpoint = it },
            label = { Text(stringResource(R.string.account_s3_endpoint)) },
            singleLine = true,
            modifier = Modifier.fillMaxWidth(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Uri),
        )
        Spacer(Modifier.height(12.dp))
        OutlinedTextField(
            value = s3Region,
            onValueChange = { s3Region = it },
            label = { Text("Region (optional)") },
            singleLine = true,
            modifier = Modifier.fillMaxWidth(),
        )
        Spacer(Modifier.height(12.dp))
        secret(label = stringResource(R.string.account_s3_access_key), value = s3Access) { s3Access = it }
        Spacer(Modifier.height(12.dp))
        secret(label = stringResource(R.string.account_s3_secret_key), value = s3Secret) { s3Secret = it }
        Spacer(Modifier.height(24.dp))
        Button(
            onClick = {
                val secrets = AccountSecrets(
                    cloudToken = cloud.takeIf(String::isNotBlank),
                    robotUser = robotUser.takeIf(String::isNotBlank),
                    robotPass = robotPass.takeIf(String::isNotBlank),
                    dnsToken = dns.takeIf(String::isNotBlank),
                    s3Endpoint = s3Endpoint.takeIf(String::isNotBlank),
                    s3Region = s3Region.takeIf(String::isNotBlank),
                    s3AccessKey = s3Access.takeIf(String::isNotBlank),
                    s3SecretKey = s3Secret.takeIf(String::isNotBlank),
                )
                viewModel.addAccount(name.ifBlank { "Account" }, secrets, onDone)
            },
            modifier = Modifier.fillMaxWidth(),
            enabled = name.isNotBlank(),
        ) { Text(stringResource(R.string.save)) }
    }
}

@Composable
private fun secret(label: String, value: String, onChange: (String) -> Unit) {
    OutlinedTextField(
        value = value,
        onValueChange = onChange,
        label = { Text(label) },
        singleLine = true,
        visualTransformation = PasswordVisualTransformation(),
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
        modifier = Modifier.fillMaxWidth(),
    )
}
