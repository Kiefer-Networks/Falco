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
      'The server and its disk are deleted. Attached volumes are kept. This cannot be undone.';

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

  @override
  String backupWindow(String window) {
    return 'On, window $window UTC';
  }

  @override
  String get backupsOn => 'Enable backups';

  @override
  String get backupsOff => 'Disable backups';

  @override
  String backupsOnTitle(String name) {
    return 'Enable backups for $name?';
  }

  @override
  String backupsOffTitle(String name) {
    return 'Disable backups for $name?';
  }

  @override
  String get backupsOnConsequence =>
      'Hetzner keeps seven daily backups. Backups cost 20 % of the server price.';

  @override
  String get backupsOffConsequence =>
      'All existing backups of this server are deleted.';

  @override
  String get changeType => 'Change type';

  @override
  String get changeTypeNeedsOff =>
      'Power off the server before changing its type.';

  @override
  String changeTypeTo(String type) {
    return 'Change to $type';
  }

  @override
  String get upgradeDisk => 'Upgrade disk (irreversible)';

  @override
  String get upgradeDiskHint =>
      'With a larger disk the server can never move back to a smaller type.';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonNone => 'None';

  @override
  String get commonOff => 'Off';

  @override
  String consoleTitle(String name) {
    return 'Console of $name';
  }

  @override
  String get consoleNote =>
      'Connect a VNC client to this websocket URL within about a minute.';

  @override
  String get consoleUrl => 'Websocket URL';

  @override
  String get consolePassword => 'VNC password';

  @override
  String createdMessage(String name) {
    return '$name created';
  }

  @override
  String deletedMessage(String name) {
    return '$name deleted';
  }

  @override
  String get deprecated => 'deprecated';

  @override
  String get emptyImages =>
      'No snapshots or backups yet. Create a snapshot from a server.';

  @override
  String get emptyPlacementGroups => 'No placement groups in this project yet.';

  @override
  String get emptySshKeys => 'No SSH keys in this project yet.';

  @override
  String get emptyVolumes => 'No volumes in this project yet.';

  @override
  String get fieldArchitecture => 'Architecture';

  @override
  String get fieldBackups => 'Backups';

  @override
  String get fieldCreated => 'Created';

  @override
  String get fieldDeleteProtection => 'Delete protection';

  @override
  String get fieldRebuildProtection => 'Rebuild protection';

  @override
  String get fieldDevice => 'Device';

  @override
  String get fieldFingerprint => 'Fingerprint';

  @override
  String get fieldFormat => 'File system';

  @override
  String get fieldImageDescription => 'Description';

  @override
  String get fieldIso => 'ISO';

  @override
  String get fieldLabels => 'Labels';

  @override
  String get fieldPrice => 'Price';

  @override
  String get fieldProtection => 'Protection';

  @override
  String get fieldPublicKey => 'Public key';

  @override
  String get fieldSize => 'Size';

  @override
  String get fieldSizeGb => 'Size in GB';

  @override
  String get fieldSource => 'Source';

  @override
  String get fieldUserData => 'Cloud init user data';

  @override
  String get filterAttached => 'Attached';

  @override
  String get filterDetached => 'Not attached';

  @override
  String get imageApp => 'App';

  @override
  String get imageBackup => 'Backup';

  @override
  String get imageSnapshot => 'Snapshot';

  @override
  String get imageSystem => 'System';

  @override
  String get imageConvert => 'To snapshot';

  @override
  String imageConvertTitle(String name) {
    return 'Convert $name to a snapshot?';
  }

  @override
  String get imageConvertConsequence =>
      'The backup becomes a snapshot. It is kept when the server is deleted and billed as a snapshot.';

  @override
  String get imageDeleteConsequence =>
      'The image is deleted. Servers built from it keep running. This cannot be undone.';

  @override
  String get isoAttach => 'Insert ISO';

  @override
  String get isoDetach => 'Eject ISO';

  @override
  String isoDetachTitle(String name) {
    return 'Eject $name?';
  }

  @override
  String get isoDetachConsequence =>
      'The server boots from its disk again after the next restart.';

  @override
  String get labelsHint => 'Optional. key=value, separated by commas.';

  @override
  String metricStats(String series, String min, String max, String avg) {
    return '$series: min $min · max $max · avg $avg';
  }

  @override
  String perMonth(String price) {
    return '$price/month';
  }

  @override
  String priceMonthly(String gross, String net, String perGb) {
    return '$gross/month gross, $net net, $perGb per GB';
  }

  @override
  String get placementGroupAdd => 'Add to placement group';

  @override
  String get placementGroupCreate => 'Create placement group';

  @override
  String get placementGroupDeleteConsequence =>
      'The group is deleted. Its servers keep running.';

  @override
  String get placementGroupEmpty => 'No servers in this group.';

  @override
  String get placementGroupNone =>
      'No placement groups in this project. Create one under Compute first.';

  @override
  String get placementGroupRemove => 'Remove from placement group';

  @override
  String placementGroupRemoveTitle(String name, String group) {
    return 'Remove $name from $group?';
  }

  @override
  String get placementGroupRemoveConsequence =>
      'The server may then share hardware with other servers of the group.';

  @override
  String get placementGroupTypeHint =>
      'Spread places every server on a different host.';

  @override
  String get protectOn => 'Protect';

  @override
  String get protectOff => 'Remove protection';

  @override
  String protectOnTitle(String name) {
    return 'Protect $name?';
  }

  @override
  String protectOffTitle(String name) {
    return 'Remove protection of $name?';
  }

  @override
  String get protectOnConsequence =>
      'It cannot be deleted until the protection is removed.';

  @override
  String get protectOffConsequence => 'It can be deleted again.';

  @override
  String get protected => 'protected';

  @override
  String get publicIpv4 => 'Public IPv4';

  @override
  String get publicIpv6 => 'Public IPv6';

  @override
  String get rebuildPick => 'Rebuild from image';

  @override
  String rebuildTitle(String name) {
    return 'Rebuild $name?';
  }

  @override
  String rebuildConsequence(String image) {
    return 'All data on the disk is lost. The server starts fresh from $image.';
  }

  @override
  String get rescueActive => 'rescue';

  @override
  String get rescueOn => 'Enable rescue';

  @override
  String get rescueOff => 'Disable rescue';

  @override
  String rescueOnTitle(String name) {
    return 'Enable rescue for $name?';
  }

  @override
  String rescueOffTitle(String name) {
    return 'Disable rescue for $name?';
  }

  @override
  String get rescueOnConsequence =>
      'The next restart boots the rescue system. Its root password is shown once.';

  @override
  String get rescueOffConsequence =>
      'The next restart boots from the disk again.';

  @override
  String get resetPassword => 'Reset root password';

  @override
  String resetPasswordTitle(String name) {
    return 'Reset the root password of $name?';
  }

  @override
  String get resetPasswordConsequence =>
      'The server needs the qemu guest agent. The new password is shown once.';

  @override
  String get resourceFirewalls => 'Firewalls';

  @override
  String get resourceImage => 'Image';

  @override
  String get resourceImages => 'Images';

  @override
  String get resourceLoadBalancer => 'Load balancer';

  @override
  String get resourceNetworks => 'Networks';

  @override
  String get resourcePlacementGroup => 'Placement group';

  @override
  String get resourcePlacementGroups => 'Placement groups';

  @override
  String get resourceSshKey => 'SSH key';

  @override
  String get resourceSshKeys => 'SSH keys';

  @override
  String get resourceVolume => 'Volume';

  @override
  String get resourceVolumes => 'Volumes';

  @override
  String get reverseDns => 'Reverse DNS';

  @override
  String get reverseDnsHint => 'Leave empty to reset to the Hetzner default.';

  @override
  String reverseDnsValue(String ptr) {
    return 'Reverse DNS: $ptr';
  }

  @override
  String get rootPasswordAfter => 'shown once after creating';

  @override
  String get rootPasswordNote =>
      'Copy it now. Falco does not store it and cannot show it again.';

  @override
  String get rootPasswordTitle => 'Root password';

  @override
  String get sectionAttached => 'Attached';

  @override
  String get sectionAttachment => 'Attachment';

  @override
  String get sectionNetwork => 'Network';

  @override
  String serverCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servers',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get serverNoSshKeys =>
      'No SSH keys in this project. You can skip this step; the root password is shown once after creating.';

  @override
  String serverNoVolumes(String location) {
    return 'No free volumes in $location.';
  }

  @override
  String get sortSize => 'Size';

  @override
  String get sshKeyAdd => 'Add SSH key';

  @override
  String get sshKeyDeleteConsequence =>
      'The key is removed from the project. Servers that use it keep it.';

  @override
  String get sshKeyHint =>
      'Paste the public key, e.g. the content of id_ed25519.pub.';

  @override
  String get sshKeyPrivate =>
      'This is a private key. Never share it; paste the public key (.pub) instead.';

  @override
  String get sshKeyUnknown =>
      'Unknown key type. Use ssh-ed25519, ssh-rsa, ecdsa or a security key.';

  @override
  String get startAfterCreate => 'Start after create';

  @override
  String get statusAvailable => 'available';

  @override
  String get statusUnavailable => 'unavailable';

  @override
  String get userDataHint =>
      'Optional. Runs on the first boot, e.g. #cloud-config.';

  @override
  String vcpuCount(int count) {
    return '$count vCPU';
  }

  @override
  String get volumeAttach => 'Attach';

  @override
  String get volumeAutomount => 'Mount automatically';

  @override
  String get volumeCreate => 'Create volume';

  @override
  String get volumeDeleteConsequence =>
      'The volume and all its data are deleted. This cannot be undone.';

  @override
  String get volumeDetach => 'Detach';

  @override
  String volumeDetachTitle(String name) {
    return 'Detach $name?';
  }

  @override
  String get volumeDetachConsequence =>
      'Unmount it on the server first, or running writes may be lost.';

  @override
  String volumeNextTo(String server, String location) {
    return 'Next to $server ($location)';
  }

  @override
  String volumeNoServers(String location) {
    return 'No servers in $location to attach to.';
  }

  @override
  String get volumeNotAttached => 'Not attached to any server';

  @override
  String get volumeResize => 'Resize';

  @override
  String volumeResizeHint(int current, int max) {
    return 'Larger than $current GB, at most $max GB. Volumes cannot shrink.';
  }

  @override
  String get volumeTarget => 'Location or server';

  @override
  String get wizardDetails => 'Details';

  @override
  String get wizardExtras => 'Volumes and placement';

  @override
  String get wizardNetworking => 'Networking';
}
