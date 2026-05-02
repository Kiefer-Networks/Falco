# Changelog

All notable changes to Falco are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.1] — 2026-05-02

Bug-fix + UX-polish release. Three additions on top of v2.1.0.

### Fixed
- **Account wizard auto-activates the new account.** Previously, if you
  had a Cloud-only account active and added a new Robot-only account
  via the drawer, the post-wizard navigation routed to the Robot tab
  while the Cloud account was still selected. `RobotRepo` then bailed
  with `requireNotNull(robotUser) { "Robot user missing" }` and the
  user saw an empty error toast. The wizard now calls
  `accountManager.setActive(newAccount.id)` before exit, guaranteeing
  the destination tab finds backing credentials.

### Added
- **Robot monthly-traffic tile** on the per-server detail screen.
  Falco's `RobotApi` had `listTraffic()` wired since v0.1 but the UI
  never consumed it. The tile now shows inbound / outbound / total
  GB for the current calendar month on the server's primary IPv4.
  Hetzner Robot's `/traffic` endpoint is a form-encoded POST with
  `ip[]` + `type=month` + `from`/`to` — the previous unparameterised
  GET was returning a generic envelope without per-IP rows.
- **Permission-denied detection in the OkHttp interceptor chain.**
  Hetzner Cloud tokens have a read-only / read-write scope split,
  Robot supports sub-users with restricted rights, and DNS tokens
  rotate. Falco now wraps 401 / 403 responses on POST / PUT / PATCH /
  DELETE into a typed `PermissionDeniedException` (skipping responses
  with a `Retry-After` header to avoid clashing with the rate-limit
  interceptor). `sanitizeError` maps the exception to a clear
  "Insufficient permissions for this action — credential is read-only
  or scoped narrower than required." hint, replacing the generic
  "HTTP 403" toast.

### Translations
- New `robot_section_traffic_month`, `robot_traffic_in`,
  `robot_traffic_out`, `robot_traffic_sum`, `robot_traffic_gb_format`
  added in all 7 supported locales.

### Notes
- Permission-denied detection is currently reactive only — the UI
  doesn't pre-hide buttons based on a cached scope. Each action that
  the credential lacks rights for surfaces the hint at click time.
  Proactive button-hiding requires a per-action permission registry
  and is tracked for v2.x.

## [2.1.0] — 2026-05-02

Major-version sweep across the build toolchain and the network /
storage stack. Five separate audit passes informed each bump; no
behavioural changes for the user.

### Changed (toolchain)
- AGP `8.13.2` → `9.2.0`. The `applicationVariants.all { ... }` block
  was removed by AGP 9; APK / AAB output naming moved to the
  `androidComponents.onVariants` block that already manages the
  F-Droid reproducibility settings.
- Hilt `2.58` → `2.59.2` (was held back in v2.0 because 2.59 requires
  AGP 9.0+).
- Gradle wrapper `8.14.4` → `9.5.0` (SHA-256 pinned).

### Changed (network)
- `com.squareup.retrofit2:retrofit` `2.11.0` → `3.0.0`. Forward
  binary-compatibility per upstream — no service-interface changes.
- `com.squareup.okhttp3:okhttp` `4.12.0` → `5.3.2`. Every
  `HttpClientFactory` interceptor + `CertificatePinner` +
  `ConnectionSpec.RESTRICTED_TLS` API used is preserved verbatim
  in 5.x. `mockwebserver` test artefact stays at `4.12.0` for now —
  Square supports the overlap; full migration to `mockwebserver3`
  follows in a maintenance pass.

### Changed (storage)
- `io.minio:minio` `8.5.14` → `9.0.0`. The 9.0 refactor renamed two
  classes Falco depended on:
  - `io.minio.http.Method` → `io.minio.Http.Method`
  - `io.minio.messages.DeleteObject` → `io.minio.messages.DeleteRequest.Object`
  - `MinioClient.removeObjects(...)` semantics inverted: the returned
    iterable now yields **failures** instead of successes. `S3Client`
    now computes the success list as `input - failures` so the
    contract callers see is preserved.

