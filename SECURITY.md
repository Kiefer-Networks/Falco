# Security Policy

## Supported Versions

Only the latest tagged release of Falco receives security fixes. The
project is maintained by a single developer and does not back-port
patches to older versions.

## Reporting a Vulnerability

Please report vulnerabilities privately. Do **not** open a public
GitHub issue.

- Email: malte.kiefer@mailbox.org
- Subject prefix: `[Falco security]`
- Optional GPG: see https://kiefer-networks.de for the current key

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

## Hall of fame

Public credit (with the reporter's permission) is given in release
notes.
