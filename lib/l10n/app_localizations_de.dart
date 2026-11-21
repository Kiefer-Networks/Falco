// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Falco';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonCreate => 'Erstellen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonCopy => 'Kopieren';

  @override
  String get commonSearch => 'Suchen';

  @override
  String get commonLoading => 'Wird geladen';

  @override
  String get moreActions => 'Weitere Aktionen';

  @override
  String get commonMore => 'Mehr';

  @override
  String get overviewUnavailable => 'Nicht verfügbar';

  @override
  String overviewStatusCount(String status, int count) {
    return '$status: $count';
  }

  @override
  String get listSort => 'Sortieren';

  @override
  String listSortBy(String field) {
    return 'Sortierung: $field';
  }

  @override
  String get listNoMatches =>
      'Keine Treffer für diese Suche oder diesen Filter.';

  @override
  String get listStaleBanner =>
      'Aktualisieren fehlgeschlagen. Angezeigt werden die zuletzt geladenen Daten.';

  @override
  String listProjectsFailed(String projects) {
    return 'Nicht geladen: $projects. Angezeigt werden die übrigen Projekte.';
  }

  @override
  String get errorTitle => 'Etwas ist schiefgelaufen';

  @override
  String get errorNetwork =>
      'Keine Verbindung zum Server. Prüfe dein Netzwerk.';

  @override
  String get detailPick => 'Wähle einen Eintrag, um seine Details zu sehen.';

  @override
  String get copied => 'In die Zwischenablage kopiert';

  @override
  String copiedSensitive(int seconds) {
    return 'Kopiert. Die Zwischenablage wird nach $seconds s geleert.';
  }

  @override
  String copiedPlain(int seconds) {
    return 'Kopiert. Dieses System kann es nicht vor anderen Apps verbergen; die Zwischenablage wird nach $seconds s geleert.';
  }

  @override
  String copyValue(String value) {
    return '$value kopieren';
  }

  @override
  String get secretShow => 'Anzeigen';

  @override
  String get secretHide => 'Verbergen';

  @override
  String get secretHidden => 'Verborgenes Geheimnis';

  @override
  String get statusRunning => 'läuft';

  @override
  String get statusOff => 'aus';

  @override
  String get statusStarting => 'startet';

  @override
  String get statusStopping => 'stoppt';

  @override
  String get statusRebooting => 'startet neu';

  @override
  String get statusInitializing => 'initialisiert';

  @override
  String get statusRebuilding => 'wird neu aufgesetzt';

  @override
  String get statusMigrating => 'migriert';

  @override
  String get statusDeleting => 'wird gelöscht';

  @override
  String get statusError => 'Fehler';

  @override
  String get statusUnknown => 'unbekannt';

  @override
  String get periodHour => '1 Std';

  @override
  String get periodDay => '24 Std';

  @override
  String get periodWeek => '7 T';

  @override
  String get periodMonth => '30 T';

  @override
  String get chartPeriod => 'Zeitraum';

  @override
  String get chartNoData => 'Keine Daten für diesen Zeitraum.';

  @override
  String get dangerZone => 'Gefahrenzone';

  @override
  String wizardStep(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get wizardSummary => 'Zusammenfassung';

  @override
  String get wizardProject => 'Projekt';

  @override
  String confirmTypeName(String name) {
    return 'Zum Bestätigen $name eintippen.';
  }

  @override
  String get confirmTypeNameLabel => 'Name';

  @override
  String get scopeProject => 'Projekt';

  @override
  String get scopeSwitch => 'Account oder Projekt wechseln';

  @override
  String get scopeAllProjects => 'Alle Projekte';

  @override
  String get scopeRobot => 'Robot';

  @override
  String get relativeJustNow => 'gerade eben';

  @override
  String relativeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Minuten',
      one: 'vor 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String relativeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Stunden',
      one: 'vor 1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String relativeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get showcaseTitle => 'Design System';

  @override
  String get showcaseTheme => 'Design';

  @override
  String get showcaseDark => 'Dunkel';

  @override
  String get showcaseLight => 'Hell';

  @override
  String get showcaseOled => 'OLED';

  @override
  String get showcaseAccent => 'Akzent';

  @override
  String get showcaseOpen => 'Öffnen';

  @override
  String get resourceServers => 'Server';

  @override
  String get resourceServer => 'Server';

  @override
  String get filterAll => 'Alle';

  @override
  String get sortName => 'Name';

  @override
  String get sortCreated => 'erstellt';

  @override
  String get actionReboot => 'Neustart';

  @override
  String get actionShutdown => 'Ausschalten';

  @override
  String get actionConsole => 'Konsole';

  @override
  String get actionSnapshot => 'Snapshot';

  @override
  String get actionRename => 'Umbenennen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionRebuild => 'Neu aufsetzen';

  @override
  String get actionCreateServer => 'Server erstellen';

  @override
  String get emptyServers => 'In diesem Projekt gibt es noch keine Server.';

  @override
  String get sectionOverview => 'Übersicht';

  @override
  String get sectionMetrics => 'Metriken';

  @override
  String get metricCpu => 'CPU';

  @override
  String get metricNetwork => 'Netzwerk';

  @override
  String get metricIn => 'ein';

  @override
  String get metricOut => 'aus';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldType => 'Typ';

  @override
  String get fieldLocation => 'Standort';

  @override
  String get fieldAddress => 'Adresse';

  @override
  String get fieldRootPassword => 'Root Passwort';

  @override
  String rebootTitle(String name) {
    return '$name neu starten?';
  }

  @override
  String get rebootConsequence =>
      'Der Server startet über ACPI neu. Offene Verbindungen brechen während des Starts ab, meist für weniger als eine Minute.';

  @override
  String deleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get deleteConsequence =>
      'Der Server und seine Festplatte werden gelöscht. Angehängte Volumes bleiben erhalten. Das lässt sich nicht rückgängig machen.';

  @override
  String get scopeEmpty => 'In diesem Bereich gibt es noch nichts anzuzeigen.';

  @override
  String get lockTitle => 'Falco ist gesperrt.';

  @override
  String get lockUnlock => 'Entsperren';

  @override
  String get lockReason => 'Entsperre Falco, um auf deine Server zuzugreifen';

  @override
  String get vaultLostTitle => 'Zugangsdaten gelöscht';

  @override
  String vaultLostMessage(String accounts) {
    return 'Das System hat die gespeicherten Zugangsdaten gelöscht, zum Beispiel nach einer Änderung der Fingerabdrücke oder des Gesichts. Gib Tokens und Zugangsdaten erneut ein für: $accounts.';
  }

  @override
  String get errorUnauthorized =>
      'Die Zugangsdaten wurden abgelehnt. Prüfe Token oder Zugangsdaten.';

  @override
  String get errorForbidden =>
      'Diesem Zugang fehlt die Berechtigung für diese Aktion, zum Beispiel bei einem Token nur mit Leserechten.';

  @override
  String get errorNotFound => 'Diese Ressource existiert nicht mehr.';

  @override
  String get errorConflict =>
      'Die Ressource ist geschützt, gesperrt oder beschäftigt. Versuche es später erneut.';

  @override
  String get errorRateLimited =>
      'Zu viele Anfragen. Warte einen Moment und versuche es erneut.';

  @override
  String get errorInvalid =>
      'Die Eingabe wurde abgelehnt. Prüfe die markierten Felder.';

  @override
  String get errorPinning =>
      'Dem Serverzertifikat wird nicht vertraut. Die Verbindung wurde gestoppt, um deine Zugangsdaten zu schützen.';

  @override
  String get errorServer =>
      'Der Server hat einen Fehler gemeldet. Versuche es später erneut.';

  @override
  String get errorLocked =>
      'Die Zugangsdaten bleiben gesperrt: die Prüfung des Systems wurde abgebrochen. Nichts wurde geändert.';

  @override
  String get statusInProgress => 'läuft';

  @override
  String get statusDone => 'erledigt';

  @override
  String get statusFailed => 'fehlgeschlagen';

  @override
  String get navCompute => 'Compute';

  @override
  String get navNetwork => 'Netzwerk';

  @override
  String get navStorage => 'Storage';

  @override
  String get navRobot => 'Robot';

  @override
  String get activityTitle => 'Aktivität';

  @override
  String get activityEmpty => 'Noch keine Aktionen.';

  @override
  String get activityShowAll => 'Gesamte Aktivität';

  @override
  String get filterRunning => 'Läuft';

  @override
  String get filterOff => 'Aus';

  @override
  String get filterInProgress => 'In Arbeit';

  @override
  String get filterFailed => 'Fehlgeschlagen';

  @override
  String get actionPowerOn => 'Einschalten';

  @override
  String get actionPowerOff => 'Ausschalten';

  @override
  String get actionReset => 'Reset';

  @override
  String shutdownTitle(String name) {
    return '$name herunterfahren?';
  }

  @override
  String get shutdownConsequence =>
      'Das Betriebssystem wird über ACPI zum Herunterfahren aufgefordert. Der Server bleibt aus, bis du ihn einschaltest.';

  @override
  String powerOffTitle(String name) {
    return '$name ausschalten?';
  }

  @override
  String get powerOffConsequence =>
      'Der Strom wird sofort getrennt, wie beim Ziehen des Steckers. Nicht gespeicherte Daten können verloren gehen.';

  @override
  String resetTitle(String name) {
    return '$name zurücksetzen?';
  }

  @override
  String get resetConsequence =>
      'Der Server wird hart neu gestartet, wie mit der Reset Taste. Nicht gespeicherte Daten können verloren gehen.';

  @override
  String get actionFailed => 'Die Aktion ist fehlgeschlagen.';

  @override
  String get fieldVcpu => 'vCPU';

  @override
  String get fieldMemory => 'Arbeitsspeicher';

  @override
  String get fieldDisk => 'Festplatte';

  @override
  String get fieldImage => 'Image';

  @override
  String get metricDisk => 'Festplatte';

  @override
  String get metricRead => 'lesen';

  @override
  String get metricWrite => 'schreiben';

  @override
  String get sectionActivity => 'Aktivität';

  @override
  String get accountAdd => 'Account hinzufügen';

  @override
  String get projectAdd => 'Projekt hinzufügen';

  @override
  String get accountStep => 'Account';

  @override
  String get projectStep => 'Cloud Projekt';

  @override
  String get fieldAccountName => 'Accountname';

  @override
  String get fieldProjectName => 'Projektname';

  @override
  String get fieldApiToken => 'API Token';

  @override
  String get tokenHint =>
      'Lege in der Hetzner Cloud Console unter Sicherheit, API Tokens einen Token mit Lese und Schreibrecht an.';

  @override
  String get tokenCheckSave => 'Prüfen und speichern';

  @override
  String get tokenHidden => 'verborgen';

  @override
  String actionCommand(String command) {
    String _temp0 = intl.Intl.selectLogic(command, {
      'start_server': 'Server einschalten',
      'stop_server': 'Server ausschalten',
      'poweron_server': 'Server einschalten',
      'poweroff_server': 'Server ausschalten',
      'shutdown_server': 'Server herunterfahren',
      'reboot_server': 'Server neu starten',
      'reset_server': 'Server zurücksetzen',
      'create_server': 'Server erstellen',
      'delete_server': 'Server löschen',
      'rebuild_server': 'Server neu aufsetzen',
      'change_server_type': 'Servertyp ändern',
      'enable_rescue': 'Rescue Modus aktivieren',
      'disable_rescue': 'Rescue Modus deaktivieren',
      'attach_iso': 'ISO einlegen',
      'detach_iso': 'ISO entfernen',
      'create_image': 'Image erstellen',
      'enable_backup': 'Backups aktivieren',
      'disable_backup': 'Backups deaktivieren',
      'change_protection': 'Schutz ändern',
      'change_dns_ptr': 'Reverse DNS ändern',
      'reset_password': 'Root Passwort zurücksetzen',
      'request_console': 'Konsole öffnen',
      'attach_volume': 'Volume anhängen',
      'detach_volume': 'Volume abhängen',
      'resize_volume': 'Volume vergrößern',
      'create_volume': 'Volume erstellen',
      'attach_to_network': 'Mit Netzwerk verbinden',
      'detach_from_network': 'Vom Netzwerk trennen',
      'add_to_placement_group': 'Zur Placement Group hinzufügen',
      'remove_from_placement_group': 'Aus Placement Group entfernen',
      'assign_floating_ip': 'Floating IP zuweisen',
      'unassign_floating_ip': 'Floating IP entfernen',
      'assign_primary_ip': 'Primary IP zuweisen',
      'unassign_primary_ip': 'Primary IP entfernen',
      'apply_firewall': 'Firewall anwenden',
      'remove_firewall': 'Firewall entfernen',
      'set_firewall_rules': 'Firewall Regeln setzen',
      'create': 'Erstellen',
      'delete': 'Löschen',
      'change_type': 'Typ ändern',
      'update_access_settings': 'Zugriff ändern',
      'rollback_snapshot': 'Snapshot zurücksetzen',
      'enable_snapshot_plan': 'Snapshot Plan aktivieren',
      'disable_snapshot_plan': 'Snapshot Plan abschalten',
      'create_snapshot': 'Snapshot erstellen',
      'delete_snapshot': 'Snapshot löschen',
      'create_subaccount': 'Subaccount anlegen',
      'delete_subaccount': 'Subaccount löschen',
      'reset_subaccount_password': 'Subaccount Passwort zurücksetzen',
      'change_home_directory': 'Home Verzeichnis ändern',
      'robot_reset': 'Reset',
      'robot_wol': 'Wake on LAN',
      'robot_boot_on': 'Boot Konfiguration aktivieren',
      'robot_boot_off': 'Boot Konfiguration deaktivieren',
      'robot_rename': 'Server umbenennen',
      'robot_cancel': 'Kündigen',
      'robot_withdraw': 'Kündigung zurückziehen',
      'robot_rdns': 'Reverse DNS ändern',
      'robot_failover': 'Failover Routing ändern',
      'robot_vswitch': 'vSwitch ändern',
      'robot_key': 'SSH Key ändern',
      'robot_address': 'IP Einstellungen ändern',
      'robot_firewall': 'Firewall ändern',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get accountManage => 'Account verwalten';

  @override
  String get lockUnavailable =>
      'Dieses Gerät hat keine Displaysperre. Richte eine PIN, Face ID oder einen Fingerabdruck ein, um Falco zu schützen.';

  @override
  String get lockContinueWithout => 'Ohne App Sperre fortfahren';

  @override
  String get fieldS3Location => 'Object Storage Standort';

  @override
  String get s3Hint =>
      'Optional. S3 Schlüssel aus der Cloud Console unter Object Storage, Zugangsdaten. Geprüft am gewählten Standort.';

  @override
  String get s3None => 'Keine';

  @override
  String get fieldAccessKey => 'Access Key';

  @override
  String get fieldSecretKey => 'Secret Key';

  @override
  String get fieldRobotUser => 'Webservice Benutzer';

  @override
  String get fieldRobotPassword => 'Webservice Passwort';

  @override
  String get robotHint =>
      'Lege in Robot unter Einstellungen, Webservice und App Einstellungen einen Webservice Benutzer an.';

  @override
  String get s3Step => 'Object Storage';

  @override
  String get cloudOpenConsole => 'Cloud Console öffnen';

  @override
  String get robotOpenSettings => 'Robot Einstellungen öffnen';

  @override
  String accountDone(String name) {
    return 'Fertig. $name ist einsatzbereit.';
  }

  @override
  String get accountOpen => 'Öffnen';

  @override
  String get fieldDescription => 'Beschreibung (optional)';

  @override
  String get servicesStep => 'Dienste';

  @override
  String get serviceCloud => 'Cloud';

  @override
  String get serviceCloudHint =>
      'Cloud Projekte mit Servern, Netzwerken, DNS und Storage';

  @override
  String get serviceRobotHint => 'Dedicated Server über den Robot Webservice';

  @override
  String get servicesPickOne => 'Wähle mindestens einen Dienst.';

  @override
  String get projectsStep => 'Cloud Projekte';

  @override
  String projectRemoveDraft(String name) {
    return '$name entfernen';
  }

  @override
  String get robotStep => 'Robot Zugang';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsEmpty => 'Noch keine Accounts.';

  @override
  String accountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Accounts',
      one: '1 Account',
    );
    return '$_temp0';
  }

  @override
  String accountCloudBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cloud, $count Projekte',
      one: 'Cloud, 1 Projekt',
    );
    return '$_temp0';
  }

  @override
  String get accountActive => 'Aktiv';

  @override
  String get accountDefault => 'Standard';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountEdit => 'Account bearbeiten';

  @override
  String get accountDelete => 'Account löschen';

  @override
  String accountDeleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get accountDeleteConsequence =>
      'Der Account wird mit allen Tokens, Schlüsseln und Robot Zugangsdaten von diesem Gerät gelöscht. Bei Hetzner ändert sich nichts.';

  @override
  String get robotAccess => 'Webservice Zugang';

  @override
  String get robotStored => 'Gespeichert und geprüft';

  @override
  String get robotAdd => 'Robot Zugang hinzufügen';

  @override
  String get robotChange => 'Robot Zugang ändern';

  @override
  String get robotDelete => 'Robot Zugang löschen';

  @override
  String robotDeleteTitle(String name) {
    return 'Robot Zugang von $name löschen?';
  }

  @override
  String get robotDeleteConsequence =>
      'Benutzer und Passwort werden von diesem Gerät gelöscht. Der Webservice Benutzer bei Hetzner bleibt.';

  @override
  String get projectsEmpty => 'Noch keine Cloud Projekte.';

  @override
  String get projectDelete => 'Projekt löschen';

  @override
  String projectDeleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get projectDeleteConsequence =>
      'Das Projekt wird mit Token und S3 Schlüsseln von diesem Gerät gelöscht. Projekt und Server bei Hetzner bleiben.';

  @override
  String get tokenChange => 'Token ändern';

  @override
  String get s3Change => 'Object Storage Schlüssel';

  @override
  String get s3Delete => 'Object Storage Schlüssel löschen';

  @override
  String s3DeleteTitle(String name) {
    return 'Object Storage Schlüssel von $name löschen?';
  }

  @override
  String get s3DeleteConsequence =>
      'Access und Secret Key werden von diesem Gerät gelöscht. Buckets und Schlüssel bei Hetzner bleiben.';

  @override
  String get s3NoKeys => 'Keine Object Storage Schlüssel';

  @override
  String s3Keys(String location) {
    return 'Object Storage Schlüssel, geprüft in $location';
  }

  @override
  String get savedMessage => 'Gespeichert';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsTheme => 'Erscheinungsbild';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsSystem => 'System';

  @override
  String get settingsSecurity => 'Sicherheit';

  @override
  String get settingsLock => 'Entsperren beim Start';

  @override
  String get settingsLockHint =>
      'Face ID, Fingerabdruck oder Geräte PIN beim Start und nach der Auto Sperre';

  @override
  String get settingsAutoLock => 'Auto Sperre';

  @override
  String get lockImmediately => 'Sofort';

  @override
  String lockSeconds(int count) {
    return 'Nach $count s';
  }

  @override
  String lockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nach $count Minuten',
      one: 'Nach 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String get settingsSecureScreen => 'Screenshots blockieren';

  @override
  String get settingsSecureScreenHint =>
      'Verdeckt Falco in der App Übersicht und blockiert Screenshots';

  @override
  String get settingsPinning => 'Zertifikat Pinning';

  @override
  String get settingsPinningHint =>
      'Aktiv für alle Hetzner Endpunkte: Cloud, Storage Boxen, Robot und Object Storage.';

  @override
  String get accentAmber => 'Bernstein';

  @override
  String get accentBlue => 'Blau';

  @override
  String get accentGreen => 'Grün';

  @override
  String get accentRed => 'Rot';

  @override
  String get accentPurple => 'Lila';

  @override
  String get accentOrange => 'Orange';

  @override
  String get aboutTitle => 'Über Falco';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'Hetzner Cloud, Robot, DNS und Storage vom Telefon aus verwalten. Freie Software ohne Tracking.';

  @override
  String get aboutWebsite => 'Website';

  @override
  String get aboutDonate => 'Spenden';

  @override
  String get aboutSource => 'Quellcode';

  @override
  String get aboutDeveloper => 'Entwickler';

  @override
  String get aboutLicense => 'Lizenz';

  @override
  String get aboutLicenses => 'Open Source Lizenzen';

  @override
  String get welcomeSkip => 'Überspringen';

  @override
  String get welcomeLanguage => 'Sprache wählen';

  @override
  String get welcomeFeatures => 'Was Falco kann';

  @override
  String get welcomeCloud =>
      'Server, Volumes, Netzwerke, Firewalls, Load Balancer und mehr, über alle Projekte.';

  @override
  String get welcomeRobot =>
      'Dedicated Server: Reset, Rescue, Wake on LAN, Reverse DNS und Failover.';

  @override
  String get welcomeDns => 'Zonen und Records deiner Cloud Projekte.';

  @override
  String get welcomeObjectStorage => 'Object Storage';

  @override
  String get welcomeObjectStorageText =>
      'Buckets und Dateien an allen Standorten, mit Uploads im Hintergrund.';

  @override
  String get welcomeSecurity => 'Dein Zugang bleibt sicher';

  @override
  String get welcomeSecretsTitle => 'Verschlüsselt auf dem Gerät';

  @override
  String get welcomeSecretsIos =>
      'Tokens und Passwörter liegen nur im iOS Schlüsselbund dieses Geräts.';

  @override
  String get welcomeSecretsAndroid =>
      'Tokens und Passwörter liegen nur im hardwaregestützten Android Keystore.';

  @override
  String get welcomeLockTitle => 'Entsperren beim Start';

  @override
  String get welcomeLockIos =>
      'Falco fragt beim Start nach Face ID, Touch ID oder deinem Code.';

  @override
  String get welcomeLockAndroid =>
      'Falco fragt beim Start nach Fingerabdruck oder Geräte PIN.';

  @override
  String get welcomePinning =>
      'TLS 1.2 oder neuer mit Zertifikat Pinning für jeden Hetzner Endpunkt. Kein Tracking.';

  @override
  String get welcomeStart => 'Bereit zum Start';

  @override
  String get welcomeStartText =>
      'Füge einen Account mit Cloud API Token, Robot Zugang oder beidem hinzu. Jeder Zugang wird vor dem Speichern geprüft.';

  @override
  String backupWindow(String window) {
    return 'An, Zeitfenster $window UTC';
  }

  @override
  String get backupsOn => 'Backups aktivieren';

  @override
  String get backupsOff => 'Backups deaktivieren';

  @override
  String backupsOnTitle(String name) {
    return 'Backups für $name aktivieren?';
  }

  @override
  String backupsOffTitle(String name) {
    return 'Backups für $name deaktivieren?';
  }

  @override
  String get backupsOnConsequence =>
      'Hetzner hält sieben tägliche Backups vor. Backups kosten 20 % des Serverpreises.';

  @override
  String get backupsOffConsequence =>
      'Alle vorhandenen Backups dieses Servers werden gelöscht.';

  @override
  String get changeType => 'Typ ändern';

  @override
  String get changeTypeNeedsOff =>
      'Schalte den Server aus, bevor du den Typ änderst.';

  @override
  String changeTypeTo(String type) {
    return 'Wechsel auf $type';
  }

  @override
  String get upgradeDisk => 'Disk vergrößern (endgültig)';

  @override
  String get upgradeDiskHint =>
      'Mit größerer Disk kann der Server nie wieder auf einen kleineren Typ wechseln.';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nein';

  @override
  String get commonNone => 'Keine';

  @override
  String get commonOff => 'Aus';

  @override
  String consoleTitle(String name) {
    return 'Konsole von $name';
  }

  @override
  String get consoleNote =>
      'Verbinde einen VNC Client innerhalb etwa einer Minute mit dieser Websocket URL.';

  @override
  String get consoleUrl => 'Websocket URL';

  @override
  String get consolePassword => 'VNC Passwort';

  @override
  String createdMessage(String name) {
    return '$name erstellt';
  }

  @override
  String deletedMessage(String name) {
    return '$name gelöscht';
  }

  @override
  String get deprecated => 'veraltet';

  @override
  String get emptyImages =>
      'Noch keine Snapshots oder Backups. Erstelle einen Snapshot von einem Server.';

  @override
  String get emptyPlacementGroups =>
      'Noch keine Placement Groups in diesem Projekt.';

  @override
  String get emptySshKeys => 'Noch keine SSH Keys in diesem Projekt.';

  @override
  String get emptyVolumes => 'Noch keine Volumes in diesem Projekt.';

  @override
  String get fieldArchitecture => 'Architektur';

  @override
  String get fieldBackups => 'Backups';

  @override
  String get fieldCreated => 'Erstellt';

  @override
  String get fieldDeleteProtection => 'Löschschutz';

  @override
  String get fieldRebuildProtection => 'Neuaufsetzschutz';

  @override
  String get fieldDevice => 'Gerät';

  @override
  String get fieldFingerprint => 'Fingerprint';

  @override
  String get fieldFormat => 'Dateisystem';

  @override
  String get fieldImageDescription => 'Beschreibung';

  @override
  String get fieldIso => 'ISO';

  @override
  String get fieldLabels => 'Labels';

  @override
  String get fieldPrice => 'Preis';

  @override
  String get fieldProtection => 'Schutz';

  @override
  String get fieldPublicKey => 'Öffentlicher Schlüssel';

  @override
  String get fieldSize => 'Größe';

  @override
  String get fieldSizeGb => 'Größe in GB';

  @override
  String get fieldSource => 'Quelle';

  @override
  String get fieldUserData => 'Cloud init User Data';

  @override
  String get filterAttached => 'Angehängt';

  @override
  String get filterDetached => 'Nicht angehängt';

  @override
  String get imageApp => 'App';

  @override
  String get imageBackup => 'Backup';

  @override
  String get imageSnapshot => 'Snapshot';

  @override
  String get imageSystem => 'System';

  @override
  String get imageConvert => 'Zu Snapshot';

  @override
  String imageConvertTitle(String name) {
    return '$name in einen Snapshot umwandeln?';
  }

  @override
  String get imageConvertConsequence =>
      'Das Backup wird zum Snapshot. Er bleibt beim Löschen des Servers erhalten und wird als Snapshot berechnet.';

  @override
  String get imageDeleteConsequence =>
      'Das Image wird gelöscht. Server daraus laufen weiter. Das lässt sich nicht rückgängig machen.';

  @override
  String get isoAttach => 'ISO einlegen';

  @override
  String get isoDetach => 'ISO auswerfen';

  @override
  String isoDetachTitle(String name) {
    return '$name auswerfen?';
  }

  @override
  String get isoDetachConsequence =>
      'Der Server startet nach dem nächsten Neustart wieder von seiner Disk.';

  @override
  String get labelsHint => 'Optional. key=value, durch Kommas getrennt.';

  @override
  String metricStats(String series, String min, String max, String avg) {
    return '$series: min $min · max $max · Ø $avg';
  }

  @override
  String perMonth(String price) {
    return '$price/Monat';
  }

  @override
  String priceServerOnly(String price) {
    return '$price (nur Server)';
  }

  @override
  String get priceUnavailable => 'Preis nicht verfügbar';

  @override
  String get typeCurrent => 'aktuell';

  @override
  String priceMonthly(String gross, String net, String perGb) {
    return '$gross/Monat brutto, $net netto, $perGb pro GB';
  }

  @override
  String get placementGroupAdd => 'Zu Placement Group hinzufügen';

  @override
  String get placementGroupCreate => 'Placement Group erstellen';

  @override
  String get placementGroupDeleteConsequence =>
      'Die Gruppe wird gelöscht. Ihre Server laufen weiter.';

  @override
  String get placementGroupEmpty => 'Keine Server in dieser Gruppe.';

  @override
  String get placementGroupNone =>
      'Keine Placement Groups in diesem Projekt. Lege zuerst eine unter Compute an.';

  @override
  String get placementGroupNeedsOff =>
      'Schalte den Server aus, bevor du ihn einer Placement Group hinzufügst.';

  @override
  String get placementGroupRemove => 'Aus Placement Group entfernen';

  @override
  String placementGroupRemoveTitle(String name, String group) {
    return '$name aus $group entfernen?';
  }

  @override
  String get placementGroupRemoveConsequence =>
      'Der Server kann danach Hardware mit anderen Servern der Gruppe teilen.';

  @override
  String get placementGroupTypeHint =>
      'Spread verteilt jeden Server auf einen anderen Host.';

  @override
  String get protectOn => 'Schützen';

  @override
  String get protectOff => 'Schutz aufheben';

  @override
  String protectOnTitle(String name) {
    return '$name schützen?';
  }

  @override
  String protectOffTitle(String name) {
    return 'Schutz von $name aufheben?';
  }

  @override
  String get protectOnConsequence =>
      'Es lässt sich erst nach Aufheben des Schutzes löschen.';

  @override
  String get protectOffConsequence => 'Es lässt sich wieder löschen.';

  @override
  String get protected => 'geschützt';

  @override
  String get publicIpv4 => 'Öffentliche IPv4';

  @override
  String get publicIpv6 => 'Öffentliche IPv6';

  @override
  String get rebuildPick => 'Neu aufsetzen mit Image';

  @override
  String rebuildTitle(String name) {
    return '$name neu aufsetzen?';
  }

  @override
  String rebuildConsequence(String image) {
    return 'Alle Daten auf der Disk gehen verloren. Der Server startet neu mit $image.';
  }

  @override
  String get rescueActive => 'Rescue';

  @override
  String get rescueOn => 'Rescue aktivieren';

  @override
  String get rescueOff => 'Rescue deaktivieren';

  @override
  String rescueOnTitle(String name) {
    return 'Rescue für $name aktivieren?';
  }

  @override
  String rescueOffTitle(String name) {
    return 'Rescue für $name deaktivieren?';
  }

  @override
  String get rescueOnConsequence =>
      'Der nächste Neustart lädt das Rescue System. Sein Root Passwort wird einmal angezeigt.';

  @override
  String get rescueOffConsequence =>
      'Der nächste Neustart lädt wieder von der Disk.';

  @override
  String get resetPassword => 'Root Passwort zurücksetzen';

  @override
  String resetPasswordTitle(String name) {
    return 'Root Passwort von $name zurücksetzen?';
  }

  @override
  String get resetPasswordConsequence =>
      'Der Server braucht den qemu guest agent. Das neue Passwort wird einmal angezeigt.';

  @override
  String get resourceFirewalls => 'Firewalls';

  @override
  String get resourceImage => 'Image';

  @override
  String get resourceImages => 'Images';

  @override
  String get resourceLoadBalancer => 'Load Balancer';

  @override
  String get resourceNetworks => 'Netzwerke';

  @override
  String get resourcePlacementGroup => 'Placement Group';

  @override
  String get resourcePlacementGroups => 'Placement Groups';

  @override
  String get resourceSshKey => 'SSH Key';

  @override
  String get resourceSshKeys => 'SSH Keys';

  @override
  String get resourceVolume => 'Volume';

  @override
  String get resourceVolumes => 'Volumes';

  @override
  String get reverseDns => 'Reverse DNS';

  @override
  String get reverseDnsHint =>
      'Leer lassen setzt auf den Hetzner Standard zurück.';

  @override
  String reverseDnsValue(String ptr) {
    return 'Reverse DNS: $ptr';
  }

  @override
  String get rootPasswordAfter => 'wird nach dem Erstellen einmal angezeigt';

  @override
  String get rootPasswordNote =>
      'Kopiere es jetzt. Falco speichert es nicht und kann es nicht erneut zeigen.';

  @override
  String get rootPasswordTitle => 'Root Passwort';

  @override
  String get sectionAttached => 'Zugeordnet';

  @override
  String get sectionAttachment => 'Zuordnung';

  @override
  String get sectionNetwork => 'Netzwerk';

  @override
  String serverCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Server',
      one: '1 Server',
    );
    return '$_temp0';
  }

  @override
  String get serverNoSshKeys =>
      'Keine SSH Keys in diesem Projekt. Du kannst den Schritt überspringen; das Root Passwort wird nach dem Erstellen einmal angezeigt.';

  @override
  String serverNoVolumes(String location) {
    return 'Keine freien Volumes in $location.';
  }

  @override
  String get sortSize => 'Größe';

  @override
  String get sshKeyAdd => 'SSH Key hinzufügen';

  @override
  String get sshKeyDeleteConsequence =>
      'Der Key wird aus dem Projekt entfernt. Server, die ihn nutzen, behalten ihn.';

  @override
  String get sshKeyHint =>
      'Füge den öffentlichen Schlüssel ein, z. B. den Inhalt von id_ed25519.pub.';

  @override
  String get sshKeyPrivate =>
      'Das ist ein privater Schlüssel. Gib ihn nie weiter; füge stattdessen den öffentlichen Schlüssel (.pub) ein.';

  @override
  String get sshKeyUnknown =>
      'Unbekannter Schlüsseltyp. Nutze ssh-ed25519, ssh-rsa, ecdsa oder einen Security Key.';

  @override
  String get startAfterCreate => 'Nach dem Erstellen starten';

  @override
  String get statusAvailable => 'verfügbar';

  @override
  String get statusUnavailable => 'nicht verfügbar';

  @override
  String get userDataHint =>
      'Optional. Läuft beim ersten Start, z. B. #cloud-config.';

  @override
  String vcpuCount(int count) {
    return '$count vCPU';
  }

  @override
  String get volumeAttach => 'Anhängen';

  @override
  String get volumeAutomount => 'Automatisch einhängen';

  @override
  String get volumeCreate => 'Volume erstellen';

  @override
  String get volumeDeleteConsequence =>
      'Das Volume und alle Daten darauf werden gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String get volumeDetach => 'Abhängen';

  @override
  String volumeDetachTitle(String name) {
    return '$name abhängen?';
  }

  @override
  String get volumeDetachConsequence =>
      'Hänge es vorher auf dem Server aus, sonst können laufende Schreibvorgänge verloren gehen.';

  @override
  String volumeNextTo(String server, String location) {
    return 'Bei $server ($location)';
  }

  @override
  String volumeNoServers(String location) {
    return 'Keine Server in $location zum Anhängen.';
  }

  @override
  String get volumeNotAttached => 'An keinen Server angehängt';

  @override
  String get volumeResize => 'Vergrößern';

  @override
  String volumeResizeHint(int current, int max) {
    return 'Größer als $current GB, höchstens $max GB. Volumes können nicht schrumpfen.';
  }

  @override
  String get volumeTarget => 'Standort oder Server';

  @override
  String get wizardDetails => 'Details';

  @override
  String get wizardExtras => 'Volumes und Placement';

  @override
  String get wizardNetworking => 'Netzwerk';

  @override
  String get actionRemove => 'Entfernen';

  @override
  String get aliasIpsHint =>
      'Optional. Weitere private IPs, durch Kommas getrennt.';

  @override
  String get autoDeleteHint => 'Wird mit dem zugewiesenen Server gelöscht.';

  @override
  String get certificateCreate => 'Zertifikat hinzufügen';

  @override
  String get certificateDeleteConsequence =>
      'Das Zertifikat wird gelöscht. Load Balancer, die es nutzen, verlieren es in ihren HTTPS Services.';

  @override
  String get certificateManaged => 'Verwaltet (Let\'s Encrypt)';

  @override
  String get certificateManagedHint =>
      'Hetzner stellt es für deine Domains aus und erneuert es.';

  @override
  String get certificatePemHint =>
      'PEM, beginnt mit -----BEGIN CERTIFICATE-----, mit Kette.';

  @override
  String get certificatePending => 'Ausstehend';

  @override
  String get certificateRetry => 'Erneut ausstellen';

  @override
  String get certificateUnused => 'Von keinem Load Balancer genutzt.';

  @override
  String get certificateUploaded => 'Hochgeladen';

  @override
  String get certificateUploadedHint =>
      'Eigenes Zertifikat und privater Schlüssel.';

  @override
  String certificateValidUntil(String date) {
    return 'Gültig bis $date';
  }

  @override
  String get domainsHint =>
      'Eine oder mehrere Domains, durch Kommas getrennt, z. B. example.com, *.example.com.';

  @override
  String get emptyCertificates => 'Noch keine Zertifikate in diesem Projekt.';

  @override
  String get emptyFirewalls => 'Noch keine Firewalls in diesem Projekt.';

  @override
  String get emptyFloatingIps => 'Noch keine Floating IPs in diesem Projekt.';

  @override
  String get emptyLoadBalancers =>
      'Noch keine Load Balancer in diesem Projekt.';

  @override
  String get emptyNetworks => 'Noch keine Netzwerke in diesem Projekt.';

  @override
  String get emptyPrimaryIps => 'Noch keine Primary IPs in diesem Projekt.';

  @override
  String get emptyZones => 'Noch keine DNS Zonen in diesem Projekt.';

  @override
  String get fieldAliasIps => 'Alias IPs';

  @override
  String get fieldAutoDelete => 'Mit Server löschen';

  @override
  String get fieldCertificatePem => 'Zertifikat';

  @override
  String get fieldChangeProtection => 'Änderungsschutz';

  @override
  String get fieldComment => 'Kommentar';

  @override
  String get fieldCookieLifetime => 'Cookie Laufzeit (s)';

  @override
  String get fieldCookieName => 'Cookie Name';

  @override
  String get fieldDefaultTtl => 'Standard TTL';

  @override
  String get fieldDestIps => 'Ziel IPs';

  @override
  String get fieldDestination => 'Ziel';

  @override
  String get fieldDestinationPort => 'Zielport';

  @override
  String get fieldDirection => 'Richtung';

  @override
  String get fieldDomains => 'Domains';

  @override
  String get fieldGateway => 'Gateway';

  @override
  String get fieldHealthCheck => 'Health Check';

  @override
  String get fieldHealthDomain => 'Health Check Domain';

  @override
  String get fieldHealthPath => 'Health Check Pfad';

  @override
  String get fieldHealthPort => 'Health Check Port';

  @override
  String get fieldHealthTls => 'Health Check über TLS';

  @override
  String get fieldInterval => 'Intervall (s)';

  @override
  String get fieldIpRange => 'IP Bereich';

  @override
  String get fieldIps => 'IPs';

  @override
  String get fieldIssuance => 'Ausstellung';

  @override
  String get fieldListenPort => 'Listen Port';

  @override
  String get fieldMode => 'Modus';

  @override
  String get fieldNameOptional => 'Name (optional)';

  @override
  String get fieldNameservers => 'Nameserver';

  @override
  String get fieldNetworkZone => 'Netzwerkzone';

  @override
  String get fieldNewValue => 'Neuer Wert';

  @override
  String get fieldPort => 'Port';

  @override
  String get fieldPrivateIp => 'Private IP';

  @override
  String get fieldPrivateKeyPem => 'Privater Schlüssel';

  @override
  String get fieldProtocol => 'Protokoll';

  @override
  String get fieldProxyProtocol => 'PROXY Protokoll';

  @override
  String get fieldRecordName => 'Name';

  @override
  String get fieldRedirectHttp => 'HTTP auf HTTPS umleiten';

  @override
  String get fieldRenewal => 'Erneuerung';

  @override
  String get fieldRetries => 'Wiederholungen';

  @override
  String get fieldSourceIps => 'Quell IPs';

  @override
  String get fieldStatus => 'Status';

  @override
  String get fieldStatusCodes => 'Statuscodes';

  @override
  String get fieldStickySessions => 'Sticky Sessions';

  @override
  String get fieldTimeout => 'Timeout (s)';

  @override
  String get fieldTtl => 'TTL';

  @override
  String get fieldTsigAlgorithm => 'TSIG Algorithmus';

  @override
  String get fieldTsigKey => 'TSIG Schlüssel (Base64)';

  @override
  String get fieldUsePrivateIp => 'Über privates Netzwerk';

  @override
  String get fieldValidFrom => 'Gültig ab';

  @override
  String get fieldValidUntil => 'Gültig bis';

  @override
  String get fieldValue => 'Wert';

  @override
  String get fieldValues => 'Werte';

  @override
  String get fieldVswitch => 'vSwitch';

  @override
  String get fieldVswitchId => 'vSwitch ID';

  @override
  String get fieldZoneName => 'Domain';

  @override
  String get filterAssigned => 'Zugewiesen';

  @override
  String get filterUnassigned => 'Nicht zugewiesen';

  @override
  String get firewallActive => 'Aktiv';

  @override
  String get firewallApply => 'Anwenden';

  @override
  String get firewallCreate => 'Firewall erstellen';

  @override
  String get firewallDeleteConsequence =>
      'Die Firewall wird gelöscht; geschützte Server sind für ihren Verkehr wieder offen.';

  @override
  String get firewallNotApplied => 'Nicht angewendet';

  @override
  String get firewallNotAppliedHint =>
      'Auf keinen Server und keinen Label Selector angewendet.';

  @override
  String get firewallRemoveConsequence =>
      'Ihre Regeln schützen dieses Ziel nicht mehr.';

  @override
  String firewallRemoveTitle(String firewall, String target) {
    return '$firewall von $target entfernen?';
  }

  @override
  String get floatingIpCreate => 'Floating IP erstellen';

  @override
  String get floatingIpUnassignConsequence =>
      'Verkehr an diese IP erreicht den Server nicht mehr.';

  @override
  String gatewayHint(String range) {
    return 'Eine IP innerhalb von $range.';
  }

  @override
  String gatewayValue(String gateway) {
    return 'über $gateway';
  }

  @override
  String healthCheckValue(String protocol, String port, String interval) {
    return '$protocol Prüfung auf $port alle $interval s';
  }

  @override
  String get healthPortHint => 'Leer nutzt den Zielport.';

  @override
  String get ipAssign => 'Zuweisen';

  @override
  String get ipAssigned => 'Zugewiesen';

  @override
  String ipAssignedTo(String server) {
    return 'zugewiesen an $server';
  }

  @override
  String get ipBlocked => 'Gesperrt';

  @override
  String ipDeleteConsequence(String ip) {
    return 'Die Adresse $ip wird freigegeben und kann an andere gehen. Das lässt sich nicht rückgängig machen.';
  }

  @override
  String get ipNoServers => 'Keine Server in diesem Projekt zum Zuweisen.';

  @override
  String get ipNotAssigned => 'Nicht zugewiesen';

  @override
  String ipOnServer(String server, String location) {
    return 'An $server zuweisen ($location)';
  }

  @override
  String get ipTarget => 'Standort oder Server';

  @override
  String get ipUnassign => 'Zuweisung entfernen';

  @override
  String ipUnassignTitle(String ip, String server) {
    return '$ip von $server entfernen?';
  }

  @override
  String get ipsAny => 'Alle IPv4 und IPv6';

  @override
  String get ipsAnyV4 => 'Alle IPv4';

  @override
  String get ipsAnyV6 => 'Alle IPv6';

  @override
  String get ipsCustom => 'Eigene';

  @override
  String get ipsHint =>
      'CIDR Blöcke, einer pro Zeile oder durch Kommas getrennt, z. B. 203.0.113.0/24.';

  @override
  String get keepIfEmpty => 'Leer behält den aktuellen.';

  @override
  String get labelSelector => 'Label Selector';

  @override
  String get lbAlgorithm => 'Algorithmus';

  @override
  String get lbChangeType => 'Typ ändern';

  @override
  String get lbDeleteConsequence =>
      'Der Load Balancer und seine öffentlichen IPs werden gelöscht. Ziele bleiben erhalten. Das lässt sich nicht rückgängig machen.';

  @override
  String get lbLeastConnections => 'Wenigste Verbindungen';

  @override
  String lbLimits(int connections, int services, int targets) {
    return '$connections Verbindungen, $services Services, $targets Ziele';
  }

  @override
  String get lbNoCertificates =>
      'Noch keine Zertifikate. Füge eines unter Zertifikate hinzu.';

  @override
  String get lbPublicDisabled => 'Öffentliche Schnittstelle deaktiviert';

  @override
  String get lbPublicOff => 'Öffentliche Schnittstelle deaktivieren';

  @override
  String get lbPublicOffConsequence =>
      'Der Load Balancer ist dann nur aus privaten Netzwerken erreichbar.';

  @override
  String get lbPublicOn => 'Öffentliche Schnittstelle aktivieren';

  @override
  String get lbRoundRobin => 'Round Robin';

  @override
  String get loadBalancerCreate => 'Load Balancer erstellen';

  @override
  String get membersEmpty =>
      'Keine Server oder Load Balancer in diesem Netzwerk.';

  @override
  String get metricConnectionsPerSecond => 'Verbindungen pro Sekunde';

  @override
  String get metricOpenConnections => 'Offene Verbindungen';

  @override
  String get metricRequestsPerSecond => 'Anfragen pro Sekunde';

  @override
  String get networkAttach => 'Mit Netzwerk verbinden';

  @override
  String get networkChangeRange => 'IP Bereich ändern';

  @override
  String get networkCreate => 'Netzwerk erstellen';

  @override
  String get networkDeleteConsequence =>
      'Das Netzwerk mit allen Subnetzen und Routen wird gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String get networkDetachConsequence =>
      'Seine private IP in diesem Netzwerk wird freigegeben.';

  @override
  String networkDetachTitle(String name, String network) {
    return '$name aus $network entfernen?';
  }

  @override
  String get networkExpose => 'Routen an vSwitch';

  @override
  String get networkExposeConsequence =>
      'Legt fest, ob die Routen dieses Netzwerks dem gekoppelten vSwitch bekannt gegeben werden.';

  @override
  String get networkExposeOff => 'Routen nicht mehr an vSwitch geben';

  @override
  String get networkExposeOn => 'Routen an vSwitch geben';

  @override
  String get networkRangeCreateHint =>
      'Ein privater Bereich, z. B. 10.0.0.0/16.';

  @override
  String get networkRangeHint =>
      'Nur größer, mit dem aktuellen Bereich darin. Das lässt sich nicht rückgängig machen.';

  @override
  String get portHint =>
      'Ein Port, ein Bereich oder any, z. B. 22, 8000-9000 oder any.';

  @override
  String get primariesEmpty => 'Noch keine primären Nameserver.';

  @override
  String get primariesHint =>
      'Einer pro Zeile: Adresse oder Adresse:Port, Port 53 als Standard.';

  @override
  String get primaryAdd => 'Primären Nameserver hinzufügen';

  @override
  String get primaryEdit => 'Primären Nameserver bearbeiten';

  @override
  String get tsigNone => 'Keiner';

  @override
  String get primaryIpCreate => 'Primary IP erstellen';

  @override
  String get primaryIpNew => 'Neue Primary IP';

  @override
  String primaryIpNoServers(String location) {
    return 'Keine Server in $location, die ausgeschaltet sind und keine Primary IP dieses Typs haben. Eine Primary IP wechselt nur zu so einem Server.';
  }

  @override
  String get primaryIpUnassignConsequence =>
      'Der Server verliert diese öffentliche Adresse. Er muss ausgeschaltet sein.';

  @override
  String get primaryRemoveConsequence =>
      'Die Zone wird nicht mehr von diesem Nameserver übertragen.';

  @override
  String primaryRemoveTitle(String address) {
    return '$address entfernen?';
  }

  @override
  String get privateIpHint => 'Optional. Leer wählt die nächste freie.';

  @override
  String get privateKeyPemHint =>
      'PEM, beginnt mit -----BEGIN PRIVATE KEY-----. Wird einmal an Hetzner gesendet, nie in Falco gespeichert.';

  @override
  String get recordAdd => 'Record hinzufügen';

  @override
  String recordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Records',
      one: '1 Record',
    );
    return '$_temp0';
  }

  @override
  String get recordEdit => 'Wert bearbeiten';

  @override
  String get recordNameHint => '@ für die Zone selbst, z. B. www oder mail.';

  @override
  String recordsBulkEdit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Record Sets',
      one: '1 Record Set',
    );
    return '$_temp0 bearbeiten';
  }

  @override
  String get recordsEditSelected => 'Auswahl bearbeiten';

  @override
  String get recordsEmpty => 'Noch keine Records.';

  @override
  String recordsFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Record Sets fehlgeschlagen',
      one: '1 Record Set fehlgeschlagen',
    );
    return '$_temp0';
  }

  @override
  String get recordsFromPrimaries =>
      'Die Einträge einer sekundären Zone kommen von ihren primären Nameservern.';

  @override
  String get recordsBulkTtlOnly =>
      'Verschiedene Typen: nur die TTL ist änderbar.';

  @override
  String get recordsBulkValueConsequence =>
      'Alle Werte dieser Record Sets werden durch den neuen Wert ersetzt.';

  @override
  String get recordsBulkTtlConsequence =>
      'Diese Record Sets erhalten die neue TTL.';

  @override
  String get recordsSelect => 'Records auswählen';

  @override
  String get recordsUpdated => 'Records aktualisiert';

  @override
  String get resourceCertificate => 'Zertifikat';

  @override
  String get resourceCertificates => 'Zertifikate';

  @override
  String get resourceFirewall => 'Firewall';

  @override
  String get resourceFloatingIp => 'Floating IP';

  @override
  String get resourceFloatingIps => 'Floating IPs';

  @override
  String get resourceLoadBalancers => 'Load Balancer';

  @override
  String get resourceNetwork => 'Netzwerk';

  @override
  String get resourcePrimaryIp => 'Primary IP';

  @override
  String get resourcePrimaryIps => 'Primary IPs';

  @override
  String get resourceRecord => 'Record Set';

  @override
  String get resourceZone => 'DNS Zone';

  @override
  String get resourceZones => 'DNS';

  @override
  String get routeAdd => 'Route hinzufügen';

  @override
  String routeDeleteConsequence(String gateway) {
    return 'Verkehr über $gateway für dieses Ziel endet.';
  }

  @override
  String routeDeleteTitle(String destination) {
    return 'Route nach $destination löschen?';
  }

  @override
  String get routesEmpty => 'Keine Routen.';

  @override
  String get rrsetDeleteConsequence =>
      'Alle Werte dieses Record Sets werden gelöscht.';

  @override
  String get rrsetProtectOffConsequence =>
      'Seine Werte lassen sich wieder ändern und löschen.';

  @override
  String get rrsetProtectOnConsequence =>
      'Seine Werte lassen sich erst nach Aufheben des Schutzes ändern oder löschen.';

  @override
  String get ruleAdd => 'Regel hinzufügen';

  @override
  String ruleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Regeln',
      one: '1 Regel',
    );
    return '$_temp0';
  }

  @override
  String get ruleDeleteConsequence =>
      'Verkehr, den diese Regel erlaubt hat, wird auf allen Servern der Firewall blockiert.';

  @override
  String ruleDeleteTitle(String rule) {
    return 'Regel $rule löschen?';
  }

  @override
  String get ruleEdit => 'Regel bearbeiten';

  @override
  String get ruleInbound => 'Eingehend';

  @override
  String get ruleOutbound => 'Ausgehend';

  @override
  String get rulesEmpty => 'Keine Regeln.';

  @override
  String secondsHint(int min, int max) {
    return '$min bis $max Sekunden';
  }

  @override
  String get sectionAppliedTo => 'Angewendet auf';

  @override
  String get sectionMembers => 'Mitglieder';

  @override
  String get sectionPrimaries => 'Primäre Nameserver';

  @override
  String get sectionRecords => 'Records';

  @override
  String get sectionRoutes => 'Routen';

  @override
  String get sectionRules => 'Regeln';

  @override
  String get sectionServices => 'Services';

  @override
  String get sectionSubnets => 'Subnetze';

  @override
  String get sectionTargets => 'Ziele';

  @override
  String get sectionUsedBy => 'Genutzt von';

  @override
  String get selectAll => 'Alle wählen';

  @override
  String get selectClear => 'Leeren';

  @override
  String selectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get selectorHint => 'z. B. role=web,env=prod';

  @override
  String get serverNoNetworks =>
      'Keine weiteren Netzwerke zum Verbinden. Erstelle eines unter Netzwerk.';

  @override
  String get serviceAdd => 'Service hinzufügen';

  @override
  String serviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Services',
      one: '1 Service',
    );
    return '$_temp0';
  }

  @override
  String get serviceDeleteConsequence =>
      'Der Load Balancer hört nicht mehr auf diesem Port.';

  @override
  String serviceDeleteTitle(String service) {
    return 'Service $service löschen?';
  }

  @override
  String get serviceEdit => 'Service bearbeiten';

  @override
  String get servicesEmpty => 'Keine Services.';

  @override
  String get sortExpiry => 'Ablauf';

  @override
  String get subnetAdd => 'Subnetz hinzufügen';

  @override
  String subnetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Subnetze',
      one: '1 Subnetz',
    );
    return '$_temp0';
  }

  @override
  String get subnetDeleteConsequence =>
      'Server in diesem Subnetz verlieren ihre privaten IPs darin.';

  @override
  String subnetDeleteTitle(String range) {
    return 'Subnetz $range löschen?';
  }

  @override
  String subnetRangeHint(String range) {
    return 'Optional, innerhalb von $range. Leer wählt den nächsten freien Bereich.';
  }

  @override
  String get subnetsEmpty => 'Keine Subnetze.';

  @override
  String get targetAdd => 'Ziel hinzufügen';

  @override
  String targetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ziele',
      one: '1 Ziel',
    );
    return '$_temp0';
  }

  @override
  String get targetIpHint =>
      'Eine öffentliche IP eines dedizierten Servers, z. B. 203.0.113.7.';

  @override
  String get targetRemoveConsequence =>
      'Der Load Balancer schickt keinen Verkehr mehr dorthin.';

  @override
  String targetRemoveTitle(String target) {
    return 'Ziel $target entfernen?';
  }

  @override
  String get targetsEmpty => 'Keine Ziele.';

  @override
  String get ttlCreateHint =>
      'Optional, 60 Sekunden oder mehr. Leer nutzt 3600.';

  @override
  String ttlDefault(int ttl) {
    return 'Standard der Zone ($ttl s)';
  }

  @override
  String ttlHint(int ttl) {
    return 'Optional, 60 Sekunden oder mehr. Leer nutzt den Standard der Zone von $ttl s.';
  }

  @override
  String get ttlLimits => '60 Sekunden oder mehr.';

  @override
  String ttlValue(int ttl) {
    return 'TTL $ttl s';
  }

  @override
  String get valueAdd => 'Wert hinzufügen';

  @override
  String get valueRemoveConsequence =>
      'Dieser Wert wird aus dem Record Set entfernt.';

  @override
  String valueRemoveTitle(String value) {
    return '$value entfernen?';
  }

  @override
  String get valuesHint =>
      'Ein Wert pro Zeile. TXT erhält Anführungszeichen, Hostnamen einen Punkt am Ende.';

  @override
  String get zoneCreate => 'Zone erstellen';

  @override
  String get zoneDeleteConsequence =>
      'Die Zone mit allen Records wird gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String get zoneExport => 'Exportieren';

  @override
  String get zoneExported => 'Zonendatei gespeichert';

  @override
  String get zoneImport => 'Zonendatei importieren';

  @override
  String get zoneImportConsequence =>
      'Alle Records der Zone werden durch die der Datei ersetzt.';

  @override
  String zoneImportTitle(String name) {
    return 'Alle Records von $name ersetzen?';
  }

  @override
  String get zonePrimary => 'Primär';

  @override
  String get zonePrimaryHint =>
      'Hetzner hält die Records; du bearbeitest sie hier.';

  @override
  String get zoneSecondary => 'Sekundär';

  @override
  String get zoneSecondaryHint =>
      'Hetzner überträgt die Zone von deinen primären Nameservern.';

  @override
  String get zonefileTooLarge => 'Die Datei ist größer als 1 MiB.';

  @override
  String get accessExternal => 'Von außen erreichbar';

  @override
  String get accessReadonly => 'Nur lesen';

  @override
  String get accessSamba => 'Samba (SMB)';

  @override
  String get accessSsh => 'SSH und SFTP';

  @override
  String get accessWebdav => 'WebDAV';

  @override
  String get accessZfs => 'ZFS Snapshot Ordner';

  @override
  String get boxAccessSettings => 'Zugriff';

  @override
  String get boxAutomatic => 'Automatisch';

  @override
  String get boxAutomaticSnapshots => 'Automatische Snapshots';

  @override
  String get boxChangeType => 'Typ ändern';

  @override
  String get boxDeleteConsequence =>
      'Die Storage Box, ihre Snapshots und Subaccounts werden mit allen Daten gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String get boxEveryDay => 'Jeden Tag';

  @override
  String get boxMaxSnapshots => 'Aufzubewahrende Snapshots';

  @override
  String get boxNewFolder => 'Neuer Ordner';

  @override
  String get boxPasswordHint =>
      '12 bis 128 Zeichen mit Groß- und Kleinbuchstaben, einer Ziffer und einem Sonderzeichen.';

  @override
  String boxPlanDaily(String time) {
    return 'Täglich um $time';
  }

  @override
  String get boxPlanHour => 'Stunde';

  @override
  String boxPlanKeeps(String when, int count) {
    return '$when, behält $count';
  }

  @override
  String get boxPlanMinute => 'Minute';

  @override
  String get boxPlanMonthday => 'Tag im Monat';

  @override
  String boxPlanMonthly(int day, String time) {
    return 'Monatlich am $day. um $time';
  }

  @override
  String get boxPlanUtc => 'Zeiten in UTC.';

  @override
  String get boxPlanWeekday => 'Wochentag';

  @override
  String boxPlanWeekly(String day, String time) {
    return 'Jeden $day um $time';
  }

  @override
  String get boxResetPassword => 'Passwort zurücksetzen';

  @override
  String get boxRollback => 'Zurücksetzen';

  @override
  String get boxRollbackConsequence =>
      'Alle Daten der Storage Box werden durch den Stand dieses Snapshots ersetzt. Neuere Daten gehen verloren.';

  @override
  String boxRollbackTitle(String name) {
    return 'Auf $name zurücksetzen?';
  }

  @override
  String get boxSnapshotCreate => 'Snapshot erstellen';

  @override
  String get boxSnapshotDeleteConsequence =>
      'Der Snapshot wird gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String get boxSnapshotPlan => 'Snapshot Plan';

  @override
  String get boxUsage => 'Belegung';

  @override
  String get boxUsedData => 'Belegt durch Daten';

  @override
  String boxUsedOf(String used, String size) {
    return '$used von $size belegt';
  }

  @override
  String get boxUsedSnapshots => 'Belegt durch Snapshots';

  @override
  String get bucketCreate => 'Bucket erstellen';

  @override
  String get bucketDelete => 'Bucket löschen';

  @override
  String get bucketDeleteConsequence =>
      'Der Bucket wird gelöscht. Er muss leer sein.';

  @override
  String get bucketNameHint =>
      '3 bis 63 Kleinbuchstaben, Ziffern, Punkte und Bindestriche.';

  @override
  String get bucketNotEmpty =>
      'Der Bucket ist nicht leer. Lösche zuerst seine Objekte.';

  @override
  String get bucketPrivate => 'Privat';

  @override
  String get bucketPublic => 'Öffentlich';

  @override
  String get bucketPublicHint =>
      'Öffentlich: alle können die Objekte ohne Link lesen.';

  @override
  String get bucketSettings => 'Bucket Einstellungen';

  @override
  String get bucketVersioning => 'Versionierung';

  @override
  String get bucketVersioningHint =>
      'Aktiviert behält jede Version eines Objekts. Ausgesetzt behält vorhandene Versionen, legt aber keine neuen an; ganz abschalten lässt sie sich nicht mehr.';

  @override
  String get bucketVisibility => 'Sichtbarkeit';

  @override
  String get commonShare => 'Teilen';

  @override
  String days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String downloadSaved(String name) {
    return 'Download gespeichert: $name';
  }

  @override
  String downloadStarted(String name) {
    return '$name wird im Hintergrund geladen';
  }

  @override
  String get emptyBoxSnapshots => 'Noch keine Snapshots.';

  @override
  String get emptyBuckets => 'Noch keine Buckets in diesem Projekt.';

  @override
  String get emptyObjects => 'Dieser Ordner ist leer.';

  @override
  String get emptyStorageBoxes => 'Noch keine Storage Boxen in diesem Projekt.';

  @override
  String get emptySubaccounts => 'Noch keine Subaccounts.';

  @override
  String get fieldContentType => 'Inhaltstyp';

  @override
  String get fieldEtag => 'ETag';

  @override
  String get fieldFolderName => 'Ordnername';

  @override
  String get fieldHomeDirectory => 'Home Verzeichnis';

  @override
  String get fieldKey => 'Schlüssel';

  @override
  String get fieldModified => 'Zuletzt geändert';

  @override
  String get fieldPassword => 'Passwort';

  @override
  String get fieldPasswordRepeat => 'Passwort wiederholen';

  @override
  String get fieldServer => 'Server';

  @override
  String get fieldUsername => 'Benutzer';

  @override
  String get folderCreate => 'Ordner anlegen';

  @override
  String hours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String get objectCopy => 'Kopieren';

  @override
  String get objectDeleteConsequence =>
      'Die Objekte werden gelöscht. Mit Versionierung bleiben ältere Versionen erhalten.';

  @override
  String get objectDownload => 'Herunterladen';

  @override
  String get objectInfo => 'Info';

  @override
  String get objectKeyInvalid =>
      'Diese Datei kann unter diesem Namen nicht gespeichert werden.';

  @override
  String get objectKeyDotSegment =>
      'Falco kann dieses Objekt nicht öffnen: Sein Schlüssel enthält \".\" oder \"..\" als Ordnernamen, den jeder Link auf einen anderen Schlüssel auflöst.';

  @override
  String get objectMove => 'Verschieben';

  @override
  String get objectUpload => 'Hochladen';

  @override
  String get objectVersions => 'Versionen';

  @override
  String objectsDeleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Objekte löschen?',
      one: '1 Objekt löschen?',
    );
    return '$_temp0';
  }

  @override
  String objectsDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Objekte gelöscht',
      one: '1 Objekt gelöscht',
    );
    return '$_temp0';
  }

  @override
  String objectsDeletedPartly(int deleted, int failed) {
    return '$deleted gelöscht, $failed fehlgeschlagen und weiter ausgewählt';
  }

  @override
  String get resourceBoxSnapshot => 'Snapshot';

  @override
  String get resourceBucket => 'Bucket';

  @override
  String get resourceBuckets => 'Buckets';

  @override
  String get resourceObjectStorage => 'Object Storage';

  @override
  String get resourceStorageBox => 'Storage Box';

  @override
  String get resourceStorageBoxes => 'Storage Boxen';

  @override
  String get resourceSubaccount => 'Subaccount';

  @override
  String get s3NoKeysHint =>
      'Dieses Projekt hat keine S3 Schlüssel. Hinterlege sie am Projekt, um Object Storage zu nutzen.';

  @override
  String get sectionSnapshots => 'Snapshots';

  @override
  String get sectionSubaccounts => 'Subaccounts';

  @override
  String get selectionClear => 'Auswahl aufheben';

  @override
  String get shareExpiry => 'Gültig für';

  @override
  String get shareLink => 'Freigabelink';

  @override
  String get statusActive => 'aktiv';

  @override
  String get statusLocked => 'gesperrt';

  @override
  String get storageBoxCreate => 'Storage Box erstellen';

  @override
  String get subaccountCreate => 'Subaccount anlegen';

  @override
  String get subaccountDeleteConsequence =>
      'Der Subaccount kann sich nicht mehr anmelden. Seine Dateien bleiben in der Storage Box.';

  @override
  String get transferDone => 'Übertragung fertig';

  @override
  String get transferFailed => 'Übertragung fehlgeschlagen';

  @override
  String transferFailedNamed(String name) {
    return 'Übertragung von $name fehlgeschlagen';
  }

  @override
  String get transferRunning => 'Wird übertragen';

  @override
  String uploadDone(String name) {
    return 'Hochgeladen: $name';
  }

  @override
  String get uploadLink => 'Upload Link';

  @override
  String uploadStarted(String name) {
    return '$name wird im Hintergrund hochgeladen';
  }

  @override
  String get versionDeleteMarker => 'gelöscht';

  @override
  String get versionLatest => 'aktuell';

  @override
  String get versionRestore => 'Wiederherstellen';

  @override
  String get versionRestoreConsequence =>
      'Diese Version wird wieder das aktuelle Objekt; das aktuelle bleibt als ältere Version.';

  @override
  String versionRestoreTitle(String name) {
    return 'Diese Version von $name wiederherstellen?';
  }

  @override
  String get versioningEnabled => 'Aktiviert';

  @override
  String get versioningNever => 'Nie aktiviert';

  @override
  String get versioningSuspended => 'Ausgesetzt';

  @override
  String get versionsEmpty => 'Keine Versionen.';

  @override
  String get addressCancelConsequence =>
      'Die Adresse wird zum gewählten Datum gekündigt und danach nicht mehr zum Server geleitet.';

  @override
  String get bootActivate => 'Aktivieren';

  @override
  String get bootActivated => 'Aktiv beim nächsten Reset';

  @override
  String get bootDeactivate => 'Deaktivieren';

  @override
  String get bootDist => 'Distribution';

  @override
  String get bootKeysHint =>
      'Robot Keys für den Root Login; ohne Keys gilt ein Passwort.';

  @override
  String get bootLang => 'Sprache';

  @override
  String get bootLastLinux => 'Letzte Linux Installation';

  @override
  String get bootLastRescue => 'Letzte Rescue Aktivierung';

  @override
  String get bootLinux => 'Linux Installation';

  @override
  String get bootNone => 'Keine Boot Konfiguration aktiv.';

  @override
  String get bootOffConsequence =>
      'Der nächste Reset startet wieder von den Platten.';

  @override
  String bootOffTitle(String config, String name) {
    return '$config für $name deaktivieren?';
  }

  @override
  String get bootOs => 'Betriebssystem';

  @override
  String get bootPasswordNote =>
      'Aktiv beim nächsten Reset. Kopiere das Passwort jetzt; Falco speichert es nicht.';

  @override
  String get bootRescue => 'Rescue System';

  @override
  String get bootVnc => 'VNC Installation';

  @override
  String get bootWindows => 'Windows Installation';

  @override
  String cancelAtDate(String date) {
    return 'Zu einem Datum (ab $date)';
  }

  @override
  String get cancelConsequence =>
      'Der Server wird zum gewählten Datum gekündigt. Seine Daten werden dann gelöscht.';

  @override
  String get cancelDate => 'Kündigungsdatum';

  @override
  String get cancelEarliest => 'Frühestes Datum';

  @override
  String get cancelNow => 'Sofort';

  @override
  String get cancelReason => 'Grund (optional)';

  @override
  String get cancelReserve => 'Standort reservieren';

  @override
  String get cancelReserveHint =>
      'Hält den Platz im Rack für einen neuen Server frei.';

  @override
  String cancelTitle(String name) {
    return '$name kündigen?';
  }

  @override
  String get cancelWithdraw => 'Kündigung zurückziehen';

  @override
  String get cancelWithdrawConsequence =>
      'Die Kündigung wird zurückgezogen; der Vertrag läuft weiter.';

  @override
  String cancelWithdrawTitle(String name) {
    return 'Kündigung von $name zurückziehen?';
  }

  @override
  String get cancellation => 'Kündigung';

  @override
  String cancelledOn(String date) {
    return 'gekündigt zum $date';
  }

  @override
  String get failoverActive => 'Aktiv auf';

  @override
  String failoverActiveOn(String server) {
    return 'Aktiv auf $server';
  }

  @override
  String get failoverEmpty => 'Keine Failover IPs.';

  @override
  String get failoverNoTargets => 'Kein anderer Server als Ziel.';

  @override
  String get failoverOwner => 'Bestellt mit';

  @override
  String get failoverRoute => 'Umleiten';

  @override
  String get failoverRouteConsequence =>
      'Verkehr an die Adresse geht in Sekunden zum neuen Server. Die Adresse muss dort konfiguriert sein.';

  @override
  String failoverRouteTitle(String ip, String server) {
    return '$ip zu $server leiten?';
  }

  @override
  String get failoverUnroute => 'Routing aufheben';

  @override
  String get failoverUnrouteConsequence =>
      'Die Adresse zeigt auf keinen Server mehr; Dienste darauf sind nicht mehr erreichbar.';

  @override
  String failoverUnrouteTitle(String ip) {
    return 'Routing von $ip aufheben?';
  }

  @override
  String get failoverUnrouted => 'Nicht geroutet';

  @override
  String get fileNotText => 'Die Datei ist kein UTF-8 Text.';

  @override
  String get fileTooLarge => 'Die Datei ist zu groß.';

  @override
  String get filterCancelled => 'Gekündigt';

  @override
  String get firewallClear => 'Firewall leeren';

  @override
  String get firewallClearConsequence =>
      'Alle Regeln der Server Firewall werden entfernt.';

  @override
  String get firewallClearTitle => 'Firewall leeren?';

  @override
  String get firewallDisable => 'Ausschalten';

  @override
  String get firewallEnable => 'Einschalten';

  @override
  String get firewallFilterIpv6 => 'IPv6 filtern';

  @override
  String get firewallHetznerServices => 'Hetzner Dienste erlauben';

  @override
  String get firewallRules => 'Regeln';

  @override
  String get firewallTemplateApplyConsequence =>
      'Alle Regeln der Server Firewall werden durch die Regeln der Vorlage ersetzt.';

  @override
  String firewallTemplateApplyTitle(String name) {
    return 'Vorlage $name anwenden?';
  }

  @override
  String get firewallUnsaved => 'noch nicht übernommen';

  @override
  String get firewallUseTemplate => 'Vorlage anwenden';

  @override
  String get installConsequence =>
      'Beim nächsten Reset startet die Installation und löscht alle Daten auf den Platten.';

  @override
  String installTitle(String name) {
    return '$name neu installieren?';
  }

  @override
  String get keyBits => 'Bits';

  @override
  String get keyFromFile => 'Aus Datei';

  @override
  String get macOff => 'MAC entfernen';

  @override
  String get macOffConsequence =>
      'Die Adresse nutzt wieder die MAC des Servers.';

  @override
  String macOffTitle(String ip) {
    return 'Eigene MAC von $ip entfernen?';
  }

  @override
  String get macOn => 'Eigene MAC';

  @override
  String get macOnConsequence =>
      'Robot erzeugt eine eigene MAC Adresse, etwa für eine virtuelle Maschine.';

  @override
  String macOnTitle(String ip) {
    return 'Eigene MAC für $ip anlegen?';
  }

  @override
  String get macUnavailable => 'nicht möglich';

  @override
  String get notCancelled => 'Nicht gekündigt';

  @override
  String get rdnsCreate => 'Reverse DNS anlegen';

  @override
  String get rdnsDefault => 'Standard Reverse DNS';

  @override
  String get rdnsDeleteConsequence =>
      'Die Adresse antwortet wieder mit dem Hetzner Standard.';

  @override
  String rdnsDeleteTitle(String ip) {
    return 'Reverse DNS von $ip löschen?';
  }

  @override
  String get rdnsEmpty => 'Keine Reverse DNS Einträge.';

  @override
  String get resetHw => 'Hardware Reset';

  @override
  String get resetMan => 'Manueller Reset durch den Support';

  @override
  String get resetManConsequence =>
      'Ein Techniker setzt den Server von Hand zurück; das kann dauern.';

  @override
  String get resetPower => 'Power Taste';

  @override
  String get resetPowerLong => 'Power Taste, lang gedrückt';

  @override
  String get resetSw => 'Software Reset (Strg+Alt+Entf)';

  @override
  String get robotActivityEmpty =>
      'Noch keine Robot Änderungen in dieser Sitzung.';

  @override
  String get robotBoot => 'Boot Konfiguration';

  @override
  String get robotBroadcast => 'Broadcast';

  @override
  String get robotCancel => 'Kündigen';

  @override
  String get robotDatacenter => 'Rechenzentrum';

  @override
  String get robotDone => 'Aktion ausgeführt';

  @override
  String robotFailed(String reason) {
    return 'Aktion fehlgeschlagen: $reason';
  }

  @override
  String get robotFailover => 'Failover';

  @override
  String get robotFirewall => 'Firewall';

  @override
  String get robotIp => 'IP Adresse';

  @override
  String get robotIps => 'IPs';

  @override
  String get robotIpsEmpty => 'Keine einzelnen IPs.';

  @override
  String get robotIpv6Net => 'IPv6 Netz';

  @override
  String get robotKeyDeleteConsequence =>
      'Der Key wird aus Robot gelöscht. Server behalten früher installierte Keys.';

  @override
  String get robotKeysEmpty => 'Noch keine SSH Keys in Robot.';

  @override
  String get robotLocked => 'Gesperrt';

  @override
  String get robotMac => 'Eigene MAC';

  @override
  String get robotNetmask => 'Netzmaske';

  @override
  String get robotNoAccess => 'Dieser Account hat keinen Robot Zugang.';

  @override
  String get robotNumber => 'Nummer';

  @override
  String robotPaidUntil(String date) {
    return 'bezahlt bis $date';
  }

  @override
  String get robotPaidUntilLabel => 'Bezahlt bis';

  @override
  String get robotProduct => 'Produkt';

  @override
  String get robotResetConsequence =>
      'Der Server startet neu; nicht gespeicherte Daten gehen verloren.';

  @override
  String get robotSectionDisabled =>
      'Schalte diesen Bereich für den Webservice Benutzer in Hetzner Robot frei.';

  @override
  String get robotServer => 'Dedicated Server';

  @override
  String get robotServers => 'Server';

  @override
  String get robotServersEmpty => 'Keine Dedicated Server.';

  @override
  String get robotSubnet => 'Subnetz';

  @override
  String get robotSubnets => 'Subnetze';

  @override
  String get robotTemplate => 'Firewall Vorlage';

  @override
  String get robotTemplates => 'Firewall Vorlagen';

  @override
  String get robotTrafficQuota => 'Inklusiv Traffic';

  @override
  String get robotVSwitch => 'vSwitch';

  @override
  String get robotVSwitches => 'vSwitches';

  @override
  String get robotWol => 'Wake on LAN';

  @override
  String get ruleAccept => 'erlauben';

  @override
  String get ruleAction => 'Aktion';

  @override
  String get ruleAny => 'alle';

  @override
  String get ruleDestIp => 'Ziel IP';

  @override
  String get ruleDestPort => 'Ziel Port';

  @override
  String get ruleDiscard => 'verwerfen';

  @override
  String get ruleFrom => 'von';

  @override
  String get ruleInput => 'Eingehend';

  @override
  String get ruleIpVersion => 'IP Version';

  @override
  String get ruleOutput => 'Ausgehend';

  @override
  String get ruleSourceIp => 'Quell IP';

  @override
  String get ruleSourcePort => 'Quell Port';

  @override
  String get ruleTcpFlags => 'TCP Flags';

  @override
  String get ruleTo => 'nach';

  @override
  String get statusCancelled => 'gekündigt';

  @override
  String get templateCreate => 'Vorlage anlegen';

  @override
  String get templateDefault => 'Standardvorlage';

  @override
  String get templateDeleteConsequence =>
      'Die Vorlage wird gelöscht. Server Firewalls behalten ihre Regeln.';

  @override
  String get templatesEmpty => 'Keine Firewall Vorlagen.';

  @override
  String get trafficDaily => 'Tageslimit (MB)';

  @override
  String get trafficDay => 'Tag';

  @override
  String get trafficHourly => 'Stundenlimit (MB)';

  @override
  String get trafficIn => 'Eingehend';

  @override
  String get trafficMonth => 'Traffic diesen Monat';

  @override
  String get trafficMonthType => 'Monat';

  @override
  String get trafficMonthly => 'Monatslimit (GB)';

  @override
  String get trafficNone => 'Keine Trafficdaten für diesen Zeitraum.';

  @override
  String get trafficOut => 'Ausgehend';

  @override
  String get trafficSum => 'Gesamt';

  @override
  String get trafficTitle => 'Traffic';

  @override
  String get trafficWarnings => 'Traffic Warnungen';

  @override
  String get trafficWarningsOn => 'Warnungen an';

  @override
  String get trafficYear => 'Jahr';

  @override
  String get vlanHint => 'VLAN ID von 4000 bis 4091';

  @override
  String get vswitchAddServer => 'Server hinzufügen';

  @override
  String get vswitchCancelConsequence =>
      'Der vSwitch wird zum gewählten Datum gekündigt; seine Server verlieren die Verbindung.';

  @override
  String get vswitchCreate => 'vSwitch anlegen';

  @override
  String get vswitchEmpty => 'Noch keine vSwitches.';

  @override
  String get vswitchNoServers => 'Keine Server in diesem vSwitch.';

  @override
  String get vswitchRemoveConsequence =>
      'Der Server verlässt das VLAN; sein Verkehr dort endet.';

  @override
  String vswitchRemoveTitle(String server, String vswitch) {
    return '$server aus $vswitch entfernen?';
  }

  @override
  String get wolConsequence => 'Ein Wake on LAN Paket geht an den Server.';

  @override
  String wolTitle(String name) {
    return '$name aufwecken?';
  }

  @override
  String get activityType => 'Typ';

  @override
  String get activityTime => 'Zeitraum';

  @override
  String get activityAnyTime => 'Beliebig';

  @override
  String get activityLastDay => 'Letzte 24 Stunden';

  @override
  String get activityLastWeek => 'Letzte 7 Tage';

  @override
  String get activityLastMonth => 'Letzte 30 Tage';

  @override
  String get activityToday => 'Heute';

  @override
  String get activityYesterday => 'Gestern';

  @override
  String get activityEarlier => 'Früher';

  @override
  String get searchHint => 'Name, IP, Label oder ID';

  @override
  String get searchStart =>
      'Suche nach Servern, IPs, Labels und IDs in allen Accounts, Projekten und Robot.';

  @override
  String get searchClear => 'Leeren';

  @override
  String get searchRecent => 'Letzte Suchen';

  @override
  String get searchResults => 'Treffer';

  @override
  String get searchNoMatches => 'Keine Treffer.';

  @override
  String get searchDedicated => 'Dedicated Server';

  @override
  String get searchRobotKeys => 'Robot SSH Keys';
}