### Changed (R8)
- ProGuard `-keepattributes` rule expanded from the bare `*Annotation*`
  wildcard to an explicit list (`RuntimeVisibleAnnotations`,
  `RuntimeVisibleParameterAnnotations`, `RuntimeVisibleTypeAnnotations`,
  `RuntimeInvisibleAnnotations`, `RuntimeInvisibleParameterAnnotations`,
  `RuntimeInvisibleTypeAnnotations`, `AnnotationDefault`,
  `InnerClasses`, `Signature`, `Exceptions`, `EnclosingMethod`). R8 9.x
  in AGP 9.0+ no longer treats `*Annotation*` as covering
  RuntimeInvisible annotations; the explicit list keeps Hilt /
  Retrofit / kotlinx-serialization shrink-safe across both R8 8.x and
  R8 9.x.

### CI
- All five GitHub Actions Dependabot major bumps merged in a separate
  pass: `actions/checkout@4 → 6`, `actions/setup-java@4 → 5`,
  `actions/download-artifact@4 → 8`, `softprops/action-gh-release@2 → 3`,
  `gradle/actions` SHA refresh.

### Tests
- `PasswordRedactionTest` extended to cover the
  `CreateCertificateRequest.privateKey` and
  `CreateServerRequest.userData` redactions added in v1.6.0 (F-002 +
  F-008). Both are negative-assertion tests — they refuse to allow
  the secret OR its surrounding metadata marker (`-----BEGIN PRIVATE
  KEY-----`, `#cloud-config`) to appear in `toString()`.

### Open follow-ups
- v2.2 candidate: drop `androidx.security:security-crypto` migration
  shim entirely.
- v2.x maintenance: migrate test fixtures to `mockwebserver3` package
  and tighten the Compose 1.11 lint rules that v2.0 disabled.

## [2.0.0] — 2026-05-02

Major release: replaces the deprecated `androidx.security:security-crypto`
EncryptedSharedPreferences credential store with a Tink-based AEAD store
on top of DataStore, and lifts the build toolchain to current.

### Changed (breaking — internal storage)
- **Credential store rewritten** on top of Google Tink (AES-256-GCM AEAD)
  with the keyset wrapped by an Android-Keystore-bound master key
  (`falco_master_v2`). Per-field ciphertext is persisted in a dedicated
  `falco_credentials_v2` DataStore, isolated from the plain account-index
  DataStore. The opt-in hardware-bound mode (Settings → Security)
  continues to work — the master Keystore key is created with
  `setUserAuthenticationRequired(true, 60s)` +
  `setInvalidatedByBiometricEnrollment(true)` when enabled.
- **Migration is automatic and idempotent.** On first launch of v2.0 the
  legacy v1 EncryptedSharedPreferences file (`falco_secure_v1.xml`) is
  read with the old MasterKey, every entry is re-encrypted with Tink
  AEAD, written to the new DataStore, and the legacy file is wiped. The
  migration marker is committed atomically with the payload so a process
  kill mid-migration is safe to retry.
- **Recovery path**: if the master key was invalidated (biometric
  re-enrollment in hardware-bound mode), the keyset is unwrapped-fail
  on construction. v2.0 catches that, drops the orphaned keyset +
  ciphertext, recreates the master key, and rebuilds — the user
  re-enters their tokens. v1.x would have crashed.

### Changed (toolchain)
- AGP `8.7.3` → `8.13.0`.
- Kotlin `2.1.0` → `2.2.21`; KSP `2.1.0-1.0.29` → `2.2.21-2.0.5`.
- Gradle wrapper `8.11.1` → `8.14.4` (SHA-256 pinned).
- `compileSdk` 35 → 36 (Android 16); `targetSdk` 35 → 36.
- `androidx.compose:compose-bom` `2025.01.00` → `2026.04.01`. Explicit
  Material3 version pin dropped — BOM is now the single source of
  truth for Compose-managed artefact versions.
- `androidx.biometric:biometric` `1.2.0-alpha05` → `1.4.0-alpha07`
  (now compatible with the bumped AGP/compileSdk).

