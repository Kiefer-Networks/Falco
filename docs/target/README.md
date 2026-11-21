# Falco 3: Zielbild

Status: Entwurf zur Freigabe. Erst nach Freigabe wird gebaut.

Falco 3 ist ein Neubau in Flutter: eine Codebasis, eine Oberfläche für iOS
und Android. Der Kotlin Code (Falco 2.x) dient als Wissensquelle, nicht als
Vorlage. Dieses Dokument legt verbindlich fest, wie die App strukturiert ist,
wie sie sich bedient, wie Daten fließen und wie gebaut und ausgeliefert wird.
Abweichungen davon brauchen eine Änderung dieses Dokuments.

## 1. Ziele

- Eine App für iOS und Android mit identischem Funktionsumfang.
- Vollständige Abdeckung der öffentlichen Hetzner APIs: Cloud
  (`api.hetzner.cloud/v1`, inkl. DNS), Storage Boxen (`api.hetzner.com/v1`),
  Robot (`robot-ws.your-server.de`), Object Storage über S3.
- Genau ein Bedienmuster pro Aufgabe. Keine Sonderwege pro Bereich.
- Account und Projekt sind immer sichtbar und explizit, nie impliziter
  globaler Zustand.
- Alle Abhängigkeiten auf dem neuesten stabilen Stand, automatisch gepflegt.
- Sicherheit auf dem Niveau einer Admin App: Pinning, Keychain/Keystore,
  App Sperre, keine Geheimnisse in Logs, Zwischenablage mit Ablauf.

Nicht Ziel: F-Droid als Pflicht, Offline Bearbeitung, Web oder Desktop
(Flutter erlaubt es später, wird aber nicht mitgetestet).

## 2. Stack

Immer die neueste stabile Version zum Zeitpunkt des Baus, exakt gepinnt
(`pubspec.lock` committet), danach automatisch aktualisiert (Abschnitt 9).

| Thema | Wahl | Begründung |
|---|---|---|
| SDK | Flutter stable, Dart 3 | eine UI Engine für beide Plattformen |
| Zustand | Riverpod (Code Generation) | Scope als Parameter, testbar, kein globaler Zustand |
| Navigation | go_router mit `go_router_builder` (typisierte Routen) | Account und Projekt in jeder Route, Deep Links |
| HTTP | dio mit eigenem `HttpClientAdapter` für Pinning | einheitliche Interceptors, Abbruch, Retry Regeln |
| API Modelle | aus den offiziellen OpenAPI Specs generiert | keine handgeschriebenen DTOs, keine Feldfehler |
| Robot API | handgeschrieben (keine Spec), mit Contract Fixtures | Robot liefert Formulare und Sonderformate |
| S3 | eigener SigV4 Client auf dio | volle Kontrolle über Pinning und Standorte |
| Geheimnisse | flutter_secure_storage (Keychain / Keystore, Hardware gestützt) | plattformnativer Schutz |
| App Sperre | local_auth (Face ID, Touch ID, Fingerabdruck, Geräte PIN) | einheitlich, Fallback auf Geräte PIN |
| Einstellungen | shared_preferences (nur Unkritisches) | Geheimnisse nie hier |
| Hintergrund Transfers | background_downloader | Uploads und Downloads auf beiden Plattformen |
| Charts | fl_chart | Metriken mit mehreren Serien und Einheiten |
| Lokalisierung | gen_l10n mit ARB, Deutsch und Englisch vollständig | weitere Sprachen nur vollständig |
| Schriften | IBM Plex Sans, IBM Plex Mono (gebündelt, OFL) | Design aus dem Redesign Mockup |

## 3. Informationsarchitektur

```
Account (Name, Zugänge)
├── Cloud Projekt 1..n (API Token)
│   ├── Compute: Server, Volumes, Images, Placement Groups
│   ├── Netzwerk: Netzwerke, Floating IPs, Primary IPs, Firewalls, Load Balancer, Zertifikate
│   ├── DNS: Zonen, RRSets
│   ├── Storage Boxen (selber Token, api.hetzner.com)
│   ├── Object Storage (S3 Keys des Projekts, alle Standorte)
│   └── Aktivität (Actions aller Ressourcen)
└── Robot (Webservice Zugang): Dedicated Server, Failover, vSwitch, rDNS, SSH Keys
```

