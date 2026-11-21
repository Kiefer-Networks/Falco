import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Falco'**
  String get appTitle;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @moreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActions;

  /// No description provided for @listSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get listSort;

  /// No description provided for @listSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort: {field}'**
  String listSortBy(String field);

  /// No description provided for @listNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No results for this search or filter.'**
  String get listNoMatches;

  /// No description provided for @listStaleBanner.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh. Showing the last loaded data.'**
  String get listStaleBanner;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection to the server. Check your network.'**
  String get errorNetwork;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// No description provided for @copiedSensitive.
  ///
  /// In en, this message translates to:
  /// **'Copied. The clipboard clears in {seconds} s.'**
  String copiedSensitive(int seconds);

  /// No description provided for @copyValue.
  ///
  /// In en, this message translates to:
  /// **'Copy {value}'**
  String copyValue(String value);

  /// No description provided for @secretShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get secretShow;

  /// No description provided for @secretHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get secretHide;

  /// No description provided for @secretHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden secret'**
  String get secretHidden;

  /// No description provided for @statusRunning.
  ///
  /// In en, this message translates to:
  /// **'running'**
  String get statusRunning;

  /// No description provided for @statusOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get statusOff;

  /// No description provided for @statusStarting.
  ///
  /// In en, this message translates to:
  /// **'starting'**
  String get statusStarting;

  /// No description provided for @statusStopping.
  ///
  /// In en, this message translates to:
  /// **'stopping'**
  String get statusStopping;

  /// No description provided for @statusRebooting.
  ///
  /// In en, this message translates to:
  /// **'rebooting'**
  String get statusRebooting;

  /// No description provided for @statusInitializing.
  ///
  /// In en, this message translates to:
  /// **'initializing'**
  String get statusInitializing;

  /// No description provided for @statusRebuilding.
  ///
  /// In en, this message translates to:
  /// **'rebuilding'**
  String get statusRebuilding;

  /// No description provided for @statusMigrating.
  ///
  /// In en, this message translates to:
  /// **'migrating'**
  String get statusMigrating;

  /// No description provided for @statusDeleting.
  ///
  /// In en, this message translates to:
  /// **'deleting'**
  String get statusDeleting;

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get statusError;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get statusUnknown;

  /// No description provided for @periodHour.
  ///
  /// In en, this message translates to:
  /// **'1h'**
  String get periodHour;

  /// No description provided for @periodDay.
  ///
  /// In en, this message translates to:
  /// **'24h'**
  String get periodDay;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'7d'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'30d'**
  String get periodMonth;

  /// No description provided for @chartPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get chartPeriod;

  /// No description provided for @chartNoData.
  ///
  /// In en, this message translates to:
  /// **'No data for this period.'**
  String get chartNoData;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @wizardStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String wizardStep(int current, int total);

  /// No description provided for @wizardSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get wizardSummary;

  /// No description provided for @wizardProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get wizardProject;

  /// No description provided for @confirmTypeName.
  ///
  /// In en, this message translates to:
  /// **'Type {name} to confirm.'**
  String confirmTypeName(String name);

  /// No description provided for @confirmTypeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get confirmTypeNameLabel;

  /// No description provided for @scopeProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get scopeProject;

  /// No description provided for @scopeSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch account or project'**
  String get scopeSwitch;

  /// No description provided for @scopeAllProjects.
  ///
  /// In en, this message translates to:
  /// **'All projects'**
  String get scopeAllProjects;

  /// No description provided for @scopeRobot.
  ///
  /// In en, this message translates to:
  /// **'Robot'**
  String get scopeRobot;

  /// No description provided for @relativeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get relativeJustNow;

  /// No description provided for @relativeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String relativeMinutes(int count);

  /// No description provided for @relativeHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String relativeHours(int count);

  /// No description provided for @relativeDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String relativeDays(int count);

  /// No description provided for @showcaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Design system'**
  String get showcaseTitle;

  /// No description provided for @showcaseTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get showcaseTheme;

  /// No description provided for @showcaseDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get showcaseDark;

  /// No description provided for @showcaseLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get showcaseLight;

  /// No description provided for @showcaseOled.
  ///
  /// In en, this message translates to:
  /// **'OLED'**
  String get showcaseOled;

  /// No description provided for @showcaseAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent'**
  String get showcaseAccent;

  /// No description provided for @showcaseOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get showcaseOpen;

  /// No description provided for @resourceServers.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get resourceServers;

  /// No description provided for @resourceServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get resourceServer;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get sortName;

  /// No description provided for @sortCreated.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get sortCreated;

  /// No description provided for @actionReboot.
  ///
  /// In en, this message translates to:
  /// **'Reboot'**
  String get actionReboot;

  /// No description provided for @actionShutdown.
  ///
  /// In en, this message translates to:
  /// **'Shutdown'**
  String get actionShutdown;

  /// No description provided for @actionConsole.
  ///
  /// In en, this message translates to:
  /// **'Console'**
  String get actionConsole;

  /// No description provided for @actionSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Snapshot'**
  String get actionSnapshot;

  /// No description provided for @actionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionRebuild.
  ///
  /// In en, this message translates to:
  /// **'Rebuild'**
  String get actionRebuild;

  /// No description provided for @actionCreateServer.
  ///
  /// In en, this message translates to:
  /// **'Create server'**
  String get actionCreateServer;

  /// No description provided for @emptyServers.
  ///
  /// In en, this message translates to:
  /// **'No servers in this project yet.'**
  String get emptyServers;

  /// No description provided for @sectionOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get sectionOverview;

  /// No description provided for @sectionMetrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get sectionMetrics;

  /// No description provided for @metricCpu.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get metricCpu;

  /// No description provided for @metricNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get metricNetwork;

  /// No description provided for @metricIn.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get metricIn;

  /// No description provided for @metricOut.
  ///
  /// In en, this message translates to:
  /// **'out'**
  String get metricOut;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// No description provided for @fieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get fieldLocation;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fieldAddress;

  /// No description provided for @fieldRootPassword.
  ///
  /// In en, this message translates to:
  /// **'Root password'**
  String get fieldRootPassword;

  /// No description provided for @rebootTitle.
  ///
  /// In en, this message translates to:
  /// **'Reboot {name}?'**
  String rebootTitle(String name);

  /// No description provided for @rebootConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server restarts through ACPI. Open connections drop while it boots, usually for less than a minute.'**
  String get rebootConsequence;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteTitle(String name);

  /// No description provided for @deleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server and its disk are deleted. This cannot be undone.'**
  String get deleteConsequence;

  /// No description provided for @scopeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show in this scope yet.'**
  String get scopeEmpty;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Falco is locked.'**
  String get lockTitle;

  /// No description provided for @lockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockUnlock;

  /// No description provided for @lockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Falco to access your servers'**
  String get lockReason;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'The access data was rejected. Check the token or the credentials.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'This access lacks the permission for this action, for example a read only token.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'This resource no longer exists.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'The resource is protected, locked or busy. Try again later.'**
  String get errorConflict;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorInvalid.
  ///
  /// In en, this message translates to:
  /// **'The input was rejected. Check the marked fields.'**
  String get errorInvalid;

  /// No description provided for @errorPinning.
  ///
  /// In en, this message translates to:
  /// **'The server certificate is not trusted. The connection was stopped to protect your access data.'**
  String get errorPinning;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server reported an error. Try again later.'**
  String get errorServer;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'in progress'**
  String get statusInProgress;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get statusDone;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get statusFailed;

  /// No description provided for @navCompute.
  ///
  /// In en, this message translates to:
  /// **'Compute'**
  String get navCompute;

  /// No description provided for @navNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get navNetwork;

  /// No description provided for @navStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get navStorage;

  /// No description provided for @navRobot.
  ///
  /// In en, this message translates to:
  /// **'Robot'**
  String get navRobot;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No actions yet.'**
  String get activityEmpty;

  /// No description provided for @activityShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all activity'**
  String get activityShowAll;

  /// No description provided for @filterRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get filterRunning;

  /// No description provided for @filterOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get filterOff;

  /// No description provided for @filterInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get filterInProgress;

  /// No description provided for @filterFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get filterFailed;

  /// No description provided for @actionPowerOn.
  ///
  /// In en, this message translates to:
  /// **'Power on'**
  String get actionPowerOn;

  /// No description provided for @actionPowerOff.
  ///
  /// In en, this message translates to:
  /// **'Power off'**
  String get actionPowerOff;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// No description provided for @shutdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Shut down {name}?'**
  String shutdownTitle(String name);

  /// No description provided for @shutdownConsequence.
  ///
  /// In en, this message translates to:
  /// **'The operating system is asked to shut down through ACPI. The server stays off until you power it on.'**
  String get shutdownConsequence;

  /// No description provided for @powerOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Power off {name}?'**
  String powerOffTitle(String name);

  /// No description provided for @powerOffConsequence.
  ///
  /// In en, this message translates to:
  /// **'The power is cut immediately, like pulling the plug. Unsaved data can be lost.'**
  String get powerOffConsequence;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset {name}?'**
  String resetTitle(String name);

  /// No description provided for @resetConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server is restarted hard, like pressing the reset button. Unsaved data can be lost.'**
  String get resetConsequence;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'The action failed.'**
  String get actionFailed;

  /// No description provided for @fieldVcpu.
  ///
  /// In en, this message translates to:
  /// **'vCPU'**
  String get fieldVcpu;

  /// No description provided for @fieldMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get fieldMemory;

  /// No description provided for @fieldDisk.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get fieldDisk;

  /// No description provided for @fieldImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get fieldImage;

  /// No description provided for @metricDisk.
  ///
  /// In en, this message translates to:
  /// **'Disk'**
  String get metricDisk;

  /// No description provided for @metricRead.
  ///
  /// In en, this message translates to:
  /// **'read'**
  String get metricRead;

  /// No description provided for @metricWrite.
  ///
  /// In en, this message translates to:
  /// **'write'**
  String get metricWrite;

  /// No description provided for @sectionActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get sectionActivity;

  /// No description provided for @accountAdd.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get accountAdd;

  /// No description provided for @projectAdd.
  ///
  /// In en, this message translates to:
  /// **'Add project'**
  String get projectAdd;

  /// No description provided for @accountStep.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountStep;

  /// No description provided for @projectStep.
  ///
  /// In en, this message translates to:
  /// **'Cloud project'**
  String get projectStep;

  /// No description provided for @fieldAccountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get fieldAccountName;

  /// No description provided for @fieldProjectName.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get fieldProjectName;

  /// No description provided for @fieldApiToken.
  ///
  /// In en, this message translates to:
  /// **'API token'**
  String get fieldApiToken;

  /// No description provided for @tokenHint.
  ///
  /// In en, this message translates to:
  /// **'Create a token with read and write access in the Hetzner Cloud Console under Security, API tokens.'**
  String get tokenHint;

  /// No description provided for @tokenCheckSave.
  ///
  /// In en, this message translates to:
  /// **'Check and save'**
  String get tokenCheckSave;

  /// No description provided for @tokenHidden.
  ///
  /// In en, this message translates to:
  /// **'hidden'**
  String get tokenHidden;

  /// No description provided for @actionCommand.
  ///
  /// In en, this message translates to:
  /// **'{command, select, start_server{Power on server} stop_server{Power off server} poweron_server{Power on server} poweroff_server{Power off server} shutdown_server{Shut down server} reboot_server{Reboot server} reset_server{Reset server} create_server{Create server} delete_server{Delete server} rebuild_server{Rebuild server} change_server_type{Change server type} enable_rescue{Enable rescue mode} disable_rescue{Disable rescue mode} attach_iso{Attach ISO} detach_iso{Detach ISO} create_image{Create image} enable_backup{Enable backups} disable_backup{Disable backups} change_protection{Change protection} change_dns_ptr{Change reverse DNS} reset_password{Reset root password} request_console{Open console} attach_volume{Attach volume} detach_volume{Detach volume} resize_volume{Resize volume} create_volume{Create volume} attach_to_network{Attach to network} detach_from_network{Detach from network} add_to_placement_group{Add to placement group} remove_from_placement_group{Remove from placement group} assign_floating_ip{Assign Floating IP} unassign_floating_ip{Unassign Floating IP} assign_primary_ip{Assign Primary IP} unassign_primary_ip{Unassign Primary IP} apply_firewall{Apply firewall} remove_firewall{Remove firewall} set_firewall_rules{Set firewall rules} other{}}'**
  String actionCommand(String command);

  /// No description provided for @accountManage.
  ///
  /// In en, this message translates to:
  /// **'Manage account'**
  String get accountManage;

  /// No description provided for @lockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This device has no screen lock. Set up a PIN, Face ID or a fingerprint to protect Falco.'**
  String get lockUnavailable;

  /// No description provided for @lockContinueWithout.
  ///
  /// In en, this message translates to:
  /// **'Continue without app lock'**
  String get lockContinueWithout;

  /// No description provided for @fieldS3Location.
  ///
  /// In en, this message translates to:
  /// **'Object Storage location'**
  String get fieldS3Location;

  /// No description provided for @s3Hint.
  ///
  /// In en, this message translates to:
  /// **'Optional. S3 keys from the Cloud Console under Object Storage, Security credentials. Checked against the chosen location.'**
  String get s3Hint;

  /// No description provided for @s3None.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get s3None;

  /// No description provided for @fieldAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Access key'**
  String get fieldAccessKey;

  /// No description provided for @fieldSecretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret key'**
  String get fieldSecretKey;

  /// No description provided for @fieldRobotUser.
  ///
  /// In en, this message translates to:
  /// **'Webservice user'**
  String get fieldRobotUser;

  /// No description provided for @fieldRobotPassword.
  ///
  /// In en, this message translates to:
  /// **'Webservice password'**
  String get fieldRobotPassword;

  /// No description provided for @robotHint.
  ///
  /// In en, this message translates to:
  /// **'Create a webservice user in Robot under Settings, Webservice and app settings.'**
  String get robotHint;

  /// No description provided for @s3Step.
  ///
  /// In en, this message translates to:
  /// **'Object Storage'**
  String get s3Step;

  /// No description provided for @cloudOpenConsole.
  ///
  /// In en, this message translates to:
  /// **'Open Cloud Console'**
  String get cloudOpenConsole;

  /// No description provided for @robotOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Robot settings'**
  String get robotOpenSettings;

  /// No description provided for @accountDone.
  ///
  /// In en, this message translates to:
  /// **'All set. {name} is ready to use.'**
  String accountDone(String name);

  /// No description provided for @accountOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get accountOpen;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get fieldDescription;

  /// No description provided for @servicesStep.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesStep;

  /// No description provided for @serviceCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get serviceCloud;

  /// No description provided for @serviceCloudHint.
  ///
  /// In en, this message translates to:
  /// **'Cloud projects with servers, networks, DNS and storage'**
  String get serviceCloudHint;

  /// No description provided for @serviceRobotHint.
  ///
  /// In en, this message translates to:
  /// **'Dedicated servers through the Robot webservice'**
  String get serviceRobotHint;

  /// No description provided for @servicesPickOne.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one service.'**
  String get servicesPickOne;

  /// No description provided for @projectsStep.
  ///
  /// In en, this message translates to:
  /// **'Cloud projects'**
  String get projectsStep;

  /// No description provided for @projectRemoveDraft.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String projectRemoveDraft(String name);

  /// No description provided for @robotStep.
  ///
  /// In en, this message translates to:
  /// **'Robot access'**
  String get robotStep;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @accountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsTitle;

  /// No description provided for @accountsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet.'**
  String get accountsEmpty;

  /// No description provided for @accountsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account} other{{count} accounts}}'**
  String accountsCount(int count);

  /// No description provided for @accountCloudBadge.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Cloud, 1 project} other{Cloud, {count} projects}}'**
  String accountCloudBadge(int count);

  /// No description provided for @accountActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get accountActive;

  /// No description provided for @accountDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get accountDefault;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @accountEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get accountEdit;

  /// No description provided for @accountDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get accountDelete;

  /// No description provided for @accountDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String accountDeleteTitle(String name);

  /// No description provided for @accountDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The account is removed from this device with all its tokens, keys and Robot credentials. Nothing changes at Hetzner.'**
  String get accountDeleteConsequence;

  /// No description provided for @robotAccess.
  ///
  /// In en, this message translates to:
  /// **'Webservice access'**
  String get robotAccess;

  /// No description provided for @robotStored.
  ///
  /// In en, this message translates to:
  /// **'Stored and checked'**
  String get robotStored;

  /// No description provided for @robotAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Robot access'**
  String get robotAdd;

  /// No description provided for @robotChange.
  ///
  /// In en, this message translates to:
  /// **'Change Robot access'**
  String get robotChange;

  /// No description provided for @robotDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Robot access'**
  String get robotDelete;

  /// No description provided for @robotDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the Robot access of {name}?'**
  String robotDeleteTitle(String name);

  /// No description provided for @robotDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'User and password are deleted from this device. The webservice user at Hetzner stays.'**
  String get robotDeleteConsequence;

  /// No description provided for @projectsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Cloud projects yet.'**
  String get projectsEmpty;

  /// No description provided for @projectDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete project'**
  String get projectDelete;

  /// No description provided for @projectDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String projectDeleteTitle(String name);

  /// No description provided for @projectDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The project is removed from this device with its token and S3 keys. The project and its servers at Hetzner stay.'**
  String get projectDeleteConsequence;

  /// No description provided for @tokenChange.
  ///
  /// In en, this message translates to:
  /// **'Change token'**
  String get tokenChange;

  /// No description provided for @s3Change.
  ///
  /// In en, this message translates to:
  /// **'Object Storage keys'**
  String get s3Change;

  /// No description provided for @s3Delete.
  ///
  /// In en, this message translates to:
  /// **'Delete Object Storage keys'**
  String get s3Delete;

  /// No description provided for @s3DeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the Object Storage keys of {name}?'**
  String s3DeleteTitle(String name);

  /// No description provided for @s3DeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'Access and secret key are deleted from this device. Buckets and keys at Hetzner stay.'**
  String get s3DeleteConsequence;

  /// No description provided for @s3NoKeys.
  ///
  /// In en, this message translates to:
  /// **'No Object Storage keys'**
  String get s3NoKeys;

  /// No description provided for @s3Keys.
  ///
  /// In en, this message translates to:
  /// **'Object Storage keys, checked at {location}'**
  String s3Keys(String location);

  /// No description provided for @savedMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystem;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsLock.
  ///
  /// In en, this message translates to:
  /// **'Unlock at start'**
  String get settingsLock;

  /// No description provided for @settingsLockHint.
  ///
  /// In en, this message translates to:
  /// **'Face ID, fingerprint or device PIN at start and after the auto lock time'**
  String get settingsLockHint;

  /// No description provided for @settingsAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto lock'**
  String get settingsAutoLock;

  /// No description provided for @lockImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get lockImmediately;

  /// No description provided for @lockSeconds.
  ///
  /// In en, this message translates to:
  /// **'After {count} s'**
  String lockSeconds(int count);

  /// No description provided for @lockMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{After 1 minute} other{After {count} minutes}}'**
  String lockMinutes(int count);

  /// No description provided for @settingsSecureScreen.
  ///
  /// In en, this message translates to:
  /// **'Block screenshots'**
  String get settingsSecureScreen;

  /// No description provided for @settingsSecureScreenHint.
  ///
  /// In en, this message translates to:
  /// **'Hides Falco in the app switcher and blocks screenshots'**
  String get settingsSecureScreenHint;

  /// No description provided for @settingsPinning.
  ///
  /// In en, this message translates to:
  /// **'Certificate pinning'**
  String get settingsPinning;

  /// No description provided for @settingsPinningHint.
  ///
  /// In en, this message translates to:
  /// **'Active for all Hetzner endpoints: Cloud, Storage Boxes, Robot and Object Storage.'**
  String get settingsPinningHint;

  /// No description provided for @accentAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get accentAmber;

  /// No description provided for @accentBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get accentBlue;

  /// No description provided for @accentGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get accentGreen;

  /// No description provided for @accentRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get accentRed;

  /// No description provided for @accentPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get accentPurple;

  /// No description provided for @accentOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get accentOrange;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Falco'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage Hetzner Cloud, Robot, DNS and Storage from your phone. Free software without tracking.'**
  String get aboutDescription;

  /// No description provided for @aboutWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get aboutWebsite;

  /// No description provided for @aboutDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get aboutDonate;

  /// No description provided for @aboutSource.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get aboutSource;

  /// No description provided for @aboutDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloper;

  /// No description provided for @aboutLicense.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get aboutLicense;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get aboutLicenses;

  /// No description provided for @welcomeSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get welcomeSkip;

  /// No description provided for @welcomeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get welcomeLanguage;

  /// No description provided for @welcomeFeatures.
  ///
  /// In en, this message translates to:
  /// **'What Falco does'**
  String get welcomeFeatures;

  /// No description provided for @welcomeCloud.
  ///
  /// In en, this message translates to:
  /// **'Servers, volumes, networks, firewalls, load balancers and more, across all your projects.'**
  String get welcomeCloud;

  /// No description provided for @welcomeRobot.
  ///
  /// In en, this message translates to:
  /// **'Dedicated servers: reset, rescue, Wake on LAN, reverse DNS and failover.'**
  String get welcomeRobot;

  /// No description provided for @welcomeDns.
  ///
  /// In en, this message translates to:
  /// **'Zones and records of your Cloud projects.'**
  String get welcomeDns;

  /// No description provided for @welcomeObjectStorage.
  ///
  /// In en, this message translates to:
  /// **'Object Storage'**
  String get welcomeObjectStorage;

  /// No description provided for @welcomeObjectStorageText.
  ///
  /// In en, this message translates to:
  /// **'Buckets and files in all locations, with uploads in the background.'**
  String get welcomeObjectStorageText;

  /// No description provided for @welcomeSecurity.
  ///
  /// In en, this message translates to:
  /// **'Your access stays safe'**
  String get welcomeSecurity;

  /// No description provided for @welcomeSecretsTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted on the device'**
  String get welcomeSecretsTitle;

  /// No description provided for @welcomeSecretsIos.
  ///
  /// In en, this message translates to:
  /// **'Tokens and passwords live only in the iOS Keychain of this device.'**
  String get welcomeSecretsIos;

  /// No description provided for @welcomeSecretsAndroid.
  ///
  /// In en, this message translates to:
  /// **'Tokens and passwords live only in the hardware backed Android Keystore.'**
  String get welcomeSecretsAndroid;

  /// No description provided for @welcomeLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock at start'**
  String get welcomeLockTitle;

  /// No description provided for @welcomeLockIos.
  ///
  /// In en, this message translates to:
  /// **'Falco asks for Face ID, Touch ID or your passcode at start.'**
  String get welcomeLockIos;

  /// No description provided for @welcomeLockAndroid.
  ///
  /// In en, this message translates to:
  /// **'Falco asks for your fingerprint or device PIN at start.'**
  String get welcomeLockAndroid;

  /// No description provided for @welcomePinning.
  ///
  /// In en, this message translates to:
  /// **'TLS 1.2 or newer with certificate pinning for every Hetzner endpoint. No tracking.'**
  String get welcomePinning;

  /// No description provided for @welcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Ready to start'**
  String get welcomeStart;

  /// No description provided for @welcomeStartText.
  ///
  /// In en, this message translates to:
  /// **'Add an account with a Cloud API token, Robot access, or both. Every access is checked before it is stored.'**
  String get welcomeStartText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
