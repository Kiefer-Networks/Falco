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
}