Regeln:

- **Scope** = Account + Projekt (oder Robot). Jede Ressource ist eindeutig
  über `Scope + Typ + ID` adressiert. Repositories, Routen und Caches nehmen
  den Scope als Parameter. Es gibt kein "aktives Projekt", das im Hintergrund
  gelesen wird.
- **"Alle Projekte"** ist ein eigener Scope Eintrag im Projektwechsler, keine
  Einstellung. Listen zeigen dann pro Zeile das Projekt, jede Aktion nutzt
  das Projekt des Eintrags.
- **Begriffe** sind fest: "Storage" heißt der Bereich mit Storage Boxen und
  Object Storage; "Löschen" ist das einzige Wort für endgültiges Entfernen;
  "Entfernen" nur für Zuordnungen (Volume abhängen, Server aus Netzwerk).

## 4. Navigation

- **Telefon:** Untere Navigationsleiste mit 4 Zielen: Compute, Netzwerk,
  Storage, Robot. Dazu oben rechts Suche und Aktivität.
- **Bereichsübersicht:** Jedes Ziel öffnet eine Übersicht mit einer Kachel
  pro Ressourcentyp (Symbol, Name, Anzahl, Status Zusammenfassung mit
  Statusbalken). Server und Dedicated Server zeigen in ihrer Kachel die
  ersten Zeilen (Status, Name, IP, Typ, Standort). Ein Tipp auf die Kachel
  öffnet die Liste des Typs als eigene Seite. Keine Tabs, nichts scrollt
  seitlich aus dem Bild.
- **Tablet:** Navigation Rail mit denselben Zielen, Liste und Detail
  nebeneinander.
- **Kopfzeile jedes Screens:** Account und Projekt als Wechsler
  (ein Tipp öffnet ein Sheet mit Accounts, Projekten und "Alle Projekte").
- **Routen** sind typisiert und tragen den Scope:
  `/a/:accountId/p/:projectId/servers/:serverId`. Damit funktionieren Zurück,
  Deep Links, Suche und Wiederherstellung nach Prozessende ohne Tricks.
- Beim Wechsel des Accounts bleibt der Bereich erhalten, die Inhalte laden
  für den neuen Scope; Detailseiten eines anderen Scopes werden geschlossen.
- DNS ist Teil von Netzwerk, Einstellungen, Accounts und Über erreicht man
  über das Profil Symbol in der Kopfzeile.

## 5. Bedienmuster (verbindlicher Katalog)

