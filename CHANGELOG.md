# Changelog

All notable changes to Falco are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project skeleton: Hetzner Cloud, Robot, DNS Console and Object
  Storage (S3) clients in Kotlin + Jetpack Compose.
- Multi-account support with EncryptedSharedPreferences-backed credential
  storage and BiometricPrompt unlock gate.
- TLS 1.3 + certificate pinning for all four Hetzner endpoints
  (pin material currently empty; populate via `scripts/fetch_pins.sh`
  before tagging a release).
- Localisations: English, German, Spanish, French, Italian, Simplified
  Chinese, Russian.
- Robot tab: server detail with reset (sw / hw / man / power) and
  Wake-on-LAN; Storage Box detail with snapshot list + create and
  sub-account list.
- DNS tab: zone detail with full record CRUD via a typed dialog
  (A / AAAA / CNAME / MX / TXT / NS / SRV / CAA + TTL).
- Object Storage tab: bucket → object browser with prefix navigation,
  per-file Share Link (1 h / 24 h / 7 d / 30 d), Download (MediaStore
  on API 29+, public Downloads dir on 26-28), Upload via SAF →
  foreground `UploadService`.
- 21 unit tests across all DTO sets, the four Retrofit interfaces, and
  the Robot rate-limit interceptor.
- Mipmap PNG launcher fallbacks at 5 densities for API < 26.
- F-Droid metadata stub, Fastlane locale folders, GitHub Actions CI
  with reproducible-build verification, dev-bootstrap helper at
  `scripts/setup-dev.sh`.

### Fixed
- BiometricGate: switch to `ContextCompat.getMainExecutor` (API 26
  compatible; the bare property requires API 28 which exceeds our
  declared minSdk).
- CredentialStore: drop the `setUserAuthenticationRequired(false, 0)`
  call — the timeout argument has a `≥ 1` precondition that lint
  flagged even when the boolean was `false`.
