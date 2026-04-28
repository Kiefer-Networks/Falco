# Contributing to Falco

Thanks for your interest in improving Falco. A few ground rules.

## License

Falco is GPL-3.0-or-later. By contributing you agree that your contributions
will be released under the same license. Every new source file must start
with the SPDX header:

```kotlin
// SPDX-License-Identifier: GPL-3.0-or-later
```

(For XML, use `<!-- SPDX-License-Identifier: GPL-3.0-or-later -->`.)

## Dev setup

```
./scripts/setup-dev.sh        # one-shot env check + wrapper bootstrap
./gradlew :app:assembleDebug  # build
./gradlew :app:test           # unit tests
./gradlew :app:lintRelease    # lint
```

Requirements:
- Android SDK (API 35), build-tools 35+
- JDK 17 or 21 (Android Studio's bundled JBR is fine)
- Gradle 8.11.1 (handled by the wrapper)

## F-Droid compliance

Falco is published on F-Droid. Contributions must keep it compliant:

- **No proprietary dependencies.** Apache-2.0, MIT, BSD, LGPL, GPL — fine.
  Anything that requires Google Play Services, Firebase, AdMob, Crashlytics,
  Analytics or any non-free SDK — not fine.
- **No trackers.** See [exodus-privacy](https://reports.exodus-privacy.eu.org/)
  for the ground truth — if you add a dep that exodus flags, it does not ship.
- **Reproducible builds.** Don't introduce timestamps, build-time random
  numbers, or any non-deterministic codegen.

## Code style

- Kotlin official style. The `.editorconfig` enforces it.
- Compose: prefer stateless composables; ViewModels expose `StateFlow`s, not
  `LiveData`. Use the `data class FooUiState(loading, error, data)` pattern.
- DI: Hilt. Repos and singletons go through `@Inject`. Cross-cutting wiring
  goes in `di/AppModule.kt`.
- HTTP: every Hetzner endpoint goes through `HttpClientFactory` so it
  inherits TLS-1.3 + cert pinning. **Do not** create raw `OkHttpClient`s
  elsewhere.
- Comments only when the *why* is non-obvious. Don't restate the code.

## Localisation

Strings live in `app/src/main/res/values/strings.xml` (English, the
authoritative source) and `values-{de,es,fr,it,zh-rCN,ru}/strings.xml`. When
you add a string, add it to all seven files. The Fastlane store metadata
under `fastlane/metadata/android/<locale>/...` follows the same rule.

If you only speak some of the languages, ship a PR with English and German
filled in and stub the rest with the English text plus a `<!-- TODO: translate -->`
comment — a follow-up PR can finalise the translation.

## Security

- Tokens never get logged. Don't add `Log.d(...)` calls around network
  responses without scrubbing.
- Don't widen `FLAG_SECURE` exemptions.
- Don't add `allowBackup="true"` or weaken the `data_extraction_rules.xml`.
- Cert pinning failures are intentional: surface them in the UI, don't
  silently fall back to unpinned TLS.

If you find a security issue, please **email** instead of opening a public
issue: `malte.kiefer@kiefer-networks.de`.

## Releasing

(Maintainer-only.)

1. Bump `versionName` + `versionCode` in `app/build.gradle.kts`.
2. Update `CHANGELOG.md` and add `fastlane/metadata/android/<locale>/changelogs/<versionCode>.txt`.
3. Refresh pins: `./scripts/fetch_pins.sh > /tmp/pins.txt`, paste into
   `app/src/main/kotlin/.../data/api/Pins.kt`.
4. `git tag -s v0.x.y && git push origin v0.x.y`.
5. CI verifies reproducibility and uploads the unsigned APK as an artifact.