| Aufgabe | Genau ein Muster |
|---|---|
| Liste | Kopfzeile mit Titel und Anzahl, Suche und Filter Chips, Sortierung im Menü, Pull to Refresh, kompakte Zeilen (Status, Name, Mono Zeile) |
| Übersicht | `AreaOverview`: Kacheln pro Ressourcentyp mit Anzahl und Status, Tipp öffnet die Liste; lädt nichts, ist der Hinweis "Nicht verfügbar" an der Kachel, lädt gar nichts, steht die Fehlerkarte darüber |
| Leer | `EmptyHint`: Symbol und ein Satz, nie ein Knopf. Angelegt wird über den FAB des Screens |
| Blockiert | `ActionHint`: ein Satz und genau ein Knopf, nur wenn der ganze Screen ohne diese Handlung nicht weitergeht (Entsperren, fehlender Robot Zugang, fehlende S3 Schlüssel); nie für leere Listen |
| Fehler | Fehlerkarte mit Ursache in Klartext und "Erneut versuchen"; bei vorhandenen Daten bleiben diese sichtbar, Fehler als Banner |
| Laden | Skeleton Zeilen beim ersten Laden, danach nur Fortschrittsbalken |
| Detail | Kopf (Status, Name, Mono Kennungen) → Abschnitte (Übersicht, Metriken, Netzwerk, Einstellungen, Aktivität) → Gefahrenzone ganz unten im Inhalt. Alle Aktionen der Ressource in der Aktionsleiste unten (`DetailActionBar`) |
| Aktionen im Detail | Aktionsleiste am unteren Rand, in Daumenreichweite: höchstens drei Aktionen als Knopf mit vollem Text (bricht um, wird nie abgeschnitten), alle weiteren im Blatt "Mehr". Kein Mehr Menü in der Kopfzeile einer Detailseite, keine Aktionsknöpfe im Inhalt außer der Gefahrenzone |
| Weitere Aktionen sonst | Screens ohne Detail (Objekt Browser, Liste einer Zeile) nutzen ein "Mehr" Menü in der Kopfzeile bzw. an der Zeile; nie doppelt |
| Anlegen | Genau ein Einstieg pro Screen: der FAB unten rechts auf der Liste des Typs ("+ Server erstellen"). Er öffnet immer einen Vollbild Wizard (Schritte, Zusammenfassung, Erstellen), Projekt Schritt nur wenn Scope "Alle Projekte". Übersicht und Leer Hinweis haben keinen Anlegen Knopf |
| Bearbeiten | Bottom Sheet mit Formular und Speichern |
| Bestätigen | Stufe 1: Sheet mit Titel, Folgen, primärer Aktion (Neustart, Ausschalten, Abhängen, Schutz ändern). Stufe 2: zusätzlich Namen eintippen (Löschen, Neuaufsetzen, Daten überschreiben). Die Regel steht im Code, nicht pro Screen |
| Rückmeldung | Eine Snackbar pro Screen; laufende Hetzner Actions zusätzlich als Fortschritt am Objekt und in der Aktivität |
| Status | Eine Komponente: Punkt oder Ring plus Wort, Farben aus Tokens |
| Werte | Eine Formatierung für Bytes, Datum (relativ und absolut), Geld, IPs (Mono, kopierbar per Tipp) |
| Geheimnisse | Ein Reveal Sheet: anzeigen, kopieren (Ablauf 60 s, als sensibel markiert), nie in Zustand oder Logs |

Jedes Muster existiert genau einmal als Komponente im Design System
(`lib/ui/`). Screens setzen nur Komponenten zusammen.

## 6. Datenarchitektur

```
UI (Widgets) → Controller (Riverpod Notifier pro Screen, Scope als Parameter)
            → Repository (pro Ressource und Scope, Cache als Stream)
            → API Client (generiert, dio, Pinning, Fehler Mapping)
                         ↘ Action Tracker (verfolgt Hetzner Actions, aktualisiert betroffene Ressourcen)
```

- **Einzige Datenquelle:** Repositories halten den Zustand pro Scope; alle
  Screens beobachten ihn. Eine Aktion aktualisiert den Cache gezielt, keine
  Liste lädt "auf Verdacht" neu, kein Screen lädt doppelt.
- **Action Tracker:** jede mutierende Anfrage liefert eine Action; der Tracker
  fragt sie ab, meldet Fortschritt und Fehler und invalidiert die Ressourcen
  aus `action.resources`. Die Aktivitätsansicht liest denselben Tracker.
- **Pagination** zentral im API Client, nie im Screen.
- **Fehlermodell:** typisiert (`Unauthorized`, `Forbidden`, `NotFound`,
  `Conflict`, `RateLimited(retryAfter)`, `Invalid(fields)`, `Network`,
  `PinningFailed`, `Locked` (Tresor zu, Prüfung abgebrochen),
  `Server`), Mapping aus Hetzner Fehlercodes, Texte nur in der UI über l10n.
- **Contract Tests:** generierte Modelle gegen die aktuellen Specs, plus
  Fixtures für Robot und S3; laufen in jeder CI.

## 7. Sicherheit

- Zertifikats Pinning pro Host (Intermediates und Roots), automatisch
  aktualisiert (Abschnitt 9). Ein fehlschlagender Pin zeigt einen
  verständlichen Fehler, nie einen stillen Fallback.
- Tokens und Keys nur in Keychain/Keystore, Zugriff nur nach Entsperren;
  App Sperre beim Start und nach Hintergrundzeit (einstellbar). Solange
  kein Account gespeichert ist, gibt es nichts zu schützen: der erste Start
  fragt nicht nach Biometrie oder PIN. Das erste Geheimnis schreibt die
  Plattform mit ihrer eigenen Prüfung in den gebundenen Speicher, ab dann
  sperrt jeder Start.
