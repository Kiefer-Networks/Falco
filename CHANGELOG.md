# Changelog

All notable changes to Falco are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.1] — 2026-05-01

Hotfix release. The 1.5.0 APK published to the GitHub release was
unsigned because `KEYSTORE_BASE64` was missing from the new
`Kiefer-Networks/Falco` repo's Actions secrets, so `apksigner`/F-Droid
rejected it as having an invalid signature. 1.5.1 ships the same code
signed with the regular release key (SHA512withRSA, RSA-4096).

### Fixed
- Release artifacts are signed again. Reinstalling 1.5.0 from F-Droid /
  GitHub had failed with `INSTALL_PARSE_FAILED_NO_CERTIFICATES`.

### Changed
- `release.yml` now fails fast in a dedicated "Verify signing secrets
  present" step when `KEYSTORE_BASE64` is empty, instead of silently
  skipping `Set up signing materials` and shipping an unsigned APK.

No functional changes vs. 1.5.0.

## [1.5.0] — 2026-05-01

Security and supply-chain hardening release. No new feature surface;
two audit rounds went over every flow that handled secrets,
supply-chain inputs or destructive actions and tightened them.

### Added
- `SECURITY.md` vulnerability disclosure policy with private reporting
  channel `security.falco@kiefer-networks.de`, timeline, and threat-model
  scope.
- `ui/util/Clipboard.kt` — central helper for sensitive copies. Sets
  `EXTRA_IS_SENSITIVE` on Android 13+ (so the system suppresses the clip
  preview banner) and schedules a 60 s wipe so a forgotten secret
  doesn't sit on the clipboard indefinitely.
- `ui/components/dialog/SecureRevealDialog.kt` — shared one-time-reveal
  dialog with `FLAG_SECURE` (`SecureFlagPolicy.SecureOn`) so screenshots
  and the recents-app preview can't capture root passwords or console
  tokens. Used by both Cloud rebuild/rescue/reset-password flows and
  Robot rescue.
- SSH-key paste guard: the AddKey sheet now refuses to submit blobs
  containing `BEGIN PRIVATE KEY` / `OPENSSH PRIVATE KEY` /
  `RSA PRIVATE KEY` / `DSA` / `EC` / `ENCRYPTED PRIVATE KEY` markers,
  preventing accidental private-key uploads.
- `IdempotencyKeyInterceptor` (`HttpClientFactory.kt`) — auto-attaches
  a UUIDv4 `Idempotency-Key` header to every `POST`/`PUT`/`PATCH`/
  `DELETE` on the cloud and storage-box clients (skipped if a caller
  already set one).
- `data/repo/DnsRepo.requireBindFileWithinLimit` — 1 MiB cap on
  `importZoneFile` and `validateZone`; throws
  `BindFileTooLargeException` before the POST.
- `RobotRateLimitException(retryAfter: String?)` carries the raw
  `Retry-After` header (RFC 7231 delta-seconds or HTTP-date) for
  callers that want to schedule a backoff.
- `S3EndpointValidatorTest` and `PasswordRedactionTest` cover the new
  validator paths and DTO redaction guarantees.
- Locked the Gradle 8.11.1 distribution checksum
  (`distributionSha256Sum`) in `gradle-wrapper.properties`.

### Changed
- Robot `ServerDetailViewModel.rescuePassword` is now a one-shot
  `SharedFlow<String>` instead of a long-lived `UiState` field; the
  password is consumed exactly once into `SecureRevealDialog` and
  cleared.
- Cloud rescue / reset-root-password / console-result dialogs now route
  through `SecureRevealDialog` (FLAG_SECURE) instead of a Snackbar.
- All sensitive copies (root password, rescue password, presigned share
  URL, console URL + password) now route through
  `Clipboard.copySensitive`.
- `SearchViewModel.selectProjectThen` awaits the active-project
  DataStore commit before invoking the navigation callback, so detail
  screens always read the correct token.
- `data/util/Errors.kt::sanitizeError` no longer exposes the exception
  class name in its fallback path — generic `"Error"` only.
