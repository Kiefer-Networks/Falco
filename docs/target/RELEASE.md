# Falco 3: Release

Dieses Dokument beschreibt, was einmalig eingerichtet werden muss und wie ein
Release abläuft. Die Pipeline ist `.github/workflows/release.yml`, die Store
Uploads laufen über fastlane (`Gemfile`, `Gemfile.lock`, `fastlane/Fastfile`).

## Ablauf

1. Signierter Tag `v<version>` (muss `version:` in `pubspec.yaml` entsprechen,
   z. B. `3.0.0+300` → `v3.0.0`). Der Workflow prüft Signatur und Version.
2. **Android:** Tests, signiertes AAB und APK, GitHub Release mit APK, AAB,
   `SHA256SUMS` und Build Provenance (`gh attestation verify <datei> -R
   Kiefer-Networks/Falco`), danach Upload des AAB in den internen Test Track
   von Google Play samt Texten und Changelog.
3. **iOS:** signiertes IPA, Upload zu TestFlight.
4. Testen über den internen Track und TestFlight.
5. Manueller Lauf: Actions → Release → *Run workflow*, als Ref den Tag
   wählen (nicht den Branch):
   - `play_track`: interne Version nach `alpha`, `beta` oder `production`
     übernehmen (nichts wird neu gebaut).
   - `ios_submit`: den TestFlight Build mit den Texten aus
     `fastlane/metadata/ios` zur App Prüfung einreichen. Veröffentlicht wird
     nach der Freigabe manuell in App Store Connect.

Jeder Store Job prüft zuerst seine Secrets und bricht mit
`Secret <NAME> is missing in environment release` ab, wenn eines fehlt. Die
GitHub Release hängt nur am Android Build, nicht an den Stores.

## Secrets in der Environment `release`

Anlegen unter Repository → Settings → Environments → `release` →
Environment secrets, oder per CLI:
`gh secret set <NAME> --env release --repo Kiefer-Networks/Falco < datei`.

| Secret | Inhalt | Status |
|---|---|---|
| `KEYSTORE_BASE64` | Upload Keystore (`.jks`) als Base64 | vorhanden |
| `KEY_ALIAS` | Alias des Upload Keys | vorhanden |
| `KEY_PASSWORD` | Passwort des Keys | vorhanden |
| `STORE_PASSWORD` | Passwort des Keystores | vorhanden |
| `PLAY_SERVICE_ACCOUNT_JSON` | JSON Schlüssel des Play Service Accounts (Klartext, nicht Base64) | fehlt |
| `ASC_KEY_ID` | Key ID des App Store Connect API Keys | fehlt |
| `ASC_ISSUER_ID` | Issuer ID (oben auf der Seite der API Keys) | fehlt |
| `ASC_KEY_P8_BASE64` | `AuthKey_<KEYID>.p8` als Base64 | fehlt |
| `IOS_DIST_CERT_P12_BASE64` | Apple Distribution Zertifikat mit privatem Schlüssel als `.p12`, Base64 | fehlt |
| `IOS_DIST_CERT_PASSWORD` | Passwort der `.p12` Datei | fehlt |
| `IOS_PROVISIONING_PROFILE_BASE64` | App Store Provisioning Profil als Base64 | fehlt |

Base64 ohne Zeilenumbrüche erzeugen: `base64 -i datei | tr -d '\n'`.

### Google Play Service Account

1. Google Cloud Console, beliebiges Projekt: *Google Play Android Developer
   API* aktivieren.
2. IAM → Dienstkonten → Dienstkonto anlegen (keine Projektrollen nötig) →
   Schlüssel → JSON. Die Datei ist `PLAY_SERVICE_ACCOUNT_JSON`.
