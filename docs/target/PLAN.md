# Falco 3: Umsetzungsplan

Grundlage ist [README.md](README.md) (Zielbild). Jede Phase endet mit einem
PR auf `next`, grüner CI und einem Lauf auf Android Emulator und iOS
Simulator. Eine Phase beginnt erst, wenn die vorherige gemergt ist.

## Projektstruktur

```
lib/
  main.dart                      App Start, Sperre, Theme, Router
  app/                           Router (typisierte Routen), Shell, Scope Wechsler
  core/
    scope/                       Account, Project, Scope, ScopeRepository
    http/                        dio Fabrik, Pinning Adapter, Interceptors, Fehler Mapping
    pins/pins.g.dart             generiert von CI (pins.yml)
    errors/                      FalcoError Hierarchie
    actions/                     ActionTracker
    secure/                      SecretStore (Keychain/Keystore), AppLock
    format/                      Bytes, Datum, Geld, IP
  api/
    cloud/                       generiert aus cloud.spec.json
    storage_box/                 generiert aus hetzner.spec.json
    robot/                       handgeschrieben + Fixtures
    s3/                          SigV4 Client
  data/<bereich>/                Repositories pro Ressource (Scope als Parameter)
  features/<bereich>/            Screens und Controller
  ui/                            Design System (Tokens, Komponenten)
  l10n/                          app_de.arb, app_en.arb
test/  integration_test/  tool/  (Spec Download, Pin Berechnung, Codegen)
```

## Design System (Phase 1, vor jedem Screen)

Tokens (Farben Dunkel/Hell/OLED, Akzente, Typo Plex Sans/Mono, Abstände,
Radien) und genau diese Komponenten, jede mit Golden Test in Hell und Dunkel:

| Komponente | Zweck |
|---|---|
| `FalcoScaffold` | Kopfzeile mit Scope Wechsler, Mehr Menü, Snackbar Host |
| `ResourceList` | Liste mit Suche, Filter Chips, Sortierung, Pull to Refresh, Skeleton, Leer, Fehler |
| `ResourceRow` | Status, Name, Mono Zeile, optionale Sparkline |
| `AreaOverview` | Bereichsübersicht: Kachel pro Ressourcentyp mit Anzahl und Status |
| `DetailPage` | Kopf, Abschnitte, Gefahrenzone |
| `DetailActionBar` | alle Aktionen eines Details unten: drei Knöpfe plus Blatt "Mehr" |
| `MoreMenu` | weitere Aktionen von Screens ohne Detail |
| `CreateWizard` | Schritte, Zusammenfassung, Projekt Schritt bei "Alle Projekte" |
| `EditSheet` | Bearbeiten als Bottom Sheet |
| `ConfirmSheet` | Stufe 1 und Stufe 2 (Name eintippen) |
| `StatusBadge` | Punkt/Ring plus Wort |
| `Mono`, `CopyableValue` | IPs, IDs, kopieren per Tipp |
| `SecretReveal` | Passwörter anzeigen und kopieren mit Ablauf |
| `MetricChart` | mehrere Serien, Einheiten, Zeitraum |
| `ErrorCard`, `EmptyHint`, `ActionHint`, `ErrorBanner` | Zustände (leer ohne Knopf, blockiert mit genau einem) |
| `ScopeSwitcherSheet` | Accounts, Projekte, "Alle Projekte" |

## Absicherung: Funktionsgleichstand und Optik

Drei Mechanismen stellen sicher, dass Falco 3 alles kann, was Falco 2 kann,
und so aussieht wie vereinbart:

1. **Funktionsinventar [PARITY.md](PARITY.md).** Aus dem Kotlin Code und den
   API Specs abgeleitet: jeder Screen, jede Aktion, jedes angezeigte Feld,
   jede Validierungsregel, jeder API Endpunkt, dazu die Lücken der alten App.
   Jede Zeile hat eine ID, eine Phase und eine Testart. Eine Phase ist erst
   fertig, wenn alle ihre Zeilen abgehakt und durch den genannten Test belegt
   sind. Neue Ideen kommen als neue Zeile dazu, nie stillschweigend.
2. **Design vor Code, pro Bereich.** Bevor ein Bereich gebaut wird, entstehen
   seine Screens im Mockup (Liste, Detail, Anlegen, Bearbeiten, Bestätigen,
   Leer, Fehler, Hell und Dunkel). Du gibst sie frei. Golden Tests prüfen
   danach jeden Screen gegen diese Freigabe.
3. **Referenz der alten App.** Falco 2 läuft auf Emulator und Simulator; von
   jedem Screen entsteht ein Screenshot als Funktionsreferenz in
   `docs/target/reference/`. So ist sichtbar, was gezeigt wurde, auch wenn es
   neu angeordnet wird.

## Vertikaler Durchstich zuerst

Vor der Breite kommt ein vollständiger Durchstich: Account anlegen,
Cloud Projekt hinzufügen, Serverliste, Server Detail mit Metriken,
Neustart mit Rückfrage, Fortschritt über den Action Tracker, Aktivität.
Echte API, alle Schichten, beide Plattformen, Hell und Dunkel. Du testest
ihn auf deinem Gerät. Erst wenn Optik, Bedienung und Architektur daran
abgenommen sind, wird die Breite gebaut. Fehler im Fundament fallen so nach
Wochen auf, nicht nach Monaten.

## Abnahme jeder Phase

- Alle PARITY Zeilen der Phase abgehakt, jeweils mit Testnachweis.
- Golden Tests grün gegen die freigegebenen Mockups.
- Integration Tests der Phase grün auf Android Emulator und iOS Simulator.
- Build zum Ausprobieren (Android APK, iOS TestFlight intern) für dich,
  deine Freigabe ist Teil der Abnahme.

