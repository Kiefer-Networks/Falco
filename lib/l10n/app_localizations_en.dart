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

  @override
  String get scopeEmpty => 'Nothing to show in this scope yet.';

  @override
  String get lockTitle => 'Falco is locked.';

  @override
  String get lockUnlock => 'Unlock';

  @override
  String get lockReason => 'Unlock Falco to access your servers';

  @override
  String get errorUnauthorized =>
      'The access data was rejected. Check the token or the credentials.';

  @override
  String get errorForbidden =>
      'This access lacks the permission for this action, for example a read only token.';

  @override
  String get errorNotFound => 'This resource no longer exists.';

  @override
  String get errorConflict =>
      'The resource is protected, locked or busy. Try again later.';

  @override
  String get errorRateLimited =>
      'Too many requests. Wait a moment and try again.';

  @override
  String get errorInvalid => 'The input was rejected. Check the marked fields.';

  @override
  String get errorPinning =>
      'The server certificate is not trusted. The connection was stopped to protect your access data.';

  @override
  String get errorServer => 'The server reported an error. Try again later.';

  @override
  String get statusInProgress => 'in progress';

  @override
  String get statusDone => 'done';

  @override
  String get statusFailed => 'failed';

  @override
  String get navCompute => 'Compute';

  @override
  String get navNetwork => 'Network';

  @override
  String get navStorage => 'Storage';

  @override
  String get navRobot => 'Robot';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityEmpty => 'No actions yet.';

  @override
  String get activityShowAll => 'Show all activity';

  @override
  String get filterRunning => 'Running';

  @override
  String get filterOff => 'Off';

  @override
  String get filterInProgress => 'In progress';

  @override
  String get filterFailed => 'Failed';

  @override
  String get actionPowerOn => 'Power on';

  @override
  String get actionPowerOff => 'Power off';

  @override
  String get actionReset => 'Reset';

  @override
  String shutdownTitle(String name) {
    return 'Shut down $name?';
  }

  @override
  String get shutdownConsequence =>
      'The operating system is asked to shut down through ACPI. The server stays off until you power it on.';

  @override
  String powerOffTitle(String name) {
    return 'Power off $name?';
  }

  @override
  String get powerOffConsequence =>
      'The power is cut immediately, like pulling the plug. Unsaved data can be lost.';

  @override
  String resetTitle(String name) {
    return 'Reset $name?';
  }

  @override
  String get resetConsequence =>
      'The server is restarted hard, like pressing the reset button. Unsaved data can be lost.';

  @override
  String get actionFailed => 'The action failed.';

  @override
  String get fieldVcpu => 'vCPU';

  @override
  String get fieldMemory => 'Memory';

  @override
  String get fieldDisk => 'Disk';

  @override
  String get fieldImage => 'Image';

  @override
  String get metricDisk => 'Disk';

  @override
  String get metricRead => 'read';

  @override
  String get metricWrite => 'write';

  @override
  String get sectionActivity => 'Activity';

  @override
  String get accountAdd => 'Add account';

  @override
  String get projectAdd => 'Add project';

  @override
  String get accountStep => 'Account';

  @override
  String get projectStep => 'Cloud project';

  @override
  String get fieldAccountName => 'Account name';

  @override
  String get fieldProjectName => 'Project name';

  @override
  String get fieldApiToken => 'API token';

  @override
  String get tokenHint =>
      'Create a token with read and write access in the Hetzner Cloud Console under Security, API tokens.';

  @override
  String get tokenCheckSave => 'Check and save';

  @override
  String get tokenHidden => 'hidden';

  @override
  String actionCommand(String command) {
    String _temp0 = intl.Intl.selectLogic(command, {
      'start_server': 'Power on server',
      'stop_server': 'Power off server',
      'poweron_server': 'Power on server',
      'poweroff_server': 'Power off server',
      'shutdown_server': 'Shut down server',
      'reboot_server': 'Reboot server',
      'reset_server': 'Reset server',
      'create_server': 'Create server',
      'delete_server': 'Delete server',
      'rebuild_server': 'Rebuild server',
      'change_server_type': 'Change server type',
      'enable_rescue': 'Enable rescue mode',
      'disable_rescue': 'Disable rescue mode',
      'attach_iso': 'Attach ISO',
      'detach_iso': 'Detach ISO',
      'create_image': 'Create image',
      'enable_backup': 'Enable backups',
      'disable_backup': 'Disable backups',
      'change_protection': 'Change protection',
      'change_dns_ptr': 'Change reverse DNS',
      'reset_password': 'Reset root password',
      'request_console': 'Open console',
      'attach_volume': 'Attach volume',
      'detach_volume': 'Detach volume',
      'resize_volume': 'Resize volume',
      'create_volume': 'Create volume',
      'attach_to_network': 'Attach to network',
      'detach_from_network': 'Detach from network',
      'add_to_placement_group': 'Add to placement group',
      'remove_from_placement_group': 'Remove from placement group',
      'assign_floating_ip': 'Assign Floating IP',
      'unassign_floating_ip': 'Unassign Floating IP',
      'assign_primary_ip': 'Assign Primary IP',
      'unassign_primary_ip': 'Unassign Primary IP',
      'apply_firewall': 'Apply firewall',
      'remove_firewall': 'Remove firewall',
      'set_firewall_rules': 'Set firewall rules',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get accountManage => 'Manage account';

  @override
  String get lockUnavailable =>
      'This device has no screen lock. Set up a PIN, Face ID or a fingerprint to protect Falco.';

  @override
  String get lockContinueWithout => 'Continue without app lock';

  @override
  String get fieldS3Location => 'Object Storage location';

  @override
  String get s3Hint =>
      'Optional. S3 keys from the Cloud Console under Object Storage, Security credentials. Checked against the chosen location.';

  @override
  String get s3None => 'None';

  @override
  String get fieldAccessKey => 'Access key';

  @override
  String get fieldSecretKey => 'Secret key';

  @override
  String get fieldRobotUser => 'Webservice user';

  @override
  String get fieldRobotPassword => 'Webservice password';

  @override
  String get robotHint =>
      'Create a webservice user in Robot under Settings, Webservice and app settings.';

  @override
  String get s3Step => 'Object Storage';

  @override
  String get cloudOpenConsole => 'Open Cloud Console';

  @override
  String get robotOpenSettings => 'Open Robot settings';

  @override
  String accountDone(String name) {
    return 'All set. $name is ready to use.';
  }

  @override
  String get accountOpen => 'Open';

  @override
  String get fieldDescription => 'Description (optional)';

  @override
  String get servicesStep => 'Services';

  @override
  String get serviceCloud => 'Cloud';

  @override
  String get serviceCloudHint =>
      'Cloud projects with servers, networks, DNS and storage';

  @override
  String get serviceRobotHint =>
      'Dedicated servers through the Robot webservice';

  @override
  String get servicesPickOne => 'Pick at least one service.';

  @override
  String get projectsStep => 'Cloud projects';

  @override
  String projectRemoveDraft(String name) {
    return 'Remove $name';
  }

  @override
  String get robotStep => 'Robot access';

  @override
  String get commonEdit => 'Edit';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsEmpty => 'No accounts yet.';

  @override
  String accountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts',
      one: '1 account',
    );
    return '$_temp0';
  }

  @override
  String accountCloudBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cloud, $count projects',
      one: 'Cloud, 1 project',
    );
    return '$_temp0';
  }

  @override
  String get accountActive => 'Active';

  @override
  String get accountDefault => 'Default';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountEdit => 'Edit account';

  @override
  String get accountDelete => 'Delete account';

  @override
  String accountDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get accountDeleteConsequence =>
      'The account is removed from this device with all its tokens, keys and Robot credentials. Nothing changes at Hetzner.';

  @override
  String get robotAccess => 'Webservice access';

  @override
  String get robotStored => 'Stored and checked';

  @override
  String get robotAdd => 'Add Robot access';

  @override
  String get robotChange => 'Change Robot access';

  @override
  String get robotDelete => 'Delete Robot access';

  @override
  String robotDeleteTitle(String name) {
    return 'Delete the Robot access of $name?';
  }

  @override
  String get robotDeleteConsequence =>
      'User and password are deleted from this device. The webservice user at Hetzner stays.';

  @override
  String get projectsEmpty => 'No Cloud projects yet.';

  @override
  String get projectDelete => 'Delete project';

  @override
  String projectDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get projectDeleteConsequence =>
      'The project is removed from this device with its token and S3 keys. The project and its servers at Hetzner stay.';

  @override
  String get tokenChange => 'Change token';

  @override
  String get s3Change => 'Object Storage keys';

  @override
  String get s3Delete => 'Delete Object Storage keys';

  @override
  String s3DeleteTitle(String name) {
    return 'Delete the Object Storage keys of $name?';
  }

  @override
  String get s3DeleteConsequence =>
      'Access and secret key are deleted from this device. Buckets and keys at Hetzner stay.';

  @override
  String get s3NoKeys => 'No Object Storage keys';

  @override
  String s3Keys(String location) {
    return 'Object Storage keys, checked at $location';
  }

  @override
  String get savedMessage => 'Saved';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSystem => 'System';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsLock => 'Unlock at start';

  @override
  String get settingsLockHint =>
      'Face ID, fingerprint or device PIN at start and after the auto lock time';

  @override
  String get settingsAutoLock => 'Auto lock';

  @override
  String get lockImmediately => 'Immediately';

  @override
  String lockSeconds(int count) {
    return 'After $count s';
  }

  @override
  String lockMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'After $count minutes',
      one: 'After 1 minute',
    );
    return '$_temp0';
  }

  @override
  String get settingsSecureScreen => 'Block screenshots';

  @override
  String get settingsSecureScreenHint =>
      'Hides Falco in the app switcher and blocks screenshots';

  @override
  String get settingsPinning => 'Certificate pinning';

  @override
  String get settingsPinningHint =>
      'Active for all Hetzner endpoints: Cloud, Storage Boxes, Robot and Object Storage.';

  @override
  String get accentAmber => 'Amber';

  @override
  String get accentBlue => 'Blue';

  @override
  String get accentGreen => 'Green';

  @override
  String get accentRed => 'Red';

  @override
  String get accentPurple => 'Purple';

  @override
  String get accentOrange => 'Orange';

  @override
  String get aboutTitle => 'About Falco';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'Manage Hetzner Cloud, Robot, DNS and Storage from your phone. Free software without tracking.';

  @override
  String get aboutWebsite => 'Website';

  @override
  String get aboutDonate => 'Donate';

  @override
  String get aboutSource => 'Source code';

  @override
  String get aboutDeveloper => 'Developer';

  @override
  String get aboutLicense => 'License';

  @override
  String get aboutLicenses => 'Open source licenses';

  @override
  String get welcomeSkip => 'Skip';

  @override
  String get welcomeLanguage => 'Choose your language';

  @override
  String get welcomeFeatures => 'What Falco does';

  @override
  String get welcomeCloud =>
      'Servers, volumes, networks, firewalls, load balancers and more, across all your projects.';

  @override
  String get welcomeRobot =>
      'Dedicated servers: reset, rescue, Wake on LAN, reverse DNS and failover.';

  @override
  String get welcomeDns => 'Zones and records of your Cloud projects.';

  @override
  String get welcomeObjectStorage => 'Object Storage';

  @override
  String get welcomeObjectStorageText =>
      'Buckets and files in all locations, with uploads in the background.';

  @override
  String get welcomeSecurity => 'Your access stays safe';

  @override
  String get welcomeSecretsTitle => 'Encrypted on the device';

  @override
  String get welcomeSecretsIos =>
      'Tokens and passwords live only in the iOS Keychain of this device.';

  @override
  String get welcomeSecretsAndroid =>
      'Tokens and passwords live only in the hardware backed Android Keystore.';

  @override
  String get welcomeLockTitle => 'Unlock at start';

  @override
  String get welcomeLockIos =>
      'Falco asks for Face ID, Touch ID or your passcode at start.';

  @override
  String get welcomeLockAndroid =>
      'Falco asks for your fingerprint or device PIN at start.';

  @override
  String get welcomePinning =>
      'TLS 1.2 or newer with certificate pinning for every Hetzner endpoint. No tracking.';

  @override
  String get welcomeStart => 'Ready to start';

  @override
  String get welcomeStartText =>
      'Add an account with a Cloud API token, Robot access, or both. Every access is checked before it is stored.';
}
