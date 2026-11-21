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
  String get errorTitle => 'Etwas ist schiefgelaufen';

  @override
  String get errorNetwork =>
      'Keine Verbindung zum Server. Prüfe dein Netzwerk.';

  @override
  String get copied => 'In die Zwischenablage kopiert';

  @override
  String copiedSensitive(int seconds) {
    return 'Kopiert. Die Zwischenablage wird nach $seconds s geleert.';
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
      'Der Server und seine Festplatte werden gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String get scopeEmpty => 'In diesem Bereich gibt es noch nichts anzuzeigen.';

  @override
  String get lockTitle => 'Falco ist gesperrt.';

  @override
  String get lockUnlock => 'Entsperren';

  @override
  String get lockReason => 'Entsperre Falco, um auf deine Server zuzugreifen';

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
}