## Phasen

| # | Inhalt | Fertig wenn |
|---|---|---|
| 0 | Repo Gerüst auf `next`: Flutter Projekt, Lints, CI (`ci.yml`, iOS Build ohne Signatur), Dependabot, `flutter-sdk.yml`; Referenz Screenshots von Falco 2 | CI grün auf beiden Plattformen, leere App startet, Referenzen abgelegt |
| 1 | Design System und Theme, Golden Tests, Showcase Screen | alle Komponenten mit Goldens, Review durch dich |
| 2 | Fundament: Scope Modell, SecretStore, AppLock, HTTP mit Pinning, `pins.yml`, Fehlermodell, ActionTracker, Pagination, Codegen aus Specs, `specs.yml`, Contract Tests | Unit Tests grün, Pin PR einmal automatisch erzeugt |
| 2b | Vertikaler Durchstich (siehe oben) | von dir auf Android und iOS abgenommen |
| 3 | Onboarding und Accounts: Account anlegen, Cloud Projekte, Robot Zugang, S3 Keys, Scope Wechsler, Sperre, Einstellungen, Über | Account mit 2 Projekten anlegen und wechseln auf beiden Plattformen |
| 4 | Compute: Server (Liste, Detail, Anlegen, Power, Rebuild, Rescue, ISO, Typ, Backups, Konsole, Metriken, Schutz, Löschen), Volumes, Images (Snapshots und Backups verwalten), Placement Groups | Abläufe "Server anlegen, neu starten, löschen" als Integration Test |
| 5 | Netzwerk: Netzwerke (Subnetze, Routen, vSwitch, Mitglieder), Firewalls, Floating IPs, Primary IPs (inkl. rDNS, Umbenennen), Load Balancer, Zertifikate, DNS (Zonen, RRSets, Schutz, Import/Export) | jeder Ressourcentyp: Liste, Detail, Anlegen, Bearbeiten, Löschen |
| 6 | Storage: Storage Boxen vollständig (Umbenennen, Labels, Schutz, Typ, Snapshot Pläne, Ordner, Snapshots, Subaccounts inkl. Home und Rechte, Löschen), Object Storage (alle Standorte, Buckets, Browser, Upload/Download im Hintergrund, Freigaben, Versionierung) | Upload im Hintergrund auf beiden Plattformen |
| 7 | Robot: Server, Reset, Rescue (Keys aus Robot), WoL, Kündigung mit Reservierung, rDNS, Failover, vSwitch, SSH Keys, Traffic | Robot Abläufe gegen Fixtures getestet |
| 8 | Suche über alle Ressourcen und Scopes, Aktivität pro Projekt und Ressource | jeder Treffer öffnet ein Ziel |
| 9 | Feinschliff: Tablet Layout (Liste und Detail), Barrierefreiheit (Screenreader, Kontraste, Schriftgrößen), Leistung, Übersetzungen vollständig | Prüfliste erfüllt |
| 10 | Release: `release.yml` (Android signiert, iOS TestFlight), Store Einträge, Version 3.0.0, `next` wird `main` | erster Release auf beiden Plattformen |

## CI Details

- **`ci.yml`:** `flutter pub get`, `dart format --set-exit-if-changed`,
  `flutter analyze`, `flutter test` (Unit, Widget, Golden, Contract),
  `flutter build appbundle` (Debug Signatur), `flutter build ios --no-codesign`
  auf `macos-latest`. Caches für pub und Gradle, nur von `main` beschrieben.
- **`pins.yml`:** Skript `tool/pins.dart` verbindet sich mit jedem Host
  (`api.hetzner.cloud`, `api.hetzner.com`, `robot-ws.your-server.de`,
  `fsn1|nbg1|hel1.your-objectstorage.com`), berechnet SPKI SHA 256 von
  Intermediate und Root, schreibt `lib/core/pins/pins.g.dart`. Bei Änderung
  PR mit Kettenübersicht; der alte Pin bleibt eine Release lang als Überlappung.
- **`specs.yml`:** lädt `docs.hetzner.cloud/cloud.spec.json` und
  `hetzner.spec.json`, generiert `lib/api/*` neu, Contract Tests laufen im PR.
- **`flutter-sdk.yml`:** vergleicht `.fvmrc`/Workflow Version mit der neuesten
  stabilen Flutter Version, öffnet PR.
- **Dependabot:** `pub`, `github-actions`, `gradle`, `bundler` (fastlane),
  7 Tage Cooldown, Gruppen, Minor/Patch automatisch.
- **`release.yml`:** Tag `v*` (signiert, Ruleset), Environment `release`:
  Android Keystore aus Secrets, AAB und APK, SHA256SUMS, Provenance,
  GitHub Release; iOS: Zertifikat und Profil aus Secrets in einen temporären
  Keychain, `flutter build ipa`, Upload zu TestFlight per App Store Connect
  API Key. Alles ohne Drittanbieter Actions wo möglich.

## Risiken

| Risiko | Gegenmaßnahme |
|---|---|
| Hetzner ändert APIs (wie DNS 2025, `datacenter` 2026) | `specs.yml` und Contract Tests melden es wöchentlich |
| Zertifikatswechsel bricht Pinning | `pins.yml` mit Überlappung, verständliche Fehlermeldung |
| iOS Hintergrund Transfers begrenzt | background_downloader nutzt `URLSession` Hintergrund Sessions; lange Uploads in Teilen |
| Robot ohne Spec | Fixtures aus der Doku, Tests pro Endpunkt |
| Umfang | Phasen strikt nacheinander, jede abnehmbar |