- `data/s3/UploadService.isLocalContentUri` now accepts only
  `content://` URIs; `file://` is rejected (could otherwise let an
  attacker-controlled file pointer push past the SAF sandbox).
- `data/s3/S3Client.validateAndNormalizeS3Endpoint` rewritten on top of
  `okhttp3.HttpUrl`: rejects `userinfo`, non-default ports, and any
  non-empty path / query / fragment. Replaces the prior `java.net.URI`
  parser.
- TLS SPKI pins refreshed against the live Hetzner chain. Current Let's
  Encrypt intermediates (`E7`, `R13`) added alongside the `ISRG Root`
  pins; the stale audit TODO on `api.hetzner.com` was retired after
  confirming the endpoint is DigiCert (Thawte G1).
- `data/s3/S3Repo` now exposes a separate `clampUploadHours` (hard
  1 h cap) distinct from `clampShareHours` (1 .. 168 h) to avoid
  granting week-long upload tokens.
- `data/auth/CredentialStore.put` / `remove` are now `suspend` and
  write via `commit()` on `Dispatchers.IO`. The async `apply()` race
  that could leave a ghost account after an OOM mid-`create()` is
  closed; `AccountManager.applySecrets` /
  `readCloudProjects` / `writeCloudProjects` / `readAccount` became
  `suspend` to match.
- DTO `toString()` overrides redact `password` / `rootPassword` on the
  eight named Cloud + Robot DTOs (covered by `PasswordRedactionTest`).
- `MainActivity.openSecuritySettings()` adds `FLAG_ACTIVITY_NEW_TASK`
  and wraps `startActivity` in `runCatching` so devices missing the
  intent handler no longer crash.
- `ShareLinkDialog` chooser passes `EXTRA_EXCLUDE_COMPONENTS` for MIUI
  Notes, Samsung Notes, AOSP-Clipboard, Huawei-Clipboard so a
  presigned URL cannot be silently routed into a clipboard / notes
  app.
- `app/proguard-rules.pro` `-assumenosideeffects` extended to strip
  `Log.w` / `Log.e` / `Log.wtf` / `println` in release, not just
  `Log.d` / `.v` / `.i`. Redundant `-keep class data.dto.**` rule
  dropped (kotlinx-serialization rules already cover DTOs).

### Removed
- Decorative `confirmDestructiveActions` and `keepDiagnostics` toggles
  from the Settings screen — they never actually gated anything.
  DataStore keys, flows, setters and string resources also removed.
- `okhttp-logging` dependency: it was shipping in release builds
  without any consumer.

### CI / Supply chain
- Pinned every GitHub Action in `.github/workflows/ci.yml` and
  `release.yml` to a verified 40-character commit SHA (no more floating
  `@v4` tags).
- `release.yml`: `umask 077` before the keystore heredoc plus explicit
  `chmod 600 app/keystore.jks keystore.properties` after, so the
  keystore is never world-readable on the runner.
- `release.yml`: `actions/download-artifact` scoped by name
  (`android-apk`, `android-aab`); `softprops/action-gh-release`
  `files:` constrained to a `release-assets/Falco-*.{apk,aab}` glob
  so unrelated artefacts can never end up attached to a release.
- `ci.yml`: `push` trigger restricted to `main`; `pull_request`
  trigger restricted to `[opened, synchronize, reopened]` against
  `main`.
- `release.yml`: preflight step `Verify tag matches versionName`
  fails the build if `${ref_name#v}` does not equal
  `app/build.gradle.kts`'s `versionName`.
- `libs.versions.toml`: `# JUSTIFIED:` comments documenting why
  `androidx.security.crypto:1.1.0-alpha07` and
  `androidx.biometric:1.2.0-alpha05` remain pinned to alpha (matches
  the `SECURITY.md` accepted-risks block).

## [1.1.0] — 2026-04-30

### Added
- **Global search** across every Hetzner resource — Cloud servers,
  volumes, networks, floating IPs, firewalls, primary IPs, load
  balancers, certificates, placement groups, SSH keys, storage boxes,
  Robot servers, DNS zones. Indexes once on screen open; tap a result
  to switch to its project and open the detail screen.