### Removed (runtime)
- `androidx.security:security-crypto` is no longer on the runtime
  hot-path. It remains in the dependency graph **only** as a one-shot
  migration reader; it will be dropped entirely in v2.1 once the
  migration window closes.

### Security
- Falco no longer depends on a deprecated cryptography library at
  runtime. Tink 1.21.0 is the current Google-maintained crypto stack
  and is what AndroidX docs recommend in place of the deprecated
  EncryptedSharedPreferences.
- The master Keystore key alias has been rotated from the legacy
  `_androidx_security_master_key_` to `falco_master_v2` so previous
  Keystore key material is no longer reachable from the running app.

### Known caveats
- `minSdk` stays at 26. Bumping is tracked for v2.x once telemetry
  exists or maintainer policy changes.
- v2.x roadmap: drop `androidx.security:security-crypto` migration
  shim entirely; consider AGP 9.x once R8 9.x repackaging defaults are
  audited.

## [1.6.0] — 2026-05-02

Security hardening release. Two rounds of audit-driven remediation;
zero High and zero Medium findings open at release.

### Added
- **Opt-in hardware-bound credentials mode** (Settings → Security):
  binds the EncryptedSharedPreferences master key with
  `setUserAuthenticationRequired(true, 60s)` and
  `setInvalidatedByBiometricEnrollment(true)`. Higher-assurance mode
  for users who want re-enrollment of biometrics to invalidate stored
  tokens. Default OFF — preserves the existing PIN-equivalence gate.
- **Tapjacking-resistant `TypeToConfirmDeleteDialog`**: type-to-match
  + FLAG_SECURE + `MotionEvent.FLAG_WINDOW_IS_OBSCURED` event-drop
  guard. Wired into Robot SSH key, Cloud SSH key, Cloud Firewall,
  Cloud Volume, and Cloud Floating IP delete flows.
- **Pre-storage credential probe**: opt-in "Verify credentials"
  button in the AccountWizard final step calls
  `AccountManager.probeCredentials` to surface bad tokens before
  persistence (Cloud `listLocations`, DNS `listZones`, Robot
  `listFailoverIps`).
- **Pre-Android-13 clipboard caveat banner** in `SecureRevealDialog`:
  on API < 33 where `EXTRA_IS_SENSITIVE` is a no-op, surfaces the
  residual exposure to the user. Localised in 7 languages.

### Security
- **TLS pin refresh**: added Let's Encrypt **E8** intermediate to the
  Object Storage and Cloud pin sets. `hel1` and `nbg1` had migrated to
  E8 ahead of the rest of the chain; on API 26-30 devices that lack
  ISRG Root X2 in the system trust store, the next intermediate
  rotation would have hard-locked S3 access. Re-verified against the
  live chain on every host.
- **DTO redaction**: `CreateCertificateRequest.privateKey` and
  `CreateServerRequest.userData` (cloud-init) now mask in `toString()`
  matching the existing pattern used by rescue/console password and
  Storage Box password DTOs.
- **MainActivity** stamps `lastPausedAt` in `onCreate` to avoid a
  spurious extra biometric prompt on first foreground after cold
  start.

### Changed
- `androidx.security:security-crypto` `1.1.0-alpha06` → `1.1.0`
  (stable). The library is deprecated in 1.1.0-beta01+; long-term
  migration to direct Android Keystore + Tink/DataStore tracked as a
  v2.0 work item.
- `androidx.biometric:biometric` stays on `1.2.0-alpha05`. The newer
  `1.4.0-alpha07` line exists but requires AGP 8.9.1+ and
  `compileSdk = 36`; the toolchain bump is deferred to v2.0.
- ProGuard: blanket `-keep class dagger.hilt.** { *; }` narrowed to
  the runtime SPI surface (entry points, generated components,
  modules, injectors, factory wrappers). R8 can now obfuscate the
  rest, reducing reverse-engineering surface in installed APKs.

### Fixed
- Clipboard / SecureRevealDialog flows now disclose the pre-API-33
  `EXTRA_IS_SENSITIVE` no-op behaviour to the user instead of relying
  on the silent 60s auto-wipe alone.

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
