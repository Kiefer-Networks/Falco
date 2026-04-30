<div align="center">

# Falco — Hetzner Manager for Android

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![CI](https://github.com/MalteKiefer/Falco/actions/workflows/ci.yml/badge.svg)](https://github.com/MalteKiefer/Falco/actions/workflows/ci.yml)
[![Donate](https://img.shields.io/badge/donate-Liberapay-F6C915?style=flat&logo=liberapay)](https://de.liberapay.com/beli3ver)

Privacy-respecting Android client for [Hetzner Online](https://www.hetzner.com).
Manage **Hetzner Cloud**, **Robot** (dedicated servers + Storage Boxes),
**DNS Console** and **Object Storage** from one secure app.

</div>

> Falco is community software and is **not affiliated** with Hetzner Online GmbH.
> Hetzner is a trademark of Hetzner Online GmbH.

## Highlights

- **100 % free software** (GPL-3.0-or-later) — no Google Play Services, no
  Firebase, no proprietary dependencies. Designed to be reproducibly buildable
  on F-Droid.
- **Multi-account, multi-project** — switch between Hetzner customers and
  Cloud projects on the fly. Per-account credentials.
- **Hardened storage** — credentials in `EncryptedSharedPreferences` with the
  master key bound to the Android Keystore (StrongBox-backed when available).
- **Biometric gate** — `BiometricPrompt` (Class 3 / Device Credential) on app
  start; auto-relock on background timeout.
- **TLS 1.3 only** with **certificate pinning** for every Hetzner endpoint
  (Cloud, Robot, DNS, Object Storage). Pins are root anchors so they survive
  Let's Encrypt's leaf rotation cycle.
- `FLAG_SECURE` on every screen, `allowBackup="false"`, auto-backup excluded.
- Localised in **7 languages** (en, de, es, fr, it, ru, zh-CN).

## Features

### Hetzner Cloud
- Servers: list, detail, metrics, create wizard, power actions, reset password,
  rebuild, change type, ISO attach/detach, rescue mode, backup toggle, console
  request, reverse DNS, rename, protection, delete.
- Volumes: list, create wizard with live price estimate, attach/detach,
  rename, resize, format, automount, protection, delete.
- Networks: list, create wizard, subnets add/delete, routes, change IP range,
  expose to vSwitch, protection, delete.
- Floating IPs: list, create wizard, assign/unassign, change reverse DNS,
  protection, delete.
- Firewalls: list, create, edit rules, apply to / remove from resources.
- SSH keys: list, create, rename, delete.
- Primary IPs: list, create, assign/unassign, protection, delete.
- Load Balancers: list overview *(create + actions wired in repo, UI growing)*.
- Certificates: upload PEM or request managed (Let's Encrypt) certs, list,
  delete, retry managed issuance.
- Placement Groups: list, create, delete.
- Storage Boxes: full detail screen — list, snapshots, subaccounts, password
  reset, access toggles (SSH/Samba/WebDAV/ZFS).

### Hetzner Robot
- Servers: rich list (status dot, chips, IPv4/IPv6 with copy, datacenter,
  paid-until), detail screen, reset (sw/hw/manual), Wake-on-LAN, rescue mode
  enable/disable, reverse DNS setter, server cancellation + withdraw.
- Failover IPs: list, route to active server, unroute.
- vSwitches: list, create, update, delete, attach/detach servers.
- SSH keys: list, create, delete.

### DNS Console
- Zones: list, create, update, delete, single-zone fetch.
- Records: list, create, update, delete, single-record fetch, **bulk
  create/update**, BIND import/export, validate.
- Primary servers (secondary zone sources): full CRUD.

### Object Storage (S3-compatible)
- Buckets: list, exists, create, delete.
- Objects: list (prefix browser), upload via foreground service, download via
  signed URL, head/stat, copy, delete (single + batch), presigned upload URL.
- Bucket settings: versioning toggle.

## Building

Requires:

- **JDK 17** (set via Gradle toolchain — auto-provisions if absent).
- **Android SDK 35** (compileSdk).
- **Kotlin 2.1**, **AGP 8.x**, **Compose BoM 2025.01**.

```sh
git clone https://github.com/MalteKiefer/Falco.git
cd Falco
./gradlew :app:assembleDebug
```

The debug APK lands in `app/build/outputs/apk/debug/`.

### Release builds

Release builds are signed with a real keystore. Provide one via
`keystore.properties` at the repo root (this file is git-ignored):

```properties
storeFile=keystore.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=upload
keyPassword=YOUR_KEY_PASSWORD
```

Then:

```sh
./gradlew :app:assembleRelease   # APK
./gradlew :app:bundleRelease     # AAB
```

### Quality gates

```sh
./gradlew :app:lintDebug          # Android Lint
./gradlew testDebugUnitTest       # unit tests
```

CI runs both on every push.

## Architecture

- **UI**: Jetpack Compose + Material 3, single-Activity (Hilt entry point).
- **DI**: Hilt.
- **Networking**: Retrofit 2 + OkHttp 4, Kotlin Serialization JSON
  converter. TLS pinning via `CertificatePinner` (SPKI SHA-256 of trust
  anchors).
- **Storage**: Jetpack DataStore for non-sensitive prefs;
  `EncryptedSharedPreferences` (AES-256-GCM, Keystore master key) for
  Hetzner tokens / S3 secrets / Robot credentials.
- **S3**: MinIO Java SDK 8.5 routed through the same hardened OkHttp client
  so it inherits TLS + pinning policy.
- **Concurrency**: Kotlin Coroutines + `StateFlow` / `SharedFlow`.

## Permissions

| Permission | Why |
|---|---|
| `INTERNET` | API calls (Hetzner + S3). |
| `ACCESS_NETWORK_STATE` | Network availability checks. |
| `USE_BIOMETRIC` | Unlock gate. |
| `POST_NOTIFICATIONS` | Upload-progress notifications (Android 13+). |
| `FOREGROUND_SERVICE` + `FOREGROUND_SERVICE_DATA_SYNC` | S3 upload service. |

No location, contacts, broad storage, accounts, or analytics permissions.

## Localisation

The default language is English. Falco ships with full translations of the
~530 user-facing strings for: German, Spanish, French, Italian, Russian and
Simplified Chinese. Help us add more in `app/src/main/res/values-*`.

## Donate

If Falco saves you time, please consider supporting development via
**[Liberapay — de.liberapay.com/beli3ver](https://de.liberapay.com/beli3ver)**.
Liberapay is non-profit, anonymous-friendly and takes no platform cut.

## Contributing

PRs welcome. Please:

1. Match the project's code style (Compose-first, no Views, no XML layouts).
2. Add strings to **all** seven `values-*/strings.xml` files when introducing
   user-visible text.
3. Run `./gradlew :app:lintDebug` and `./gradlew testDebugUnitTest` before
   opening a PR.

## License

[GPL-3.0-or-later](LICENSE). See [`LICENSE`](LICENSE) for the full text.
