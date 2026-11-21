# Falco 3: Paritätsinventar

Status: Abnahmeliste für den Neubau. Grundlage: [README.md](README.md) (Zielbild) und [PLAN.md](PLAN.md) (Phasen). Erzeugt aus dem Kotlin Code von Falco 2.5 (Branch `docs/flutter-target`), den offiziellen Specs `cloud.spec.json` und `hetzner.spec.json` sowie der Robot Webservice Doku.

## Benutzung als Abnahmeliste

1. Jede Zeile ist eine prüfbare Anforderung. Eine Phase ist erst abgenommen, wenn alle Zeilen mit ihrer Phasennummer erfüllt und durch den genannten Test abgedeckt sind.
2. Der Test trägt die ID im Namen (z. B. `test('CMP-012 ...')`), damit `grep` die Abdeckung zeigt. Fehlt ein Test zur ID, gilt die Zeile als offen. `dart run tool/parity_check.dart` prüft das in jeder CI; eine Zeile ohne Test steht nur mit Grund im Abschnitt [Zurückgestellt](#zurückgestellt).
3. **Quelle** zeigt die Stelle im alten Code (Pfade relativ zu `app/src/main/kotlin/de/kiefer_networks/falco/`, `S/` = `ui/screens/`, `C/` = `ui/components/`, `D/` = `data/`). "API neu" heißt: die alte App kann das nicht, die API bietet es, der Neubau liefert es. "Alt nur Repository" heißt: Code existiert, aber keine Oberfläche.
4. **API Endpunkt(e)**: Cloud Pfade relativ zu `https://api.hetzner.cloud/v1`, Storage Boxen zu `https://api.hetzner.com/v1`, Robot zu `https://robot-ws.your-server.de`, S3 als Operationsname.
5. Regeln aus der alten App (Grenzen, Pflichtfelder) gelten weiter, außer sie stehen unter [Nicht übernehmen](#nicht-übernehmen). Bedienmuster (Bestätigungsstufen, Wizard, Edit Sheet) richten sich immer nach README Abschnitt 5, nicht nach der alten Umsetzung.
6. Abhaken: Spalte in einer Kopie dieser Datei oder im PR der Phase mit Liste der IDs.

## Zählung

| Bereich | Präfix | Zeilen | davon neu oder ohne alte UI |
|---|---|---|---|
| Onboarding & Accounts | ONB | 42 | 0 |
| Einstellungen & Sicherheit | SET | 23 | 1 |
| Compute | CMP | 99 | 20 |
| Netzwerk | NET | 94 | 18 |
| DNS | DNS | 31 | 10 |
| Storage Boxen | STB | 37 | 16 |
| Object Storage | OBJ | 25 | 6 |
| Robot | ROB | 60 | 24 |
| Suche & Aktivität | SUC | 40 | 28 |
| Querschnitt | QRS | 30 | 0 |
| **Summe** | | **481** | **123** |

Zusätzlich: 181 Endpunkte der alten App im Abschnitt [Endpunkt Zuordnung](#endpunkt-zuordnung-alte-app) und die Liste [Nicht übernehmen](#nicht-übernehmen) (Präfix BUG).


## Onboarding & Accounts

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| ONB-001 | Onboarding Seitenfolge | 4 Seiten: Sprache, Was Falco kann, Sicherheit, Start; Punkte Indikator | `S/welcome/OnboardingScreen.kt:49` |  | 3 | Widget |
| ONB-002 | Onboarding Navigation | Weiter, Zurück, Überspringen; letzte Seite "Account hinzufügen" | `S/welcome/OnboardingScreen.kt:102` |  | 3 | Widget |
| ONB-003 | Onboarding Sprachwahl | Sprache wählen, sofort angewendet, später in Einstellungen änderbar | `S/welcome/OnboardingViewModel.kt:22` |  | 3 | Widget |
| ONB-004 | Onboarding Funktionsseite | Kurzbeschreibung Cloud, Robot, DNS, Object Storage | `S/welcome/OnboardingScreen.kt:149` |  | 3 | Golden |
| ONB-005 | Onboarding Sicherheitsseite | Hinweise Keystore Verschlüsselung, Entsperren beim Start, TLS 1.3 und Pinning; Text für iOS (Keychain, Face ID) anpassen | `S/welcome/OnboardingScreen.kt:163` |  | 3 | Golden |
| ONB-006 | Onboarding nur beim ersten Start | Ohne Account landet die App im Onboarding; mit Account in der Shell | `ui/nav/AccountLanding.kt` |  | 3 | Integration |
| ONB-007 | Account Wizard Schrittanzeige | Titel "Schritt n von m", Schritte dynamisch nach gewählten Diensten | `S/accounts/AccountWizardViewModel.kt:69` |  | 3 | Widget |
| ONB-008 | Wizard Schritt Name | Pflicht, nicht leer, max. 64 Zeichen | `S/accounts/AccountWizardViewModel.kt:80` |  | 3 | Unit |
| ONB-009 | Wizard Schritt Dienste | Mindestens ein Dienst (Cloud, Robot); Fehlerhinweis "Pick at least one service" | `S/accounts/AccountWizardScreen.kt:258` |  | 3 | Widget |
| ONB-010 | Wizard Cloud Projekte | Mehrere Projekte pro Account; Projekt hinzufügen und entfernen | `S/accounts/AccountWizardViewModel.kt:113` |  | 3 | Unit |
| ONB-011 | Wizard Cloud Projekt Felder | Projektname und API Token Pflicht | `S/accounts/AccountWizardViewModel.kt:87` |  | 3 | Unit |
| ONB-012 | Wizard S3 pro Projekt | Optional: Endpoint, Access Key, Secret Key Pflicht wenn aktiviert; Region optional | `S/accounts/AccountWizardScreen.kt:361` |  | 3 | Unit |
| ONB-013 | Wizard Link Cloud Console | Öffnet Hetzner Cloud Console im Browser zum Token anlegen | `S/accounts/AccountWizardScreen.kt:302` |  | 3 | Widget |
| ONB-014 | Wizard Robot Zugang | Webservice Benutzer und Passwort Pflicht | `S/accounts/AccountWizardViewModel.kt:98` |  | 3 | Unit |
| ONB-015 | Wizard Link Robot Einstellungen | Öffnet Robot Webservice Einstellungen im Browser | `S/accounts/AccountWizardScreen.kt:407` |  | 3 | Widget |
| ONB-016 | Wizard Übersicht | Zeigt Name, Projekte mit Token maskiert, S3 Daten, Robot Benutzer | `S/accounts/AccountWizardScreen.kt:416` |  | 3 | Golden |
| ONB-017 | Wizard Zugangsprüfung | Probe aller Zugänge vor dem Speichern; "Credentials valid" oder Fehlertext bereinigt | `S/accounts/AccountWizardViewModel.kt:159`<br>`D/auth/AccountManager.kt:89` | `GET /servers`<br>`GET /server (Robot)`<br>`S3 ListBuckets` | 3 | Unit |
| ONB-018 | Wizard Speichern | Speichert Account, Projekte, Geheimnisse; doppelte Ausführung gesperrt | `S/accounts/AccountWizardViewModel.kt:140` |  | 3 | Unit |
| ONB-019 | Wizard Fertig Seite | "All set", Account ist nutzbar | `S/accounts/AccountWizardScreen.kt:573` |  | 3 | Widget |
| ONB-020 | Wizard Zurück und Sprung | Zurück und direkter Sprung zu einem Schritt aus der Übersicht | `S/accounts/AccountWizardViewModel.kt:129` |  | 3 | Unit |
| ONB-021 | Accountliste | Alle Accounts mit Name, Beschreibung | `S/accounts/AccountsScreen.kt:76` |  | 3 | Golden |
| ONB-022 | Accountzeile Dienst Badges | Cloud (Anzahl Projekte), Robot | `S/accounts/AccountsScreen.kt:174` |  | 3 | Golden |
| ONB-023 | Accountzeile Aktiv und Standard | Badges "Active" und "Default" | `S/accounts/AccountsScreen.kt:205` |  | 3 | Golden |
| ONB-024 | Account hinzufügen | FAB öffnet Wizard | `S/accounts/AccountsScreen.kt:118` |  | 3 | Widget |
| ONB-025 | Account entfernen | Bestätigung, löscht alle Geheimnisse des Accounts | `S/accounts/AccountsScreen.kt:127`<br>`S/accounts/AccountsViewModel.kt:53` |  | 3 | Unit |
| ONB-026 | Account bearbeiten | Name und Beschreibung im Sheet | `S/accounts/AccountsScreen.kt:249` |  | 3 | Widget |
| ONB-027 | Standard Account setzen | Account wird beim Start gewählt | `S/accounts/AccountsScreen.kt:278`<br>`S/accounts/AccountsViewModel.kt:61` |  | 3 | Unit |
| ONB-028 | Aktiven Account wechseln | Über Accountliste und Navigationsleiste | `S/accounts/AccountsViewModel.kt:57`<br>`ui/FalcoRootViewModel.kt:53` |  | 3 | Integration |
| ONB-029 | Projekte verwalten | Liste der Cloud Projekte eines Accounts | `S/cloud/ProjectManageScreen.kt:60` |  | 3 | Golden |
| ONB-030 | Projekt anlegen | Name, Token, optional S3 Endpoint, Region, Access und Secret Key | `S/cloud/ProjectFormScreen.kt:108`<br>`S/cloud/ProjectsViewModel.kt:79` |  | 3 | Widget |
| ONB-031 | Projekt bearbeiten | Gleiches Formular, Geheimnisse nicht im Klartext vorbefüllt | `S/cloud/ProjectManageScreen.kt:160`<br>`S/cloud/ProjectsViewModel.kt:87` |  | 3 | Widget |
| ONB-032 | Projekt Formular Validierung | Speichern nur wenn Name und Token gesetzt und S3 vollständig falls aktiv | `S/cloud/ProjectFormScreen.kt:183` |  | 3 | Unit |
| ONB-033 | Projekt entfernen | Bestätigung "Remove project and its S3 credentials?" | `S/cloud/ProjectManageScreen.kt:104`<br>`S/cloud/ProjectsViewModel.kt:95` |  | 3 | Unit |
| ONB-034 | Projektwechsler Sheet | Projekte, "All projects", Neues Projekt, Projekte verwalten | `S/cloud/ProjectPickerSheet.kt:47`<br>`S/cloud/CloudHubScreen.kt:148` |  | 3 | Widget |
| ONB-035 | Aktives Projekt setzen | Wechsel lädt Listen neu | `S/cloud/ProjectsViewModel.kt:47` |  | 3 | Unit |
| ONB-036 | Projekt wählen dann öffnen | Aus Suche und Aggregat: erst Projekt setzen, dann Detail öffnen; im Neubau über Scope in der Route | `S/cloud/ProjectsViewModel.kt:62` |  | 3 | Unit |
| ONB-037 | Projekt Auswahl beim Anlegen | Bei "Alle Projekte" fragt ein Dialog, in welches Projekt angelegt wird; im Neubau Wizard Schritt | `C/dialog/ProjectChooserDialog.kt:42` |  | 3 | Widget |
| ONB-038 | S3 Endpoint Prüfung | Nur fsn1, hel1, nbg1 .your-objectstorage.com; nur https; kein Pfad | `D/api/S3Client.kt:38` |  | 3 | Unit |
| ONB-039 | Account Probe Robot | Robot Zugang wird mit Serverliste geprüft, 401 klar gemeldet | `D/auth/AccountManager.kt:89` | `GET /server` | 3 | Unit |
| ONB-040 | Über Screen | Website, Spenden, Quellcode, Kiefer Networks, Lizenz GPL-3.0-or-later | `S/about/AboutScreen.kt:120` |  | 3 | Golden |
| ONB-041 | Versionsanzeige | Version in Einstellungen und Über | `S/settings/SettingsScreen.kt:221` |  | 3 | Widget |
| ONB-042 | Leerzustand ohne Account | "No accounts yet" mit Aktion "Add account" in Navigation und Einstellungen | `ui/nav/NavShell.kt:382` |  | 3 | Widget |

## Einstellungen & Sicherheit

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| SET-001 | Einstellungen Übersicht | Abschnitte Allgemein (Darstellung, Sprache), Cloud, Sicherheit, Über | `S/settings/SettingsScreen.kt:172` |  | 3 | Golden |
| SET-002 | Theme Modus | System, Hell, Dunkel, OLED Schwarz | `S/settings/SettingsScreen.kt:322`<br>`D/auth/SecurityPreferences.kt:147` |  | 3 | Golden |
| SET-003 | Akzentfarbe | Rot, Blau, Grün, Lila, Orange, Bernstein; wirkt auf Buttons, Chips, Status | `S/settings/SettingsScreen.kt:340`<br>`D/auth/SecurityPreferences.kt:152` |  | 3 | Golden |
| SET-004 | App Sprache | Sprachwahl in App, unabhängig vom System | `S/settings/SettingsScreen.kt:391`<br>`D/auth/SecurityPreferences.kt:71` |  | 3 | Widget |
| SET-005 | Sprachumfang | Alt: de, en, es, fr, it, ru, zh-CN; Neu laut Zielbild nur vollständige Sprachen (de, en Pflicht) | `res/values-*/strings.xml` |  | 9 | Unit |
| SET-006 | Alle Projekte kombinieren | Alt Schalter in Einstellungen; Neu als Scope "Alle Projekte" im Wechsler, kein Schalter | `S/settings/SettingsScreen.kt:195`<br>`D/auth/SecurityPreferences.kt:106` |  | 3 | Integration |
| SET-007 | Entsperren beim Start | Kaltstart verlangt Biometrie oder Geräte PIN (Standard an) | `S/settings/SettingsScreen.kt:242`<br>`MainActivity.kt:92` |  | 3 | Integration |
| SET-008 | Auto Sperre Zeit | Sofort, 30 s, 1 min, 5 min, 15 min; Standard 60 s; Höchstwert 900 s erzwungen | `S/settings/SettingsScreen.kt:250`<br>`D/auth/SecurityPreferences.kt:143` |  | 3 | Unit |
| SET-009 | Auto Sperre Begrenzung | Ungültige oder alte Werte (z. B. -1) auf Standard, größer 900 auf 900 | `D/auth/SecurityPreferences.kt:37` |  | 3 | Unit |
| SET-010 | Sperre beim Zurückkehren | Nach Hintergrundzeit größer Timeout erneut entsperren | `MainActivity.kt:60` |  | 3 | Integration |
| SET-011 | Sperrbildschirm | Inhalt verdeckt bis entsperrt, Zustand nie persistiert | `MainActivity.kt:86` |  | 3 | Golden |
| SET-012 | Biometrie nicht verfügbar | Eigener Screen mit Hinweis, wenn keine Biometrie oder PIN eingerichtet | `MainActivity.kt:82` |  | 3 | Widget |
| SET-013 | Biometrie Sonderfall alte Android Versionen | API 28 und 29 Sonderbehandlung; im Neubau local_auth mit Geräte PIN Fallback | `D/auth/BiometricGate.kt:37` |  | 3 | Unit |
| SET-014 | Screenshots blockieren | FLAG_SECURE Standard an, abschaltbar; iOS: Inhalt im App Switcher verdecken | `S/settings/SettingsScreen.kt:282`<br>`MainActivity.kt:54` |  | 3 | Integration |
| SET-015 | Hardware gebundene Geheimnisse | Schlüssel nur nach frischer Entsperrung nutzbar (höhere Sicherheitsstufe) | `S/settings/SettingsScreen.kt:290`<br>`D/auth/SecurityPreferences.kt:130` |  | 3 | Unit |
| SET-016 | TLS Pinning Info | Anzeige, dass Pinning für alle Hetzner Endpunkte aktiv ist | `S/settings/SettingsScreen.kt:302` |  | 3 | Widget |
| SET-017 | Geheimnisspeicher | AEAD (Tink) mit Keystore Master Key; Neu: flutter_secure_storage Keychain/Keystore | `D/auth/CredentialStore.kt:257` |  | 2 | Unit |
| SET-018 | Geheimnisfelder pro Account | Cloud Token pro Projekt, S3 Endpoint, Region, Keys, Robot Benutzer und Passwort | `D/auth/AccountManager.kt:200` |  | 2 | Unit |
| SET-019 | Zwischenablage mit Ablauf | Kopierte Geheimnisse nach 60 s löschen | `ui/util/Clipboard.kt:23` |  | 2 | Unit |
| SET-020 | Zwischenablage sensibel markieren | Als sensibel markieren; Hinweis wenn System das nicht kann | `C/dialog/SecureRevealDialog.kt:50` |  | 2 | Widget |
| SET-021 | Geheimnis anzeigen Sheet | Einmalige Anzeige von Passwörtern mit Kopieren und Schließen | `C/dialog/SecureRevealDialog.kt:77` |  | 2 | Widget |
| SET-022 | Fehlertexte bereinigt | Keine Tokens oder URLs mit Geheimnissen in Fehlermeldungen | `D/util/Errors.kt:20` |  | 2 | Unit |
| SET-023 | Kein Entsperren vor dem ersten Account | Solange kein Account gespeichert ist, fragt der Start nicht nach Biometrie oder PIN; danach gilt SET-007. Das erste Geheimnis landet mit der Prüfung der Plattform im gebundenen Speicher | API neu |  | 9 | Unit |

## Compute

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| CMP-001 | Cloud Bereich Reiter | Server, Firewalls, Storage Boxen, Ressourcen, SSH Keys; Neu: Bereiche laut Zielbild (Compute, Netzwerk, Storage) | `S/cloud/CloudHubScreen.kt:57` |  | 4 | Widget |
| CMP-002 | Serverliste | Alle Server des Scopes, bei "Alle Projekte" mit Projekt pro Zeile, alle Seiten geladen | `S/cloud/CloudScreen.kt:177`<br>`D/repo/CloudRepo.kt:206` | `GET /servers` | 4 | Unit |
| CMP-003 | Serverzeile Felder | Name, Status (Ton und Wort), Public IPv4 sonst IPv6, Typ in Großbuchstaben, Location | `S/cloud/CloudScreen.kt:221` | `GET /servers` | 4 | Golden |
| CMP-004 | Serverliste Leer | Leerhinweis mit Aktion "Server erstellen" | `S/cloud/CloudScreen.kt:178` |  | 4 | Widget |
| CMP-005 | Serverliste Schnellaktionen | Sheet aus Zeile: Einschalten, Ausschalten, Neustart, Herunterfahren, Reset, Snapshot | `S/cloud/CloudScreen.kt:141`<br>`S/cloud/CloudViewModel.kt:140` | `POST /servers/{id}/actions/poweron`<br>`POST /servers/{id}/actions/poweroff`<br>`POST /servers/{id}/actions/reboot`<br>`POST /servers/{id}/actions/shutdown`<br>`POST /servers/{id}/actions/reset`<br>`POST /servers/{id}/actions/create_image` | 4 | Widget |
| CMP-006 | Schnellaktion Bestätigung | "Run X on this server now?"; Neu: Stufe 1 ConfirmSheet nach Katalog | `S/cloud/CloudScreen.kt:150` |  | 4 | Widget |
| CMP-007 | Server anlegen Einstieg | FAB "Create server" | `S/cloud/CloudScreen.kt:116` |  | 4 | Widget |
| CMP-008 | Server anlegen Schritte | Location, Typ, Image, SSH, Details, Zusammenfassung | `S/cloud/CreateServerSheet.kt:67` | `GET /locations`<br>`GET /server_types`<br>`GET /images`<br>`GET /ssh_keys` | 4 | Widget |
| CMP-009 | Server anlegen Optionen laden | Locations, Typen, Images, SSH Keys des Zielprojekts | `S/cloud/CloudViewModel.kt:63` | `GET /locations`<br>`GET /server_types`<br>`GET /images`<br>`GET /ssh_keys` | 4 | Unit |
| CMP-010 | Server anlegen Typkarte | Name, Kerne, RAM, Disk; nur an Location verfügbare Typen | `S/cloud/CreateServerSheet.kt:140` | `GET /server_types` | 4 | Golden |
| CMP-011 | Server anlegen SSH Schritt | Mehrfachauswahl; Hinweis wenn keine Keys, Schritt überspringbar | `S/cloud/CreateServerSheet.kt:167` | `GET /ssh_keys` | 4 | Widget |
| CMP-012 | Server anlegen Details | Name Pflicht, cloud-init User Data optional, "Start after create" | `S/cloud/CreateServerSheet.kt:201` | `POST /servers` | 4 | Widget |
| CMP-013 | Server anlegen Ausführung | Erstellt Server, Doppelklick gesperrt, Liste neu laden | `S/cloud/CloudViewModel.kt:87`<br>`D/repo/CloudRepo.kt:219` | `POST /servers` | 4 | Integration |
| CMP-014 | Root Passwort nach Anlegen | Einmalig im Reveal Sheet wenn kein SSH Key gewählt | `S/cloud/CloudScreen.kt:159`<br>`S/cloud/CloudViewModel.kt:49` | `POST /servers` | 4 | Widget |
| CMP-015 | Serverdetail Laden | Server, Metriken, Aktivität laden, Pull to Refresh | `S/cloud/CloudServerDetailViewModel.kt:91` | `GET /servers/{id}` | 4 | Unit |
| CMP-016 | Serverdetail Kopf | Name, Status, Schutz Badge | `S/cloud/CloudServerDetailScreen.kt:205` | `GET /servers/{id}` | 4 | Golden |
| CMP-017 | Serverdetail Übersicht | Typ, Datacenter, vCPU, RAM, Disk, Image | `S/cloud/CloudServerDetailScreen.kt:898` | `GET /servers/{id}` | 4 | Golden |
| CMP-018 | Serverdetail IPs | Public IPv4, Public IPv6, kopierbar | `S/cloud/CloudServerDetailScreen.kt:840` | `GET /servers/{id}` | 4 | Golden |
| CMP-019 | Serverdetail Zugeordnete Ressourcen | Volumes, Firewalls, Netzwerke, Load Balancer mit Sprung ins Detail | `S/cloud/CloudServerDetailScreen.kt:924` | `GET /servers/{id}` | 4 | Widget |
| CMP-020 | Server Neustart | Kachel Reboot mit Bestätigung | `S/cloud/CloudServerDetailScreen.kt:246`<br>`S/cloud/CloudServerDetailViewModel.kt:173` | `POST /servers/{id}/actions/reboot` | 4 | Integration |
| CMP-021 | Server Herunterfahren | ACPI Shutdown mit Bestätigung | `S/cloud/CloudServerDetailScreen.kt:247`<br>`S/cloud/CloudServerDetailViewModel.kt:174` | `POST /servers/{id}/actions/shutdown` | 4 | Unit |
| CMP-022 | Server Einschalten | Power on | `S/cloud/CloudServerDetailScreen.kt:248`<br>`S/cloud/CloudServerDetailViewModel.kt:171` | `POST /servers/{id}/actions/poweron` | 4 | Unit |
| CMP-023 | Server Ausschalten | Hartes Power off mit Bestätigung | `S/cloud/CloudServerDetailScreen.kt:360`<br>`S/cloud/CloudServerDetailViewModel.kt:172` | `POST /servers/{id}/actions/poweroff` | 4 | Unit |
| CMP-024 | Server Reset | Hardware Reset mit Bestätigung | `S/cloud/CloudServerDetailScreen.kt:370`<br>`S/cloud/CloudServerDetailViewModel.kt:175` | `POST /servers/{id}/actions/reset` | 4 | Unit |
| CMP-025 | Server Snapshot | Snapshot erstellen; Neu: Beschreibung und Labels abfragen | `S/cloud/CloudServerDetailScreen.kt:268`<br>`S/cloud/CloudServerDetailViewModel.kt:176` | `POST /servers/{id}/actions/create_image` | 4 | Unit |
| CMP-026 | Server Konsole | Konsole anfordern, URL (wss) und Passwort anzeigen und kopieren, gültig etwa 1 Minute | `S/cloud/CloudServerDetailScreen.kt:815`<br>`S/cloud/CloudServerDetailViewModel.kt:229` | `POST /servers/{id}/actions/request_console` | 4 | Widget |
| CMP-027 | Server Metriken | CPU %, Disk Durchsatz lesen/schreiben, Netzwerk ein/aus | `S/cloud/CloudServerDetailScreen.kt:288` | `GET /servers/{id}/metrics` | 4 | Golden |
| CMP-028 | Metrik Zeiträume | 1h, 24h, 7d, 30d umschaltbar | `S/cloud/CloudServerDetailScreen.kt:1020`<br>`S/cloud/CloudServerDetailViewModel.kt:115` | `GET /servers/{id}/metrics` | 4 | Unit |
| CMP-029 | Metrik Kennzahlen | Min, Max, Durchschnitt pro Serie, Einheit automatisch (B/s, KB/s, ...) | `S/cloud/CloudServerDetailScreen.kt:1118`<br>`D/repo/CloudRepo.kt:68` |  | 4 | Unit |
| CMP-030 | Root Passwort zurücksetzen | Bestätigung, neues Passwort einmalig im Reveal Sheet | `S/cloud/CloudServerDetailScreen.kt:385`<br>`S/cloud/CloudServerDetailViewModel.kt:204` | `POST /servers/{id}/actions/reset_password` | 4 | Widget |
| CMP-031 | Server Neuaufsetzen | Image wählen (Reiter System oder Snapshot/Backup), veraltete markiert, Warnung Datenverlust; Neu: Stufe 2 | `S/cloud/RebuildDialog.kt:63`<br>`S/cloud/CloudServerDetailViewModel.kt:178` | `GET /images`<br>`POST /servers/{id}/actions/rebuild` | 4 | Integration |
| CMP-032 | Neuaufsetzen Root Passwort | Rückgabe Root Passwort einmalig anzeigen | `S/cloud/CloudServerDetailScreen.kt:735` | `POST /servers/{id}/actions/rebuild` | 4 | Widget |
| CMP-033 | Servertyp ändern | Liste mit aktuellem Typ markiert, Kerne, RAM, Disk; Server muss aus sein | `S/cloud/ChangeTypeDialog.kt:55`<br>`S/cloud/CloudServerDetailViewModel.kt:212` | `GET /server_types`<br>`POST /servers/{id}/actions/change_type` | 4 | Widget |
| CMP-034 | Servertyp Disk Upgrade | Schalter "Upgrade disk (irreversible)", Hinweis Downgrade dann unmöglich | `S/cloud/ChangeTypeDialog.kt:82` | `POST /servers/{id}/actions/change_type` | 4 | Widget |
| CMP-035 | ISO einlegen | Suche in ISOs, veraltete markiert | `S/cloud/IsoPickerDialog.kt:58`<br>`S/cloud/CloudServerDetailViewModel.kt:209` | `GET /isos`<br>`POST /servers/{id}/actions/attach_iso` | 4 | Widget |
| CMP-036 | ISO auswerfen | Nur sichtbar wenn ISO eingelegt | `S/cloud/CloudServerDetailScreen.kt:401`<br>`S/cloud/CloudServerDetailViewModel.kt:210` | `POST /servers/{id}/actions/detach_iso` | 4 | Unit |
| CMP-037 | Eingelegtes ISO anzeigen | Name und Beschreibung des ISO nachladen | `S/cloud/CloudServerDetailScreen.kt:1243`<br>`S/cloud/CloudServerDetailViewModel.kt:303` | `GET /isos/{id}` | 4 | Unit |
| CMP-038 | Backups an/aus | Umschalten mit Bestätigung | `S/cloud/CloudServerDetailScreen.kt:980`<br>`S/cloud/CloudServerDetailViewModel.kt:189` | `POST /servers/{id}/actions/enable_backup`<br>`POST /servers/{id}/actions/disable_backup` | 4 | Unit |
| CMP-039 | Rescue an/aus | Rescue aktivieren (Passwort einmalig anzeigen) oder deaktivieren | `S/cloud/CloudServerDetailScreen.kt:998`<br>`S/cloud/CloudServerDetailViewModel.kt:193` | `POST /servers/{id}/actions/enable_rescue`<br>`POST /servers/{id}/actions/disable_rescue` | 4 | Unit |
| CMP-040 | Server an Netzwerk | Netzwerk wählen, statische IP optional; Hinweis wenn keine Netzwerke | `S/cloud/CloudServerDetailScreen.kt:1284`<br>`S/cloud/CloudServerDetailViewModel.kt:258` | `GET /networks`<br>`POST /servers/{id}/actions/attach_to_network` | 5 | Widget |
| CMP-041 | Server aus Netzwerk entfernen | Bestätigung mit Netzwerkname | `S/cloud/CloudServerDetailScreen.kt:668`<br>`S/cloud/CloudServerDetailViewModel.kt:262` | `POST /servers/{id}/actions/detach_from_network` | 5 | Unit |
| CMP-042 | Server Reverse DNS | IP wählen, PTR eingeben, leer setzt Standard zurück | `S/cloud/CloudServerDetailScreen.kt:774`<br>`S/cloud/CloudServerDetailViewModel.kt:225` | `POST /servers/{id}/actions/change_dns_ptr` | 5 | Widget |
| CMP-043 | Placement Group zuordnen | Gruppe wählen; Hinweis wenn keine vorhanden | `S/cloud/CloudServerDetailScreen.kt:1350`<br>`S/cloud/CloudServerDetailViewModel.kt:276` | `GET /placement_groups`<br>`POST /servers/{id}/actions/add_to_placement_group` | 4 | Widget |
| CMP-044 | Placement Group entfernen | Bestätigung mit Gruppenname | `S/cloud/CloudServerDetailScreen.kt:699`<br>`S/cloud/CloudServerDetailViewModel.kt:282` | `POST /servers/{id}/actions/remove_from_placement_group` | 4 | Unit |
| CMP-045 | Server Aktivität | Letzte 30 Actions des Servers | `S/cloud/CloudServerDetailScreen.kt:476`<br>`S/cloud/CloudServerDetailViewModel.kt:323` | `GET /servers/{id}/actions` | 8 | Widget |
| CMP-046 | Server Schutz | Lösch und Rebuild Schutz getrennt schaltbar | `S/cloud/CloudServerDetailScreen.kt:1225`<br>`S/cloud/CloudServerDetailViewModel.kt:216` | `POST /servers/{id}/actions/change_protection` | 4 | Widget |
| CMP-047 | Server umbenennen | Bottom Sheet mit Name | `S/cloud/CloudServerDetailScreen.kt:1202`<br>`S/cloud/CloudServerDetailViewModel.kt:185` | `PUT /servers/{id}` | 4 | Widget |
| CMP-048 | Server löschen | Stufe 2: Servername eintippen; Hinweis nicht externe Volumes | `S/cloud/CloudServerDetailScreen.kt:586`<br>`S/cloud/CloudServerDetailViewModel.kt:220` | `DELETE /servers/{id}` | 4 | Integration |
| CMP-049 | Server Gefahrenzone | Löschen ganz unten getrennt | `S/cloud/CloudServerDetailScreen.kt:503` |  | 4 | Golden |
| CMP-050 | Volumeliste | Name, Größe GB, Status, Server ID, Location | `S/cloud/CloudVolumesTab.kt:226`<br>`S/cloud/CloudVolumesTab.kt:98` | `GET /volumes` | 4 | Golden |
| CMP-051 | Volume anlegen Schritte | Ziel (Location oder Server), Größe, Details | `S/cloud/CloudVolumesTab.kt:324` | `GET /locations`<br>`GET /servers` | 4 | Widget |
| CMP-052 | Volume Größe | Voreinstellungen 10, 50, 100, 250, 500, 1024, 2048, 5120, 10240 GB, Regler 10 bis 10240 | `S/cloud/CloudVolumesTab.kt:419` |  | 4 | Unit |
| CMP-053 | Volume Format | Kein, ext4, xfs | `S/cloud/CloudVolumesTab.kt:458` | `POST /volumes` | 4 | Widget |
| CMP-054 | Volume Automount | "Auto-mount on attach" wenn Server gewählt | `S/cloud/CloudVolumesTab.kt:475` | `POST /volumes` | 4 | Widget |
| CMP-055 | Volume Preis | Geschätzter Preis brutto, netto und pro GB pro Monat | `S/cloud/CloudVolumesTab.kt:277` | `GET /pricing` | 4 | Unit |
| CMP-056 | Volume anlegen Ausführung | Name Pflicht | `S/cloud/CloudVolumesTab.kt:135` | `POST /volumes` | 4 | Integration |
| CMP-057 | Volumedetail Übersicht | Größe, Format, Location, Status | `S/cloud/CloudVolumeDetailScreen.kt:308` | `GET /volumes/{id}` | 4 | Golden |
| CMP-058 | Volume Zuordnung | Server oder "Not attached to any server" | `S/cloud/CloudVolumeDetailScreen.kt:150` | `GET /volumes/{id}` | 4 | Golden |
| CMP-059 | Volume anhängen | Server suchen und wählen, Automount Schalter | `S/cloud/AttachVolumeDialog.kt:84`<br>`S/cloud/CloudVolumeDetailViewModel.kt:78` | `GET /servers`<br>`POST /volumes/{id}/actions/attach` | 4 | Widget |
| CMP-060 | Volume abhängen | Stufe 1 Bestätigung | `S/cloud/CloudVolumeDetailScreen.kt:195`<br>`S/cloud/CloudVolumeDetailViewModel.kt:82` | `POST /volumes/{id}/actions/detach` | 4 | Unit |
| CMP-061 | Volume vergrößern | Nur wachsen, neue Größe größer aktueller | `S/cloud/CloudVolumeDetailScreen.kt:374`<br>`S/cloud/CloudVolumeDetailViewModel.kt:84` | `POST /volumes/{id}/actions/resize` | 4 | Unit |
| CMP-062 | Volume umbenennen | Bottom Sheet | `S/cloud/CloudVolumeDetailScreen.kt:212`<br>`S/cloud/CloudVolumeDetailViewModel.kt:67` | `PUT /volumes/{id}` | 4 | Widget |
| CMP-063 | Volume Schutz | Löschschutz umschalten | `S/cloud/CloudVolumeDetailScreen.kt:215`<br>`S/cloud/CloudVolumeDetailViewModel.kt:86` | `POST /volumes/{id}/actions/change_protection` | 4 | Unit |
| CMP-064 | Volume löschen | Bestätigung; Neu: Stufe 2 | `S/cloud/CloudVolumeDetailScreen.kt:283`<br>`S/cloud/CloudVolumeDetailViewModel.kt:69` | `DELETE /volumes/{id}` | 4 | Unit |
| CMP-065 | Placement Group Liste | Name pro Zeile im Reiter Ressourcen | `S/cloud/CloudResourcesTab.kt:264` | `GET /placement_groups` | 4 | Golden |
| CMP-066 | Placement Group anlegen | Name Pflicht, Typ fest "spread" | `S/cloud/CloudResourcesTab.kt:708`<br>`S/cloud/CloudExtraResourcesViewModels.kt:118` | `POST /placement_groups` | 4 | Widget |
| CMP-067 | Placement Group umbenennen | Alt nur im Repository, keine UI | `D/repo/CloudRepo.kt:910` | `PUT /placement_groups/{id}` | 4 | Widget |
| CMP-068 | Placement Group löschen | Alt nur im Repository, keine UI | `D/repo/CloudRepo.kt:915` | `DELETE /placement_groups/{id}` | 4 | Unit |
| CMP-069 | Placement Group Detail | Alt nur im Repository; Neu: Detail mit Servern | `D/repo/CloudRepo.kt:898` | `GET /placement_groups/{id}` | 4 | Widget |
| CMP-070 | SSH Key Liste Cloud | Name, Fingerprint | `S/cloud/CloudSshKeysTab.kt:98` | `GET /ssh_keys` | 4 | Golden |
| CMP-071 | SSH Key hinzufügen | Aus Datei oder manuell; Name und Key Pflicht | `S/cloud/CloudSshKeysTab.kt:280`<br>`S/cloud/CloudSshKeysTab.kt:107` | `POST /ssh_keys` | 4 | Widget |
| CMP-072 | SSH Key Prüfung privat | Private Keys (PEM, OpenSSH, PuTTY, SSH2, Zertifikat) abgewiesen | `ui/util/SshKeyValidation.kt:12` |  | 4 | Unit |
| CMP-073 | SSH Key Prüfung öffentlich | Nur bekannte Präfixe: ssh-rsa, ssh-ed25519, ssh-dss, ecdsa-sha2-nistp256/384/521, sk-ecdsa, sk-ssh-ed25519 | `ui/util/SshKeyValidation.kt:31` |  | 4 | Unit |
| CMP-074 | SSH Key Projekt bei Aggregat | Projektwahl beim Anlegen | `S/cloud/CloudSshKeysTab.kt:235` | `POST /ssh_keys` | 4 | Widget |
| CMP-075 | SSH Key löschen | Bestätigung | `S/cloud/CloudSshKeysTab.kt:245`<br>`S/cloud/CloudSshKeysTab.kt:117` | `DELETE /ssh_keys/{id}` | 4 | Unit |
| CMP-076 | SSH Key umbenennen | Alt nur im Repository, keine UI | `D/repo/CloudRepo.kt:479` | `PUT /ssh_keys/{id}` | 4 | Widget |
| CMP-077 | Images Liste für Rebuild | Systemimages und Snapshots/Backups | `S/cloud/CloudServerDetailViewModel.kt:234` | `GET /images` | 4 | Unit |
| CMP-078 | Pricing laden | Preise für Volumes | `D/repo/CloudRepo.kt:514` | `GET /pricing` | 4 | Unit |
| CMP-079 | Locations laden | Für Anlegen Dialoge | `D/repo/CloudRepo.kt:512` | `GET /locations` | 4 | Unit |
| CMP-080 | Datacenter laden | Alt nur Repository; Hetzner entfernt `datacenter` 2026, Neu nur Location nutzen | `D/repo/CloudRepo.kt:513` | `GET /datacenters` | 4 | Unit |
| CMP-081 | Server anlegen mit Netzwerken | Private Netze beim Anlegen wählen | API neu | `POST /servers` | 4 | Widget |
| CMP-082 | Server anlegen mit Firewalls | Firewalls beim Anlegen anwenden | API neu | `POST /servers` | 4 | Widget |
| CMP-083 | Server anlegen mit Volumes | Bestehende Volumes anhängen, Automount | API neu | `POST /servers` | 4 | Widget |
| CMP-084 | Server anlegen mit Placement Group | Gruppe beim Anlegen wählen | API neu | `POST /servers` | 4 | Widget |
| CMP-085 | Server anlegen Public Net | IPv4/IPv6 einzeln abschaltbar, vorhandene Primary IPs nutzen | API neu | `POST /servers` | 4 | Widget |
| CMP-086 | Server anlegen Labels | Labels beim Anlegen setzen | API neu | `POST /servers` | 4 | Widget |
| CMP-087 | Server Labels | Labels anzeigen und im Edit Sheet bearbeiten | API neu | `PUT /servers/{id}` | 4 | Widget |
| CMP-088 | Volume Labels | Labels anzeigen und bearbeiten | API neu | `PUT /volumes/{id}` | 4 | Widget |
| CMP-089 | Snapshot mit Beschreibung | Beschreibung und Labels beim Snapshot | API neu | `POST /servers/{id}/actions/create_image` | 4 | Widget |
| CMP-090 | Images Liste | Eigene Snapshots und Backups als Liste mit Größe, Datum, Quelle | API neu | `GET /images` | 4 | Golden |
| CMP-091 | Placement Group Typ | Typ aus Spec wählen statt fest "spread" | API neu | `POST /placement_groups` | 4 | Unit |
| CMP-092 | Datacenter einzeln | Nur falls noch nötig; Hetzner baut `datacenter` 2026 ab | API neu | `GET /datacenters/{id}` | 4 | Unit |
| CMP-093 | Image Detail | Größe, Quelle, Erstelldatum, Schutz, Labels | API neu | `GET /images/{id}` | 4 | Unit |
| CMP-094 | Image bearbeiten | Beschreibung, Typ snapshot, Labels | API neu | `PUT /images/{id}` | 4 | Unit |
| CMP-095 | Image löschen | Snapshot oder Backup löschen, Stufe 2 | API neu | `DELETE /images/{id}` | 4 | Unit |
| CMP-096 | Image Schutz | Löschschutz umschalten | API neu | `POST /images/{id}/actions/change_protection` | 4 | Unit |
| CMP-097 | Location einzeln | Location Details | API neu | `GET /locations/{id}` | 4 | Unit |
| CMP-098 | Servertyp einzeln | Typdetails mit Preisen je Location | API neu | `GET /server_types/{id}` | 4 | Unit |
| CMP-099 | SSH Key Detail | Name, Fingerprint, Key, Labels | API neu | `GET /ssh_keys/{id}` | 4 | Unit |

## Netzwerk

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| NET-001 | Firewall Liste | Name, Status "Active" (angewendet) oder "Not applied" | `S/cloud/CloudFirewallsTab.kt:282`<br>`S/cloud/CloudFirewallsTab.kt:88` | `GET /firewalls` | 5 | Golden |
| NET-002 | Firewall anlegen | Name Pflicht; Neu: Regeln und Ziele schon im Wizard | `S/cloud/CloudFirewallsTab.kt:338`<br>`S/cloud/CloudFirewallsTab.kt:98` | `POST /firewalls` | 5 | Widget |
| NET-003 | Firewall aus Liste anwenden | Server suchen und wählen | `S/cloud/FirewallApplyDialog.kt:61`<br>`S/cloud/CloudFirewallsTab.kt:115` | `GET /servers`<br>`POST /firewalls/{id}/actions/apply_to_resources` | 5 | Widget |
| NET-004 | Firewall Detail Regeln | Liste mit Richtung, Protokoll, Port, IPs, Beschreibung; Leerhinweis | `S/cloud/CloudFirewallDetailScreen.kt:160`<br>`S/cloud/CloudFirewallDetailViewModel.kt:55` | `GET /firewalls/{id}` | 5 | Golden |
| NET-005 | Firewall Regel anlegen | Neue Regel Dialog | `S/cloud/FirewallRuleDialog.kt:92`<br>`S/cloud/CloudFirewallDetailViewModel.kt:83` | `POST /firewalls/{id}/actions/set_rules` | 5 | Widget |
| NET-006 | Firewall Regel Richtung | Inbound (Quell IPs) oder Outbound (Ziel IPs) | `S/cloud/FirewallRuleDialog.kt:132` |  | 5 | Widget |
| NET-007 | Firewall Regel Protokoll | tcp, udp, icmp, esp, gre; Port nur bei tcp/udp | `S/cloud/FirewallRuleDialog.kt:58` |  | 5 | Unit |
| NET-008 | Firewall Regel Port | Einzelport, Bereich "8000-9000" oder "any" | `S/cloud/FirewallRuleDialog.kt:161` |  | 5 | Unit |
| NET-009 | Firewall Regel IPs | CIDR Liste, Schnellwahl Any IPv4 (0.0.0.0/0) und Any IPv6 (::/0), mindestens eine IP | `S/cloud/FirewallRuleDialog.kt:184` |  | 5 | Unit |
| NET-010 | Firewall Regel Beschreibung | Freitext optional | `S/cloud/FirewallRuleDialog.kt:174` |  | 5 | Widget |
| NET-011 | Firewall Regel bearbeiten | Gleicher Dialog vorbefüllt | `S/cloud/FirewallRuleDialog.kt:94` | `POST /firewalls/{id}/actions/set_rules` | 5 | Widget |
| NET-012 | Firewall Regel löschen | Bestätigung | `S/cloud/CloudFirewallDetailScreen.kt:274`<br>`S/cloud/CloudFirewallDetailViewModel.kt:93` | `POST /firewalls/{id}/actions/set_rules` | 5 | Unit |
| NET-013 | Firewall zugeordnete Server | Liste, Leerhinweis | `S/cloud/CloudFirewallDetailScreen.kt:179` | `GET /firewalls/{id}` | 5 | Golden |
| NET-014 | Firewall an Server | Server wählen | `S/cloud/CloudFirewallDetailScreen.kt:182`<br>`S/cloud/CloudFirewallDetailViewModel.kt:98` | `POST /firewalls/{id}/actions/apply_to_resources` | 5 | Widget |
| NET-015 | Firewall von Server entfernen | Bestätigung mit Folgehinweis | `S/cloud/CloudFirewallDetailScreen.kt:293`<br>`S/cloud/CloudFirewallDetailViewModel.kt:102` | `POST /firewalls/{id}/actions/remove_from_resources` | 5 | Unit |
| NET-016 | Firewall umbenennen | Bottom Sheet | `S/cloud/CloudFirewallDetailScreen.kt:212`<br>`S/cloud/CloudFirewallDetailViewModel.kt:70` | `PUT /firewalls/{id}` | 5 | Widget |
| NET-017 | Firewall löschen | Bestätigung | `S/cloud/CloudFirewallDetailScreen.kt:248`<br>`S/cloud/CloudFirewallDetailViewModel.kt:74` | `DELETE /firewalls/{id}` | 5 | Unit |
| NET-018 | Floating IP Liste | IP, Name, Typ, Server, Home Location | `S/cloud/CloudFloatingIpsTab.kt:203`<br>`S/cloud/CloudFloatingIpsTab.kt:90` | `GET /floating_ips` | 5 | Golden |
| NET-019 | Floating IP anlegen Schritte | Typ, Ziel, Details | `S/cloud/CloudFloatingIpsTab.kt:246` | `GET /locations`<br>`GET /servers` | 5 | Widget |
| NET-020 | Floating IP Typ | IPv4 oder IPv6 | `S/cloud/CloudFloatingIpsTab.kt:296` |  | 5 | Widget |
| NET-021 | Floating IP Ziel | Home Location oder Server; "Assign to server immediately" | `S/cloud/CloudFloatingIpsTab.kt:314` |  | 5 | Widget |
| NET-022 | Floating IP Details | Name optional, Beschreibung optional | `S/cloud/CloudFloatingIpsTab.kt:353` | `POST /floating_ips` | 5 | Widget |
| NET-023 | Floating IP anlegen Ausführung | Projekt bei Aggregat | `S/cloud/CloudFloatingIpsTab.kt:114` | `POST /floating_ips` | 5 | Integration |
| NET-024 | Floating IP Detail | IP, zugewiesen/nicht, Typ, Datacenter, Server, Reverse DNS | `S/cloud/CloudFloatingIpDetailScreen.kt:138` | `GET /floating_ips/{id}` | 5 | Golden |
| NET-025 | Floating IP zuweisen | Server wählen | `S/cloud/CloudFloatingIpDetailScreen.kt:192`<br>`S/cloud/CloudFloatingIpDetailViewModel.kt:75` | `POST /floating_ips/{id}/actions/assign` | 5 | Widget |
| NET-026 | Floating IP Zuweisung entfernen | Stufe 1 | `S/cloud/CloudFloatingIpDetailScreen.kt:188`<br>`S/cloud/CloudFloatingIpDetailViewModel.kt:76` | `POST /floating_ips/{id}/actions/unassign` | 5 | Unit |
| NET-027 | Floating IP Reverse DNS | IP und PTR; leer setzt zurück | `S/cloud/CloudFloatingIpDetailScreen.kt:284`<br>`S/cloud/CloudFloatingIpDetailViewModel.kt:77` | `POST /floating_ips/{id}/actions/change_dns_ptr` | 5 | Widget |
| NET-028 | Floating IP umbenennen | Bottom Sheet | `S/cloud/CloudFloatingIpDetailScreen.kt:238`<br>`S/cloud/CloudFloatingIpDetailViewModel.kt:67` | `PUT /floating_ips/{id}` | 5 | Widget |
| NET-029 | Floating IP Schutz | Löschschutz | `S/cloud/CloudFloatingIpDetailScreen.kt:212`<br>`S/cloud/CloudFloatingIpDetailViewModel.kt:80` | `POST /floating_ips/{id}/actions/change_protection` | 5 | Unit |
| NET-030 | Floating IP löschen | Bestätigung (alt mit falschem Text, siehe BUG) | `S/cloud/CloudFloatingIpDetailScreen.kt:323`<br>`S/cloud/CloudFloatingIpDetailViewModel.kt:69` | `DELETE /floating_ips/{id}` | 5 | Unit |
| NET-031 | Primary IP Liste | IP, Name, Typ, Server, Datacenter | `S/cloud/CloudPrimaryIpsTab.kt:196`<br>`S/cloud/CloudPrimaryIpsTab.kt:85` | `GET /primary_ips` | 5 | Golden |
| NET-032 | Primary IP anlegen Schritte | Typ IPv4/IPv6, Ziel (Location oder Server), Name Pflicht | `S/cloud/CloudPrimaryIpsTab.kt:233`<br>`S/cloud/CloudPrimaryIpsTab.kt:97` | `GET /locations`<br>`GET /servers` | 5 | Widget |
| NET-033 | Primary IP anlegen Ausführung | Projekt bei Aggregat | `S/cloud/CloudPrimaryIpsTab.kt:109` | `POST /primary_ips` | 5 | Integration |
| NET-034 | Primary IP Detail | IP, zugewiesen/nicht, Typ, Datacenter, Server, Reverse DNS (nur Anzeige) | `S/cloud/CloudPrimaryIpDetailScreen.kt:129` | `GET /primary_ips/{id}` | 5 | Golden |
| NET-035 | Primary IP zuweisen | Server wählen (Server muss aus sein) | `S/cloud/CloudPrimaryIpDetailScreen.kt:183`<br>`S/cloud/CloudPrimaryIpDetailViewModel.kt:73` | `POST /primary_ips/{id}/actions/assign` | 5 | Widget |
| NET-036 | Primary IP Zuweisung entfernen | Stufe 1 | `S/cloud/CloudPrimaryIpDetailScreen.kt:179`<br>`S/cloud/CloudPrimaryIpDetailViewModel.kt:74` | `POST /primary_ips/{id}/actions/unassign` | 5 | Unit |
| NET-037 | Primary IP Schutz | Löschschutz | `S/cloud/CloudPrimaryIpDetailScreen.kt:192`<br>`S/cloud/CloudPrimaryIpDetailViewModel.kt:75` | `POST /primary_ips/{id}/actions/change_protection` | 5 | Unit |
| NET-038 | Primary IP löschen | Bestätigung | `S/cloud/CloudPrimaryIpDetailScreen.kt:229`<br>`S/cloud/CloudPrimaryIpDetailViewModel.kt:67` | `DELETE /primary_ips/{id}` | 5 | Unit |
| NET-039 | Netzwerk Liste | Name, IP Bereich | `S/cloud/CloudNetworksTab.kt:204`<br>`S/cloud/CloudNetworksTab.kt:91` | `GET /networks` | 5 | Golden |
| NET-040 | Netzwerk anlegen Details | Name Pflicht, IP Bereich CIDR (privat, z. B. 10.0.0.0/16) | `S/cloud/CloudNetworksTab.kt:292` | `POST /networks` | 5 | Widget |
| NET-041 | Netzwerk anlegen Subnetz | Optional: Netzwerkzone (eu-central, us-east, us-west, ap-southeast), Typ cloud/server/vswitch, Bereich optional, vSwitch ID Pflicht bei vswitch | `S/cloud/CloudNetworksTab.kt:252` | `POST /networks` | 5 | Unit |
| NET-042 | Netzwerk anlegen Ausführung | Projekt bei Aggregat | `S/cloud/CloudNetworksTab.kt:98` | `POST /networks` | 5 | Integration |
| NET-043 | Netzwerk Detail Übersicht | IP Bereich, Anzahl Subnetze, Routen, vSwitch Status | `S/cloud/CloudNetworkDetailScreen.kt:393` | `GET /networks/{id}` | 5 | Golden |
| NET-044 | Netzwerk Schutz Anzeige | Löschschutz Badge | `S/cloud/CloudNetworkDetailScreen.kt:168` | `GET /networks/{id}` | 5 | Golden |
| NET-045 | Netzwerk Subnetze | Liste mit Bereich, Typ, Zone, Gateway, vSwitch ID | `S/cloud/CloudNetworkDetailScreen.kt:497` | `GET /networks/{id}` | 5 | Golden |
| NET-046 | Subnetz hinzufügen | Typ, Zone, Bereich optional (innerhalb Netz), vSwitch ID | `S/cloud/CloudNetworkDetailScreen.kt:672`<br>`S/cloud/CloudNetworkDetailViewModel.kt:80` | `POST /networks/{id}/actions/add_subnet` | 5 | Widget |
| NET-047 | Subnetz löschen | Bestätigung mit Bereich | `S/cloud/CloudNetworkDetailScreen.kt:329`<br>`S/cloud/CloudNetworkDetailViewModel.kt:84` | `POST /networks/{id}/actions/delete_subnet` | 5 | Unit |
| NET-048 | Netzwerk Routen | Liste Ziel über Gateway | `S/cloud/CloudNetworkDetailScreen.kt:530` | `GET /networks/{id}` | 5 | Golden |
| NET-049 | Route hinzufügen | Ziel CIDR und Gateway (innerhalb Netz) Pflicht | `S/cloud/CloudNetworkDetailScreen.kt:746`<br>`S/cloud/CloudNetworkDetailViewModel.kt:88` | `POST /networks/{id}/actions/add_route` | 5 | Widget |
| NET-050 | Route löschen | Bestätigung mit Ziel und Gateway | `S/cloud/CloudNetworkDetailScreen.kt:350`<br>`S/cloud/CloudNetworkDetailViewModel.kt:92` | `POST /networks/{id}/actions/delete_route` | 5 | Unit |
| NET-051 | Netzwerk IP Bereich ändern | Nur vergrößern, Hinweis unumkehrbar; Speichern nur bei Änderung | `S/cloud/CloudNetworkDetailScreen.kt:591`<br>`S/cloud/CloudNetworkDetailViewModel.kt:76` | `POST /networks/{id}/actions/change_ip_range` | 5 | Widget |
| NET-052 | Netzwerk Routen an vSwitch | "Expose routes to vSwitch" Schalter | `S/cloud/CloudNetworkDetailScreen.kt:630`<br>`S/cloud/CloudNetworkDetailViewModel.kt:96` | `PUT /networks/{id}` | 5 | Widget |
| NET-053 | Netzwerk umbenennen | Bottom Sheet | `S/cloud/CloudNetworkDetailScreen.kt:273`<br>`S/cloud/CloudNetworkDetailViewModel.kt:59` | `PUT /networks/{id}` | 5 | Widget |
| NET-054 | Netzwerk Schutz | Löschschutz | `S/cloud/CloudNetworkDetailScreen.kt:244`<br>`S/cloud/CloudNetworkDetailViewModel.kt:72` | `POST /networks/{id}/actions/change_protection` | 5 | Unit |
| NET-055 | Netzwerk löschen | Bestätigung, Subnetze werden mit gelöscht | `S/cloud/CloudNetworkDetailScreen.kt:378`<br>`S/cloud/CloudNetworkDetailViewModel.kt:63` | `DELETE /networks/{id}` | 5 | Unit |
| NET-056 | Load Balancer Liste | Name, Typ, Status im Reiter Ressourcen | `S/cloud/CloudResourcesTab.kt:238`<br>`S/cloud/CloudExtraResourcesViewModels.kt:36` | `GET /load_balancers` | 5 | Golden |
| NET-057 | Load Balancer Detail Übersicht | Typ, Anzahl Services, Anzahl Targets | `S/cloud/CloudLoadBalancerDetailScreen.kt:436` | `GET /load_balancers/{id}` | 5 | Golden |
| NET-058 | Load Balancer Netzwerk | Public IPv4, IPv6, "Public interface disabled", private Netze | `S/cloud/CloudLoadBalancerDetailScreen.kt:168` | `GET /load_balancers/{id}` | 5 | Golden |
| NET-059 | LB Services Liste | Protokoll, Listen Port, Ziel Port, PROXY Protokoll; Leerhinweis | `S/cloud/CloudLoadBalancerDetailScreen.kt:194` | `GET /load_balancers/{id}` | 5 | Golden |
| NET-060 | LB Service anlegen | Protokoll tcp/http/https, Listen und Ziel Port 1 bis 65535, PROXY protocol | `S/cloud/CloudLoadBalancerDetailScreen.kt:705`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:104` | `POST /load_balancers/{id}/actions/add_service` | 5 | Unit |
| NET-061 | LB Service bearbeiten | Listen Port nicht änderbar | `S/cloud/CloudLoadBalancerDetailScreen.kt:746`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:108` | `POST /load_balancers/{id}/actions/update_service` | 5 | Widget |
| NET-062 | LB Service löschen | Bestätigung | `S/cloud/CloudLoadBalancerDetailViewModel.kt:123` | `POST /load_balancers/{id}/actions/delete_service` | 5 | Unit |
| NET-063 | LB Targets Liste | Server mit IP, Label Selector, IP; Leerhinweis; Zustand eines Selectors aus seinen Servern | `S/cloud/CloudLoadBalancerDetailScreen.kt:221` | `GET /load_balancers/{id}` | 5 | Golden |
| NET-064 | LB Target Server | Server ID, "Route via private network" | `S/cloud/CloudLoadBalancerDetailScreen.kt:841`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:127` | `POST /load_balancers/{id}/actions/add_target` | 5 | Widget |
| NET-065 | LB Target Label Selector | Selector wie role=web,env=prod | `S/cloud/CloudLoadBalancerDetailScreen.kt:858`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:138` | `POST /load_balancers/{id}/actions/add_target` | 5 | Widget |
| NET-066 | LB Target IP | IP Adresse | `S/cloud/CloudLoadBalancerDetailScreen.kt:872`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:148` | `POST /load_balancers/{id}/actions/add_target` | 5 | Widget |
| NET-067 | LB Target entfernen | Bestätigung; ein Server Target mit seiner IP | `S/cloud/CloudLoadBalancerDetailViewModel.kt:161` | `POST /load_balancers/{id}/actions/remove_target` | 5 | Unit |
| NET-068 | LB Algorithmus | Round robin oder Least connections, Speichern nur bei Änderung | `S/cloud/CloudLoadBalancerDetailScreen.kt:586`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:96` | `POST /load_balancers/{id}/actions/change_algorithm` | 5 | Widget |
| NET-069 | LB Typ ändern | Typliste mit aktuellem markiert, Grenzen max. Verbindungen, Services, Targets | `S/cloud/CloudLoadBalancerDetailScreen.kt:631`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:100` | `GET /load_balancer_types`<br>`POST /load_balancers/{id}/actions/change_type` | 5 | Widget |
| NET-070 | LB Public Interface | Aktivieren oder deaktivieren | `S/cloud/CloudLoadBalancerDetailScreen.kt:290`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:92` | `POST /load_balancers/{id}/actions/enable_public_interface`<br>`POST /load_balancers/{id}/actions/disable_public_interface` | 5 | Unit |
| NET-071 | LB Schutz | Löschschutz | `S/cloud/CloudLoadBalancerDetailScreen.kt:298`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:88` | `POST /load_balancers/{id}/actions/change_protection` | 5 | Unit |
| NET-072 | LB umbenennen | Bottom Sheet | `S/cloud/CloudLoadBalancerDetailScreen.kt:271`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:77` | `PUT /load_balancers/{id}` | 5 | Widget |
| NET-073 | LB löschen | Bestätigung | `S/cloud/CloudLoadBalancerDetailScreen.kt:335`<br>`S/cloud/CloudLoadBalancerDetailViewModel.kt:79` | `DELETE /load_balancers/{id}` | 5 | Unit |
| NET-074 | LB anlegen | Alt nur Repository, keine UI; Neu Wizard: Typ, Location, Netz, Services, Targets | `D/repo/CloudRepo.kt:756` | `POST /load_balancers` | 5 | Integration |
| NET-075 | LB an Netzwerk | Alt nur Repository | `D/repo/CloudRepo.kt:822` | `POST /load_balancers/{id}/actions/attach_to_network` | 5 | Widget |
| NET-076 | LB von Netzwerk entfernen | Alt nur Repository | `D/repo/CloudRepo.kt:828` | `POST /load_balancers/{id}/actions/detach_from_network` | 5 | Unit |
| NET-077 | LB Reverse DNS | Alt nur Repository | `D/repo/CloudRepo.kt:840` | `POST /load_balancers/{id}/actions/change_dns_ptr` | 5 | Widget |
| NET-078 | LB Metriken | Alt nur API Interface, keine UI; Neu: open_connections, connections_per_second, requests_per_second, bandwidth | `D/api/CloudApi.kt:543` | `GET /load_balancers/{id}/metrics` | 5 | Golden |
| NET-079 | Zertifikat Liste | Name, Typ, Domains, Ablauf | `S/cloud/CloudResourcesTab.kt:251`<br>`S/cloud/CloudExtraResourcesViewModels.kt:62` | `GET /certificates` | 5 | Golden |
| NET-080 | Zertifikat hochladen | Name, Zertifikat PEM, privater Schlüssel PEM | `S/cloud/CloudResourcesTab.kt:632`<br>`S/cloud/CloudExtraResourcesViewModels.kt:70` | `POST /certificates` | 5 | Widget |
| NET-081 | Zertifikat verwaltet | Let's Encrypt: Name, Domains kommagetrennt | `S/cloud/CloudResourcesTab.kt:638`<br>`S/cloud/CloudExtraResourcesViewModels.kt:83` | `POST /certificates` | 5 | Widget |
| NET-082 | Zertifikat Detail | Alt nur Repository | `D/repo/CloudRepo.kt:854` | `GET /certificates/{id}` | 5 | Golden |
| NET-083 | Zertifikat umbenennen | Alt nur Repository | `D/repo/CloudRepo.kt:885` | `PUT /certificates/{id}` | 5 | Widget |
| NET-084 | Zertifikat löschen | Alt nur Repository | `D/repo/CloudRepo.kt:890` | `DELETE /certificates/{id}` | 5 | Unit |
| NET-085 | Zertifikat erneut ausstellen | Alt nur Repository; Retry für fehlgeschlagene verwaltete | `D/repo/CloudRepo.kt:891` | `POST /certificates/{id}/actions/retry` | 5 | Unit |
| NET-086 | Alias IPs Server | Alt nur Repository | `D/repo/CloudRepo.kt:415` | `POST /servers/{id}/actions/change_alias_ips` | 5 | Widget |
| NET-087 | LB Health Check | Protokoll, Port, Intervall, Timeout, Retries, HTTP Pfad und Statuscodes je Service | API neu | `POST /load_balancers/{id}/actions/update_service` | 5 | Widget |
| NET-088 | LB HTTP Optionen | Zertifikate für https, Redirect http, Sticky Sessions, Cookie, Timeout | API neu | `POST /load_balancers/{id}/actions/add_service` | 5 | Widget |
| NET-089 | Firewall auf Label Selector | Anwenden auf label_selector statt einzelner Server | API neu | `POST /firewalls/{id}/actions/apply_to_resources` | 5 | Widget |
| NET-090 | Labels Netzwerk Ressourcen | Labels für Firewalls, Floating IPs, Primary IPs, Netzwerke, LB, Zertifikate | API neu | `PUT /firewalls/{id}`<br>`PUT /floating_ips/{id}`<br>`PUT /networks/{id}`<br>`PUT /load_balancers/{id}`<br>`PUT /certificates/{id}` | 5 | Widget |
| NET-091 | LB Typ einzeln | Typdetails mit Preisen | API neu | `GET /load_balancer_types/{id}` | 5 | Unit |
| NET-092 | Netzwerk Mitglieder | Server und LB im Netz mit privater IP | API neu | `GET /networks/{id}/members` | 5 | Unit |
| NET-093 | Primary IP bearbeiten | Name, auto_delete, Labels | API neu | `PUT /primary_ips/{id}` | 5 | Unit |
| NET-094 | Primary IP Reverse DNS | PTR setzen, leer setzt zurück; alt nur Anzeige | API neu | `POST /primary_ips/{id}/actions/change_dns_ptr` | 5 | Unit |

## DNS

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| DNS-001 | Zonenliste | Name, Anzahl Records, TTL, Status | `S/dns/DnsScreen.kt:112`<br>`S/dns/DnsScreen.kt:65` | `GET /zones` | 5 | Golden |
| DNS-002 | Zone anlegen | Name Pflicht, Standard TTL optional mindestens 60 s | `S/dns/ZoneFormDialog.kt:44`<br>`S/dns/DnsScreen.kt:72` | `POST /zones` | 5 | Unit |
| DNS-003 | Zone bearbeiten | Name gesperrt, nur TTL | `S/dns/ZoneFormDialog.kt:60`<br>`S/dns/DnsScreen.kt:79` | `POST /zones/{id}/actions/change_ttl` | 5 | Widget |
| DNS-004 | Zone löschen | Bestätigung, alle Records gelöscht; Neu: Stufe 2 | `S/dns/DnsScreen.kt:202`<br>`S/dns/DnsScreen.kt:86` | `DELETE /zones/{id}` | 5 | Unit |
| DNS-005 | Zonendetail Übersicht | TTL, Status, Anzahl Records | `S/dns/ZoneDetailScreen.kt:422`<br>`S/dns/ZoneDetailViewModel.kt:69` | `GET /zones/{id}`<br>`GET /zones/{id}/rrsets` | 5 | Golden |
| DNS-006 | Recordliste | Name, Typ, Wert, TTL pro Wert; Aktualisieren lädt die Records neu, ein Fehler zeigt "Erneut versuchen", Anlegen erst nach dem Laden | `S/dns/ZoneDetailScreen.kt:473` | `GET /zones/{id}/rrsets` | 5 | Golden |
| DNS-007 | Record anlegen | Name, Typ, Wert Pflicht, TTL optional mindestens 60 | `S/dns/RecordDialog.kt:60`<br>`S/dns/ZoneDetailViewModel.kt:100` | `POST /zones/{id}/rrsets/{name}/{type}/actions/add_records`<br>`POST /zones/{id}/rrsets/{name}/{type}/actions/change_ttl` | 5 | Unit |
| DNS-008 | Record Typen | A, AAAA, CNAME, MX, TXT, NS, SRV, CAA; Neu zusätzlich alle Typen der Spec (PTR, DS, TLSA, HINFO, RP) | `S/dns/RecordDialog.kt:43` |  | 5 | Unit |
| DNS-009 | Record Wert Normalisierung | TXT Anführungszeichen, je String höchstens 255 Byte, FQDN Punkt je Typ | `D/repo/DnsRepo.kt:118` |  | 5 | Unit |
| DNS-010 | Record bearbeiten | Ersetzt Wert im RRSet, TTL Änderung | `S/dns/ZoneDetailScreen.kt:620`<br>`S/dns/ZoneDetailViewModel.kt:102` | `POST /zones/{id}/rrsets/{name}/{type}/actions/set_records`<br>`POST /zones/{id}/rrsets/{name}/{type}/actions/change_ttl` | 5 | Unit |
| DNS-011 | Record löschen | Entfernt einen Wert aus dem RRSet | `S/dns/ZoneDetailScreen.kt:627`<br>`S/dns/ZoneDetailViewModel.kt:105` | `POST /zones/{id}/rrsets/{name}/{type}/actions/remove_records` | 5 | Unit |
| DNS-012 | Mehrfachauswahl Records | Auswahl, Alle wählen (ohne SOA und Apex NS), Leeren, Zähler | `S/dns/ZoneDetailScreen.kt:460` |  | 5 | Widget |
| DNS-013 | Sammelbearbeitung | Neuer Wert und/oder TTL (mind. eins), leer heißt behalten; neuer Wert nur bei einem Typ; Bestätigung mit den betroffenen Record Sets | `S/dns/BulkEditDialog.kt:46`<br>`S/dns/ZoneDetailViewModel.kt:113` | `POST /zones/{id}/rrsets/{name}/{type}/actions/set_records` | 5 | Unit |
| DNS-014 | Sammelbearbeitung Ergebnis | "Records updated" oder Anzahl fehlgeschlagener | `S/dns/ZoneDetailScreen.kt:162` |  | 5 | Widget |
| DNS-015 | Zonendatei importieren | Datei wählen, max. 1 MiB, Bestätigung "ersetzt alle Records"; Neu: Stufe 2 | `S/dns/ZoneDetailScreen.kt:338`<br>`S/dns/ZoneDetailViewModel.kt:125` | `POST /zones/{id}/actions/import_zonefile` | 5 | Integration |
| DNS-016 | Zonendatei exportieren | BIND Datei über Dateidialog speichern | `S/dns/ZoneDetailScreen.kt:234`<br>`S/dns/ZoneDetailViewModel.kt:143` | `GET /zones/{id}/zonefile` | 5 | Integration |
| DNS-017 | Primäre Nameserver Liste | Für sekundäre Zonen: Adresse, Port und TSIG Algorithmus | `S/dns/ZoneDetailScreen.kt:512` | `GET /zones/{id}` | 5 | Golden |
| DNS-018 | Primären Server hinzufügen | Adresse Pflicht, Port 1 bis 65535 (Standard 53), TSIG Algorithmus und Schlüssel optional | `S/dns/PrimaryServerDialog.kt:35`<br>`S/dns/ZoneDetailViewModel.kt:164` | `POST /zones/{id}/actions/change_primary_nameservers` | 5 | Unit |
| DNS-019 | Primären Server bearbeiten | Gleicher Dialog; TSIG aller Server bleibt erhalten | `S/dns/PrimaryServerDialog.kt:37`<br>`S/dns/ZoneDetailViewModel.kt:167` | `POST /zones/{id}/actions/change_primary_nameservers` | 5 | Widget |
| DNS-020 | Primären Server entfernen | Bestätigung mit Adresse:Port | `S/dns/ZoneDetailScreen.kt:370`<br>`S/dns/ZoneDetailViewModel.kt:170` | `POST /zones/{id}/actions/change_primary_nameservers` | 5 | Unit |
| DNS-021 | DNS Action abwarten | Nach jeder Änderung Zone Action bis fertig verfolgen | `D/repo/DnsRepo.kt:61` | `GET /zones/actions/{id}` | 5 | Unit |
| DNS-022 | Zone sekundär anlegen | Modus primary/secondary mit primären Nameservern beim Anlegen | API neu | `POST /zones` | 5 | Widget |
| DNS-023 | RRSet Modell | Records als RRSets anzeigen und bearbeiten (Name, Typ, TTL, Werte) | API neu | `GET /zones/{id}/rrsets` | 5 | Unit |
| DNS-024 | Zone bearbeiten | Labels der Zone | API neu | `PUT /zones/{id_or_name}` | 5 | Unit |
| DNS-025 | Zone Schutz | Löschschutz der Zone | API neu | `POST /zones/{id_or_name}/actions/change_protection` | 5 | Unit |
| DNS-026 | RRSet anlegen | Name, Typ, TTL, Werte, Labels in einem Aufruf | API neu | `POST /zones/{id_or_name}/rrsets` | 5 | Unit |
| DNS-027 | RRSet einzeln | Einzelnes RRSet laden | API neu | `GET /zones/{id_or_name}/rrsets/{rr_name}/{rr_type}` | 5 | Unit |
| DNS-028 | RRSet bearbeiten | Labels des RRSets | API neu | `PUT /zones/{id_or_name}/rrsets/{rr_name}/{rr_type}` | 5 | Unit |
| DNS-029 | RRSet löschen | Ganzes RRSet löschen | API neu | `DELETE /zones/{id_or_name}/rrsets/{rr_name}/{rr_type}` | 5 | Unit |
| DNS-030 | RRSet Schutz | Änderungsschutz pro RRSet | API neu | `POST /zones/{id_or_name}/rrsets/{rr_name}/{rr_type}/actions/change_protection` | 5 | Unit |
| DNS-031 | RRSet Werte aktualisieren | Kommentare einzelner Werte ändern | API neu | `POST /zones/{id_or_name}/rrsets/{rr_name}/{rr_type}/actions/update_records` | 5 | Unit |

## Storage Boxen

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| STB-001 | Storage Box Liste | Name, Benutzer, Typ, Status (Active, Initializing, Locked, Inactive), Schutz | `S/cloud/CloudStorageBoxesTab.kt:410`<br>`S/cloud/CloudStorageBoxesTab.kt:97` | `GET /storage_boxes` | 6 | Golden |
| STB-002 | Storage Box anlegen Schritte | Location, Typ, Zugangsdaten | `S/cloud/CloudStorageBoxesTab.kt:215`<br>`S/cloud/CloudStorageBoxesTab.kt:109` | `GET /storage_box_types`<br>`GET /locations` | 6 | Widget |
| STB-003 | Storage Box anlegen Daten | Name Pflicht, Passwort mindestens 8 Zeichen | `S/cloud/CloudStorageBoxesTab.kt:224` | `POST /storage_boxes` | 6 | Unit |
| STB-004 | Storage Box anlegen Ausführung | Projekt bei Aggregat, Action verfolgen | `S/cloud/CloudStorageBoxesTab.kt:120` | `POST /storage_boxes`<br>`GET /storage_boxes/actions/{id}` | 6 | Integration |
| STB-005 | Storage Box Detail Übersicht | Benutzer, Typ, Größe, Belegt (Daten, Snapshots), Datacenter, Schutz | `S/cloud/CloudStorageBoxDetailScreen.kt:361`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:56` | `GET /storage_boxes/{id}` | 6 | Golden |
| STB-006 | Storage Box Belegung | Balken Belegt von Größe | `S/cloud/CloudStorageBoxDetailScreen.kt:383` | `GET /storage_boxes/{id}` | 6 | Golden |
| STB-007 | Zugriff SSH | Schalter, wirkt auf ganze Box | `S/cloud/CloudStorageBoxDetailScreen.kt:436`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:84` | `POST /storage_boxes/{id}/actions/update_access_settings` | 6 | Unit |
| STB-008 | Zugriff SMB | Schalter | `S/cloud/CloudStorageBoxDetailScreen.kt:437`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:81` | `POST /storage_boxes/{id}/actions/update_access_settings` | 6 | Unit |
| STB-009 | Zugriff WebDAV | Schalter | `S/cloud/CloudStorageBoxDetailScreen.kt:438`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:87` | `POST /storage_boxes/{id}/actions/update_access_settings` | 6 | Unit |
| STB-010 | Zugriff ZFS | Schalter (Snapshot Ordner sichtbar) | `S/cloud/CloudStorageBoxDetailScreen.kt:439`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:90` | `POST /storage_boxes/{id}/actions/update_access_settings` | 6 | Unit |
| STB-011 | Zugriff extern | Schalter "external access" | `S/cloud/CloudStorageBoxDetailScreen.kt:440`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:93` | `POST /storage_boxes/{id}/actions/update_access_settings` | 6 | Unit |
| STB-012 | Storage Box Passwort zurücksetzen | Neues Passwort mindestens 8 Zeichen, Bestätigung | `S/cloud/CloudStorageBoxDetailScreen.kt:703`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:77` | `POST /storage_boxes/{id}/actions/reset_password` | 6 | Unit |
| STB-013 | Snapshot Liste | Name, Datum, Größe, "automatic" Badge, Beschreibung | `S/cloud/CloudStorageBoxDetailScreen.kt:168` | `GET /storage_boxes/{id}/snapshots` | 6 | Golden |
| STB-014 | Snapshot anlegen | Beschreibung optional | `S/cloud/CloudStorageBoxDetailScreen.kt:268`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:97` | `POST /storage_boxes/{id}/snapshots` | 6 | Unit |
| STB-015 | Snapshot löschen | Bestätigung mit Name | `S/cloud/CloudStorageBoxDetailScreen.kt:281`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:101` | `DELETE /storage_boxes/{id}/snapshots/{id}` | 6 | Unit |
| STB-016 | Snapshot Rollback | Warnung alle Daten ersetzt; Neu: Stufe 2 | `S/cloud/CloudStorageBoxDetailScreen.kt:293`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:106` | `POST /storage_boxes/{id}/actions/rollback_snapshot` | 6 | Integration |
| STB-017 | Subaccount Liste | Benutzer, Home, Beschreibung, read-only Badge | `S/cloud/CloudStorageBoxDetailScreen.kt:194` | `GET /storage_boxes/{id}/subaccounts` | 6 | Golden |
| STB-018 | Subaccount anlegen | Passwort mind. 8, Home Verzeichnis Pflicht, Beschreibung, read-only, external access; Protokolle auf Box Ebene | `S/cloud/CloudStorageBoxDetailScreen.kt:782`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:110` | `POST /storage_boxes/{id}/subaccounts` | 6 | Unit |
| STB-019 | Subaccount löschen | Bestätigung | `S/cloud/CloudStorageBoxDetailScreen.kt:314`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:119` | `DELETE /storage_boxes/{id}/subaccounts/{id}` | 6 | Unit |
| STB-020 | Subaccount Passwort zurücksetzen | Neues Passwort mind. 8 | `S/cloud/CloudStorageBoxDetailScreen.kt:554`<br>`S/cloud/CloudStorageBoxDetailViewModel.kt:123` | `POST /storage_boxes/{id}/subaccounts/{id}/actions/reset_subaccount_password` | 6 | Unit |
| STB-021 | Subaccount bearbeiten | Alt nur Repository (Beschreibung, Labels) | `D/repo/CloudRepo.kt:656` | `PUT /storage_boxes/{id}/subaccounts/{id}` | 6 | Widget |
| STB-022 | Storage Box Aktivität | Letzte Actions aller Boxen | `D/api/CloudApi.kt:617` | `GET /storage_boxes/actions` | 8 | Unit |
| STB-023 | Storage Box bearbeiten | Name und Labels | API neu | `PUT /storage_boxes/{id} (api.hetzner.com)` | 6 | Unit |
| STB-024 | Storage Box löschen | Stufe 2, Name eintippen | API neu | `DELETE /storage_boxes/{id} (api.hetzner.com)` | 6 | Unit |
| STB-025 | Ordner auflisten | Ordnerauswahl für Subaccount Home | API neu | `GET /storage_boxes/{id}/folders (api.hetzner.com)` | 6 | Unit |
| STB-026 | Actions listen: storage_boxes | Aktivität im Detail der Ressource | API neu | `GET /storage_boxes/{id}/actions (api.hetzner.com)` | 6 | Unit |
| STB-027 | Action abfragen: storage_boxes | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /storage_boxes/{id}/actions/{action_id} (api.hetzner.com)` | 6 | Unit |
| STB-028 | Storage Box Schutz | Löschschutz | API neu | `POST /storage_boxes/{id}/actions/change_protection (api.hetzner.com)` | 6 | Unit |
| STB-029 | Storage Box Typ ändern | Upgrade/Downgrade mit Preis | API neu | `POST /storage_boxes/{id}/actions/change_type (api.hetzner.com)` | 6 | Unit |
| STB-030 | Snapshot Plan aus | Automatische Snapshots abschalten | API neu | `POST /storage_boxes/{id}/actions/disable_snapshot_plan (api.hetzner.com)` | 6 | Unit |
| STB-031 | Snapshot Plan an | Anzahl, Minute, Stunde, Wochentag, Monatstag | API neu | `POST /storage_boxes/{id}/actions/enable_snapshot_plan (api.hetzner.com)` | 6 | Unit |
| STB-032 | Subaccount Detail | Einzelnen Subaccount laden | API neu | `GET /storage_boxes/{id}/subaccounts/{subaccount_id} (api.hetzner.com)` | 6 | Unit |
| STB-033 | Subaccount Home ändern | Home Verzeichnis wechseln | API neu | `POST /storage_boxes/{id}/subaccounts/{subaccount_id}/actions/change_home_directory (api.hetzner.com)` | 6 | Unit |
| STB-034 | Subaccount Rechte | read-only, extern, Protokolle pro Subaccount | API neu | `POST /storage_boxes/{id}/subaccounts/{subaccount_id}/actions/update_access_settings (api.hetzner.com)` | 6 | Unit |
| STB-035 | Snapshot Detail | Einzelnen Snapshot laden | API neu | `GET /storage_boxes/{id}/snapshots/{snapshot_id} (api.hetzner.com)` | 6 | Unit |
| STB-036 | Snapshot bearbeiten | Beschreibung und Labels | API neu | `PUT /storage_boxes/{id}/snapshots/{snapshot_id} (api.hetzner.com)` | 6 | Unit |
| STB-037 | Storage Box Typ einzeln | Typdetails mit Preisen | API neu | `GET /storage_box_types/{id} (api.hetzner.com)` | 6 | Unit |

## Object Storage

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| OBJ-001 | Bucketliste | Buckets des Projekts mit S3 Zugang | `S/s3/S3Screen.kt:200`<br>`S/s3/S3Screen.kt:90` | `S3 ListBuckets` | 6 | Golden |
| OBJ-002 | Bucket anlegen | Name Pflicht, Region optional; Neu: S3 Namensregeln prüfen | `S/s3/S3Screen.kt:299`<br>`S/s3/S3Screen.kt:97` | `S3 CreateBucket` | 6 | Unit |
| OBJ-003 | Bucket löschen | Bucket muss leer sein, Bestätigung | `S/s3/S3Screen.kt:265`<br>`S/s3/S3Screen.kt:108` | `S3 DeleteBucket` | 6 | Unit |
| OBJ-004 | Bucket Einstellungen | Sheet mit Versionierung Status | `S/s3/S3Screen.kt:346`<br>`S/s3/S3Screen.kt:119` | `S3 GetBucketVersioning` | 6 | Widget |
| OBJ-005 | Versionierung an/aussetzen | Aktivieren oder Aussetzen mit Erklärung | `S/s3/S3Screen.kt:389`<br>`S/s3/S3Screen.kt:127` | `S3 PutBucketVersioning` | 6 | Unit |
| OBJ-006 | Objektbrowser | Ordner per Prefix, Navigation in Unterordner, Objektname, Größe | `S/s3/ObjectBrowserScreen.kt:277`<br>`S/s3/ObjectBrowserViewModel.kt:77` | `S3 ListObjectsV2` | 6 | Golden |
| OBJ-007 | Objekt hochladen | Datei wählen, Upload im Vordergrunddienst mit Benachrichtigung | `S/s3/ObjectBrowserScreen.kt:351`<br>`D/s3/UploadService.kt:57` | `S3 PutObject` | 6 | Integration |
| OBJ-008 | Upload Prüfung | Bucketname Regex, Key max. 1024 Zeichen ohne führendes `/` und ohne Segment `.` oder `..`, MIME Format | `D/s3/UploadService.kt:130` |  | 6 | Unit |
| OBJ-009 | Upload Benachrichtigung | Kanal "falco_uploads", Fortschritt und Ergebnis | `D/s3/UploadService.kt:176` |  | 6 | Integration |
| OBJ-010 | Objekt Info | Größe, zuletzt geändert, Content Type, ETag | `S/s3/ObjectInfoSheet.kt:45`<br>`S/s3/ObjectBrowserViewModel.kt:174` | `S3 HeadObject` | 6 | Widget |
| OBJ-011 | Freigabelink | Ablauf 1 h, 24 h, 7 Tage; Link kopieren oder teilen | `S/s3/ShareLinkDialog.kt:37`<br>`S/s3/ObjectBrowserViewModel.kt:116` | `S3 presigned GET` | 6 | Unit |
| OBJ-012 | Objekt herunterladen | Speichern in Downloads, Meldung "Download saved" | `S/s3/ObjectBrowserScreen.kt:576`<br>`S/s3/ObjectBrowserViewModel.kt:128`<br>`D/s3/S3DownloadHelper.kt` | `S3 GetObject` | 6 | Integration |
| OBJ-013 | Objekt kopieren | Ziel Bucket, Prefix optional, Ziel Key | `S/s3/CopyMoveDialog.kt:74`<br>`S/s3/ObjectBrowserViewModel.kt:141` | `S3 CopyObject` | 6 | Unit |
| OBJ-014 | Objekt verschieben | Kopieren und Quelle löschen, nur nach bestätigter Kopie; Ziel Key endet nicht auf `/` | `S/s3/ObjectBrowserScreen.kt:584`<br>`S/s3/ObjectBrowserViewModel.kt:158` | `S3 CopyObject`<br>`S3 DeleteObject` | 6 | Unit |
| OBJ-015 | Objekt löschen | Bestätigung mit Name | `S/s3/ObjectBrowserScreen.kt:374`<br>`S/s3/ObjectBrowserViewModel.kt:92` | `S3 DeleteObject` | 6 | Unit |
| OBJ-016 | Mehrfachauswahl Objekte | Auswahl, Zähler, Auswahl aufheben | `S/s3/ObjectBrowserScreen.kt:460` |  | 6 | Widget |
| OBJ-017 | Mehrere Objekte löschen | Bestätigung mit Anzahl, Teilerfolg ausgewertet | `S/s3/ObjectBrowserScreen.kt:399`<br>`S/s3/ObjectBrowserViewModel.kt:103`<br>`D/api/S3Client.kt:244` | `S3 DeleteObjects` | 6 | Unit |
| OBJ-018 | Objekt Aktionsmenü | Info, Freigabe, Herunterladen, Kopieren, Verschieben, Löschen | `S/s3/ObjectBrowserScreen.kt:568` |  | 6 | Widget |
| OBJ-019 | S3 Zugang pro Projekt | S3 Daten am Cloud Projekt, ein Endpoint pro Projekt | `S/cloud/ProjectFormScreen.kt:124` |  | 6 | Unit |
| OBJ-020 | Mehrere Standorte | Alle Standorte (fsn1, nbg1, hel1) eines Projekts gleichzeitig | API neu | `S3 ListBuckets` | 6 | Integration |
| OBJ-021 | Hintergrund Download | Download über background_downloader mit Fortschritt | API neu | `S3 GetObject` | 6 | Integration |
| OBJ-022 | Mehrteiliger Upload | Große Dateien in Teilen hochladen; scheitert das Zusammenfügen, bleiben die Teile und es wird später erneut versucht, Aufgeben bricht den Upload ab | API neu | `S3 CreateMultipartUpload` | 6 | Integration |
| OBJ-023 | Objektversionen | Versionen listen, alte Version laden oder wiederherstellen | API neu | `S3 ListObjectVersions` | 6 | Widget |
| OBJ-024 | Ordner anlegen | Leeres Prefix Objekt anlegen | API neu | `S3 PutObject` | 6 | Unit |
| OBJ-025 | Upload Link | Presigned PUT Link (alt nur Repository) | `D/repo/S3Repo.kt:35` | `S3 presigned PUT` | 6 | Unit |

## Robot

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| ROB-001 | Robot Bereich Reiter | Dedicated Server, Failover IPs, vSwitches, Reverse DNS, SSH Keys | `S/robot/RobotScreen.kt:108` |  | 7 | Widget |
| ROB-002 | Robot kein Zugriff Hinweis | Bei 401/403 pro Bereich: "Enable this section in Hetzner Robot"; ein abgelehnter Login wird erst nach einer Änderung wieder gesendet | `S/robot/FailoverTab.kt:114` |  | 7 | Widget |
| ROB-003 | Robot Ratenlimit | 429 oder 403 mit Retry-After als Drosselung melden, nie als Auth Fehler | `D/api/HttpClientFactory.kt:199` |  | 7 | Unit |
| ROB-004 | Robot Serverliste | Name oder Nummer, gekündigt Badge, IPv4, IPv6 Netz, Datacenter, bezahlt bis | `S/robot/RobotScreen.kt:220`<br>`S/robot/RobotScreen.kt:97` | `GET /server` | 7 | Golden |
| ROB-005 | Robot Liste Schnellaktionen | Reset, Wake-on-LAN aus der Zeile | `S/robot/RobotScreen.kt:311` | `POST /reset/{n}`<br>`POST /wol/{n}` | 7 | Widget |
| ROB-006 | Robot Serverdetail | Nummer, Produkt, Datacenter, Status, bezahlt bis | `S/robot/ServerDetailScreen.kt:548`<br>`S/robot/ServerDetailViewModel.kt:66` | `GET /server/{n}` | 7 | Golden |
| ROB-007 | Robot Serverdetail Netzwerk | Public IPv4, IPv6 Netz, kopierbar | `S/robot/ServerDetailScreen.kt:168` | `GET /server/{n}` | 7 | Golden |
| ROB-008 | Robot Traffic Monat | Eingehend, ausgehend, gesamt in GB für laufenden Monat | `S/robot/ServerDetailScreen.kt:187`<br>`D/repo/RobotRepo.kt:103` | `POST /traffic` | 7 | Unit |
| ROB-009 | Robot Reset | Typ wählen: Software (Ctrl+Alt+Del), Hardware, manuell durch Support, Power Cycle | `S/robot/ServerDetailScreen.kt:629`<br>`S/robot/ServerDetailViewModel.kt:176` | `POST /reset/{n}` | 7 | Widget |
| ROB-010 | Robot Wake-on-LAN | Bestätigung | `S/robot/ServerDetailScreen.kt:502`<br>`S/robot/ServerDetailViewModel.kt:186` | `POST /wol/{n}` | 7 | Unit |
| ROB-011 | Robot Rescue aktivieren | SSH Keys aus Robot optional wählen; Root Passwort einmalig; aktiv beim nächsten Reset | `S/robot/ServerDetailScreen.kt:298`<br>`S/robot/ServerDetailViewModel.kt:99` | `GET /key`<br>`GET /boot/{n}/rescue`<br>`POST /boot/{n}/rescue` | 7 | Widget |
| ROB-012 | Robot Rescue deaktivieren | Schalter | `S/robot/ServerDetailScreen.kt:242`<br>`S/robot/ServerDetailViewModel.kt:113` | `DELETE /boot/{n}/rescue` | 7 | Unit |
| ROB-013 | Robot Server Reverse DNS | IP und PTR, leer setzt Standard | `S/robot/ServerDetailScreen.kt:353`<br>`S/robot/ServerDetailViewModel.kt:126` | `POST /rdns/{ip}` | 7 | Widget |
| ROB-014 | Robot Kündigung | Datum YYYY-MM-DD oder "now", Grund optional, Standort reservieren | `S/robot/ServerDetailScreen.kt:398`<br>`S/robot/ServerDetailViewModel.kt:140` | `GET /server/{n}/cancellation`<br>`POST /server/{n}/cancellation` | 7 | Unit |
| ROB-015 | Robot Kündigung zurückziehen | Nur bei bestehender Kündigung | `S/robot/ServerDetailScreen.kt:273`<br>`S/robot/ServerDetailViewModel.kt:163` | `DELETE /server/{n}/cancellation` | 7 | Unit |
| ROB-016 | Robot Ergebnis Meldungen | "Action completed" oder "Action failed: ..." als Snackbar | `S/robot/ServerDetailScreen.kt:101` |  | 7 | Widget |
| ROB-017 | Failover Liste | IP, aktives Ziel "Active on" | `S/robot/FailoverTab.kt:187`<br>`S/robot/FailoverTab.kt:71` | `GET /failover` | 7 | Golden |
| ROB-018 | Failover routen | Ziel Server IP, muss sich vom aktuellen unterscheiden | `S/robot/FailoverTab.kt:238`<br>`S/robot/FailoverTab.kt:86` | `POST /failover/{ip}` | 7 | Unit |
| ROB-019 | Failover Routing aufheben | Bestätigung mit Folgen | `S/robot/FailoverTab.kt:154`<br>`S/robot/FailoverTab.kt:93` | `DELETE /failover/{ip}` | 7 | Unit |
| ROB-020 | rDNS Liste | IP, PTR | `S/robot/RobotRdnsTab.kt:73` | `GET /rdns` | 7 | Golden |
| ROB-021 | rDNS anlegen | IP und PTR Pflicht | `S/robot/RobotRdnsTab.kt:149`<br>`S/robot/RobotRdnsTab.kt:86` | `POST /rdns/{ip}` | 7 | Widget |
| ROB-022 | rDNS bearbeiten | IP gesperrt | `S/robot/RobotRdnsTab.kt:172` | `POST /rdns/{ip}` | 7 | Widget |
| ROB-023 | rDNS löschen | Bestätigung | `S/robot/RobotRdnsTab.kt:183`<br>`S/robot/RobotRdnsTab.kt:93` | `DELETE /rdns/{ip}` | 7 | Unit |
| ROB-024 | vSwitch Liste | Name, VLAN, ID, gekündigt Badge | `S/robot/VSwitchTab.kt:135`<br>`S/robot/VSwitchTab.kt:71` | `GET /vswitch` | 7 | Golden |
| ROB-025 | vSwitch anlegen | Name Pflicht, VLAN 4000 bis 4091 | `S/robot/VSwitchTab.kt:186`<br>`S/robot/VSwitchTab.kt:86` | `POST /vswitch` | 7 | Unit |
| ROB-026 | vSwitch Detail | ID, VLAN, Status aktiv/gekündigt | `S/robot/RobotVSwitchDetailScreen.kt:263`<br>`S/robot/RobotVSwitchDetailViewModel.kt:56` | `GET /vswitch/{id}` | 7 | Golden |
| ROB-027 | vSwitch Server Liste | Nummer, IP, Status | `S/robot/RobotVSwitchDetailScreen.kt:158` | `GET /vswitch/{id}` | 7 | Golden |
| ROB-028 | vSwitch Server hinzufügen | Server suchen und wählen | `S/robot/RobotVSwitchDetailScreen.kt:521`<br>`S/robot/RobotVSwitchDetailViewModel.kt:81` | `GET /server`<br>`POST /vswitch/{id}/server` | 7 | Widget |
| ROB-029 | vSwitch Server entfernen | Bestätigung | `S/robot/RobotVSwitchDetailScreen.kt:217`<br>`S/robot/RobotVSwitchDetailViewModel.kt:85` | `DELETE /vswitch/{id}/server` | 7 | Unit |
| ROB-030 | vSwitch bearbeiten | Name und VLAN 4000 bis 4091 | `S/robot/RobotVSwitchDetailScreen.kt:378`<br>`S/robot/RobotVSwitchDetailViewModel.kt:71` | `POST /vswitch/{id}` | 7 | Unit |
| ROB-031 | vSwitch löschen | Kündigungsdatum YYYY-MM-DD, leer sofort; Bestätigung | `S/robot/RobotVSwitchDetailScreen.kt:449`<br>`S/robot/RobotVSwitchDetailViewModel.kt:75` | `DELETE /vswitch/{id}` | 7 | Unit |
| ROB-032 | Robot SSH Key Liste | Name, Fingerprint, Typ, Bits | `S/robot/RobotSshKeysTab.kt:384`<br>`S/robot/RobotSshKeysTab.kt:96` | `GET /key` | 7 | Golden |
| ROB-033 | Robot SSH Key hinzufügen | Aus Datei oder manuell, gleiche Prüfung wie Cloud | `S/robot/RobotSshKeysTab.kt:249`<br>`S/robot/RobotSshKeysTab.kt:109` | `POST /key` | 7 | Widget |
| ROB-034 | Robot SSH Key löschen | Bestätigung | `S/robot/RobotSshKeysTab.kt:212`<br>`S/robot/RobotSshKeysTab.kt:116` | `DELETE /key/{fp}` | 7 | Unit |
| ROB-035 | Robot Reset Optionen | Verfügbare Reset Typen pro Server laden statt fest | `D/repo/RobotRepo.kt:32` | `GET /reset/{n}` | 7 | Unit |
| ROB-036 | Robot Reset Übersicht | Reset Optionen aller Server | API neu | `GET /reset` | 7 | Unit |
| ROB-037 | Robot Boot Übersicht | Aktive Boot Konfiguration (alt nur Repository) | `D/repo/RobotRepo.kt:72` | `GET /boot/{n}` | 7 | Unit |
| ROB-038 | Robot Rescue letzte Daten | Letztes Rescue Passwort und Konfiguration | API neu | `GET /boot/{n}/rescue/last` | 7 | Unit |
| ROB-039 | Robot Linux Installation | Distribution, Architektur, Sprache, Keys; aktivieren und abbrechen | API neu | `GET /boot/{n}/linux`<br>`POST /boot/{n}/linux`<br>`DELETE /boot/{n}/linux`<br>`GET /boot/{n}/linux/last` | 7 | Widget |
| ROB-040 | Robot VNC Installation | VNC Installation aktivieren und abbrechen | API neu | `GET /boot/{n}/vnc`<br>`POST /boot/{n}/vnc`<br>`DELETE /boot/{n}/vnc` | 7 | Widget |
| ROB-041 | Robot Windows Installation | Windows Installation aktivieren und abbrechen | API neu | `GET /boot/{n}/windows`<br>`POST /boot/{n}/windows`<br>`DELETE /boot/{n}/windows` | 7 | Widget |
| ROB-042 | Robot Server umbenennen | Servername setzen | API neu | `POST /server/{n}` | 7 | Widget |
| ROB-043 | Robot WoL Status | Prüfen ob WoL verfügbar | API neu | `GET /wol/{n}` | 7 | Unit |
| ROB-044 | Robot Failover Detail | Einzelne Failover IP | API neu | `GET /failover/{ip}` | 7 | Unit |
| ROB-045 | Robot rDNS einzeln | Einzelnen PTR laden (alt nur Repository) | `D/repo/RobotRepo.kt:53` | `GET /rdns/{ip}` | 7 | Unit |
| ROB-046 | Robot rDNS anlegen getrennt | PUT legt an, POST ändert; alt immer POST | API neu | `PUT /rdns/{ip}` | 7 | Unit |
| ROB-047 | Robot SSH Key Detail | Einzelnen Key laden | API neu | `GET /key/{fp}` | 7 | Unit |
| ROB-048 | Robot SSH Key umbenennen | Name ändern | API neu | `POST /key/{fp}` | 7 | Widget |
| ROB-049 | Robot IP Liste | Alle IPs mit Server, Traffic Warnungen | API neu | `GET /ip`<br>`GET /ip/{ip}` | 7 | Golden |
| ROB-050 | Robot IP Traffic Warnungen | Schwellen stündlich, täglich, monatlich setzen | API neu | `POST /ip/{ip}` | 7 | Widget |
| ROB-051 | Robot IP MAC | Separate MAC anzeigen, anlegen, löschen | API neu | `GET /ip/{ip}/mac`<br>`PUT /ip/{ip}/mac`<br>`DELETE /ip/{ip}/mac` | 7 | Widget |
| ROB-052 | Robot IP Kündigung | Kündigung anzeigen, setzen, zurückziehen | API neu | `GET /ip/{ip}/cancellation`<br>`POST /ip/{ip}/cancellation`<br>`DELETE /ip/{ip}/cancellation` | 7 | Widget |
| ROB-053 | Robot Subnetz Liste | Subnetze mit Server, Gateway, Maske | API neu | `GET /subnet`<br>`GET /subnet/{ip}` | 7 | Golden |
| ROB-054 | Robot Subnetz Traffic Warnungen | Schwellen setzen | API neu | `POST /subnet/{ip}` | 7 | Widget |
| ROB-055 | Robot Subnetz MAC | MAC anzeigen, setzen, löschen | API neu | `GET /subnet/{ip}/mac`<br>`PUT /subnet/{ip}/mac`<br>`DELETE /subnet/{ip}/mac` | 7 | Widget |
| ROB-056 | Robot Subnetz Kündigung | Kündigung anzeigen, setzen, zurückziehen | API neu | `GET /subnet/{ip}/cancellation`<br>`POST /subnet/{ip}/cancellation`<br>`DELETE /subnet/{ip}/cancellation` | 7 | Widget |
| ROB-057 | Robot Firewall | Server Firewall Status, Regeln (mit TCP Flags), Filter IPv6, Hetzner Dienste | API neu | `GET /firewall/{n}`<br>`POST /firewall/{n}`<br>`DELETE /firewall/{n}` | 7 | Widget |
| ROB-058 | Robot Firewall Vorlagen | Vorlagen listen, anlegen, ändern, löschen | API neu | `GET /firewall/template`<br>`POST /firewall/template`<br>`GET /firewall/template/{id}`<br>`POST /firewall/template/{id}`<br>`DELETE /firewall/template/{id}` | 7 | Widget |
| ROB-059 | Robot Traffic Abfrage | Traffic frei wählbar nach Zeitraum (Tag, Monat, Jahr) pro IP/Subnetz | `D/repo/RobotRepo.kt:94` | `POST /traffic` | 7 | Golden |
| ROB-060 | Robot Bestellung | Server, Serverbörse, Addons bestellen; nur nach Entscheidung, Kaufbestätigung Pflicht | API neu | `GET /order/server/product`<br>`POST /order/server/transaction`<br>`GET /order/server_market/product`<br>`POST /order/server_market/transaction`<br>`GET /order/server_addon/{n}/product`<br>`POST /order/server_addon/transaction` | 7 | Integration |

## Suche & Aktivität

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| SUC-001 | Suche Eingabe | Feld "Search…", Hinweis vor Eingabe, "Nothing matches" | `S/search/SearchScreen.kt:98`<br>`S/search/SearchViewModel.kt:111` |  | 8 | Widget |
| SUC-002 | Suche Index | Lädt alle Ressourcen aller Projekte plus Robot Server und DNS Zonen | `S/search/SearchViewModel.kt:102` | `GET /servers`<br>`GET /volumes`<br>`GET /networks`<br>`GET /floating_ips`<br>`GET /primary_ips`<br>`GET /firewalls`<br>`GET /load_balancers`<br>`GET /certificates`<br>`GET /placement_groups`<br>`GET /ssh_keys`<br>`GET /storage_boxes`<br>`GET /zones`<br>`GET /server` | 8 | Unit |
| SUC-003 | Suche Ergebnisgruppen | Server, Dedicated, Volumes, Netzwerke, Floating IPs, Firewalls, Storage Boxen, Zonen, SSH Keys, LB, Zertifikate, Placement Groups | `S/search/SearchScreen.kt:213` |  | 8 | Golden |
| SUC-004 | Suche Treffer Unterzeile | z. B. Netzwerk IP Bereich, SSH Key Fingerprint, Zone Anzahl Records, Storage Box Benutzer | `S/search/SearchViewModel.kt:154` |  | 8 | Unit |
| SUC-005 | Suche Treffer öffnen | Setzt Projekt und öffnet Detail; Neu: jeder Treffer öffnet ein Ziel inkl. Primary IP, Zertifikat, Placement Group, SSH Key | `S/search/SearchViewModel.kt:124` |  | 8 | Integration |
| SUC-006 | Aktivität Projekt | Actions aller Ressourcentypen eines Projekts, sortiert | `S/cloud/CloudActivityScreen.kt:124`<br>`D/repo/CloudRepo.kt:438` | `GET /{resource}/actions` | 8 | Unit |
| SUC-007 | Aktivität Filter | Alle, Laufend, Fehlgeschlagen | `S/cloud/CloudActivityScreen.kt:153` |  | 8 | Widget |
| SUC-008 | Aktivität Gruppierung | Heute, Gestern, Datum | `S/cloud/CloudActivityScreen.kt:88` |  | 8 | Unit |
| SUC-009 | Aktivitätszeile | Befehl, Ressource, Start, Ende, Status done/running/failed, Fortschritt | `C/ActivityRow.kt:84` |  | 8 | Golden |
| SUC-010 | Aktivität aktualisieren | Refresh Button und Pull to Refresh | `S/cloud/CloudActivityScreen.kt:132` |  | 8 | Widget |
| SUC-011 | Volume Aktivität | Actions eines Volumes im Detail (alt deklariert, nicht genutzt) | `D/api/CloudApi.kt:395` | `GET /volumes/{id}/actions` | 8 | Widget |
| SUC-012 | Aktivität Einstieg | Symbol in Cloud Kopfzeile | `S/cloud/CloudHubScreen.kt:131` |  | 8 | Widget |
| SUC-013 | Action abfragen: actions | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /actions` | 8 | Unit |
| SUC-014 | Action abfragen: certificates | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /certificates/actions/{id}` | 8 | Unit |
| SUC-015 | Actions listen: certificates | Aktivität im Detail der Ressource | API neu | `GET /certificates/{id}/actions` | 8 | Unit |
| SUC-016 | Action abfragen: certificates | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /certificates/{id}/actions/{action_id}` | 8 | Unit |
| SUC-017 | Action abfragen: firewalls | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /firewalls/actions/{id}` | 8 | Unit |
| SUC-018 | Actions listen: firewalls | Aktivität im Detail der Ressource | API neu | `GET /firewalls/{id}/actions` | 8 | Unit |
| SUC-019 | Action abfragen: firewalls | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /firewalls/{id}/actions/{action_id}` | 8 | Unit |
| SUC-020 | Action abfragen: floating_ips | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /floating_ips/actions/{id}` | 8 | Unit |
| SUC-021 | Actions listen: floating_ips | Aktivität im Detail der Ressource | API neu | `GET /floating_ips/{id}/actions` | 8 | Unit |
| SUC-022 | Action abfragen: floating_ips | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /floating_ips/{id}/actions/{action_id}` | 8 | Unit |
| SUC-023 | Action abfragen: images | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /images/actions/{id}` | 8 | Unit |
| SUC-024 | Actions listen: images | Aktivität im Detail der Ressource | API neu | `GET /images/{id}/actions` | 8 | Unit |
| SUC-025 | Action abfragen: images | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /images/{id}/actions/{action_id}` | 8 | Unit |
| SUC-026 | Action abfragen: load_balancers | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /load_balancers/actions/{id}` | 8 | Unit |
| SUC-027 | Actions listen: load_balancers | Aktivität im Detail der Ressource | API neu | `GET /load_balancers/{id}/actions` | 8 | Unit |
| SUC-028 | Action abfragen: load_balancers | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /load_balancers/{id}/actions/{action_id}` | 8 | Unit |
| SUC-029 | Action abfragen: networks | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /networks/actions/{id}` | 8 | Unit |
| SUC-030 | Actions listen: networks | Aktivität im Detail der Ressource | API neu | `GET /networks/{id}/actions` | 8 | Unit |
| SUC-031 | Action abfragen: networks | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /networks/{id}/actions/{action_id}` | 8 | Unit |
| SUC-032 | Action abfragen: primary_ips | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /primary_ips/actions/{id}` | 8 | Unit |
| SUC-033 | Actions listen: primary_ips | Aktivität im Detail der Ressource | API neu | `GET /primary_ips/{id}/actions` | 8 | Unit |
| SUC-034 | Action abfragen: primary_ips | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /primary_ips/{id}/actions/{action_id}` | 8 | Unit |
| SUC-035 | Action abfragen: servers | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /servers/actions/{id}` | 8 | Unit |
| SUC-036 | Action abfragen: servers | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /servers/{id}/actions/{action_id}` | 8 | Unit |
| SUC-037 | Action abfragen: volumes | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /volumes/actions/{id}` | 8 | Unit |
| SUC-038 | Action abfragen: volumes | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /volumes/{id}/actions/{action_id}` | 8 | Unit |
| SUC-039 | Actions listen: zones | Aktivität im Detail der Ressource | API neu | `GET /zones/{id_or_name}/actions` | 8 | Unit |
| SUC-040 | Action abfragen: zones | Fortschritt laufender Actions verfolgen (ActionTracker) | API neu | `GET /zones/{id_or_name}/actions/{action_id}` | 8 | Unit |

## Querschnitt

| ID | Funktion | Details/Regeln | Quelle | API Endpunkt(e) | Phase | Test |
|---|---|---|---|---|---|---|
| QRS-001 | Navigation Bereiche | Alt Drawer: Cloud, Robot, DNS, Storage, Suche, Accounts, Einstellungen, Über; Neu: 4 Ziele unten plus Suche und Aktivität | `ui/nav/NavShell.kt:95` |  | 3 | Widget |
| QRS-002 | Navigation Account Kopf | Account Wechsler im Drawer Kopf | `ui/nav/NavShell.kt:513` |  | 3 | Widget |
| QRS-003 | Routen | Detailrouten mit ID; Neu: Scope in jeder Route | `ui/nav/Routes.kt:5` |  | 2 | Unit |
| QRS-004 | Pull to Refresh | Auf allen Listen und Details | `S/cloud/CloudScreen.kt:177` |  | 9 | Widget |
| QRS-005 | Fehlerzustand | Fehlerkarte mit "Retry" | `C/ErrorState.kt:52` |  | 1 | Golden |
| QRS-006 | Ladezustand | Ladeanzeige; Neu Skeleton | `C/LoadingState.kt:45` |  | 1 | Golden |
| QRS-007 | Leerzustand | "Nothing here yet." plus Aktion | `C/EmptyState.kt` |  | 1 | Golden |
| QRS-008 | Aktionssheet | Gruppierte Aktionen im Bottom Sheet | `C/dialog/ActionsBottomSheet.kt` |  | 1 | Golden |
| QRS-009 | Bestätigung einfach | "%s?" mit Folgen, Abbrechen | `C/dialog/ConfirmDestructiveDialog.kt:40` |  | 1 | Widget |
| QRS-010 | Bestätigung Name eintippen | Löschen erst nach Eingabe des Namens | `C/dialog/TypeToConfirmDeleteDialog.kt:82` |  | 1 | Widget |
| QRS-011 | Statuskomponente | Running, Off, Starting, Stopping, Initializing, Rebuilding, Migrating, Deleting | `C/Console.kt:77` |  | 1 | Golden |
| QRS-012 | Detailbausteine | HeroCard, KpiStrip, ActionStrip, DetailSection | `C/detail/HeroCard.kt` |  | 1 | Golden |
| QRS-013 | Wizard Gerüst | Schritte, Zurück, Weiter, Erstellen, Auswahlkarten | `C/wizard/WizardScaffold.kt`<br>`C/wizard/PickCard.kt` |  | 1 | Golden |
| QRS-014 | Liniendiagramm | Mehrere Serien, Achsen, Min/Max | `C/LineChart.kt:107` |  | 1 | Golden |
| QRS-015 | Byte Formatierung | Einheitliche Bytes Ausgabe | `ui/util/ByteFormat.kt` |  | 2 | Unit |
| QRS-016 | Pagination | Alle Seiten laden über meta.pagination | `D/api/Paging.kt:14` |  | 2 | Unit |
| QRS-017 | Zertifikat Pinning | api.hetzner.cloud, api.hetzner.com, robot-ws.your-server.de, fsn1/hel1/nbg1.your-objectstorage.com | `D/api/Pins.kt:52` |  | 2 | Integration |
| QRS-018 | TLS Mindestversion | TLS 1.2 und 1.3, restriktive Cipher | `D/api/HttpClientFactory.kt:40` |  | 2 | Unit |
| QRS-019 | Klartext verboten | http für S3 abgelehnt | `D/api/S3Client.kt:32` |  | 2 | Unit |
| QRS-020 | Zeitlimits | Connect 15 s, Read/Write 30 s, kein automatischer Retry von POST | `D/api/HttpClientFactory.kt:58` |  | 2 | Unit |
| QRS-021 | Rechtefehler | 403 Cloud als PermissionDenied klar gemeldet | `D/api/PermissionDeniedException.kt` |  | 2 | Unit |
| QRS-022 | Aggregat Laden | Listen über alle Projekte parallel, Projekt ID pro Eintrag | `D/repo/CloudRepo.kt:193` |  | 3 | Unit |
| QRS-023 | Benachrichtigungen | Nur Uploads (Kanal falco_uploads) | `D/s3/UploadService.kt:176` |  | 6 | Integration |
| QRS-024 | Teilen | System Share Sheet für Freigabelinks | `S/s3/ShareLinkDialog.kt:176` |  | 6 | Widget |
| QRS-025 | Dateiauswahl | SSH Key aus Datei, Zonendatei Import, Upload Quelle | `S/cloud/CloudSshKeysTab.kt:167` |  | 4 | Integration |
| QRS-026 | Barrierefreiheit | Screenreader Labels, Kontraste, Schriftgrößen |  |  | 9 | Widget |
| QRS-027 | Tablet Layout | Liste und Detail nebeneinander, Navigation Rail |  |  | 9 | Golden |
| QRS-028 | Action Tracker | Laufende Actions bis Ende verfolgen, betroffene Ressource neu laden, Fortschritt am Objekt | `D/repo/DnsRepo.kt:61` | `GET /actions/{id}` | 2 | Unit |
| QRS-029 | Bereichsübersicht | Jeder Bereich der unteren Navigation öffnet eine Übersicht: pro Ressourcentyp eine Kachel mit Anzahl und Status, Server mit ihren ersten Zeilen; keine scrollenden Tabs |  |  | 9 | Golden |
| QRS-030 | Aktionsleiste im Detail | Alle Aktionen einer Ressource unten: höchstens drei als Knopf mit vollem Text, der Rest im Blatt "Mehr"; genau ein Anlegen pro Screen (FAB), leere Listen ohne Knopf |  |  | 9 | Golden |

## Endpunkt Zuordnung alte App

Jeder Endpunkt, den Falco 2.x deklariert, mit Fundstelle und den Zeilen, die ihn abdecken. "keine Zeile" heißt: im alten Code deklariert, aber nirgends genutzt.

| Host | Methode und Pfad | Kotlin | Funktion | Zeilen |
|---|---|---|---|---|
| cloud | `GET /servers` | `D/api/CloudApi.kt:31` | `listServers` | ONB-017, CMP-002, CMP-003, CMP-051, CMP-059, NET-003, NET-019, NET-032, SUC-002 |
| cloud | `POST /servers` | `D/api/CloudApi.kt:37` | `createServer` | CMP-012, CMP-013, CMP-014, CMP-081, CMP-082, CMP-083, CMP-084, CMP-085, CMP-086 |
| cloud | `POST /servers/{id}/actions/poweron` | `D/api/CloudApi.kt:42` | `powerOn` | CMP-005, CMP-022 |
| cloud | `POST /servers/{id}/actions/poweroff` | `D/api/CloudApi.kt:45` | `powerOff` | CMP-005, CMP-023 |
| cloud | `POST /servers/{id}/actions/reboot` | `D/api/CloudApi.kt:48` | `reboot` | CMP-005, CMP-020 |
| cloud | `POST /servers/{id}/actions/shutdown` | `D/api/CloudApi.kt:51` | `shutdown` | CMP-005, CMP-021 |
| cloud | `POST /servers/{id}/actions/reset` | `D/api/CloudApi.kt:54` | `reset` | CMP-005, CMP-024 |
| cloud | `POST /servers/{id}/actions/create_image` | `D/api/CloudApi.kt:57` | `snapshot` | CMP-005, CMP-025, CMP-089 |
| cloud | `GET /volumes` | `D/api/CloudApi.kt:60` | `listVolumes` | CMP-050, SUC-002 |
| cloud | `GET /volumes/{id}` | `D/api/CloudApi.kt:63` | `getVolume` | CMP-057, CMP-058 |
| cloud | `POST /volumes` | `D/api/CloudApi.kt:66` | `createVolume` | CMP-053, CMP-054, CMP-056 |
| cloud | `PUT /volumes/{id}` | `D/api/CloudApi.kt:71` | `updateVolume` | CMP-062, CMP-088 |
| cloud | `DELETE /volumes/{id}` | `D/api/CloudApi.kt:77` | `deleteVolume` | CMP-064 |
| cloud | `POST /volumes/{id}/actions/attach` | `D/api/CloudApi.kt:80` | `attachVolume` | CMP-059 |
| cloud | `POST /volumes/{id}/actions/detach` | `D/api/CloudApi.kt:86` | `detachVolume` | CMP-060 |
| cloud | `POST /volumes/{id}/actions/resize` | `D/api/CloudApi.kt:89` | `resizeVolume` | CMP-061 |
| cloud | `POST /volumes/{id}/actions/change_protection` | `D/api/CloudApi.kt:95` | `changeVolumeProtection` | CMP-063 |
| cloud | `GET /firewalls` | `D/api/CloudApi.kt:101` | `listFirewalls` | NET-001, SUC-002 |
| cloud | `POST /firewalls` | `D/api/CloudApi.kt:104` | `createFirewall` | NET-002 |
| cloud | `GET /floating_ips` | `D/api/CloudApi.kt:109` | `listFloatingIps` | NET-018, SUC-002 |
| cloud | `GET /networks` | `D/api/CloudApi.kt:112` | `listNetworks` | CMP-040, NET-039, SUC-002 |
| cloud | `GET /servers/{id}` | `D/api/CloudApi.kt:115` | `getServer` | CMP-015, CMP-016, CMP-017, CMP-018, CMP-019 |
| cloud | `PUT /servers/{id}` | `D/api/CloudApi.kt:118` | `updateServer` | CMP-047, CMP-087 |
| cloud | `DELETE /servers/{id}` | `D/api/CloudApi.kt:124` | `deleteServer` | CMP-048 |
| cloud | `POST /servers/{id}/actions/reset_password` | `D/api/CloudApi.kt:127` | `resetServerPassword` | CMP-030 |
| cloud | `POST /servers/{id}/actions/rebuild` | `D/api/CloudApi.kt:130` | `rebuildServer` | CMP-031, CMP-032 |
| cloud | `POST /servers/{id}/actions/enable_rescue` | `D/api/CloudApi.kt:136` | `enableRescue` | CMP-039 |
| cloud | `POST /servers/{id}/actions/disable_rescue` | `D/api/CloudApi.kt:142` | `disableRescue` | CMP-039 |
| cloud | `POST /servers/{id}/actions/enable_backup` | `D/api/CloudApi.kt:145` | `enableBackup` | CMP-038 |
| cloud | `POST /servers/{id}/actions/disable_backup` | `D/api/CloudApi.kt:148` | `disableBackup` | CMP-038 |
| cloud | `POST /servers/{id}/actions/attach_iso` | `D/api/CloudApi.kt:151` | `attachIso` | CMP-035 |
| cloud | `POST /servers/{id}/actions/detach_iso` | `D/api/CloudApi.kt:157` | `detachIso` | CMP-036 |
| cloud | `POST /servers/{id}/actions/change_type` | `D/api/CloudApi.kt:160` | `changeServerType` | CMP-033, CMP-034 |
| cloud | `POST /servers/{id}/actions/change_protection` | `D/api/CloudApi.kt:166` | `changeServerProtection` | CMP-046 |
| cloud | `POST /servers/{id}/actions/attach_to_network` | `D/api/CloudApi.kt:172` | `attachServerToNetwork` | CMP-040 |
| cloud | `POST /servers/{id}/actions/detach_from_network` | `D/api/CloudApi.kt:178` | `detachServerFromNetwork` | CMP-041 |
| cloud | `POST /servers/{id}/actions/change_alias_ips` | `D/api/CloudApi.kt:184` | `changeServerAliasIps` | NET-086 |
| cloud | `POST /servers/{id}/actions/add_to_placement_group` | `D/api/CloudApi.kt:190` | `addServerToPlacementGroup` | CMP-043 |
| cloud | `POST /servers/{id}/actions/remove_from_placement_group` | `D/api/CloudApi.kt:196` | `removeServerFromPlacementGroup` | CMP-044 |
| cloud | `GET /{collection}/actions` | `D/api/CloudApi.kt:201` | `listCollectionActions` | SUC-006 |
| cloud | `GET /servers/{id}/actions` | `D/api/CloudApi.kt:208` | `listServerActions` | CMP-045 |
| cloud | `POST /servers/{id}/actions/change_dns_ptr` | `D/api/CloudApi.kt:215` | `changeServerDnsPtr` | CMP-042 |
| cloud | `POST /servers/{id}/actions/request_console` | `D/api/CloudApi.kt:221` | `requestServerConsole` | CMP-026 |
| cloud | `GET /servers/{id}/metrics` | `D/api/CloudApi.kt:226` | `serverMetrics` | CMP-027, CMP-028 |
| cloud | `GET /images` | `D/api/CloudApi.kt:235` | `listImages` | CMP-008, CMP-009, CMP-031, CMP-077, CMP-090 |
| cloud | `GET /server_types` | `D/api/CloudApi.kt:245` | `listServerTypes` | CMP-008, CMP-009, CMP-010, CMP-033 |
| cloud | `GET /isos` | `D/api/CloudApi.kt:248` | `listIsos` | CMP-035 |
| cloud | `GET /firewalls/{id}` | `D/api/CloudApi.kt:251` | `getFirewall` | NET-004, NET-013 |
| cloud | `PUT /firewalls/{id}` | `D/api/CloudApi.kt:254` | `updateFirewall` | NET-016, NET-090 |
| cloud | `DELETE /firewalls/{id}` | `D/api/CloudApi.kt:260` | `deleteFirewall` | NET-017 |
| cloud | `POST /firewalls/{id}/actions/set_rules` | `D/api/CloudApi.kt:263` | `setFirewallRules` | NET-005, NET-011, NET-012 |
| cloud | `POST /firewalls/{id}/actions/apply_to_resources` | `D/api/CloudApi.kt:269` | `applyFirewall` | NET-003, NET-014, NET-089 |
| cloud | `POST /firewalls/{id}/actions/remove_from_resources` | `D/api/CloudApi.kt:275` | `removeFirewall` | NET-015 |
| cloud | `GET /ssh_keys` | `D/api/CloudApi.kt:283` | `listSshKeys` | CMP-008, CMP-009, CMP-011, CMP-070, SUC-002 |
| cloud | `POST /ssh_keys` | `D/api/CloudApi.kt:286` | `createSshKey` | CMP-071, CMP-074 |
| cloud | `PUT /ssh_keys/{id}` | `D/api/CloudApi.kt:291` | `updateSshKey` | CMP-076 |
| cloud | `DELETE /ssh_keys/{id}` | `D/api/CloudApi.kt:297` | `deleteSshKey` | CMP-075 |
| cloud | `POST /floating_ips` | `D/api/CloudApi.kt:302` | `createFloatingIp` | NET-022, NET-023 |
| cloud | `GET /floating_ips/{id}` | `D/api/CloudApi.kt:307` | `getFloatingIp` | NET-024 |
| cloud | `PUT /floating_ips/{id}` | `D/api/CloudApi.kt:310` | `updateFloatingIp` | NET-028, NET-090 |
| cloud | `DELETE /floating_ips/{id}` | `D/api/CloudApi.kt:316` | `deleteFloatingIp` | NET-030 |
| cloud | `POST /floating_ips/{id}/actions/assign` | `D/api/CloudApi.kt:319` | `assignFloatingIp` | NET-025 |
| cloud | `POST /floating_ips/{id}/actions/unassign` | `D/api/CloudApi.kt:325` | `unassignFloatingIp` | NET-026 |
| cloud | `POST /floating_ips/{id}/actions/change_dns_ptr` | `D/api/CloudApi.kt:328` | `changeFloatingIpDnsPtr` | NET-027 |
| cloud | `POST /floating_ips/{id}/actions/change_protection` | `D/api/CloudApi.kt:334` | `changeFloatingIpProtection` | NET-029 |
| cloud | `GET /networks/{id}` | `D/api/CloudApi.kt:342` | `getNetwork` | NET-043, NET-044, NET-045, NET-048 |
| cloud | `POST /networks` | `D/api/CloudApi.kt:345` | `createNetwork` | NET-040, NET-041, NET-042 |
| cloud | `PUT /networks/{id}` | `D/api/CloudApi.kt:350` | `updateNetwork` | NET-052, NET-053, NET-090 |
| cloud | `DELETE /networks/{id}` | `D/api/CloudApi.kt:356` | `deleteNetwork` | NET-055 |
| cloud | `POST /networks/{id}/actions/add_subnet` | `D/api/CloudApi.kt:359` | `addNetworkSubnet` | NET-046 |
| cloud | `POST /networks/{id}/actions/delete_subnet` | `D/api/CloudApi.kt:365` | `deleteNetworkSubnet` | NET-047 |
| cloud | `POST /networks/{id}/actions/change_protection` | `D/api/CloudApi.kt:371` | `changeNetworkProtection` | NET-054 |
| cloud | `POST /networks/{id}/actions/add_route` | `D/api/CloudApi.kt:377` | `addNetworkRoute` | NET-049 |
| cloud | `POST /networks/{id}/actions/delete_route` | `D/api/CloudApi.kt:383` | `deleteNetworkRoute` | NET-050 |
| cloud | `POST /networks/{id}/actions/change_ip_range` | `D/api/CloudApi.kt:389` | `changeNetworkIpRange` | NET-051 |
| cloud | `GET /volumes/{id}/actions` | `D/api/CloudApi.kt:395` | `listVolumeActions` | SUC-011 |
| cloud | `GET /primary_ips` | `D/api/CloudApi.kt:404` | `listPrimaryIps` | NET-031, SUC-002 |
| cloud | `GET /primary_ips/{id}` | `D/api/CloudApi.kt:407` | `getPrimaryIp` | NET-034 |
| cloud | `POST /primary_ips` | `D/api/CloudApi.kt:410` | `createPrimaryIp` | NET-033 |
| cloud | `DELETE /primary_ips/{id}` | `D/api/CloudApi.kt:415` | `deletePrimaryIp` | NET-038 |
| cloud | `POST /primary_ips/{id}/actions/assign` | `D/api/CloudApi.kt:418` | `assignPrimaryIp` | NET-035 |
| cloud | `POST /primary_ips/{id}/actions/unassign` | `D/api/CloudApi.kt:424` | `unassignPrimaryIp` | NET-036 |
| cloud | `POST /primary_ips/{id}/actions/change_protection` | `D/api/CloudApi.kt:427` | `changePrimaryIpProtection` | NET-037 |
| cloud | `GET /locations` | `D/api/CloudApi.kt:435` | `listLocations` | CMP-008, CMP-009, CMP-051, CMP-079, NET-019, NET-032, STB-002 |
| cloud | `GET /datacenters` | `D/api/CloudApi.kt:438` | `listDatacenters` | CMP-080 |
| cloud | `GET /actions/{id}` | `D/api/CloudApi.kt:443` | `getAction` | QRS-028 |
| cloud | `GET /load_balancers` | `D/api/CloudApi.kt:448` | `listLoadBalancers` | NET-056, SUC-002 |
| cloud | `GET /load_balancers/{id}` | `D/api/CloudApi.kt:451` | `getLoadBalancer` | NET-057, NET-058, NET-059, NET-063 |
| cloud | `POST /load_balancers` | `D/api/CloudApi.kt:454` | `createLoadBalancer` | NET-074 |
| cloud | `PUT /load_balancers/{id}` | `D/api/CloudApi.kt:459` | `updateLoadBalancer` | NET-072, NET-090 |
| cloud | `DELETE /load_balancers/{id}` | `D/api/CloudApi.kt:465` | `deleteLoadBalancer` | NET-073 |
| cloud | `POST /load_balancers/{id}/actions/add_service` | `D/api/CloudApi.kt:468` | `addLoadBalancerService` | NET-060, NET-088 |
| cloud | `POST /load_balancers/{id}/actions/update_service` | `D/api/CloudApi.kt:474` | `updateLoadBalancerService` | NET-061, NET-087 |
| cloud | `POST /load_balancers/{id}/actions/delete_service` | `D/api/CloudApi.kt:480` | `deleteLoadBalancerService` | NET-062 |
| cloud | `POST /load_balancers/{id}/actions/add_target` | `D/api/CloudApi.kt:486` | `addLoadBalancerTarget` | NET-064, NET-065, NET-066 |
| cloud | `POST /load_balancers/{id}/actions/remove_target` | `D/api/CloudApi.kt:492` | `removeLoadBalancerTarget` | NET-067 |
| cloud | `POST /load_balancers/{id}/actions/change_algorithm` | `D/api/CloudApi.kt:498` | `changeLoadBalancerAlgorithm` | NET-068 |
| cloud | `POST /load_balancers/{id}/actions/change_type` | `D/api/CloudApi.kt:504` | `changeLoadBalancerType` | NET-069 |
| cloud | `POST /load_balancers/{id}/actions/attach_to_network` | `D/api/CloudApi.kt:510` | `attachLoadBalancerToNetwork` | NET-075 |
| cloud | `POST /load_balancers/{id}/actions/detach_from_network` | `D/api/CloudApi.kt:516` | `detachLoadBalancerFromNetwork` | NET-076 |
| cloud | `POST /load_balancers/{id}/actions/enable_public_interface` | `D/api/CloudApi.kt:522` | `enableLoadBalancerPublicInterface` | NET-070 |
| cloud | `POST /load_balancers/{id}/actions/disable_public_interface` | `D/api/CloudApi.kt:525` | `disableLoadBalancerPublicInterface` | NET-070 |
| cloud | `POST /load_balancers/{id}/actions/change_protection` | `D/api/CloudApi.kt:528` | `changeLoadBalancerProtection` | NET-071 |
| cloud | `POST /load_balancers/{id}/actions/change_dns_ptr` | `D/api/CloudApi.kt:534` | `changeLoadBalancerDnsPtr` | NET-077 |
| cloud | `GET /load_balancer_types` | `D/api/CloudApi.kt:540` | `listLoadBalancerTypes` | NET-069 |
| cloud | `GET /load_balancers/{id}/metrics` | `D/api/CloudApi.kt:543` | `loadBalancerMetrics` | NET-078 |
| cloud | `GET /certificates` | `D/api/CloudApi.kt:554` | `listCertificates` | NET-079, SUC-002 |
| cloud | `GET /certificates/{id}` | `D/api/CloudApi.kt:557` | `getCertificate` | NET-082 |
| cloud | `POST /certificates` | `D/api/CloudApi.kt:560` | `createCertificate` | NET-080, NET-081 |
| cloud | `PUT /certificates/{id}` | `D/api/CloudApi.kt:565` | `updateCertificate` | NET-083, NET-090 |
| cloud | `DELETE /certificates/{id}` | `D/api/CloudApi.kt:571` | `deleteCertificate` | NET-084 |
| cloud | `POST /certificates/{id}/actions/retry` | `D/api/CloudApi.kt:574` | `retryCertificate` | NET-085 |
| cloud | `GET /placement_groups` | `D/api/CloudApi.kt:579` | `listPlacementGroups` | CMP-043, CMP-065, SUC-002 |
| cloud | `GET /placement_groups/{id}` | `D/api/CloudApi.kt:582` | `getPlacementGroup` | CMP-069 |
| cloud | `POST /placement_groups` | `D/api/CloudApi.kt:585` | `createPlacementGroup` | CMP-066, CMP-091 |
| cloud | `PUT /placement_groups/{id}` | `D/api/CloudApi.kt:590` | `updatePlacementGroup` | CMP-067 |
| cloud | `DELETE /placement_groups/{id}` | `D/api/CloudApi.kt:596` | `deletePlacementGroup` | CMP-068 |
| cloud | `GET /isos/{id}` | `D/api/CloudApi.kt:601` | `getIso` | CMP-037 |
| cloud | `GET /pricing` | `D/api/CloudApi.kt:606` | `getPricing` | CMP-055, CMP-078 |
| sb | `GET /storage_boxes/actions` | `D/api/CloudApi.kt:617` | `listStorageBoxActions` | STB-022 |
| sb | `GET /storage_boxes` | `D/api/CloudApi.kt:623` | `listStorageBoxes` | STB-001, SUC-002 |
| sb | `GET /storage_boxes/{id}` | `D/api/CloudApi.kt:626` | `getStorageBox` | STB-005, STB-006 |
| sb | `POST /storage_boxes` | `D/api/CloudApi.kt:629` | `createStorageBox` | STB-003, STB-004 |
| sb | `GET /storage_box_types` | `D/api/CloudApi.kt:634` | `listStorageBoxTypes` | STB-002 |
| sb | `GET /storage_boxes/actions/{id}` | `D/api/CloudApi.kt:637` | `getStorageBoxAction` | STB-004 |
| sb | `POST /storage_boxes/{id}/actions/reset_password` | `D/api/CloudApi.kt:640` | `resetStorageBoxPassword` | STB-012 |
| sb | `POST /storage_boxes/{id}/actions/update_access_settings` | `D/api/CloudApi.kt:646` | `updateStorageBoxAccessSettings` | STB-007, STB-008, STB-009, STB-010, STB-011 |
| sb | `GET /storage_boxes/{id}/snapshots` | `D/api/CloudApi.kt:652` | `listStorageBoxSnapshots` | STB-013 |
| sb | `POST /storage_boxes/{id}/snapshots` | `D/api/CloudApi.kt:655` | `createStorageBoxSnapshot` | STB-014 |
| sb | `DELETE /storage_boxes/{id}/snapshots/{snap}` | `D/api/CloudApi.kt:661` | `deleteStorageBoxSnapshot` | STB-015 |
| sb | `POST /storage_boxes/{id}/actions/rollback_snapshot` | `D/api/CloudApi.kt:667` | `rollbackStorageBoxSnapshot` | STB-016 |
| sb | `GET /storage_boxes/{id}/subaccounts` | `D/api/CloudApi.kt:673` | `listStorageBoxSubaccounts` | STB-017 |
| sb | `POST /storage_boxes/{id}/subaccounts` | `D/api/CloudApi.kt:676` | `createStorageBoxSubaccount` | STB-018 |
| sb | `DELETE /storage_boxes/{id}/subaccounts/{sub}` | `D/api/CloudApi.kt:682` | `deleteStorageBoxSubaccount` | STB-019 |
| sb | `PUT /storage_boxes/{id}/subaccounts/{sub}` | `D/api/CloudApi.kt:688` | `updateStorageBoxSubaccount` | STB-021 |
| sb | `POST /storage_boxes/{id}/subaccounts/{sub}/actions/reset_subaccount_password` | `D/api/CloudApi.kt:695` | `resetSubaccountPassword` | STB-020 |
| cloud | `GET /zones` | `D/api/DnsApi.kt:24` | `listZones` | DNS-001, SUC-002 |
| cloud | `GET /zones/{zone}` | `D/api/DnsApi.kt:30` | `getZone` | DNS-005, DNS-017 |
| cloud | `POST /zones` | `D/api/DnsApi.kt:33` | `createZone` | DNS-002, DNS-022 |
| cloud | `DELETE /zones/{zone}` | `D/api/DnsApi.kt:36` | `deleteZone` | DNS-004 |
| cloud | `POST /zones/{zone}/actions/change_ttl` | `D/api/DnsApi.kt:39` | `changeZoneTtl` | DNS-003 |
| cloud | `GET /zones/{zone}/zonefile` | `D/api/DnsApi.kt:42` | `exportZonefile` | DNS-016 |
| cloud | `POST /zones/{zone}/actions/import_zonefile` | `D/api/DnsApi.kt:45` | `importZonefile` | DNS-015 |
| cloud | `POST /zones/{zone}/actions/change_primary_nameservers` | `D/api/DnsApi.kt:48` | `changePrimaryNameservers` | DNS-018, DNS-019, DNS-020 |
| cloud | `GET /zones/actions/{id}` | `D/api/DnsApi.kt:54` | `getAction` | DNS-021 |
| cloud | `GET /zones/{zone}/rrsets` | `D/api/DnsApi.kt:57` | `listRRSets` | DNS-005, DNS-006, DNS-023 |
| cloud | `POST /zones/{zone}/rrsets/{name}/{type}/actions/add_records` | `D/api/DnsApi.kt:64` | `addRecords` | DNS-007 |
| cloud | `POST /zones/{zone}/rrsets/{name}/{type}/actions/set_records` | `D/api/DnsApi.kt:72` | `setRecords` | DNS-010, DNS-013 |
| cloud | `POST /zones/{zone}/rrsets/{name}/{type}/actions/remove_records` | `D/api/DnsApi.kt:80` | `removeRecords` | DNS-011 |
| cloud | `POST /zones/{zone}/rrsets/{name}/{type}/actions/change_ttl` | `D/api/DnsApi.kt:88` | `changeRRSetTtl` | DNS-007, DNS-010 |
| robot | `GET /server` | `D/api/RobotApi.kt:24` | `listServers` | ONB-017, ONB-039, ROB-004, ROB-028, SUC-002 |
| robot | `GET /server/{number}` | `D/api/RobotApi.kt:27` | `getServer` | ROB-006, ROB-007 |
| robot | `GET /reset/{number}` | `D/api/RobotApi.kt:30` | `resetOptions` | ROB-035 |
| robot | `POST /reset/{number}` | `D/api/RobotApi.kt:34` | `reset` | ROB-005, ROB-009 |
| robot | `POST /wol/{number}` | `D/api/RobotApi.kt:40` | `wakeOnLan` | ROB-005, ROB-010 |
| robot | `GET /failover` | `D/api/RobotApi.kt:43` | `listFailoverIps` | ROB-017 |
| robot | `POST /failover/{ip}` | `D/api/RobotApi.kt:47` | `routeFailover` | ROB-018 |
| robot | `DELETE /failover/{ip}` | `D/api/RobotApi.kt:53` | `unrouteFailover` | ROB-019 |
| robot | `GET /rdns` | `D/api/RobotApi.kt:58` | `listRdns` | ROB-020 |
| robot | `GET /rdns/{ip}` | `D/api/RobotApi.kt:61` | `getRdns` | ROB-045 |
| robot | `POST /rdns/{ip}` | `D/api/RobotApi.kt:66` | `setRdns` | ROB-013, ROB-021, ROB-022 |
| robot | `DELETE /rdns/{ip}` | `D/api/RobotApi.kt:72` | `deleteRdns` | ROB-023 |
| robot | `GET /vswitch` | `D/api/RobotApi.kt:78` | `listVSwitches` | ROB-024 |
| robot | `GET /vswitch/{id}` | `D/api/RobotApi.kt:81` | `getVSwitch` | ROB-026, ROB-027 |
| robot | `POST /vswitch` | `D/api/RobotApi.kt:85` | `createVSwitch` | ROB-025 |
| robot | `POST /vswitch/{id}` | `D/api/RobotApi.kt:93` | `updateVSwitch` | ROB-030 |
| robot | `DELETE /vswitch/{id}` | `D/api/RobotApi.kt:102` | `deleteVSwitch` | ROB-031 |
| robot | `POST /vswitch/{id}/server` | `D/api/RobotApi.kt:109` | `attachServerToVSwitch` | ROB-028 |
| robot | `DELETE /vswitch/{id}/server` | `D/api/RobotApi.kt:116` | `detachServerFromVSwitch` | ROB-029 |
| robot | `GET /boot/{number}` | `D/api/RobotApi.kt:124` | `bootOptions` | ROB-037 |
| robot | `GET /boot/{number}/rescue` | `D/api/RobotApi.kt:127` | `rescueOptions` | ROB-011 |
| robot | `POST /boot/{number}/rescue` | `D/api/RobotApi.kt:131` | `enableRescue` | ROB-011 |
| robot | `DELETE /boot/{number}/rescue` | `D/api/RobotApi.kt:138` | `disableRescue` | ROB-012 |
| robot | `GET /server/{number}/cancellation` | `D/api/RobotApi.kt:143` | `getCancellation` | ROB-014 |
| robot | `POST /server/{number}/cancellation` | `D/api/RobotApi.kt:147` | `cancelServer` | ROB-014 |
| robot | `DELETE /server/{number}/cancellation` | `D/api/RobotApi.kt:155` | `withdrawCancellation` | ROB-015 |
| robot | `GET /traffic` | `D/api/RobotApi.kt:160` | `listTraffic` | keine Zeile |
| robot | `POST /traffic` | `D/api/RobotApi.kt:170` | `queryTraffic` | ROB-008, ROB-059 |
| robot | `GET /key` | `D/api/RobotApi.kt:178` | `listKeys` | ROB-011, ROB-032 |
| robot | `POST /key` | `D/api/RobotApi.kt:182` | `createKey` | ROB-033 |
| robot | `DELETE /key/{fp}` | `D/api/RobotApi.kt:188` | `deleteKey` | ROB-034 |

## Nicht übernehmen

Bekannte Fehler und Einschränkungen von Falco 2.x. Der Neubau darf sie nicht nachbauen; jede Zeile braucht einen Test, der das neue Verhalten absichert.

| ID | Problem | Referenz | Vorgabe Neu |
|---|---|---|---|
| BUG-001 | Floating IP Löschdialog zeigt Volume Texte ("Delete volume?") | `S/cloud/CloudFloatingIpDetailScreen.kt:323` | Texte pro Ressourcentyp aus einer Quelle, Test auf Titel |
| BUG-002 | Bestätigungen uneinheitlich: Server löschen mit Namenseingabe, Volume, Netzwerk, Zone, Bucket, Storage Box Rollback, Zonenimport und Rebuild nur einfacher Dialog | `C/dialog/TypeToConfirmDeleteDialog.kt`<br>`S/cloud/CloudVolumeDetailScreen.kt:283`<br>`S/dns/ZoneDetailScreen.kt:338`<br>`S/cloud/RebuildDialog.kt:117` | Stufe 1 und 2 nach README Abschnitt 5, Regel zentral im Code |
| BUG-003 | TTL Grenzen widersprüchlich: Zone und Record mindestens 60, Sammelbearbeitung mindestens 0 | `S/dns/BulkEditDialog.kt:40`<br>`S/dns/RecordDialog.kt:60` | Eine Regel aus der Spec für alle TTL Felder |
| BUG-004 | DNS Altlasten: `dnsToken` und `DNS_TOKEN` werden noch gelesen und geschrieben, Accountzeile zeigt Badge "DNS" | `D/auth/AccountManager.kt:39`<br>`D/auth/CredentialStore.kt:251`<br>`S/accounts/AccountsScreen.kt:181` | Kein eigener DNS Zugang, DNS gehört zum Cloud Projekt |
| BUG-005 | DNS Records als Einzelrecords modelliert, Bearbeiten ersetzt RRSet über Geschwisterliste | `D/repo/DnsRepo.kt:129` | RRSet Modell der Cloud API direkt abbilden |
| BUG-006 | DNS nutzt nur das aktive Projekt, ignoriert "Alle Projekte" | `D/repo/DnsRepo.kt:53` | Scope als Parameter, Zonen aller Projekte |
| BUG-007 | Aggregat als globale Einstellung und implizit aktives Projekt (`selectProjectThen`) | `D/auth/SecurityPreferences.kt:106`<br>`S/cloud/ProjectsViewModel.kt:62` | Scope in Route, "Alle Projekte" als Scope Eintrag |
| BUG-008 | Placement Group Typ fest "spread" | `S/cloud/CloudResourcesTab.kt:720` | Typ aus Spec |
| BUG-009 | Veralteter User-Agent "Falco/0.1 (F-Droid; Android)" | `D/api/HttpClientFactory.kt:187` | Version und Plattform aus Build |
| BUG-010 | Migration alter Formate (einzelner CLOUD_TOKEN, SharedPreferences v1) | `D/auth/AccountManager.kt:232`<br>`D/auth/CredentialStore.kt:200` | Neubau startet ohne Altformate, kein Import |
| BUG-011 | Datacenter Anzeige an Server, Floating IP, Primary IP, Storage Box | `S/cloud/CloudServerDetailScreen.kt:901`<br>`S/cloud/CloudFloatingIpDetailScreen.kt:152`<br>`S/cloud/CloudPrimaryIpDetailScreen.kt:143`<br>`S/cloud/CloudStorageBoxDetailScreen.kt:407` | Location anzeigen, `datacenter` entfällt 2026 |
| BUG-012 | Robot Reset Typen fest im Code statt aus `GET /reset/{n}` | `S/robot/ServerDetailScreen.kt:629`<br>`D/repo/RobotRepo.kt:32` | Nur angebotene Typen zeigen |
| BUG-013 | Kündigungsdatum als Freitext "YYYY-MM-DD oder now" | `S/robot/ServerDetailScreen.kt:408`<br>`S/robot/RobotVSwitchDetailScreen.kt:460` | Datumsauswahl ab frühestem Datum aus `GET /server/{n}/cancellation` |
| BUG-014 | `GET /traffic` deklariert, laut Robot Doku nicht vorhanden (nur POST) | `D/api/RobotApi.kt:160` | Entfernen, nur POST /traffic |
| BUG-015 | Primary IP Reverse DNS nur angezeigt, nicht änderbar | `S/cloud/CloudPrimaryIpDetailScreen.kt:161` | Bearbeiten wie Floating IP (siehe NET Lückenzeilen) |
| BUG-016 | Bucketname beim Anlegen nicht geprüft, nur im Upload Dienst | `S/s3/S3Screen.kt:295`<br>`D/s3/UploadService.kt:179` | Eine Prüfung im Formular |
| BUG-017 | Doppelte Wege: Serveraktionen in Liste und Detail, Storage Boxen unter Cloud statt Storage, SSH Keys als Cloud Reiter | `S/cloud/CloudScreen.kt:141`<br>`S/cloud/CloudHubScreen.kt:57` | Ein Muster pro Aufgabe, IA nach README Abschnitt 3 |
| BUG-018 | Begriffe gemischt: "Remove project" mit Button "Delete", "Detach" und "Remove" für Zuordnungen | `S/cloud/ProjectManageScreen.kt:104`<br>`S/cloud/CloudServerDetailScreen.kt:668` | "Löschen" nur für endgültig, "Entfernen" für Zuordnungen |
| BUG-019 | Onboarding nennt Storage Boxen unter Robot | `S/welcome/OnboardingScreen.kt:153` | Storage Boxen gehören zur Cloud API (api.hetzner.com) |
| BUG-020 | Übersetzungen unvollständig: en 813, de 571, es/fr/it/ru 537, zh-CN 527 Strings | `res/values-*/strings.xml` | Nur vollständige Sprachen ausliefern, de und en zu 100 % |
| BUG-021 | Code ohne Oberfläche (tot): u. a. `createLoadBalancer`, `deleteCertificate`, `renameSshKey`, `updateStorageBoxSubaccount`, `uploadLink`, `bootOptions` | `D/repo/CloudRepo.kt`<br>`D/repo/RobotRepo.kt`<br>`D/repo/S3Repo.kt` | Nur bauen, was eine Zeile in diesem Inventar hat |
| BUG-022 | Aktivitätslimit fest 30 Einträge ohne Nachladen | `S/cloud/CloudServerDetailViewModel.kt:361` | Pagination wie alle Listen |
| BUG-023 | Biometrie Sonderweg Android 9/10 | `D/auth/BiometricGate.kt:37` | local_auth Standardverhalten |

## Zurückgestellt

Zeilen ohne Test, jede mit Grund. `tool/parity_check.dart` akzeptiert eine Zeile ohne Test nur, wenn sie hier steht.

| ID | Grund |
|---|---|
| ROB-060 | Bestellungen kosten Geld und brauchen eine Entscheidung zu Umfang und Kaufbestätigung; kommt nach Release 3.0 als eigene Phase. |
| QRS-023 | Die Benachrichtigungen der Transfers zeigt background_downloader nativ; Tests ersetzen das Plugin durch FakeTransfers, geprüft wird es beim Gerätetest der Uploads (OBJ-007). |
| BUG-021 | Regel für den Bau ("nur bauen, was eine Zeile hat"), kein Laufzeitverhalten; gesichert durch Review und diese Liste. |