3. Play Console → Nutzer und Berechtigungen → Neue Nutzer einladen → Mailadresse
   des Dienstkontos. Unter *App Berechtigungen* nur Falco hinzufügen mit:
   - Store Präsenz verwalten (Texte und Changelog)
   - Releases für Test Tracks erstellen, bearbeiten und veröffentlichen
   - Releases in der Produktion erstellen, bearbeiten und veröffentlichen
     (nur für `play_track: production`)

   Keine Kontoberechtigungen, kein Zugriff auf Finanzdaten.

### App Store Connect API Key

App Store Connect → Benutzer und Zugriff → Integrationen → App Store Connect
API → Team Keys → Key erstellen, Rolle **App Manager** (TestFlight Upload,
Metadaten, Einreichung zur Prüfung; *Developer* reicht nur für den Upload).
Die `.p8` Datei lässt sich nur einmal laden.

### Zertifikat und Profil

1. developer.apple.com → Certificates → **Apple Distribution** anlegen (CSR
   aus der Schlüsselbundverwaltung), installieren, im Schlüsselbund
   Zertifikat samt privatem Schlüssel als `.p12` mit Passwort exportieren.
2. Identifiers → App ID `de.kiefer-networks.falco` (explizit, ohne weitere
   Capabilities).
3. Profiles → **App Store Connect** Distribution Profil für diese App ID und
   das Zertifikat aus Schritt 1 → `.mobileprovision` laden.

Der Workflow liest Team ID und UUID aus dem Profil und signiert manuell
(`ios/Flutter/Signing.xcconfig` wird nur im CI geschrieben). Läuft das
Zertifikat ab (nach einem Jahr), Zertifikat und Profil erneuern und beide
Secrets ersetzen.

## Einmalig vor dem ersten Release

### Google Play

- Die Play Developer API kann keine App anlegen und keinen ersten Build
  hochladen. Gibt es Falco noch nicht in Play: App in der Play Console
  anlegen (Paketname `de.kiefer_networks.falco`), Play App Signing mit dem
  bestehenden Upload Key einrichten und das erste AAB **von Hand** in den
  internen Test hochladen (aus der GitHub Release oder lokal gebaut). Erst
  danach funktioniert der Upload aus dem Workflow.
- Solange die App im Entwurf ist, lehnt Play Releases mit Status
  `completed` ab. Dann den ersten Release von Hand abschließen.
- App Inhalte ausfüllen: Datenschutzerklärung
  `https://github.com/Kiefer-Networks/Falco/blob/main/PRIVACY.md`,
  Datensicherheit (keine Daten erhoben oder geteilt, Übertragung
  verschlüsselt), Einstufung, Zielgruppe, keine Werbung, App Zugriff
  (Prüfer brauchen einen Hetzner Cloud Token eines Test Projekts).
- Kategorie: **Tools**, Kontakt Mailadresse und Website.
- Alte Übersetzungen des Store Eintrags (fr, es, it, ru, zh) löschen; Falco 3
  ist nur Deutsch und Englisch, der Upload überschreibt nur `de-DE` und
  `en-US`.
- Screenshots hochladen (siehe unten). Der Workflow lädt keine Bilder hoch.

### App Store

- App in App Store Connect anlegen: Bundle ID `de.kiefer-networks.falco`,
  Primärsprache Deutsch oder Englisch, SKU frei wählbar.
- App Datenschutz: **Keine Daten erfasst**. Datenschutz URL wie oben.
- Altersfreigabe, Kategorie Entwicklertools / Dienstprogramme (aus
  `primary_category.txt` und `secondary_category.txt`), Kontakt und Hinweis
  für die App Prüfung inklusive Test Token.
- Exportkonformität ist über `ITSAppUsesNonExemptEncryption = false` in der
  `Info.plist` beantwortet (nur HTTPS).
- Screenshots für iPhone 6,9" und iPad 13" hochladen.
- Inhaltsrechte (App Informationen → Content Rights): **Enthält keine
  Inhalte Dritter**. Der Workflow beantwortet das zusätzlich bei jeder
  Einreichung (`submission_information` in `fastlane/Fastfile`), ohne
  Antwort lehnt App Store Connect die erste Einreichung ab.