- Bildschirmschutz in den Apps Übersichten, keine Screenshots von Geheimnissen.
- Keine Analyse, kein Tracking, keine Drittanbieter Dienste.
- Logs ohne Header, Bodies und Tokens; Release Builds ohne Debug Logging.

## 8. Qualität

- Tests: Unit (Repositories, Tracker, Formatierung), Widget und Golden Tests
  für jede Design System Komponente in Hell und Dunkel, Integration Tests
  der Kernabläufe auf Android Emulator und iOS Simulator.
- `flutter analyze` mit strengen Lints, Formatierung als Pflicht.
- Jeder Bereich wird vor dem Merge auf beiden Plattformen ausgeführt.

## 9. CI, Pflege und Releases

| Workflow | Auslöser | Inhalt |
|---|---|---|
| `ci.yml` | PR, main | format, analyze, Unit und Widget Tests, Contract Tests, Android Build, iOS Build ohne Signatur (macOS Runner) |
| `integration.yml` | PR mit Label, nightly | Integration Tests auf Android Emulator und iOS Simulator |
| `pins.yml` | wöchentlich und manuell | holt die Zertifikatsketten aller Hosts, berechnet SPKI Pins, öffnet bei Änderung einen PR mit Diff der Ketten |
| `specs.yml` | wöchentlich | lädt die Hetzner OpenAPI Specs, generiert die Modelle neu, öffnet bei Änderung einen PR mit Changelog Auszug |
| `flutter-sdk.yml` | wöchentlich | prüft die neueste stabile Flutter Version, aktualisiert `.fvmrc`/CI Version, öffnet PR |
| Dependabot | wöchentlich | pub, GitHub Actions, Gradle, Bundler/CocoaPods; Minor/Patch automatisch nach grüner CI, Major manuell |
| `release.yml` | signierter Tag `v*` | Android: signiertes AAB und APK, GitHub Release, Provenance, optional Play Store; iOS: signiertes IPA, Upload zu TestFlight, optional App Store Review |

Die bestehenden Härtungen bleiben: Actions per SHA, minimale Rechte,
zizmor, Dependency Review, Rulesets, signierte Commits und Tags,
Geheimnisse nur in der Environment `release`. Einrichtung und Ablauf des
Releases: [RELEASE.md](RELEASE.md).

## 10. Repository und Migration

- Der Neubau entsteht im selben Repository auf dem Branch `next`, als
  Flutter Projekt im Wurzelverzeichnis. Die Kotlin App bleibt bis zur
  Funktionsgleichheit auf `main`.
- Android Paketname `de.kiefer_networks.falco` und Signaturschlüssel bleiben,
  damit bestehende Installationen das Update erhalten. Gespeicherte
  Zugangsdaten werden nicht migriert (anderer Speicher); die App führt beim
  ersten Start durch das erneute Hinzufügen.
- Reihenfolge: Fundament (Scope, API, Tracker, Fehler, Design System) →
  Compute → Netzwerk und DNS → Storage → Robot → Suche und Aktivität →
  Feinschliff → Release 3.0.

## 11. Voraussetzungen

| Was | Wer |
|---|---|
| Xcode (aktuell) mit iOS Simulator, Flutter SDK, JDK lokal | Malte installiert, oder ich nach Freigabe per Homebrew (Flutter, JDK) |
| Apple Developer Account, Bundle ID, App Store Connect API Key | Malte |
| iOS Signing (Zertifikat, Profil) als Secrets in Environment `release` | Malte legt an, ich verdrahte |
| macOS Runner Minuten auf GitHub | öffentliches Repo: kostenlos |

## 12. Offene Entscheidungen

1. App Store und Play Store Veröffentlichung, oder zunächst nur GitHub
   Releases und TestFlight?
2. Bundle ID für iOS (Vorschlag `de.kiefer-networks.falco`).
3. Sollen Zugangsdaten aus Falco 2 einmalig per Export übernommen werden
   können (verschlüsselte Datei), oder reicht Neu Einrichtung?