- **Multiple Cloud projects per account.** Edit / add / remove Cloud
  projects from the Accounts screen; switch the active project from
  the home tab without re-authenticating.
- **Aggregate-projects mode** — a settings toggle that fans every
  list-style query out to all Cloud projects of the active account
  and merges the results (resource-type tabs show across-projects).
- **Project picker before create** — when aggregate mode is on, every
  Cloud "create" wizard (server, volume, floating IP, network,
  firewall, SSH key, certificate, placement group, primary IP) first
  asks which project the new resource should land in.
- Storage Box detail screen: snapshots (list / create / restore /
  delete), subaccounts (list / create / delete / set password),
  master-account password reset, access toggles
  (SSH / Samba / WebDAV / ZFS).
- Cloud server detail metrics (CPU, disk I/O, network) with a
  selectable period (24 h / 7 d / 30 d).
- OLED-black dark theme + five accent palettes
  (red / blue / green / purple / orange) selectable from the
  Appearance settings sub-screen.
- About / Settings hub with Security, Appearance and Language
  sub-screens.
- Localised F-Droid metadata (title, short description, full
  description) for all seven shipped locales.

### Changed
- APK / AAB outputs renamed to `Falco-<version>-<type>.apk` so
  multi-app repositories never collide on the generic
  `app-release.apk`.
- Card surfaces gain explicit elevation in dark themes so they
  remain distinguishable from the surface background.

### Fixed
- Search pre-indexes in parallel and filters locally — first results
  appear immediately and detail-screen tap no longer 404s on the
  wrong project token.

## [1.0.0] — 2026-04-30

First public release.

### Added
- Hetzner Cloud, Robot, DNS Console and Object Storage (S3-compatible)
  clients implemented in Kotlin + Jetpack Compose, single-Activity Hilt
  entry point.
- Multi-account support; credentials stored in
  `EncryptedSharedPreferences` with the master key bound to the
  Android Keystore (StrongBox-backed when available). BiometricPrompt
  unlock gate (Class 3 / Device Credential) on cold start with
  configurable auto-lock timeout.
- TLS 1.3-only OkHttp stack with SPKI root pinning for every Hetzner
  endpoint
  (`api.hetzner.cloud`, `robot-ws.your-server.de`, `dns.hetzner.com`,
  `api.hetzner.com`, `*.your-objectstorage.com`).
- `FLAG_SECURE` on every screen; `allowBackup="false"`; auto-backup
  excluded; data-extraction rules locked down.
- Cloud feature surface: server CRUD + actions (power, reset password,
  rebuild, change type, ISO attach/detach, rescue, backup toggle,
  console request, reverse DNS, rename, protection, delete); volume
  wizard with live price estimate; networks, floating IPs, firewalls,
  SSH keys, primary IPs, certificates, placement groups, storage
  boxes — all with full CRUD where the API allows.
- Robot feature surface: rich server list + detail (status / IPs /
  datacenter / paid-until); reset (sw / hw / man / power);
  Wake-on-LAN; rescue mode with FLAG_SECURE password reveal;
  reverse DNS; cancellation + withdraw. Failover IPs (route /
  unroute), vSwitches (CRUD + attach/detach), Robot SSH keys.
- DNS feature surface: zones (CRUD + single-zone fetch); records
  (CRUD + bulk create/update + BIND import/export + validate); primary
  servers (CRUD).
- Object Storage: bucket CRUD; object browser with prefix navigation,
  per-file Share Link (1 h / 24 h / 7 d / 30 d), Download
  (MediaStore on API 29+, public Downloads on API 26-28), Upload via
  SAF + foreground `UploadService`; bucket versioning toggle.
- 21 unit tests covering every DTO set, Retrofit interface and the
  Robot rate-limit interceptor.
- Localisations: English, German, Spanish, French, Italian, Russian,
  Simplified Chinese.
- F-Droid recipe + Fastlane locale folders + GitHub Actions CI with
  reproducible-build verification.

## [0.1.0] — 2026-04-30

Initial development tag — project skeleton, CI scaffold, and the bones
of the Cloud / Robot / DNS / S3 clients before feature lock for v1.0.