- Preise und Verfügbarkeit: Preis **Kostenlos**, Verfügbarkeit in allen
  Ländern und Regionen. Ohne Preisstufe lässt sich keine Version zur
  Prüfung einreichen.

### Screenshots

```
flutter test --tags screenshots --run-skipped --update-goldens
```

rendert die Hauptbildschirme gegen die Fake APIs (keine echten Daten) auf
Deutsch und Englisch nach `fastlane/metadata/android/<locale>/images/`
(Smartphone 1080×1920, Tablet 1600×2560) und `fastlane/screenshots/<locale>/`
(iPhone 1290×2796, iPad 2048×2732). Beide Ordner sind git ignoriert.

## Neue Version

1. `version:` in `pubspec.yaml` erhöhen (Name und Build Nummer).
2. `fastlane/metadata/android/<locale>/changelogs/<build>.txt` und
   `fastlane/metadata/ios/<locale>/release_notes.txt` schreiben.
3. Nach dem Merge: `git tag -s v<version> -m "Falco <version>"` und
   `git push origin v<version>`.

Lokal signiert ein Release Build mit `android/key.properties` (git ignoriert,
`storeFile`, `storePassword`, `keyAlias`, `keyPassword`) oder den Variablen
`FALCO_STORE_FILE`, `FALCO_STORE_PASSWORD`, `FALCO_KEY_ALIAS`,
`FALCO_KEY_PASSWORD`. Ohne Schlüssel bricht der Release Build ab, statt mit
dem Debug Schlüssel zu signieren.

## Umstellung: `next` wird `main`

Noch nicht ausgeführt. Empfohlen vor dem Tag `v3.0.0`, damit Links auf
`main` (Datenschutzerklärung, Badges) stimmen.

1. Alle Phasen auf `next` gemerged, CI grün, Abnahme auf beiden Plattformen.
2. Pull Request `next` → `main` mit **Merge Commit** (kein Squash, die
   Historie von `next` bleibt erhalten). `next` stammt von `main` ab, der
   Kotlin Code wird dabei entfernt.

   Das Ruleset `main` erlaubt nur Squash (`allowed_merge_methods:
   ["squash"]`) und verlangt lineare Historie (`required_linear_history`),
   in den Repository Einstellungen ist „Allow merge commits“ aus. Für
   diesen einen Merge stellt der Maintainer von Hand um und danach zurück:

   1. Settings → General → Pull Requests: **Allow merge commits**
      einschalten.
   2. Settings → Rules → Rulesets → `main`: unter „Require a pull
      request before merging“ bei „Allowed merge methods“ **Merge**
      ergänzen und **Require linear history** abwählen. Speichern.
   3. Den Pull Request mit „Create a merge commit“ mergen. Der Merge
      Commit muss signiert sein (`required_signatures`): über die GitHub
      Oberfläche signiert GitHub selbst, lokal mit `git merge -S`.
   4. Sofort zurückstellen: Allowed merge methods wieder nur **Squash**,
      **Require linear history** wieder an, **Allow merge commits** aus.

   Ohne diese Umstellung ist ein Squash Merge zulässig: der Stand von
   `main` ist danach derselbe, nur die einzelnen Commits von `next`
   fehlen in der Historie von `main` (sie bleiben im Tag oder Branch
   `next` erhalten, solange er nicht gelöscht ist).
3. Auf `main` umstellen: `target-branch: next` in
   `.github/dependabot.yml` entfernen, `ci.yml` Trigger auf `main`
   beschränken, Hinweise auf `next` in Workflows und Dokumenten anpassen.
4. Rulesets und Environment `release` prüfen (Tags `v*`), dann
   `v3.0.0` auf `main` taggen.
5. `next` nach erfolgreichem Release löschen oder archivieren.
