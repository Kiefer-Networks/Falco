// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Falco';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonLoading => 'Loading';

  @override
  String get moreActions => 'More actions';

  @override
  String get listSort => 'Sort';

  @override
  String listSortBy(String field) {
    return 'Sort: $field';
  }

  @override
  String get listNoMatches => 'No results for this search or filter.';

  @override
  String get listStaleBanner =>
      'Could not refresh. Showing the last loaded data.';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorNetwork => 'No connection to the server. Check your network.';

  @override
  String get copied => 'Copied to clipboard';

  @override
  String copiedSensitive(int seconds) {
    return 'Copied. The clipboard clears in $seconds s.';
  }

  @override
  String copyValue(String value) {
    return 'Copy $value';
  }

  @override
  String get secretShow => 'Show';

  @override
  String get secretHide => 'Hide';

  @override
  String get secretHidden => 'Hidden secret';

  @override
  String get statusRunning => 'running';

  @override
  String get statusOff => 'off';

  @override
  String get statusStarting => 'starting';

  @override
  String get statusStopping => 'stopping';

  @override
  String get statusRebooting => 'rebooting';

  @override
  String get statusInitializing => 'initializing';

  @override
  String get statusRebuilding => 'rebuilding';

  @override
  String get statusMigrating => 'migrating';

  @override
  String get statusDeleting => 'deleting';

  @override
  String get statusError => 'error';

  @override
  String get statusUnknown => 'unknown';

  @override
  String get periodHour => '1h';

  @override
  String get periodDay => '24h';

  @override
  String get periodWeek => '7d';

  @override
  String get periodMonth => '30d';

  @override
  String get chartPeriod => 'Period';

  @override
  String get chartNoData => 'No data for this period.';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String wizardStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get wizardSummary => 'Summary';

  @override
  String get wizardProject => 'Project';

  @override
  String confirmTypeName(String name) {
    return 'Type $name to confirm.';
  }

  @override
  String get confirmTypeNameLabel => 'Name';

  @override
  String get scopeProject => 'Project';

  @override
  String get scopeSwitch => 'Switch account or project';

  @override
  String get scopeAllProjects => 'All projects';

  @override
  String get scopeRobot => 'Robot';

  @override
  String get relativeJustNow => 'just now';

  @override
  String relativeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String relativeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String relativeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get showcaseTitle => 'Design system';

  @override
  String get showcaseTheme => 'Theme';

  @override
  String get showcaseDark => 'Dark';

  @override
  String get showcaseLight => 'Light';

  @override
  String get showcaseOled => 'OLED';

  @override
  String get showcaseAccent => 'Accent';

  @override
  String get showcaseOpen => 'Open';

  @override
  String get resourceServers => 'Servers';

  @override
  String get resourceServer => 'Server';

  @override
  String get filterAll => 'All';

  @override
  String get sortName => 'name';

  @override
  String get sortCreated => 'created';

  @override
  String get actionReboot => 'Reboot';

  @override
  String get actionShutdown => 'Shutdown';

  @override
  String get actionConsole => 'Console';

  @override
  String get actionSnapshot => 'Snapshot';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRebuild => 'Rebuild';

  @override
  String get actionCreateServer => 'Create server';

  @override
  String get emptyServers => 'No servers in this project yet.';

  @override
  String get sectionOverview => 'Overview';

  @override
  String get sectionMetrics => 'Metrics';

  @override
  String get metricCpu => 'CPU';

  @override
  String get metricNetwork => 'Network';

  @override
  String get metricIn => 'in';

  @override
  String get metricOut => 'out';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldLocation => 'Location';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldRootPassword => 'Root password';

  @override
  String rebootTitle(String name) {
    return 'Reboot $name?';
  }

  @override
  String get rebootConsequence =>
      'The server restarts through ACPI. Open connections drop while it boots, usually for less than a minute.';

  @override
  String deleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get deleteConsequence =>
      'The server and its disk are deleted. This cannot be undone.';
}
