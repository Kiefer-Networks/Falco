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
  String get commonMore => 'More';

  @override
  String get overviewUnavailable => 'Not available';

  @override
  String overviewStatusCount(String status, int count) {
    return '$status: $count';
  }

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
  String listProjectsFailed(String projects) {
    return 'Could not load: $projects. Showing the other projects.';
  }

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorNetwork => 'No connection to the server. Check your network.';

  @override
  String get detailPick => 'Pick an entry to see its details.';

  @override
  String get copied => 'Copied to clipboard';

  @override
  String copiedSensitive(int seconds) {
    return 'Copied. The clipboard clears in $seconds s.';
  }

  @override
  String copiedPlain(int seconds) {
    return 'Copied. This system cannot hide it from other apps; the clipboard clears in $seconds s.';
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
  String get vaultLostTitle => 'Access data deleted';

  @override
  String vaultLostMessage(String accounts) {
    return 'The system deleted the stored access data, for example after a change to the fingerprints or the face. Enter the tokens and credentials again for: $accounts.';
  }

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
      'create': 'Create',
      'delete': 'Delete',
      'change_type': 'Change type',
      'update_access_settings': 'Change access',
      'rollback_snapshot': 'Roll back snapshot',
      'enable_snapshot_plan': 'Enable snapshot plan',
      'disable_snapshot_plan': 'Disable snapshot plan',
      'create_snapshot': 'Create snapshot',
      'delete_snapshot': 'Delete snapshot',
      'create_subaccount': 'Add subaccount',
      'delete_subaccount': 'Delete subaccount',
      'reset_subaccount_password': 'Reset subaccount password',
      'change_home_directory': 'Change home directory',
      'robot_reset': 'Reset',
      'robot_wol': 'Wake on LAN',
      'robot_boot_on': 'Activate boot configuration',
      'robot_boot_off': 'Deactivate boot configuration',
      'robot_rename': 'Rename server',
      'robot_cancel': 'Cancel',
      'robot_withdraw': 'Withdraw cancellation',
      'robot_rdns': 'Change reverse DNS',
      'robot_failover': 'Change failover routing',
      'robot_vswitch': 'Change vSwitch',
      'robot_key': 'Change SSH key',
      'robot_address': 'Change IP settings',
      'robot_firewall': 'Change firewall',
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

  @override
  String get actionRemove => 'Remove';

  @override
  String get aliasIpsHint =>
      'Optional. Further private IPs, separated by commas.';

  @override
  String get autoDeleteHint =>
      'Deleted together with the server it is assigned to.';

  @override
  String get certificateCreate => 'Add certificate';

  @override
  String get certificateDeleteConsequence =>
      'The certificate is deleted. Load balancers using it lose it from their HTTPS services.';

  @override
  String get certificateManaged => 'Managed (Let\'s Encrypt)';

  @override
  String get certificateManagedHint =>
      'Hetzner issues and renews it for your domains.';

  @override
  String get certificatePemHint =>
      'PEM, starting with -----BEGIN CERTIFICATE-----, chain included.';

  @override
  String get certificatePending => 'Pending';

  @override
  String get certificateRetry => 'Retry';

  @override
  String get certificateUnused => 'Not used by any load balancer.';

  @override
  String get certificateUploaded => 'Uploaded';

  @override
  String get certificateUploadedHint => 'Your own certificate and private key.';

  @override
  String certificateValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get domainsHint =>
      'One or more domains, separated by commas, e.g. example.com, *.example.com.';

  @override
  String get emptyCertificates => 'No certificates in this project yet.';

  @override
  String get emptyFirewalls => 'No firewalls in this project yet.';

  @override
  String get emptyFloatingIps => 'No Floating IPs in this project yet.';

  @override
  String get emptyLoadBalancers => 'No load balancers in this project yet.';

  @override
  String get emptyNetworks => 'No networks in this project yet.';

  @override
  String get emptyPrimaryIps => 'No Primary IPs in this project yet.';

  @override
  String get emptyZones => 'No DNS zones in this project yet.';

  @override
  String get fieldAliasIps => 'Alias IPs';

  @override
  String get fieldAutoDelete => 'Delete with server';

  @override
  String get fieldCertificatePem => 'Certificate';

  @override
  String get fieldChangeProtection => 'Change protection';

  @override
  String get fieldComment => 'Comment';

  @override
  String get fieldCookieLifetime => 'Cookie lifetime (s)';

  @override
  String get fieldCookieName => 'Cookie name';

  @override
  String get fieldDefaultTtl => 'Default TTL';

  @override
  String get fieldDestIps => 'Destination IPs';

  @override
  String get fieldDestination => 'Destination';

  @override
  String get fieldDestinationPort => 'Destination port';

  @override
  String get fieldDirection => 'Direction';

  @override
  String get fieldDomains => 'Domains';

  @override
  String get fieldGateway => 'Gateway';

  @override
  String get fieldHealthCheck => 'Health check';

  @override
  String get fieldHealthDomain => 'Health check domain';

  @override
  String get fieldHealthPath => 'Health check path';

  @override
  String get fieldHealthPort => 'Health check port';

  @override
  String get fieldHealthTls => 'Health check over TLS';

  @override
  String get fieldInterval => 'Interval (s)';

  @override
  String get fieldIpRange => 'IP range';

  @override
  String get fieldIps => 'IPs';

  @override
  String get fieldIssuance => 'Issuance';

  @override
  String get fieldListenPort => 'Listen port';

  @override
  String get fieldMode => 'Mode';

  @override
  String get fieldNameOptional => 'Name (optional)';

  @override
  String get fieldNameservers => 'Nameservers';

  @override
  String get fieldNetworkZone => 'Network zone';

  @override
  String get fieldNewValue => 'New value';

  @override
  String get fieldPort => 'Port';

  @override
  String get fieldPrivateIp => 'Private IP';

  @override
  String get fieldPrivateKeyPem => 'Private key';

  @override
  String get fieldProtocol => 'Protocol';

  @override
  String get fieldProxyProtocol => 'PROXY protocol';

  @override
  String get fieldRecordName => 'Name';

  @override
  String get fieldRedirectHttp => 'Redirect HTTP to HTTPS';

  @override
  String get fieldRenewal => 'Renewal';

  @override
  String get fieldRetries => 'Retries';

  @override
  String get fieldSourceIps => 'Source IPs';

  @override
  String get fieldStatus => 'Status';

  @override
  String get fieldStatusCodes => 'Status codes';

  @override
  String get fieldStickySessions => 'Sticky sessions';

  @override
  String get fieldTimeout => 'Timeout (s)';

  @override
  String get fieldTtl => 'TTL';

  @override
  String get fieldTsigAlgorithm => 'TSIG algorithm';

  @override
  String get fieldTsigKey => 'TSIG key (base64)';

  @override
  String get fieldUsePrivateIp => 'Route via private network';

  @override
  String get fieldValidFrom => 'Valid from';

  @override
  String get fieldValidUntil => 'Valid until';

  @override
  String get fieldValue => 'Value';

  @override
  String get fieldValues => 'Values';

  @override
  String get fieldVswitch => 'vSwitch';

  @override
  String get fieldVswitchId => 'vSwitch ID';

  @override
  String get fieldZoneName => 'Domain';

  @override
  String get filterAssigned => 'Assigned';

  @override
  String get filterUnassigned => 'Not assigned';

  @override
  String get firewallActive => 'Active';

  @override
  String get firewallApply => 'Apply';

  @override
  String get firewallCreate => 'Create firewall';

  @override
  String get firewallDeleteConsequence =>
      'The firewall is deleted; servers it protects are open to its traffic again.';

  @override
  String get firewallNotApplied => 'Not applied';

  @override
  String get firewallNotAppliedHint =>
      'Not applied to any server or label selector.';

  @override
  String get firewallRemoveConsequence =>
      'Its rules no longer protect this target.';

  @override
  String firewallRemoveTitle(String firewall, String target) {
    return 'Remove $firewall from $target?';
  }

  @override
  String get floatingIpCreate => 'Create Floating IP';

  @override
  String get floatingIpUnassignConsequence =>
      'Traffic to this IP no longer reaches the server.';

  @override
  String gatewayHint(String range) {
    return 'An IP inside $range.';
  }

  @override
  String gatewayValue(String gateway) {
    return 'via $gateway';
  }

  @override
  String healthCheckValue(String protocol, String port, String interval) {
    return '$protocol check on $port every $interval s';
  }

  @override
  String get healthPortHint => 'Empty uses the destination port.';

  @override
  String get ipAssign => 'Assign';

  @override
  String get ipAssigned => 'Assigned';

  @override
  String ipAssignedTo(String server) {
    return 'assigned to $server';
  }

  @override
  String get ipBlocked => 'Blocked';

  @override
  String ipDeleteConsequence(String ip) {
    return 'The address $ip is released and may go to someone else. This cannot be undone.';
  }

  @override
  String get ipNoServers => 'No servers in this project to assign to.';

  @override
  String get ipNotAssigned => 'Not assigned';

  @override
  String ipOnServer(String server, String location) {
    return 'Assign to $server ($location)';
  }

  @override
  String get ipTarget => 'Location or server';

  @override
  String get ipUnassign => 'Unassign';

  @override
  String ipUnassignTitle(String ip, String server) {
    return 'Unassign $ip from $server?';
  }

  @override
  String get ipsAny => 'Any IPv4 and IPv6';

  @override
  String get ipsAnyV4 => 'Any IPv4';

  @override
  String get ipsAnyV6 => 'Any IPv6';

  @override
  String get ipsCustom => 'Custom';

  @override
  String get ipsHint =>
      'CIDR blocks, one per line or separated by commas, e.g. 203.0.113.0/24.';

  @override
  String get keepIfEmpty => 'Empty keeps the current one.';

  @override
  String get labelSelector => 'Label selector';

  @override
  String get lbAlgorithm => 'Algorithm';

  @override
  String get lbChangeType => 'Change type';

  @override
  String get lbDeleteConsequence =>
      'The load balancer and its public IPs are deleted. Targets are kept. This cannot be undone.';

  @override
  String get lbLeastConnections => 'Least connections';

  @override
  String lbLimits(int connections, int services, int targets) {
    return '$connections connections, $services services, $targets targets';
  }

  @override
  String get lbNoCertificates =>
      'No certificates yet. Add one in Certificates.';

  @override
  String get lbPublicDisabled => 'Public interface disabled';

  @override
  String get lbPublicOff => 'Disable public interface';

  @override
  String get lbPublicOffConsequence =>
      'The load balancer is then reachable from private networks only.';

  @override
  String get lbPublicOn => 'Enable public interface';

  @override
  String get lbRoundRobin => 'Round robin';

  @override
  String get loadBalancerCreate => 'Create load balancer';

  @override
  String get membersEmpty => 'No servers or load balancers in this network.';

  @override
  String get metricConnectionsPerSecond => 'Connections per second';

  @override
  String get metricOpenConnections => 'Open connections';

  @override
  String get metricRequestsPerSecond => 'Requests per second';

  @override
  String get networkAttach => 'Attach to network';

  @override
  String get networkChangeRange => 'Change IP range';

  @override
  String get networkCreate => 'Create network';

  @override
  String get networkDeleteConsequence =>
      'The network and all its subnets and routes are deleted. This cannot be undone.';

  @override
  String get networkDetachConsequence =>
      'Its private IP in this network is released.';

  @override
  String networkDetachTitle(String name, String network) {
    return 'Remove $name from $network?';
  }

  @override
  String get networkExpose => 'Routes to vSwitch';

  @override
  String get networkExposeConsequence =>
      'Decides whether the routes of this network are announced to the coupled vSwitch.';

  @override
  String get networkExposeOff => 'Stop exposing routes to vSwitch';

  @override
  String get networkExposeOn => 'Expose routes to vSwitch';

  @override
  String get networkRangeCreateHint => 'A private range, e.g. 10.0.0.0/16.';

  @override
  String get networkRangeHint =>
      'Only larger, containing the current range. This cannot be undone.';

  @override
  String get portHint => 'One port, a range or any, e.g. 22, 8000-9000 or any.';

  @override
  String get primariesEmpty => 'No primary nameservers yet.';

  @override
  String get primariesHint =>
      'One per line: address or address:port, port 53 by default.';

  @override
  String get primaryAdd => 'Add primary nameserver';

  @override
  String get primaryEdit => 'Edit primary nameserver';

  @override
  String get tsigNone => 'None';

  @override
  String get primaryIpCreate => 'Create Primary IP';

  @override
  String get primaryIpNew => 'New Primary IP';

  @override
  String primaryIpNoServers(String location) {
    return 'No servers in $location that are off and have no Primary IP of this type. A Primary IP moves only to such a server.';
  }

  @override
  String get primaryIpUnassignConsequence =>
      'The server loses this public address. It must be off.';

  @override
  String get primaryRemoveConsequence =>
      'The zone is no longer transferred from this nameserver.';

  @override
  String primaryRemoveTitle(String address) {
    return 'Remove $address?';
  }

  @override
  String get privateIpHint => 'Optional. Empty picks the next free one.';

  @override
  String get privateKeyPemHint =>
      'PEM, starting with -----BEGIN PRIVATE KEY-----. Sent once to Hetzner, never stored in Falco.';

  @override
  String get recordAdd => 'Add record';

  @override
  String recordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
    );
    return '$_temp0';
  }

  @override
  String get recordEdit => 'Edit value';

  @override
  String get recordNameHint => '@ for the zone itself, e.g. www or mail.';

  @override
  String recordsBulkEdit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count record sets',
      one: '1 record set',
    );
    return 'Edit $_temp0';
  }

  @override
  String get recordsEditSelected => 'Edit selected';

  @override
  String get recordsEmpty => 'No records yet.';

  @override
  String recordsFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count record sets failed',
      one: '1 record set failed',
    );
    return '$_temp0';
  }

  @override
  String get recordsFromPrimaries =>
      'The records of a secondary zone come from its primary nameservers.';

  @override
  String get recordsBulkTtlOnly => 'Different types: only the TTL can change.';

  @override
  String get recordsBulkValueConsequence =>
      'Every value of these record sets is replaced by the new value.';

  @override
  String get recordsBulkTtlConsequence => 'These record sets get the new TTL.';

  @override
  String get recordsSelect => 'Select records';

  @override
  String get recordsUpdated => 'Records updated';

  @override
  String get resourceCertificate => 'Certificate';

  @override
  String get resourceCertificates => 'Certificates';

  @override
  String get resourceFirewall => 'Firewall';

  @override
  String get resourceFloatingIp => 'Floating IP';

  @override
  String get resourceFloatingIps => 'Floating IPs';

  @override
  String get resourceLoadBalancers => 'Load balancers';

  @override
  String get resourceNetwork => 'Network';

  @override
  String get resourcePrimaryIp => 'Primary IP';

  @override
  String get resourcePrimaryIps => 'Primary IPs';

  @override
  String get resourceRecord => 'Record set';

  @override
  String get resourceZone => 'DNS zone';

  @override
  String get resourceZones => 'DNS';

  @override
  String get routeAdd => 'Add route';

  @override
  String routeDeleteConsequence(String gateway) {
    return 'Traffic via $gateway for this destination stops.';
  }

  @override
  String routeDeleteTitle(String destination) {
    return 'Delete route to $destination?';
  }

  @override
  String get routesEmpty => 'No routes.';

  @override
  String get rrsetDeleteConsequence =>
      'All values of this record set are deleted.';

  @override
  String get rrsetProtectOffConsequence =>
      'Its values can be changed and deleted again.';

  @override
  String get rrsetProtectOnConsequence =>
      'Its values cannot be changed or deleted until the protection is removed.';

  @override
  String get ruleAdd => 'Add rule';

  @override
  String ruleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rules',
      one: '1 rule',
    );
    return '$_temp0';
  }

  @override
  String get ruleDeleteConsequence =>
      'Traffic this rule allowed is blocked on every server of the firewall.';

  @override
  String ruleDeleteTitle(String rule) {
    return 'Delete rule $rule?';
  }

  @override
  String get ruleEdit => 'Edit rule';

  @override
  String get ruleInbound => 'Inbound';

  @override
  String get ruleOutbound => 'Outbound';

  @override
  String get rulesEmpty => 'No rules.';

  @override
  String secondsHint(int min, int max) {
    return '$min to $max seconds';
  }

  @override
  String get sectionAppliedTo => 'Applied to';

  @override
  String get sectionMembers => 'Members';

  @override
  String get sectionPrimaries => 'Primary nameservers';

  @override
  String get sectionRecords => 'Records';

  @override
  String get sectionRoutes => 'Routes';

  @override
  String get sectionRules => 'Rules';

  @override
  String get sectionServices => 'Services';

  @override
  String get sectionSubnets => 'Subnets';

  @override
  String get sectionTargets => 'Targets';

  @override
  String get sectionUsedBy => 'Used by';

  @override
  String get selectAll => 'Select all';

  @override
  String get selectClear => 'Clear';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get selectorHint => 'e.g. role=web,env=prod';

  @override
  String get serverNoNetworks =>
      'No networks left to attach to. Create one under Network.';

  @override
  String get serviceAdd => 'Add service';

  @override
  String serviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services',
      one: '1 service',
    );
    return '$_temp0';
  }

  @override
  String get serviceDeleteConsequence =>
      'The load balancer stops listening on this port.';

  @override
  String serviceDeleteTitle(String service) {
    return 'Delete service $service?';
  }

  @override
  String get serviceEdit => 'Edit service';

  @override
  String get servicesEmpty => 'No services.';

  @override
  String get sortExpiry => 'Expiry';

  @override
  String get subnetAdd => 'Add subnet';

  @override
  String subnetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subnets',
      one: '1 subnet',
    );
    return '$_temp0';
  }

  @override
  String get subnetDeleteConsequence =>
      'Servers in this subnet lose their private IPs in it.';

  @override
  String subnetDeleteTitle(String range) {
    return 'Delete subnet $range?';
  }

  @override
  String subnetRangeHint(String range) {
    return 'Optional, inside $range. Empty picks the next free range.';
  }

  @override
  String get subnetsEmpty => 'No subnets.';

  @override
  String get targetAdd => 'Add target';

  @override
  String targetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count targets',
      one: '1 target',
    );
    return '$_temp0';
  }

  @override
  String get targetIpHint =>
      'A public IP of a dedicated server, e.g. 203.0.113.7.';

  @override
  String get targetRemoveConsequence =>
      'The load balancer no longer sends traffic to it.';

  @override
  String targetRemoveTitle(String target) {
    return 'Remove target $target?';
  }

  @override
  String get targetsEmpty => 'No targets.';

  @override
  String get ttlCreateHint => 'Optional, 60 seconds or more. Empty uses 3600.';

  @override
  String ttlDefault(int ttl) {
    return 'Zone default ($ttl s)';
  }

  @override
  String ttlHint(int ttl) {
    return 'Optional, 60 seconds or more. Empty uses the zone default of $ttl s.';
  }

  @override
  String get ttlLimits => '60 seconds or more.';

  @override
  String ttlValue(int ttl) {
    return 'TTL $ttl s';
  }

  @override
  String get valueAdd => 'Add value';

  @override
  String get valueRemoveConsequence =>
      'This value is removed from the record set.';

  @override
  String valueRemoveTitle(String value) {
    return 'Remove $value?';
  }

  @override
  String get valuesHint =>
      'One value per line. TXT gets quotes, host names a trailing dot.';

  @override
  String get zoneCreate => 'Create zone';

  @override
  String get zoneDeleteConsequence =>
      'The zone and all its records are deleted. This cannot be undone.';

  @override
  String get zoneExport => 'Export';

  @override
  String get zoneExported => 'Zone file saved';

  @override
  String get zoneImport => 'Import zone file';

  @override
  String get zoneImportConsequence =>
      'Every record of the zone is replaced by those of the file.';

  @override
  String zoneImportTitle(String name) {
    return 'Replace all records of $name?';
  }

  @override
  String get zonePrimary => 'Primary';

  @override
  String get zonePrimaryHint =>
      'Hetzner holds the records; you edit them here.';

  @override
  String get zoneSecondary => 'Secondary';

  @override
  String get zoneSecondaryHint =>
      'Hetzner copies the zone from your primary nameservers.';

  @override
  String get zonefileTooLarge => 'The file is larger than 1 MiB.';

  @override
  String get accessExternal => 'Reachable externally';

  @override
  String get accessReadonly => 'Read only';

  @override
  String get accessSamba => 'Samba (SMB)';

  @override
  String get accessSsh => 'SSH and SFTP';

  @override
  String get accessWebdav => 'WebDAV';

  @override
  String get accessZfs => 'ZFS snapshot folder';

  @override
  String get boxAccessSettings => 'Access';

  @override
  String get boxAutomatic => 'Automatic';

  @override
  String get boxAutomaticSnapshots => 'Automatic snapshots';

  @override
  String get boxChangeType => 'Change type';

  @override
  String get boxDeleteConsequence =>
      'The Storage Box, its snapshots and subaccounts are deleted with all data. This cannot be undone.';

  @override
  String get boxEveryDay => 'Every day';

  @override
  String get boxMaxSnapshots => 'Snapshots to keep';

  @override
  String get boxNewFolder => 'New folder';

  @override
  String get boxPasswordHint =>
      '12 to 128 characters with upper and lower case, a digit and a special character.';

  @override
  String boxPlanDaily(String time) {
    return 'Daily at $time';
  }

  @override
  String get boxPlanHour => 'Hour';

  @override
  String boxPlanKeeps(String when, int count) {
    return '$when, keeps $count';
  }

  @override
  String get boxPlanMinute => 'Minute';

  @override
  String get boxPlanMonthday => 'Day of the month';

  @override
  String boxPlanMonthly(int day, String time) {
    return 'Monthly on day $day at $time';
  }

  @override
  String get boxPlanUtc => 'Times are UTC.';

  @override
  String get boxPlanWeekday => 'Weekday';

  @override
  String boxPlanWeekly(String day, String time) {
    return '${day}s at $time';
  }

  @override
  String get boxResetPassword => 'Reset password';

  @override
  String get boxRollback => 'Roll back';

  @override
  String get boxRollbackConsequence =>
      'All data of the Storage Box is replaced with the state of this snapshot. Newer data is lost.';

  @override
  String boxRollbackTitle(String name) {
    return 'Roll back to $name?';
  }

  @override
  String get boxSnapshotCreate => 'Create snapshot';

  @override
  String get boxSnapshotDeleteConsequence =>
      'The snapshot is deleted. This cannot be undone.';

  @override
  String get boxSnapshotPlan => 'Snapshot plan';

  @override
  String get boxUsage => 'Usage';

  @override
  String get boxUsedData => 'Used by data';

  @override
  String boxUsedOf(String used, String size) {
    return '$used of $size used';
  }

  @override
  String get boxUsedSnapshots => 'Used by snapshots';

  @override
  String get bucketCreate => 'Create bucket';

  @override
  String get bucketDelete => 'Delete bucket';

  @override
  String get bucketDeleteConsequence =>
      'The bucket is deleted. It must be empty.';

  @override
  String get bucketNameHint =>
      '3 to 63 lower case letters, digits, dots and hyphens.';

  @override
  String get bucketNotEmpty =>
      'The bucket is not empty. Delete its objects first.';

  @override
  String get bucketPrivate => 'Private';

  @override
  String get bucketPublic => 'Public';

  @override
  String get bucketPublicHint =>
      'Public: everyone can read the objects without a link.';

  @override
  String get bucketSettings => 'Bucket settings';

  @override
  String get bucketVersioning => 'Versioning';

  @override
  String get bucketVersioningHint =>
      'Enabled keeps every version of an object. Suspended keeps existing versions but adds no new ones; versioning cannot be turned off again.';

  @override
  String get bucketVisibility => 'Visibility';

  @override
  String get commonShare => 'Share';

  @override
  String days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String downloadSaved(String name) {
    return 'Download saved: $name';
  }

  @override
  String downloadStarted(String name) {
    return 'Downloading $name in the background';
  }

  @override
  String get emptyBoxSnapshots => 'No snapshots yet.';

  @override
  String get emptyBuckets => 'No buckets in this project yet.';

  @override
  String get emptyObjects => 'This folder is empty.';

  @override
  String get emptyStorageBoxes => 'No Storage Boxes in this project yet.';

  @override
  String get emptySubaccounts => 'No subaccounts yet.';

  @override
  String get fieldContentType => 'Content type';

  @override
  String get fieldEtag => 'ETag';

  @override
  String get fieldFolderName => 'Folder name';

  @override
  String get fieldHomeDirectory => 'Home directory';

  @override
  String get fieldKey => 'Key';

  @override
  String get fieldModified => 'Last modified';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldPasswordRepeat => 'Repeat password';

  @override
  String get fieldServer => 'Server';

  @override
  String get fieldUsername => 'Username';

  @override
  String get folderCreate => 'Create folder';

  @override
  String hours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get objectCopy => 'Copy';

  @override
  String get objectDeleteConsequence =>
      'The objects are deleted. With versioning, older versions stay.';

  @override
  String get objectDownload => 'Download';

  @override
  String get objectInfo => 'Info';

  @override
  String get objectKeyInvalid => 'This file cannot be stored under that name.';

  @override
  String get objectKeyDotSegment =>
      'Falco cannot open this object: its key contains \".\" or \"..\" as a folder name, which every link resolves to another key.';

  @override
  String get objectMove => 'Move';

  @override
  String get objectUpload => 'Upload';

  @override
  String get objectVersions => 'Versions';

  @override
  String objectsDeleteTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count objects?',
      one: 'Delete 1 object?',
    );
    return '$_temp0';
  }

  @override
  String objectsDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objects deleted',
      one: '1 object deleted',
    );
    return '$_temp0';
  }

  @override
  String objectsDeletedPartly(int deleted, int failed) {
    return '$deleted deleted, $failed failed and stay selected';
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
  String get resourceStorageBoxes => 'Storage Boxes';

  @override
  String get resourceSubaccount => 'Subaccount';

  @override
  String get s3NoKeysHint =>
      'This project has no S3 keys. Add them to the project to use Object Storage.';

  @override
  String get sectionSnapshots => 'Snapshots';

  @override
  String get sectionSubaccounts => 'Subaccounts';

  @override
  String get selectionClear => 'Clear selection';

  @override
  String get shareExpiry => 'Valid for';

  @override
  String get shareLink => 'Share link';

  @override
  String get statusActive => 'active';

  @override
  String get statusLocked => 'locked';

  @override
  String get storageBoxCreate => 'Create Storage Box';

  @override
  String get subaccountCreate => 'Add subaccount';

  @override
  String get subaccountDeleteConsequence =>
      'The subaccount can no longer log in. Its files stay in the Storage Box.';

  @override
  String get transferDone => 'Transfer finished';

  @override
  String get transferFailed => 'Transfer failed';

  @override
  String transferFailedNamed(String name) {
    return 'Transfer of $name failed';
  }

  @override
  String get transferRunning => 'Transferring';

  @override
  String uploadDone(String name) {
    return 'Uploaded: $name';
  }

  @override
  String get uploadLink => 'Upload link';

  @override
  String uploadStarted(String name) {
    return 'Uploading $name in the background';
  }

  @override
  String get versionDeleteMarker => 'deleted';

  @override
  String get versionLatest => 'current';

  @override
  String get versionRestore => 'Restore';

  @override
  String get versionRestoreConsequence =>
      'This version becomes the current object again; the current one stays as an older version.';

  @override
  String versionRestoreTitle(String name) {
    return 'Restore this version of $name?';
  }

  @override
  String get versioningEnabled => 'Enabled';

  @override
  String get versioningNever => 'Never enabled';

  @override
  String get versioningSuspended => 'Suspended';

  @override
  String get versionsEmpty => 'No versions.';

  @override
  String get addressCancelConsequence =>
      'The address is cancelled at the chosen date and then no longer routed to the server.';

  @override
  String get bootActivate => 'Activate';

  @override
  String get bootActivated => 'Active at the next reset';

  @override
  String get bootDeactivate => 'Deactivate';

  @override
  String get bootDist => 'Distribution';

  @override
  String get bootKeysHint =>
      'Robot keys for the root login; without keys a password is used.';

  @override
  String get bootLang => 'Language';

  @override
  String get bootLastLinux => 'Last Linux installation';

  @override
  String get bootLastRescue => 'Last rescue activation';

  @override
  String get bootLinux => 'Linux installation';

  @override
  String get bootNone => 'No boot configuration active.';

  @override
  String get bootOffConsequence => 'The next reset boots from the disks again.';

  @override
  String bootOffTitle(String config, String name) {
    return 'Deactivate $config for $name?';
  }

  @override
  String get bootOs => 'Operating system';

  @override
  String get bootPasswordNote =>
      'Active at the next reset. Copy the password now; Falco does not store it.';

  @override
  String get bootRescue => 'Rescue system';

  @override
  String get bootVnc => 'VNC installation';

  @override
  String get bootWindows => 'Windows installation';

  @override
  String cancelAtDate(String date) {
    return 'At a date (from $date)';
  }

  @override
  String get cancelConsequence =>
      'The server is cancelled at the chosen date. Its data is deleted then.';

  @override
  String get cancelDate => 'Cancellation date';

  @override
  String get cancelEarliest => 'Earliest date';

  @override
  String get cancelNow => 'Immediately';

  @override
  String get cancelReason => 'Reason (optional)';

  @override
  String get cancelReserve => 'Reserve location';

  @override
  String get cancelReserveHint => 'Keeps the rack location for a new server.';

  @override
  String cancelTitle(String name) {
    return 'Cancel $name?';
  }

  @override
  String get cancelWithdraw => 'Withdraw cancellation';

  @override
  String get cancelWithdrawConsequence =>
      'The cancellation is withdrawn; the contract continues.';

  @override
  String cancelWithdrawTitle(String name) {
    return 'Withdraw the cancellation of $name?';
  }

  @override
  String get cancellation => 'Cancellation';

  @override
  String cancelledOn(String date) {
    return 'cancelled for $date';
  }

  @override
  String get failoverActive => 'Active on';

  @override
  String failoverActiveOn(String server) {
    return 'Active on $server';
  }

  @override
  String get failoverEmpty => 'No failover IPs.';

  @override
  String get failoverNoTargets => 'No other server to route to.';

  @override
  String get failoverOwner => 'Ordered with';

  @override
  String get failoverRoute => 'Route';

  @override
  String get failoverRouteConsequence =>
      'Traffic to the address goes to the new server within seconds. The address must be configured there.';

  @override
  String failoverRouteTitle(String ip, String server) {
    return 'Route $ip to $server?';
  }

  @override
  String get failoverUnroute => 'Unroute';

  @override
  String get failoverUnrouteConsequence =>
      'The address is routed nowhere; services on it become unreachable.';

  @override
  String failoverUnrouteTitle(String ip) {
    return 'Unroute $ip?';
  }

  @override
  String get failoverUnrouted => 'Not routed';

  @override
  String get fileNotText => 'The file is not UTF-8 text.';

  @override
  String get fileTooLarge => 'The file is too large.';

  @override
  String get filterCancelled => 'Cancelled';

  @override
  String get firewallClear => 'Clear firewall';

  @override
  String get firewallClearConsequence =>
      'All rules of the server firewall are removed.';

  @override
  String get firewallClearTitle => 'Clear the firewall?';

  @override
  String get firewallDisable => 'Disable';

  @override
  String get firewallEnable => 'Enable';

  @override
  String get firewallFilterIpv6 => 'Filter IPv6';

  @override
  String get firewallHetznerServices => 'Allow Hetzner services';

  @override
  String get firewallRules => 'Rules';

  @override
  String get firewallTemplateApplyConsequence =>
      'All rules of the server firewall are replaced by the rules of the template.';

  @override
  String firewallTemplateApplyTitle(String name) {
    return 'Apply template $name?';
  }

  @override
  String get firewallUnsaved => 'not applied yet';

  @override
  String get firewallUseTemplate => 'Apply template';

  @override
  String get installConsequence =>
      'At the next reset the installation starts and deletes all data on the disks.';

  @override
  String installTitle(String name) {
    return 'Reinstall $name?';
  }

  @override
  String get keyBits => 'Bits';

  @override
  String get keyFromFile => 'From file';

  @override
  String get macOff => 'Remove MAC';

  @override
  String get macOffConsequence =>
      'The address uses the MAC of the server again.';

  @override
  String macOffTitle(String ip) {
    return 'Remove the separate MAC of $ip?';
  }

  @override
  String get macOn => 'Separate MAC';

  @override
  String get macOnConsequence =>
      'Robot creates a separate MAC address, e.g. for a virtual machine.';

  @override
  String macOnTitle(String ip) {
    return 'Create a separate MAC for $ip?';
  }

  @override
  String get macUnavailable => 'not possible';

  @override
  String get notCancelled => 'Not cancelled';

  @override
  String get rdnsCreate => 'Add reverse DNS';

  @override
  String get rdnsDefault => 'Default reverse DNS';

  @override
  String get rdnsDeleteConsequence =>
      'The address answers with the Hetzner default again.';

  @override
  String rdnsDeleteTitle(String ip) {
    return 'Delete the reverse DNS of $ip?';
  }

  @override
  String get rdnsEmpty => 'No reverse DNS entries.';

  @override
  String get resetHw => 'Hardware reset';

  @override
  String get resetMan => 'Manual reset by support';

  @override
  String get resetManConsequence =>
      'A technician resets the server by hand; this can take a while.';

  @override
  String get resetPower => 'Power button';

  @override
  String get resetPowerLong => 'Power button, long press';

  @override
  String get resetSw => 'Software reset (Ctrl+Alt+Del)';

  @override
  String get robotActivityEmpty => 'No Robot changes in this session yet.';

  @override
  String get robotBoot => 'Boot configuration';

  @override
  String get robotBroadcast => 'Broadcast';

  @override
  String get robotCancel => 'Cancel contract';

  @override
  String get robotDatacenter => 'Data center';

  @override
  String get robotDone => 'Action completed';

  @override
  String robotFailed(String reason) {
    return 'Action failed: $reason';
  }

  @override
  String get robotFailover => 'Failover';

  @override
  String get robotFirewall => 'Firewall';

  @override
  String get robotIp => 'IP address';

  @override
  String get robotIps => 'IPs';

  @override
  String get robotIpsEmpty => 'No single IPs.';

  @override
  String get robotIpv6Net => 'IPv6 net';

  @override
  String get robotKeyDeleteConsequence =>
      'The key is deleted from Robot. Servers keep keys installed earlier.';

  @override
  String get robotKeysEmpty => 'No SSH keys in Robot yet.';

  @override
  String get robotLocked => 'Locked';

  @override
  String get robotMac => 'Separate MAC';

  @override
  String get robotNetmask => 'Netmask';

  @override
  String get robotNoAccess => 'This account has no Robot access.';

  @override
  String get robotNumber => 'Number';

  @override
  String robotPaidUntil(String date) {
    return 'paid until $date';
  }

  @override
  String get robotPaidUntilLabel => 'Paid until';

  @override
  String get robotProduct => 'Product';

  @override
  String get robotResetConsequence =>
      'The server restarts; unsaved data is lost.';

  @override
  String get robotSectionDisabled =>
      'Enable this section for the webservice user in Hetzner Robot.';

  @override
  String get robotServer => 'Dedicated server';

  @override
  String get robotServers => 'Servers';

  @override
  String get robotServersEmpty => 'No dedicated servers.';

  @override
  String get robotSubnet => 'Subnet';

  @override
  String get robotSubnets => 'Subnets';

  @override
  String get robotTemplate => 'Firewall template';

  @override
  String get robotTemplates => 'Firewall templates';

  @override
  String get robotTrafficQuota => 'Traffic included';

  @override
  String get robotVSwitch => 'vSwitch';

  @override
  String get robotVSwitches => 'vSwitches';

  @override
  String get robotWol => 'Wake on LAN';

  @override
  String get ruleAccept => 'accept';

  @override
  String get ruleAction => 'Action';

  @override
  String get ruleAny => 'any';

  @override
  String get ruleDestIp => 'Destination IP';

  @override
  String get ruleDestPort => 'Destination port';

  @override
  String get ruleDiscard => 'discard';

  @override
  String get ruleFrom => 'from';

  @override
  String get ruleInput => 'Incoming';

  @override
  String get ruleIpVersion => 'IP version';

  @override
  String get ruleOutput => 'Outgoing';

  @override
  String get ruleSourceIp => 'Source IP';

  @override
  String get ruleSourcePort => 'Source port';

  @override
  String get ruleTcpFlags => 'TCP flags';

  @override
  String get ruleTo => 'to';

  @override
  String get statusCancelled => 'cancelled';

  @override
  String get templateCreate => 'Create template';

  @override
  String get templateDefault => 'Default template';

  @override
  String get templateDeleteConsequence =>
      'The template is deleted. Server firewalls keep their rules.';

  @override
  String get templatesEmpty => 'No firewall templates.';

  @override
  String get trafficDaily => 'Daily limit (MB)';

  @override
  String get trafficDay => 'Day';

  @override
  String get trafficHourly => 'Hourly limit (MB)';

  @override
  String get trafficIn => 'Incoming';

  @override
  String get trafficMonth => 'Traffic this month';

  @override
  String get trafficMonthType => 'Month';

  @override
  String get trafficMonthly => 'Monthly limit (GB)';

  @override
  String get trafficNone => 'No traffic data for this period.';

  @override
  String get trafficOut => 'Outgoing';

  @override
  String get trafficSum => 'Total';

  @override
  String get trafficTitle => 'Traffic';

  @override
  String get trafficWarnings => 'Traffic warnings';

  @override
  String get trafficWarningsOn => 'warnings on';

  @override
  String get trafficYear => 'Year';

  @override
  String get vlanHint => 'VLAN ID from 4000 to 4091';

  @override
  String get vswitchAddServer => 'Add server';

  @override
  String get vswitchCancelConsequence =>
      'The vSwitch is cancelled at the chosen date; its servers lose the connection.';

  @override
  String get vswitchCreate => 'Create vSwitch';

  @override
  String get vswitchEmpty => 'No vSwitches yet.';

  @override
  String get vswitchNoServers => 'No servers in this vSwitch.';

  @override
  String get vswitchRemoveConsequence =>
      'The server leaves the VLAN; its traffic there stops.';

  @override
  String vswitchRemoveTitle(String server, String vswitch) {
    return 'Remove $server from $vswitch?';
  }

  @override
  String get wolConsequence => 'A Wake on LAN packet is sent to the server.';

  @override
  String wolTitle(String name) {
    return 'Wake $name?';
  }

  @override
  String get activityType => 'Type';

  @override
  String get activityTime => 'Time';

  @override
  String get activityAnyTime => 'Any time';

  @override
  String get activityLastDay => 'Last 24 hours';

  @override
  String get activityLastWeek => 'Last 7 days';

  @override
  String get activityLastMonth => 'Last 30 days';

  @override
  String get activityToday => 'Today';

  @override
  String get activityYesterday => 'Yesterday';

  @override
  String get activityEarlier => 'Earlier';

  @override
  String get searchHint => 'Name, IP, label or ID';

  @override
  String get searchStart =>
      'Search servers, IPs, labels and IDs in all accounts, projects and Robot.';

  @override
  String get searchClear => 'Clear';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchResults => 'Results';

  @override
  String get searchNoMatches => 'Nothing matches.';

  @override
  String get searchDedicated => 'Dedicated servers';

  @override
  String get searchRobotKeys => 'Robot SSH keys';
}
