// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.accounts

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.auth.AccountSecrets
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

enum class HetznerService { Cloud, Robot, Dns, S3 }

sealed interface WizardStep {
    data object Name : WizardStep
    data object ServicePicker : WizardStep
    data class Credentials(val service: HetznerService) : WizardStep
    data object Review : WizardStep
    data object Done : WizardStep
}

data class CloudCreds(val token: String = "")
data class RobotCreds(val user: String = "", val pass: String = "")
data class DnsCreds(val token: String = "")
data class S3Creds(
    val endpoint: String = "fsn1.your-objectstorage.com",
    val region: String = "",
    val accessKey: String = "",
    val secretKey: String = "",
)

data class WizardState(
    val name: String = "",
    val services: Set<HetznerService> = emptySet(),
    val cloud: CloudCreds = CloudCreds(),
    val robot: RobotCreds = RobotCreds(),
    val dns: DnsCreds = DnsCreds(),
    val s3: S3Creds = S3Creds(),
    val stepIndex: Int = 0,
    val saving: Boolean = false,
    val saved: Boolean = false,
)

@HiltViewModel
class AccountWizardViewModel @Inject constructor(
    private val accountManager: AccountManager,
) : ViewModel() {

    private val _state = MutableStateFlow(WizardState())
    val state: StateFlow<WizardState> = _state.asStateFlow()

    /** Derived ordered list of steps based on the current service selection. */
    fun steps(s: WizardState = _state.value): List<WizardStep> = buildList {
        add(WizardStep.Name)
        add(WizardStep.ServicePicker)
        HetznerService.entries.filter { it in s.services }.forEach { add(WizardStep.Credentials(it)) }
        add(WizardStep.Review)
        add(WizardStep.Done)
    }

    fun currentStep(): WizardStep = steps()[_state.value.stepIndex.coerceIn(0, steps().lastIndex)]

    fun isCurrentStepValid(): Boolean = when (val step = currentStep()) {
        WizardStep.Name -> _state.value.name.isNotBlank() && _state.value.name.length <= 64
        WizardStep.ServicePicker -> _state.value.services.isNotEmpty()
        is WizardStep.Credentials -> validateCreds(step.service)
        WizardStep.Review, WizardStep.Done -> true
    }

    private fun validateCreds(service: HetznerService): Boolean = when (service) {
        HetznerService.Cloud -> _state.value.cloud.token.isNotBlank()
        HetznerService.Robot -> _state.value.robot.user.isNotBlank() && _state.value.robot.pass.isNotBlank()
        HetznerService.Dns -> _state.value.dns.token.isNotBlank()
        HetznerService.S3 -> _state.value.s3.endpoint.isNotBlank() &&
            _state.value.s3.accessKey.isNotBlank() &&
            _state.value.s3.secretKey.isNotBlank()
    }

    fun setName(value: String) = _state.update { it.copy(name = value.take(64)) }
    fun toggleService(service: HetznerService) = _state.update {
        val next = if (service in it.services) it.services - service else it.services + service
        it.copy(services = next)
    }
    fun setCloudToken(value: String) = _state.update { it.copy(cloud = CloudCreds(value)) }
    fun setRobotUser(value: String) = _state.update { it.copy(robot = it.robot.copy(user = value)) }
    fun setRobotPass(value: String) = _state.update { it.copy(robot = it.robot.copy(pass = value)) }
    fun setDnsToken(value: String) = _state.update { it.copy(dns = DnsCreds(value)) }
    fun setS3Endpoint(value: String) = _state.update { it.copy(s3 = it.s3.copy(endpoint = value)) }
    fun setS3Region(value: String) = _state.update { it.copy(s3 = it.s3.copy(region = value)) }
    fun setS3AccessKey(value: String) = _state.update { it.copy(s3 = it.s3.copy(accessKey = value)) }
    fun setS3SecretKey(value: String) = _state.update { it.copy(s3 = it.s3.copy(secretKey = value)) }

    fun next() {
        val total = steps().size
        _state.update { s -> s.copy(stepIndex = (s.stepIndex + 1).coerceAtMost(total - 1)) }
    }

    fun back() {
        _state.update { s -> s.copy(stepIndex = (s.stepIndex - 1).coerceAtLeast(0)) }
    }

    fun goToStep(step: WizardStep) {
        val idx = steps().indexOfFirst { it::class == step::class && it == step }
        if (idx >= 0) _state.update { it.copy(stepIndex = idx) }
    }

    fun save() {
        if (_state.value.saving) return
        val s = _state.value
        _state.update { it.copy(saving = true) }
        viewModelScope.launch {
            val secrets = AccountSecrets(
                cloudToken = if (HetznerService.Cloud in s.services) s.cloud.token else null,
                robotUser = if (HetznerService.Robot in s.services) s.robot.user else null,
                robotPass = if (HetznerService.Robot in s.services) s.robot.pass else null,
                dnsToken = if (HetznerService.Dns in s.services) s.dns.token else null,
                s3Endpoint = if (HetznerService.S3 in s.services) s.s3.endpoint else null,
                s3Region = if (HetznerService.S3 in s.services) s.s3.region.takeIf(String::isNotBlank) else null,
                s3AccessKey = if (HetznerService.S3 in s.services) s.s3.accessKey else null,
                s3SecretKey = if (HetznerService.S3 in s.services) s.s3.secretKey else null,
            )
            accountManager.create(displayName = s.name, secrets = secrets)
            _state.update { it.copy(saving = false, saved = true) }
            next() // advance to Done step
        }
    }
}
