# Security Policy

## Supported Versions

Only the latest tagged release of Falco receives security fixes. The
project is maintained by a single developer and does not back-port
patches to older versions.

## Reporting a Vulnerability

Please report vulnerabilities privately. Do **not** open a public
GitHub issue.

- Email: security.falco@kiefer-networks.de
- Subject prefix: `[Falco security]`

Please include:

1. A description of the issue and its impact in concrete terms.
2. The affected file(s) and line numbers, or a reproducer.
3. The Falco version (visible in About) and the device / Android version
   you observed it on.

## Disclosure timeline

I aim for the following timeline once a report is received:

| Step | Target |
|---|---|
| Acknowledge receipt | within 5 days |
| First triage / severity assessment | within 14 days |
| Fix in `main` | within 60 days for High/Critical, 90 days otherwise |
| Public disclosure | after a fix has shipped in a tagged release |

## Threat model in scope

Falco stores Hetzner API tokens and Robot HTTP-Basic credentials. The
threat model assumes:

- The Android device is not rooted by the attacker.
- The Hetzner backends are trusted (out of scope).
- Network attackers may attempt MITM with user-installed CAs — Falco
  enforces TLS 1.2/1.3 and SPKI-root certificate pinning to defeat this.
- Co-located malicious apps cannot read EncryptedSharedPreferences but
  may attempt clipboard reads, screen capture, and intent abuse.

## Out of scope

- Penetration testing of `*.hetzner.cloud`, `*.your-server.de`,
  `*.your-objectstorage.com`, `*.hetzner.com` themselves.
- Issues that require a rooted device with a debugger attached.
- Vulnerabilities in optional accessibility services the user
  voluntarily installs.

## Build supply chain

Gradle dependency verification metadata (`gradle/verification-metadata.xml`)
is currently **not shipped**. The hashes Gradle generated locally diverged
from the transitive set Linux CI runners actually pull (different bom
`.module` files, platform-specific `aapt2` jars, etc.), and incremental
patching produced an unreliable file.

Maintainer action item (tracked as findings B-005 + B-006):

1. From a clean Linux environment that mirrors the CI runner image,
   run `./gradlew --write-verification-metadata sha256,pgp help` to
   regenerate the metadata file.
2. Populate `<trusted-keys>` for the maven groups Falco depends on
   (Google / AndroidX, JetBrains, Square, MinIO, Dagger). For each
   group, fetch the publisher's signing key, cross-check the
   fingerprint against a second source, then add a `<trusted-key>`
   entry.
3. Flip `<verify-metadata>` and `<verify-signatures>` to `true` and
   verify a clean build still passes.

Until that's done, supply-chain protection relies on TLS pinning of
Maven Central / dl.google.com plus reproducible-build verification on
F-Droid. SHA-256 dependency pinning is a known gap.

## Accepted Risks

A handful of items have been reviewed and consciously accepted rather
than fixed. They are recorded here so the trail is reproducible.

1. **`androidx.biometric:biometric` on the alpha track.** Falco pins
   `androidx.biometric:biometric:1.4.0-alpha07` because the `1.1.0`
   stable track from 2021 lacks the Class-3 + `DEVICE_CREDENTIAL`
   authenticator gating the auth flow uses. The `1.2.x` line was
   abandoned by AndroidX in favour of the active `1.4.x` track, which
   is what we ship. *Why accepted:* no stable replacement exposes the
   APIs we need. *Revisit:* every Falco release — bump alpha forward;
   move to stable as soon as AndroidX promotes 1.4.x.

2. **`androidx.security:security-crypto` as migration-only dep.** As
   of v2.0 the runtime credential store is Tink + DataStore (see Build
   supply chain below). `security-crypto` is retained in the
   dependency graph **only** as a one-shot reader that reads the v1
   `EncryptedSharedPreferences` file once at first launch, re-encrypts
   every entry with the new Tink AEAD, writes to the new DataStore,
   and wipes the legacy file. *Why accepted (transitional):* the
   library is deprecated but functional, and the maintainer wants
   existing users' tokens to migrate transparently. *Revisit:* drop
   the dependency in v2.1, after the migration window has elapsed.

2. **Two informational audit items (F-013 / F-017) accepted as
   known.** Both were flagged informational only — no exploit
   path, no user-visible impact. *Why accepted:* informational
   classification and no remediation path that wouldn't add more
   risk than it removes. *Revisit:* during the next audit pass —
   confirm conditions still hold and either close or re-classify.

3. **No public delete-redirect cleanup on the old GitHub URL.** The
   project moved from `MalteKiefer/Falco` to `Kiefer-Networks/Falco`;
   GitHub keeps a permanent redirect from the old URL. *Why
   accepted:* the redirect is transparent to clones, releases and
   F-Droid recipes, and there is no way to remove it short of
   deleting and recreating the namespace (which would break every
   incoming link). *Revisit:* only if GitHub ever ships a "purge
   redirect" admin action, or if the redirect is observed pointing
   at the wrong destination.

4. **Gradle dependency PGP verification disabled
   (`verify-signatures=false`).** `gradle/verification-metadata.xml`
   ships with PGP signature verification disabled; resolved
   artefacts are pinned by SHA-256 only and the `<trusted-keys>`
   set is empty. *Why accepted:* SHA-256 pinning already defeats
   the in-the-wild supply-chain attacks Falco is most exposed to
   (a compromised Maven mirror serving a swapped JAR), and
   populating per-group GPG fingerprints for every transitive
   dependency is a substantial one-time effort. See the
   **Build supply chain** section above for the maintainer action
   item. *Revisit:* before v2.0 — enumerate per-group GPG
   fingerprints, add `<trusted-key>` entries, and flip
   `<verify-signatures>` to `true`.

## Hall of fame

Public credit (with the reporter's permission) is given in release
notes.
