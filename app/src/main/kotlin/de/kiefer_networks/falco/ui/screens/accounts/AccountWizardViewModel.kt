// SPDX-License-Identifier: GPL-3.0-or-later
package de.kiefer_networks.falco.ui.screens.accounts

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import de.kiefer_networks.falco.data.auth.AccountManager
import de.kiefer_networks.falco.data.auth.AccountSecrets
import de.kiefer_networks.falco.data.model.CloudProject
import de.kiefer_networks.falco.data.util.sanitizeError
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.util.UUID
import javax.inject.Inject

enum class HetznerService { Cloud, Robot, Dns }

sealed interface WizardStep {
    data object Name : WizardStep
    data object ServicePicker : WizardStep
    data class Credentials(val service: HetznerService) : WizardStep
    data object Review : WizardStep
    data object Done : WizardStep
}

data class RobotCreds(val user: String = "", val pass: String = "")
data class DnsCreds(val token: String = "")

/**
 * Draft state for one Cloud project being authored inside the wizard. We keep
 * a stable id from the moment the user adds an empty card so list operations
 * don't shift while typing.
 */
data class CloudProjectDraft(
    val id: String = UUID.randomUUID().toString(),
    val name: String = "",
    val token: String = "",
    val s3Enabled: Boolean = false,
    val s3Endpoint: String = "fsn1.your-objectstorage.com",
    val s3Region: String = "",
    val s3AccessKey: String = "",
    val s3SecretKey: String = "",
)

data class WizardState(
    val name: String = "",
    val services: Set<HetznerService> = emptySet(),
    val cloudProjects: List<CloudProjectDraft> = listOf(CloudProjectDraft()),
    val robot: RobotCreds = RobotCreds(),
    val dns: DnsCreds = DnsCreds(),
    val stepIndex: Int = 0,
    val saving: Boolean = false,
    val saved: Boolean = false,
    val verifying: Boolean = false,
    val verified: Boolean = false,
    val verifyError: String? = null,
)

@HiltViewModel
class AccountWizardViewModel @Inject constructor(
    private val accountManager: AccountManager,
) : ViewModel() {

    private val _state = MutableStateFlow(WizardState())
    val state: StateFlow<WizardState> = _state.asStateFlow()

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
        HetznerService.Cloud -> {
            val list = _state.value.cloudProjects
            list.isNotEmpty() && list.all { p ->
                p.name.isNotBlank() && p.token.isNotBlank() &&
                    (!p.s3Enabled || (
                        p.s3Endpoint.isNotBlank() &&
                            p.s3AccessKey.isNotBlank() &&
                            p.s3SecretKey.isNotBlank()
                        ))
            }
        }
        HetznerService.Robot -> _state.value.robot.user.isNotBlank() && _state.value.robot.pass.isNotBlank()
        HetznerService.Dns -> _state.value.dns.token.isNotBlank()
    }

    fun setName(value: String) = _state.update { it.copy(name = value.take(64)) }

    fun toggleService(service: HetznerService) = _state.update {
        val next = if (service in it.services) it.services - service else it.services + service
        it.copy(services = next)
    }

    fun setRobotUser(value: String) = _state.update { it.copy(robot = it.robot.copy(user = value)) }
    fun setRobotPass(value: String) = _state.update { it.copy(robot = it.robot.copy(pass = value)) }
    fun setDnsToken(value: String) = _state.update { it.copy(dns = DnsCreds(value)) }

    // Project list ops

    fun addCloudProject() = _state.update { it.copy(cloudProjects = it.cloudProjects + CloudProjectDraft()) }

    fun removeCloudProject(id: String) = _state.update {
        val next = it.cloudProjects.filterNot { p -> p.id == id }
        it.copy(cloudProjects = next.ifEmpty { listOf(CloudProjectDraft()) })
    }

    fun updateCloudProject(id: String, transform: (CloudProjectDraft) -> CloudProjectDraft) = _state.update {
        it.copy(cloudProjects = it.cloudProjects.map { p -> if (p.id == id) transform(p) else p })
    }

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
            val secrets = buildSecrets(s)
            accountManager.create(displayName = s.name, secrets = secrets)
            _state.update { it.copy(saving = false, saved = true) }
            next()
        }
    }

    fun verify() {
        if (_state.value.verifying) return
        val s = _state.value
        _state.update { it.copy(verifying = true, verified = false, verifyError = null) }
        viewModelScope.launch {
            val secrets = buildSecrets(s)
            val result = runCatching { accountManager.probeCredentials(secrets) }
            _state.update { current ->
                result.fold(
                    onSuccess = { current.copy(verifying = false, verified = true, verifyError = null) },
                    onFailure = { e -> current.copy(verifying = false, verified = false, verifyError = sanitizeError(e)) },
                )
            }
        }
    }

    private fun buildSecrets(s: WizardState): AccountSecrets {
        val projects = if (HetznerService.Cloud in s.services) {
            s.cloudProjects.map { d ->
                CloudProject(
                    id = d.id,
                    name = d.name,
                    cloudToken = d.token,
                    s3Endpoint = d.s3Endpoint.takeIf { d.s3Enabled && it.isNotBlank() },
                    s3Region = d.s3Region.takeIf { d.s3Enabled && it.isNotBlank() },
                    s3AccessKey = d.s3AccessKey.takeIf { d.s3Enabled && it.isNotBlank() },
                    s3SecretKey = d.s3SecretKey.takeIf { d.s3Enabled && it.isNotBlank() },
                )
            }
        } else emptyList()
        return AccountSecrets(
            cloudProjects = projects,
            activeCloudProjectId = projects.firstOrNull()?.id,
            robotUser = if (HetznerService.Robot in s.services) s.robot.user else null,
            robotPass = if (HetznerService.Robot in s.services) s.robot.pass else null,
            dnsToken = if (HetznerService.Dns in s.services) s.dns.token else null,
        )
    }
}
