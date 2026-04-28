# Falco — Hetzner Manager for Android

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)

Falco is a privacy-respecting Android client for [Hetzner Online](https://www.hetzner.com)
services. It manages **Hetzner Cloud**, **Robot** (dedicated servers + Storage Boxes),
**DNS Console** and **Object Storage** (S3) from a single secure app.

> Falco is community software and is **not affiliated** with Hetzner Online GmbH.

## Status

Early skeleton. Account setup, server listing/control and storage browsing work
end-to-end; the polish, error UX and edge cases are still being filled in. See
[`CHANGELOG.md`](CHANGELOG.md).

## Highlights

- 100 % free software (GPL-3.0-or-later) — no Google Play Services, no Firebase,
  no proprietary dependencies. Designed to be reproducibly buildable on F-Droid.
- Credentials stored in `EncryptedSharedPreferences` with the master key bound
  to the **Android Keystore** (StrongBox-backed when available).
- **BiometricPrompt** (Class 3 / Device Credential) gate on app start.
- **TLS 1.3 only** with **certificate pinning** for every Hetzner endpoint
  (Cloud, Robot, DNS, Object Storage).
- `FLAG_SECURE` on every screen, `allowBackup="false"`, auto-backup excluded.
- Multi-account support — switch between Hetzner customer accounts.
- Localised in **7 languages** (en, de, es, fr, it, zh-CN, ru).

## Building

Falco uses the standard Android toolchain. Requirements:

- **JDK 17** (configured via `kotlin { jvmToolchain(17) }` — Gradle will
  provision it automatically if absent).
- **Android SDK** with API 35 platform and recent build-tools.
- **Gradle 8.11.1** — once provisioned via the wrapper, you can use
  `./gradlew` directly. To bootstrap the wrapper jar on a fresh checkout
  (only needed once), run:
  ```bash
  gradle wrapper --gradle-version 8.11.1
  ```
  with a system Gradle, or open the project in Android Studio which generates
  the wrapper automatically.

Then:

```bash
./gradlew :app:assembleRelease    # release APK
./gradlew :app:installDebug       # install debug build to attached device
./gradlew :app:test               # unit tests
./gradlew :app:lintRelease        # lint
```

### Signing for release

Place a `keystore.properties` file at the repo root:

```
storeFile=/absolute/path/to/falco-release.jks
storePassword=…
keyAlias=falco
keyPassword=…
```

The release build will pick it up automatically. Never commit the keystore or
this file (`.gitignore` already excludes them).

## F-Droid release flow

1. Bump `versionName` and `versionCode` in `app/build.gradle.kts`.
2. Update `CHANGELOG.md` and add a new `fastlane/metadata/android/<locale>/changelogs/<versionCode>.txt`.
3. Refresh certificate pins:
   ```bash
   ./scripts/fetch_pins.sh > /tmp/pins.txt
   # review, then paste relevant pins into app/src/main/kotlin/.../data/api/Pins.kt
   ```
4. Tag the release: `git tag -s v0.x.y && git push origin v0.x.y`.
5. Verify reproducibility locally:
   ```bash
   ./gradlew :app:assembleRelease
   cp app/build/outputs/apk/release/app-release-unsigned.apk a.apk
   ./gradlew clean :app:assembleRelease
   diffoscope a.apk app/build/outputs/apk/release/app-release-unsigned.apk
   ```
6. Open a PR against [`fdroiddata`](https://gitlab.com/fdroid/fdroiddata)
   referencing `metadata/de.kiefer_networks.falco.yml`.

## Security model

| Threat | Mitigation |
|---|---|
| Token exfiltration via filesystem | EncryptedSharedPreferences (AES-256-GCM, MasterKey in Keystore + StrongBox) |
| Token leak via screenshots / Recents | `FLAG_SECURE` on the only Activity |
| Token leak via auto-backup / device transfer | `allowBackup="false"`, `data_extraction_rules.xml` excludes everything |
| Network MITM | TLS 1.3-only `RESTRICTED_TLS` ConnectionSpec + per-host SHA-256 SPKI pinning |
| Token leak via logs | `Log.{v,d,i}` stripped by R8 in release builds |
| Token leak via crash dumps | No third-party crash reporter; only stack traces with stripped source filenames |
| Stolen device | BiometricPrompt (Class 3) + Device Credential gate; auto-lock timeout configurable |

## Architecture

```
ui (Compose + ViewModel + Hilt) ──▶ domain (UseCases) ──▶ data
                                                          ├── auth (CredentialStore, AccountManager, BiometricGate)
                                                          ├── api  (Retrofit/MinIO clients per Hetzner service)
                                                          ├── repo (CloudRepo, RobotRepo, DnsRepo, S3Repo)
                                                          └── dto  (kotlinx.serialization data classes)
```

Single-module Clean-Architecture-lite. Compose handles the *View* layer,
ViewModels are the *ViewModel/Controller*, repositories are the *Model* layer.

## Contributing

Issues and pull requests welcome at
[`github.com/maltekiefer/falco`](https://github.com/maltekiefer/falco). All
contributions must be GPL-3.0-or-later compatible.

## License

[GPL-3.0-or-later](LICENSE). Copyright © 2026 Malte Kiefer.
