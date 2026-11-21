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

  /// No description provided for @commonMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get commonMore;

  /// No description provided for @overviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get overviewUnavailable;

  /// No description provided for @overviewStatusCount.
  ///
  /// In en, this message translates to:
  /// **'{status}: {count}'**
  String overviewStatusCount(String status, int count);

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

  /// No description provided for @listProjectsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load: {projects}. Showing the other projects.'**
  String listProjectsFailed(String projects);

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

  /// No description provided for @detailPick.
  ///
  /// In en, this message translates to:
  /// **'Pick an entry to see its details.'**
  String get detailPick;

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

  /// No description provided for @copiedPlain.
  ///
  /// In en, this message translates to:
  /// **'Copied. This system cannot hide it from other apps; the clipboard clears in {seconds} s.'**
  String copiedPlain(int seconds);

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
  /// **'The server and its disk are deleted. Attached volumes are kept. This cannot be undone.'**
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

  /// No description provided for @vaultLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Access data deleted'**
  String get vaultLostTitle;

  /// No description provided for @vaultLostMessage.
  ///
  /// In en, this message translates to:
  /// **'The system deleted the stored access data, for example after a change to the fingerprints or the face. Enter the tokens and credentials again for: {accounts}.'**
  String vaultLostMessage(String accounts);

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
  /// **'{command, select, start_server{Power on server} stop_server{Power off server} poweron_server{Power on server} poweroff_server{Power off server} shutdown_server{Shut down server} reboot_server{Reboot server} reset_server{Reset server} create_server{Create server} delete_server{Delete server} rebuild_server{Rebuild server} change_server_type{Change server type} enable_rescue{Enable rescue mode} disable_rescue{Disable rescue mode} attach_iso{Attach ISO} detach_iso{Detach ISO} create_image{Create image} enable_backup{Enable backups} disable_backup{Disable backups} change_protection{Change protection} change_dns_ptr{Change reverse DNS} reset_password{Reset root password} request_console{Open console} attach_volume{Attach volume} detach_volume{Detach volume} resize_volume{Resize volume} create_volume{Create volume} attach_to_network{Attach to network} detach_from_network{Detach from network} add_to_placement_group{Add to placement group} remove_from_placement_group{Remove from placement group} assign_floating_ip{Assign Floating IP} unassign_floating_ip{Unassign Floating IP} assign_primary_ip{Assign Primary IP} unassign_primary_ip{Unassign Primary IP} apply_firewall{Apply firewall} remove_firewall{Remove firewall} set_firewall_rules{Set firewall rules} create{Create} delete{Delete} change_type{Change type} update_access_settings{Change access} rollback_snapshot{Roll back snapshot} enable_snapshot_plan{Enable snapshot plan} disable_snapshot_plan{Disable snapshot plan} create_snapshot{Create snapshot} delete_snapshot{Delete snapshot} create_subaccount{Add subaccount} delete_subaccount{Delete subaccount} reset_subaccount_password{Reset subaccount password} change_home_directory{Change home directory} robot_reset{Reset} robot_wol{Wake on LAN} robot_boot_on{Activate boot configuration} robot_boot_off{Deactivate boot configuration} robot_rename{Rename server} robot_cancel{Cancel} robot_withdraw{Withdraw cancellation} robot_rdns{Change reverse DNS} robot_failover{Change failover routing} robot_vswitch{Change vSwitch} robot_key{Change SSH key} robot_address{Change IP settings} robot_firewall{Change firewall} other{}}'**
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

  /// No description provided for @backupWindow.
  ///
  /// In en, this message translates to:
  /// **'On, window {window} UTC'**
  String backupWindow(String window);

  /// No description provided for @backupsOn.
  ///
  /// In en, this message translates to:
  /// **'Enable backups'**
  String get backupsOn;

  /// No description provided for @backupsOff.
  ///
  /// In en, this message translates to:
  /// **'Disable backups'**
  String get backupsOff;

  /// No description provided for @backupsOnTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable backups for {name}?'**
  String backupsOnTitle(String name);

  /// No description provided for @backupsOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable backups for {name}?'**
  String backupsOffTitle(String name);

  /// No description provided for @backupsOnConsequence.
  ///
  /// In en, this message translates to:
  /// **'Hetzner keeps seven daily backups. Backups cost 20 % of the server price.'**
  String get backupsOnConsequence;

  /// No description provided for @backupsOffConsequence.
  ///
  /// In en, this message translates to:
  /// **'All existing backups of this server are deleted.'**
  String get backupsOffConsequence;

  /// No description provided for @changeType.
  ///
  /// In en, this message translates to:
  /// **'Change type'**
  String get changeType;

  /// No description provided for @changeTypeNeedsOff.
  ///
  /// In en, this message translates to:
  /// **'Power off the server before changing its type.'**
  String get changeTypeNeedsOff;

  /// No description provided for @changeTypeTo.
  ///
  /// In en, this message translates to:
  /// **'Change to {type}'**
  String changeTypeTo(String type);

  /// No description provided for @upgradeDisk.
  ///
  /// In en, this message translates to:
  /// **'Upgrade disk (irreversible)'**
  String get upgradeDisk;

  /// No description provided for @upgradeDiskHint.
  ///
  /// In en, this message translates to:
  /// **'With a larger disk the server can never move back to a smaller type.'**
  String get upgradeDiskHint;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get commonOff;

  /// No description provided for @consoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Console of {name}'**
  String consoleTitle(String name);

  /// No description provided for @consoleNote.
  ///
  /// In en, this message translates to:
  /// **'Connect a VNC client to this websocket URL within about a minute.'**
  String get consoleNote;

  /// No description provided for @consoleUrl.
  ///
  /// In en, this message translates to:
  /// **'Websocket URL'**
  String get consoleUrl;

  /// No description provided for @consolePassword.
  ///
  /// In en, this message translates to:
  /// **'VNC password'**
  String get consolePassword;

  /// No description provided for @createdMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} created'**
  String createdMessage(String name);

  /// No description provided for @deletedMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String deletedMessage(String name);

  /// No description provided for @deprecated.
  ///
  /// In en, this message translates to:
  /// **'deprecated'**
  String get deprecated;

  /// No description provided for @emptyImages.
  ///
  /// In en, this message translates to:
  /// **'No snapshots or backups yet. Create a snapshot from a server.'**
  String get emptyImages;

  /// No description provided for @emptyPlacementGroups.
  ///
  /// In en, this message translates to:
  /// **'No placement groups in this project yet.'**
  String get emptyPlacementGroups;

  /// No description provided for @emptySshKeys.
  ///
  /// In en, this message translates to:
  /// **'No SSH keys in this project yet.'**
  String get emptySshKeys;

  /// No description provided for @emptyVolumes.
  ///
  /// In en, this message translates to:
  /// **'No volumes in this project yet.'**
  String get emptyVolumes;

  /// No description provided for @fieldArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get fieldArchitecture;

  /// No description provided for @fieldBackups.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get fieldBackups;

  /// No description provided for @fieldCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get fieldCreated;

  /// No description provided for @fieldDeleteProtection.
  ///
  /// In en, this message translates to:
  /// **'Delete protection'**
  String get fieldDeleteProtection;

  /// No description provided for @fieldRebuildProtection.
  ///
  /// In en, this message translates to:
  /// **'Rebuild protection'**
  String get fieldRebuildProtection;

  /// No description provided for @fieldDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get fieldDevice;

  /// No description provided for @fieldFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fieldFingerprint;

  /// No description provided for @fieldFormat.
  ///
  /// In en, this message translates to:
  /// **'File system'**
  String get fieldFormat;

  /// No description provided for @fieldImageDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldImageDescription;

  /// No description provided for @fieldIso.
  ///
  /// In en, this message translates to:
  /// **'ISO'**
  String get fieldIso;

  /// No description provided for @fieldLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get fieldLabels;

  /// No description provided for @fieldPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get fieldPrice;

  /// No description provided for @fieldProtection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get fieldProtection;

  /// No description provided for @fieldPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Public key'**
  String get fieldPublicKey;

  /// No description provided for @fieldSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fieldSize;

  /// No description provided for @fieldSizeGb.
  ///
  /// In en, this message translates to:
  /// **'Size in GB'**
  String get fieldSizeGb;

  /// No description provided for @fieldSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get fieldSource;

  /// No description provided for @fieldUserData.
  ///
  /// In en, this message translates to:
  /// **'Cloud init user data'**
  String get fieldUserData;

  /// No description provided for @filterAttached.
  ///
  /// In en, this message translates to:
  /// **'Attached'**
  String get filterAttached;

  /// No description provided for @filterDetached.
  ///
  /// In en, this message translates to:
  /// **'Not attached'**
  String get filterDetached;

  /// No description provided for @imageApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get imageApp;

  /// No description provided for @imageBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get imageBackup;

  /// No description provided for @imageSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Snapshot'**
  String get imageSnapshot;

  /// No description provided for @imageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get imageSystem;

  /// No description provided for @imageConvert.
  ///
  /// In en, this message translates to:
  /// **'To snapshot'**
  String get imageConvert;

  /// No description provided for @imageConvertTitle.
  ///
  /// In en, this message translates to:
  /// **'Convert {name} to a snapshot?'**
  String imageConvertTitle(String name);

  /// No description provided for @imageConvertConsequence.
  ///
  /// In en, this message translates to:
  /// **'The backup becomes a snapshot. It is kept when the server is deleted and billed as a snapshot.'**
  String get imageConvertConsequence;

  /// No description provided for @imageDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The image is deleted. Servers built from it keep running. This cannot be undone.'**
  String get imageDeleteConsequence;

  /// No description provided for @isoAttach.
  ///
  /// In en, this message translates to:
  /// **'Insert ISO'**
  String get isoAttach;

  /// No description provided for @isoDetach.
  ///
  /// In en, this message translates to:
  /// **'Eject ISO'**
  String get isoDetach;

  /// No description provided for @isoDetachTitle.
  ///
  /// In en, this message translates to:
  /// **'Eject {name}?'**
  String isoDetachTitle(String name);

  /// No description provided for @isoDetachConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server boots from its disk again after the next restart.'**
  String get isoDetachConsequence;

  /// No description provided for @labelsHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. key=value, separated by commas.'**
  String get labelsHint;

  /// No description provided for @metricStats.
  ///
  /// In en, this message translates to:
  /// **'{series}: min {min} · max {max} · avg {avg}'**
  String metricStats(String series, String min, String max, String avg);

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'{price}/month'**
  String perMonth(String price);

  /// No description provided for @priceMonthly.
  ///
  /// In en, this message translates to:
  /// **'{gross}/month gross, {net} net, {perGb} per GB'**
  String priceMonthly(String gross, String net, String perGb);

  /// No description provided for @placementGroupAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to placement group'**
  String get placementGroupAdd;

  /// No description provided for @placementGroupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create placement group'**
  String get placementGroupCreate;

  /// No description provided for @placementGroupDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The group is deleted. Its servers keep running.'**
  String get placementGroupDeleteConsequence;

  /// No description provided for @placementGroupEmpty.
  ///
  /// In en, this message translates to:
  /// **'No servers in this group.'**
  String get placementGroupEmpty;

  /// No description provided for @placementGroupNone.
  ///
  /// In en, this message translates to:
  /// **'No placement groups in this project. Create one under Compute first.'**
  String get placementGroupNone;

  /// No description provided for @placementGroupRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from placement group'**
  String get placementGroupRemove;

  /// No description provided for @placementGroupRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from {group}?'**
  String placementGroupRemoveTitle(String name, String group);

  /// No description provided for @placementGroupRemoveConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server may then share hardware with other servers of the group.'**
  String get placementGroupRemoveConsequence;

  /// No description provided for @placementGroupTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Spread places every server on a different host.'**
  String get placementGroupTypeHint;

  /// No description provided for @protectOn.
  ///
  /// In en, this message translates to:
  /// **'Protect'**
  String get protectOn;

  /// No description provided for @protectOff.
  ///
  /// In en, this message translates to:
  /// **'Remove protection'**
  String get protectOff;

  /// No description provided for @protectOnTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect {name}?'**
  String protectOnTitle(String name);

  /// No description provided for @protectOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove protection of {name}?'**
  String protectOffTitle(String name);

  /// No description provided for @protectOnConsequence.
  ///
  /// In en, this message translates to:
  /// **'It cannot be deleted until the protection is removed.'**
  String get protectOnConsequence;

  /// No description provided for @protectOffConsequence.
  ///
  /// In en, this message translates to:
  /// **'It can be deleted again.'**
  String get protectOffConsequence;

  /// No description provided for @protected.
  ///
  /// In en, this message translates to:
  /// **'protected'**
  String get protected;

  /// No description provided for @publicIpv4.
  ///
  /// In en, this message translates to:
  /// **'Public IPv4'**
  String get publicIpv4;

  /// No description provided for @publicIpv6.
  ///
  /// In en, this message translates to:
  /// **'Public IPv6'**
  String get publicIpv6;

  /// No description provided for @rebuildPick.
  ///
  /// In en, this message translates to:
  /// **'Rebuild from image'**
  String get rebuildPick;

  /// No description provided for @rebuildTitle.
  ///
  /// In en, this message translates to:
  /// **'Rebuild {name}?'**
  String rebuildTitle(String name);

  /// No description provided for @rebuildConsequence.
  ///
  /// In en, this message translates to:
  /// **'All data on the disk is lost. The server starts fresh from {image}.'**
  String rebuildConsequence(String image);

  /// No description provided for @rescueActive.
  ///
  /// In en, this message translates to:
  /// **'rescue'**
  String get rescueActive;

  /// No description provided for @rescueOn.
  ///
  /// In en, this message translates to:
  /// **'Enable rescue'**
  String get rescueOn;

  /// No description provided for @rescueOff.
  ///
  /// In en, this message translates to:
  /// **'Disable rescue'**
  String get rescueOff;

  /// No description provided for @rescueOnTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable rescue for {name}?'**
  String rescueOnTitle(String name);

  /// No description provided for @rescueOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable rescue for {name}?'**
  String rescueOffTitle(String name);

  /// No description provided for @rescueOnConsequence.
  ///
  /// In en, this message translates to:
  /// **'The next restart boots the rescue system. Its root password is shown once.'**
  String get rescueOnConsequence;

  /// No description provided for @rescueOffConsequence.
  ///
  /// In en, this message translates to:
  /// **'The next restart boots from the disk again.'**
  String get rescueOffConsequence;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset root password'**
  String get resetPassword;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset the root password of {name}?'**
  String resetPasswordTitle(String name);

  /// No description provided for @resetPasswordConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server needs the qemu guest agent. The new password is shown once.'**
  String get resetPasswordConsequence;

  /// No description provided for @resourceFirewalls.
  ///
  /// In en, this message translates to:
  /// **'Firewalls'**
  String get resourceFirewalls;

  /// No description provided for @resourceImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get resourceImage;

  /// No description provided for @resourceImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get resourceImages;

  /// No description provided for @resourceLoadBalancer.
  ///
  /// In en, this message translates to:
  /// **'Load balancer'**
  String get resourceLoadBalancer;

  /// No description provided for @resourceNetworks.
  ///
  /// In en, this message translates to:
  /// **'Networks'**
  String get resourceNetworks;

  /// No description provided for @resourcePlacementGroup.
  ///
  /// In en, this message translates to:
  /// **'Placement group'**
  String get resourcePlacementGroup;

  /// No description provided for @resourcePlacementGroups.
  ///
  /// In en, this message translates to:
  /// **'Placement groups'**
  String get resourcePlacementGroups;

  /// No description provided for @resourceSshKey.
  ///
  /// In en, this message translates to:
  /// **'SSH key'**
  String get resourceSshKey;

  /// No description provided for @resourceSshKeys.
  ///
  /// In en, this message translates to:
  /// **'SSH keys'**
  String get resourceSshKeys;

  /// No description provided for @resourceVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get resourceVolume;

  /// No description provided for @resourceVolumes.
  ///
  /// In en, this message translates to:
  /// **'Volumes'**
  String get resourceVolumes;

  /// No description provided for @reverseDns.
  ///
  /// In en, this message translates to:
  /// **'Reverse DNS'**
  String get reverseDns;

  /// No description provided for @reverseDnsHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to reset to the Hetzner default.'**
  String get reverseDnsHint;

  /// No description provided for @reverseDnsValue.
  ///
  /// In en, this message translates to:
  /// **'Reverse DNS: {ptr}'**
  String reverseDnsValue(String ptr);

  /// No description provided for @rootPasswordAfter.
  ///
  /// In en, this message translates to:
  /// **'shown once after creating'**
  String get rootPasswordAfter;

  /// No description provided for @rootPasswordNote.
  ///
  /// In en, this message translates to:
  /// **'Copy it now. Falco does not store it and cannot show it again.'**
  String get rootPasswordNote;

  /// No description provided for @rootPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Root password'**
  String get rootPasswordTitle;

  /// No description provided for @sectionAttached.
  ///
  /// In en, this message translates to:
  /// **'Attached'**
  String get sectionAttached;

  /// No description provided for @sectionAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get sectionAttachment;

  /// No description provided for @sectionNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get sectionNetwork;

  /// No description provided for @serverCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 server} other{{count} servers}}'**
  String serverCount(int count);

  /// No description provided for @serverNoSshKeys.
  ///
  /// In en, this message translates to:
  /// **'No SSH keys in this project. You can skip this step; the root password is shown once after creating.'**
  String get serverNoSshKeys;

  /// No description provided for @serverNoVolumes.
  ///
  /// In en, this message translates to:
  /// **'No free volumes in {location}.'**
  String serverNoVolumes(String location);

  /// No description provided for @sortSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sortSize;

  /// No description provided for @sshKeyAdd.
  ///
  /// In en, this message translates to:
  /// **'Add SSH key'**
  String get sshKeyAdd;

  /// No description provided for @sshKeyDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The key is removed from the project. Servers that use it keep it.'**
  String get sshKeyDeleteConsequence;

  /// No description provided for @sshKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the public key, e.g. the content of id_ed25519.pub.'**
  String get sshKeyHint;

  /// No description provided for @sshKeyPrivate.
  ///
  /// In en, this message translates to:
  /// **'This is a private key. Never share it; paste the public key (.pub) instead.'**
  String get sshKeyPrivate;

  /// No description provided for @sshKeyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown key type. Use ssh-ed25519, ssh-rsa, ecdsa or a security key.'**
  String get sshKeyUnknown;

  /// No description provided for @startAfterCreate.
  ///
  /// In en, this message translates to:
  /// **'Start after create'**
  String get startAfterCreate;

  /// No description provided for @statusAvailable.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get statusAvailable;

  /// No description provided for @statusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get statusUnavailable;

  /// No description provided for @userDataHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Runs on the first boot, e.g. #cloud-config.'**
  String get userDataHint;

  /// No description provided for @vcpuCount.
  ///
  /// In en, this message translates to:
  /// **'{count} vCPU'**
  String vcpuCount(int count);

  /// No description provided for @volumeAttach.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get volumeAttach;

  /// No description provided for @volumeAutomount.
  ///
  /// In en, this message translates to:
  /// **'Mount automatically'**
  String get volumeAutomount;

  /// No description provided for @volumeCreate.
  ///
  /// In en, this message translates to:
  /// **'Create volume'**
  String get volumeCreate;

  /// No description provided for @volumeDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The volume and all its data are deleted. This cannot be undone.'**
  String get volumeDeleteConsequence;

  /// No description provided for @volumeDetach.
  ///
  /// In en, this message translates to:
  /// **'Detach'**
  String get volumeDetach;

  /// No description provided for @volumeDetachTitle.
  ///
  /// In en, this message translates to:
  /// **'Detach {name}?'**
  String volumeDetachTitle(String name);

  /// No description provided for @volumeDetachConsequence.
  ///
  /// In en, this message translates to:
  /// **'Unmount it on the server first, or running writes may be lost.'**
  String get volumeDetachConsequence;

  /// No description provided for @volumeNextTo.
  ///
  /// In en, this message translates to:
  /// **'Next to {server} ({location})'**
  String volumeNextTo(String server, String location);

  /// No description provided for @volumeNoServers.
  ///
  /// In en, this message translates to:
  /// **'No servers in {location} to attach to.'**
  String volumeNoServers(String location);

  /// No description provided for @volumeNotAttached.
  ///
  /// In en, this message translates to:
  /// **'Not attached to any server'**
  String get volumeNotAttached;

  /// No description provided for @volumeResize.
  ///
  /// In en, this message translates to:
  /// **'Resize'**
  String get volumeResize;

  /// No description provided for @volumeResizeHint.
  ///
  /// In en, this message translates to:
  /// **'Larger than {current} GB, at most {max} GB. Volumes cannot shrink.'**
  String volumeResizeHint(int current, int max);

  /// No description provided for @volumeTarget.
  ///
  /// In en, this message translates to:
  /// **'Location or server'**
  String get volumeTarget;

  /// No description provided for @wizardDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get wizardDetails;

  /// No description provided for @wizardExtras.
  ///
  /// In en, this message translates to:
  /// **'Volumes and placement'**
  String get wizardExtras;

  /// No description provided for @wizardNetworking.
  ///
  /// In en, this message translates to:
  /// **'Networking'**
  String get wizardNetworking;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @aliasIpsHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Further private IPs, separated by commas.'**
  String get aliasIpsHint;

  /// No description provided for @autoDeleteHint.
  ///
  /// In en, this message translates to:
  /// **'Deleted together with the server it is assigned to.'**
  String get autoDeleteHint;

  /// No description provided for @certificateCreate.
  ///
  /// In en, this message translates to:
  /// **'Add certificate'**
  String get certificateCreate;

  /// No description provided for @certificateDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The certificate is deleted. Load balancers using it lose it from their HTTPS services.'**
  String get certificateDeleteConsequence;

  /// No description provided for @certificateManaged.
  ///
  /// In en, this message translates to:
  /// **'Managed (Let\'s Encrypt)'**
  String get certificateManaged;

  /// No description provided for @certificateManagedHint.
  ///
  /// In en, this message translates to:
  /// **'Hetzner issues and renews it for your domains.'**
  String get certificateManagedHint;

  /// No description provided for @certificatePemHint.
  ///
  /// In en, this message translates to:
  /// **'PEM, starting with -----BEGIN CERTIFICATE-----, chain included.'**
  String get certificatePemHint;

  /// No description provided for @certificatePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get certificatePending;

  /// No description provided for @certificateRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get certificateRetry;

  /// No description provided for @certificateUnused.
  ///
  /// In en, this message translates to:
  /// **'Not used by any load balancer.'**
  String get certificateUnused;

  /// No description provided for @certificateUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get certificateUploaded;

  /// No description provided for @certificateUploadedHint.
  ///
  /// In en, this message translates to:
  /// **'Your own certificate and private key.'**
  String get certificateUploadedHint;

  /// No description provided for @certificateValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String certificateValidUntil(String date);

  /// No description provided for @domainsHint.
  ///
  /// In en, this message translates to:
  /// **'One or more domains, separated by commas, e.g. example.com, *.example.com.'**
  String get domainsHint;

  /// No description provided for @emptyCertificates.
  ///
  /// In en, this message translates to:
  /// **'No certificates in this project yet.'**
  String get emptyCertificates;

  /// No description provided for @emptyFirewalls.
  ///
  /// In en, this message translates to:
  /// **'No firewalls in this project yet.'**
  String get emptyFirewalls;

  /// No description provided for @emptyFloatingIps.
  ///
  /// In en, this message translates to:
  /// **'No Floating IPs in this project yet.'**
  String get emptyFloatingIps;

  /// No description provided for @emptyLoadBalancers.
  ///
  /// In en, this message translates to:
  /// **'No load balancers in this project yet.'**
  String get emptyLoadBalancers;

  /// No description provided for @emptyNetworks.
  ///
  /// In en, this message translates to:
  /// **'No networks in this project yet.'**
  String get emptyNetworks;

  /// No description provided for @emptyPrimaryIps.
  ///
  /// In en, this message translates to:
  /// **'No Primary IPs in this project yet.'**
  String get emptyPrimaryIps;

  /// No description provided for @emptyZones.
  ///
  /// In en, this message translates to:
  /// **'No DNS zones in this project yet.'**
  String get emptyZones;

  /// No description provided for @fieldAliasIps.
  ///
  /// In en, this message translates to:
  /// **'Alias IPs'**
  String get fieldAliasIps;

  /// No description provided for @fieldAutoDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete with server'**
  String get fieldAutoDelete;

  /// No description provided for @fieldCertificatePem.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get fieldCertificatePem;

  /// No description provided for @fieldChangeProtection.
  ///
  /// In en, this message translates to:
  /// **'Change protection'**
  String get fieldChangeProtection;

  /// No description provided for @fieldComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get fieldComment;

  /// No description provided for @fieldCookieLifetime.
  ///
  /// In en, this message translates to:
  /// **'Cookie lifetime (s)'**
  String get fieldCookieLifetime;

  /// No description provided for @fieldCookieName.
  ///
  /// In en, this message translates to:
  /// **'Cookie name'**
  String get fieldCookieName;

  /// No description provided for @fieldDefaultTtl.
  ///
  /// In en, this message translates to:
  /// **'Default TTL'**
  String get fieldDefaultTtl;

  /// No description provided for @fieldDestIps.
  ///
  /// In en, this message translates to:
  /// **'Destination IPs'**
  String get fieldDestIps;

  /// No description provided for @fieldDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get fieldDestination;

  /// No description provided for @fieldDestinationPort.
  ///
  /// In en, this message translates to:
  /// **'Destination port'**
  String get fieldDestinationPort;

  /// No description provided for @fieldDirection.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get fieldDirection;

  /// No description provided for @fieldDomains.
  ///
  /// In en, this message translates to:
  /// **'Domains'**
  String get fieldDomains;

  /// No description provided for @fieldGateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get fieldGateway;

  /// No description provided for @fieldHealthCheck.
  ///
  /// In en, this message translates to:
  /// **'Health check'**
  String get fieldHealthCheck;

  /// No description provided for @fieldHealthDomain.
  ///
  /// In en, this message translates to:
  /// **'Health check domain'**
  String get fieldHealthDomain;

  /// No description provided for @fieldHealthPath.
  ///
  /// In en, this message translates to:
  /// **'Health check path'**
  String get fieldHealthPath;

  /// No description provided for @fieldHealthPort.
  ///
  /// In en, this message translates to:
  /// **'Health check port'**
  String get fieldHealthPort;

  /// No description provided for @fieldHealthTls.
  ///
  /// In en, this message translates to:
  /// **'Health check over TLS'**
  String get fieldHealthTls;

  /// No description provided for @fieldInterval.
  ///
  /// In en, this message translates to:
  /// **'Interval (s)'**
  String get fieldInterval;

  /// No description provided for @fieldIpRange.
  ///
  /// In en, this message translates to:
  /// **'IP range'**
  String get fieldIpRange;

  /// No description provided for @fieldIps.
  ///
  /// In en, this message translates to:
  /// **'IPs'**
  String get fieldIps;

  /// No description provided for @fieldIssuance.
  ///
  /// In en, this message translates to:
  /// **'Issuance'**
  String get fieldIssuance;

  /// No description provided for @fieldListenPort.
  ///
  /// In en, this message translates to:
  /// **'Listen port'**
  String get fieldListenPort;

  /// No description provided for @fieldMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get fieldMode;

  /// No description provided for @fieldNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get fieldNameOptional;

  /// No description provided for @fieldNameservers.
  ///
  /// In en, this message translates to:
  /// **'Nameservers'**
  String get fieldNameservers;

  /// No description provided for @fieldNetworkZone.
  ///
  /// In en, this message translates to:
  /// **'Network zone'**
  String get fieldNetworkZone;

  /// No description provided for @fieldNewValue.
  ///
  /// In en, this message translates to:
  /// **'New value'**
  String get fieldNewValue;

  /// No description provided for @fieldPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get fieldPort;

  /// No description provided for @fieldPrivateIp.
  ///
  /// In en, this message translates to:
  /// **'Private IP'**
  String get fieldPrivateIp;

  /// No description provided for @fieldPrivateKeyPem.
  ///
  /// In en, this message translates to:
  /// **'Private key'**
  String get fieldPrivateKeyPem;

  /// No description provided for @fieldProtocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get fieldProtocol;

  /// No description provided for @fieldProxyProtocol.
  ///
  /// In en, this message translates to:
  /// **'PROXY protocol'**
  String get fieldProxyProtocol;

  /// No description provided for @fieldRecordName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldRecordName;

  /// No description provided for @fieldRedirectHttp.
  ///
  /// In en, this message translates to:
  /// **'Redirect HTTP to HTTPS'**
  String get fieldRedirectHttp;

  /// No description provided for @fieldRenewal.
  ///
  /// In en, this message translates to:
  /// **'Renewal'**
  String get fieldRenewal;

  /// No description provided for @fieldRetries.
  ///
  /// In en, this message translates to:
  /// **'Retries'**
  String get fieldRetries;

  /// No description provided for @fieldSourceIps.
  ///
  /// In en, this message translates to:
  /// **'Source IPs'**
  String get fieldSourceIps;

  /// No description provided for @fieldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get fieldStatus;

  /// No description provided for @fieldStatusCodes.
  ///
  /// In en, this message translates to:
  /// **'Status codes'**
  String get fieldStatusCodes;

  /// No description provided for @fieldStickySessions.
  ///
  /// In en, this message translates to:
  /// **'Sticky sessions'**
  String get fieldStickySessions;

  /// No description provided for @fieldTimeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout (s)'**
  String get fieldTimeout;

  /// No description provided for @fieldTtl.
  ///
  /// In en, this message translates to:
  /// **'TTL'**
  String get fieldTtl;

  /// No description provided for @fieldTsigAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'TSIG algorithm'**
  String get fieldTsigAlgorithm;

  /// No description provided for @fieldTsigKey.
  ///
  /// In en, this message translates to:
  /// **'TSIG key (base64)'**
  String get fieldTsigKey;

  /// No description provided for @fieldUsePrivateIp.
  ///
  /// In en, this message translates to:
  /// **'Route via private network'**
  String get fieldUsePrivateIp;

  /// No description provided for @fieldValidFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get fieldValidFrom;

  /// No description provided for @fieldValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get fieldValidUntil;

  /// No description provided for @fieldValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get fieldValue;

  /// No description provided for @fieldValues.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get fieldValues;

  /// No description provided for @fieldVswitch.
  ///
  /// In en, this message translates to:
  /// **'vSwitch'**
  String get fieldVswitch;

  /// No description provided for @fieldVswitchId.
  ///
  /// In en, this message translates to:
  /// **'vSwitch ID'**
  String get fieldVswitchId;

  /// No description provided for @fieldZoneName.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get fieldZoneName;

  /// No description provided for @filterAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get filterAssigned;

  /// No description provided for @filterUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get filterUnassigned;

  /// No description provided for @firewallActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get firewallActive;

  /// No description provided for @firewallApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get firewallApply;

  /// No description provided for @firewallCreate.
  ///
  /// In en, this message translates to:
  /// **'Create firewall'**
  String get firewallCreate;

  /// No description provided for @firewallDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The firewall is deleted; servers it protects are open to its traffic again.'**
  String get firewallDeleteConsequence;

  /// No description provided for @firewallNotApplied.
  ///
  /// In en, this message translates to:
  /// **'Not applied'**
  String get firewallNotApplied;

  /// No description provided for @firewallNotAppliedHint.
  ///
  /// In en, this message translates to:
  /// **'Not applied to any server or label selector.'**
  String get firewallNotAppliedHint;

  /// No description provided for @firewallRemoveConsequence.
  ///
  /// In en, this message translates to:
  /// **'Its rules no longer protect this target.'**
  String get firewallRemoveConsequence;

  /// No description provided for @firewallRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {firewall} from {target}?'**
  String firewallRemoveTitle(String firewall, String target);

  /// No description provided for @floatingIpCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Floating IP'**
  String get floatingIpCreate;

  /// No description provided for @floatingIpUnassignConsequence.
  ///
  /// In en, this message translates to:
  /// **'Traffic to this IP no longer reaches the server.'**
  String get floatingIpUnassignConsequence;

  /// No description provided for @gatewayHint.
  ///
  /// In en, this message translates to:
  /// **'An IP inside {range}.'**
  String gatewayHint(String range);

  /// No description provided for @gatewayValue.
  ///
  /// In en, this message translates to:
  /// **'via {gateway}'**
  String gatewayValue(String gateway);

  /// No description provided for @healthCheckValue.
  ///
  /// In en, this message translates to:
  /// **'{protocol} check on {port} every {interval} s'**
  String healthCheckValue(String protocol, String port, String interval);

  /// No description provided for @healthPortHint.
  ///
  /// In en, this message translates to:
  /// **'Empty uses the destination port.'**
  String get healthPortHint;

  /// No description provided for @ipAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get ipAssign;

  /// No description provided for @ipAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get ipAssigned;

  /// No description provided for @ipAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'assigned to {server}'**
  String ipAssignedTo(String server);

  /// No description provided for @ipBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get ipBlocked;

  /// No description provided for @ipDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The address {ip} is released and may go to someone else. This cannot be undone.'**
  String ipDeleteConsequence(String ip);

  /// No description provided for @ipNoServers.
  ///
  /// In en, this message translates to:
  /// **'No servers in this project to assign to.'**
  String get ipNoServers;

  /// No description provided for @ipNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get ipNotAssigned;

  /// No description provided for @ipOnServer.
  ///
  /// In en, this message translates to:
  /// **'Assign to {server} ({location})'**
  String ipOnServer(String server, String location);

  /// No description provided for @ipTarget.
  ///
  /// In en, this message translates to:
  /// **'Location or server'**
  String get ipTarget;

  /// No description provided for @ipUnassign.
  ///
  /// In en, this message translates to:
  /// **'Unassign'**
  String get ipUnassign;

  /// No description provided for @ipUnassignTitle.
  ///
  /// In en, this message translates to:
  /// **'Unassign {ip} from {server}?'**
  String ipUnassignTitle(String ip, String server);

  /// No description provided for @ipsAny.
  ///
  /// In en, this message translates to:
  /// **'Any IPv4 and IPv6'**
  String get ipsAny;

  /// No description provided for @ipsAnyV4.
  ///
  /// In en, this message translates to:
  /// **'Any IPv4'**
  String get ipsAnyV4;

  /// No description provided for @ipsAnyV6.
  ///
  /// In en, this message translates to:
  /// **'Any IPv6'**
  String get ipsAnyV6;

  /// No description provided for @ipsCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get ipsCustom;

  /// No description provided for @ipsHint.
  ///
  /// In en, this message translates to:
  /// **'CIDR blocks, one per line or separated by commas, e.g. 203.0.113.0/24.'**
  String get ipsHint;

  /// No description provided for @keepIfEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty keeps the current one.'**
  String get keepIfEmpty;

  /// No description provided for @labelSelector.
  ///
  /// In en, this message translates to:
  /// **'Label selector'**
  String get labelSelector;

  /// No description provided for @lbAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'Algorithm'**
  String get lbAlgorithm;

  /// No description provided for @lbChangeType.
  ///
  /// In en, this message translates to:
  /// **'Change type'**
  String get lbChangeType;

  /// No description provided for @lbDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The load balancer and its public IPs are deleted. Targets are kept. This cannot be undone.'**
  String get lbDeleteConsequence;

  /// No description provided for @lbLeastConnections.
  ///
  /// In en, this message translates to:
  /// **'Least connections'**
  String get lbLeastConnections;

  /// No description provided for @lbLimits.
  ///
  /// In en, this message translates to:
  /// **'{connections} connections, {services} services, {targets} targets'**
  String lbLimits(int connections, int services, int targets);

  /// No description provided for @lbNoCertificates.
  ///
  /// In en, this message translates to:
  /// **'No certificates yet. Add one in Certificates.'**
  String get lbNoCertificates;

  /// No description provided for @lbPublicDisabled.
  ///
  /// In en, this message translates to:
  /// **'Public interface disabled'**
  String get lbPublicDisabled;

  /// No description provided for @lbPublicOff.
  ///
  /// In en, this message translates to:
  /// **'Disable public interface'**
  String get lbPublicOff;

  /// No description provided for @lbPublicOffConsequence.
  ///
  /// In en, this message translates to:
  /// **'The load balancer is then reachable from private networks only.'**
  String get lbPublicOffConsequence;

  /// No description provided for @lbPublicOn.
  ///
  /// In en, this message translates to:
  /// **'Enable public interface'**
  String get lbPublicOn;

  /// No description provided for @lbRoundRobin.
  ///
  /// In en, this message translates to:
  /// **'Round robin'**
  String get lbRoundRobin;

  /// No description provided for @loadBalancerCreate.
  ///
  /// In en, this message translates to:
  /// **'Create load balancer'**
  String get loadBalancerCreate;

  /// No description provided for @membersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No servers or load balancers in this network.'**
  String get membersEmpty;

  /// No description provided for @metricConnectionsPerSecond.
  ///
  /// In en, this message translates to:
  /// **'Connections per second'**
  String get metricConnectionsPerSecond;

  /// No description provided for @metricOpenConnections.
  ///
  /// In en, this message translates to:
  /// **'Open connections'**
  String get metricOpenConnections;

  /// No description provided for @metricRequestsPerSecond.
  ///
  /// In en, this message translates to:
  /// **'Requests per second'**
  String get metricRequestsPerSecond;

  /// No description provided for @networkAttach.
  ///
  /// In en, this message translates to:
  /// **'Attach to network'**
  String get networkAttach;

  /// No description provided for @networkChangeRange.
  ///
  /// In en, this message translates to:
  /// **'Change IP range'**
  String get networkChangeRange;

  /// No description provided for @networkCreate.
  ///
  /// In en, this message translates to:
  /// **'Create network'**
  String get networkCreate;

  /// No description provided for @networkDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The network and all its subnets and routes are deleted. This cannot be undone.'**
  String get networkDeleteConsequence;

  /// No description provided for @networkDetachConsequence.
  ///
  /// In en, this message translates to:
  /// **'Its private IP in this network is released.'**
  String get networkDetachConsequence;

  /// No description provided for @networkDetachTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from {network}?'**
  String networkDetachTitle(String name, String network);

  /// No description provided for @networkExpose.
  ///
  /// In en, this message translates to:
  /// **'Routes to vSwitch'**
  String get networkExpose;

  /// No description provided for @networkExposeConsequence.
  ///
  /// In en, this message translates to:
  /// **'Decides whether the routes of this network are announced to the coupled vSwitch.'**
  String get networkExposeConsequence;

  /// No description provided for @networkExposeOff.
  ///
  /// In en, this message translates to:
  /// **'Stop exposing routes to vSwitch'**
  String get networkExposeOff;

  /// No description provided for @networkExposeOn.
  ///
  /// In en, this message translates to:
  /// **'Expose routes to vSwitch'**
  String get networkExposeOn;

  /// No description provided for @networkRangeCreateHint.
  ///
  /// In en, this message translates to:
  /// **'A private range, e.g. 10.0.0.0/16.'**
  String get networkRangeCreateHint;

  /// No description provided for @networkRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Only larger, containing the current range. This cannot be undone.'**
  String get networkRangeHint;

  /// No description provided for @portHint.
  ///
  /// In en, this message translates to:
  /// **'One port, a range or any, e.g. 22, 8000-9000 or any.'**
  String get portHint;

  /// No description provided for @primariesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No primary nameservers yet.'**
  String get primariesEmpty;

  /// No description provided for @primariesHint.
  ///
  /// In en, this message translates to:
  /// **'One per line: address or address:port, port 53 by default.'**
  String get primariesHint;

  /// No description provided for @primaryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add primary nameserver'**
  String get primaryAdd;

  /// No description provided for @primaryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit primary nameserver'**
  String get primaryEdit;

  /// No description provided for @tsigNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get tsigNone;

  /// No description provided for @primaryIpCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Primary IP'**
  String get primaryIpCreate;

  /// No description provided for @primaryIpNew.
  ///
  /// In en, this message translates to:
  /// **'New Primary IP'**
  String get primaryIpNew;

  /// No description provided for @primaryIpNoServers.
  ///
  /// In en, this message translates to:
  /// **'No servers in {location} that are off and have no Primary IP of this type. A Primary IP moves only to such a server.'**
  String primaryIpNoServers(String location);

  /// No description provided for @primaryIpUnassignConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server loses this public address. It must be off.'**
  String get primaryIpUnassignConsequence;

  /// No description provided for @primaryRemoveConsequence.
  ///
  /// In en, this message translates to:
  /// **'The zone is no longer transferred from this nameserver.'**
  String get primaryRemoveConsequence;

  /// No description provided for @primaryRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {address}?'**
  String primaryRemoveTitle(String address);

  /// No description provided for @privateIpHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Empty picks the next free one.'**
  String get privateIpHint;

  /// No description provided for @privateKeyPemHint.
  ///
  /// In en, this message translates to:
  /// **'PEM, starting with -----BEGIN PRIVATE KEY-----. Sent once to Hetzner, never stored in Falco.'**
  String get privateKeyPemHint;

  /// No description provided for @recordAdd.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get recordAdd;

  /// No description provided for @recordCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record} other{{count} records}}'**
  String recordCount(int count);

  /// No description provided for @recordEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit value'**
  String get recordEdit;

  /// No description provided for @recordNameHint.
  ///
  /// In en, this message translates to:
  /// **'@ for the zone itself, e.g. www or mail.'**
  String get recordNameHint;

  /// No description provided for @recordsBulkEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit {count, plural, =1{1 record set} other{{count} record sets}}'**
  String recordsBulkEdit(int count);

  /// No description provided for @recordsEditSelected.
  ///
  /// In en, this message translates to:
  /// **'Edit selected'**
  String get recordsEditSelected;

  /// No description provided for @recordsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No records yet.'**
  String get recordsEmpty;

  /// No description provided for @recordsFailed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record set failed} other{{count} record sets failed}}'**
  String recordsFailed(int count);

  /// No description provided for @recordsFromPrimaries.
  ///
  /// In en, this message translates to:
  /// **'The records of a secondary zone come from its primary nameservers.'**
  String get recordsFromPrimaries;

  /// No description provided for @recordsBulkTtlOnly.
  ///
  /// In en, this message translates to:
  /// **'Different types: only the TTL can change.'**
  String get recordsBulkTtlOnly;

  /// No description provided for @recordsBulkValueConsequence.
  ///
  /// In en, this message translates to:
  /// **'Every value of these record sets is replaced by the new value.'**
  String get recordsBulkValueConsequence;

  /// No description provided for @recordsBulkTtlConsequence.
  ///
  /// In en, this message translates to:
  /// **'These record sets get the new TTL.'**
  String get recordsBulkTtlConsequence;

  /// No description provided for @recordsSelect.
  ///
  /// In en, this message translates to:
  /// **'Select records'**
  String get recordsSelect;

  /// No description provided for @recordsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Records updated'**
  String get recordsUpdated;

  /// No description provided for @resourceCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get resourceCertificate;

  /// No description provided for @resourceCertificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get resourceCertificates;

  /// No description provided for @resourceFirewall.
  ///
  /// In en, this message translates to:
  /// **'Firewall'**
  String get resourceFirewall;

  /// No description provided for @resourceFloatingIp.
  ///
  /// In en, this message translates to:
  /// **'Floating IP'**
  String get resourceFloatingIp;

  /// No description provided for @resourceFloatingIps.
  ///
  /// In en, this message translates to:
  /// **'Floating IPs'**
  String get resourceFloatingIps;

  /// No description provided for @resourceLoadBalancers.
  ///
  /// In en, this message translates to:
  /// **'Load balancers'**
  String get resourceLoadBalancers;

  /// No description provided for @resourceNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get resourceNetwork;

  /// No description provided for @resourcePrimaryIp.
  ///
  /// In en, this message translates to:
  /// **'Primary IP'**
  String get resourcePrimaryIp;

  /// No description provided for @resourcePrimaryIps.
  ///
  /// In en, this message translates to:
  /// **'Primary IPs'**
  String get resourcePrimaryIps;

  /// No description provided for @resourceRecord.
  ///
  /// In en, this message translates to:
  /// **'Record set'**
  String get resourceRecord;

  /// No description provided for @resourceZone.
  ///
  /// In en, this message translates to:
  /// **'DNS zone'**
  String get resourceZone;

  /// No description provided for @resourceZones.
  ///
  /// In en, this message translates to:
  /// **'DNS'**
  String get resourceZones;

  /// No description provided for @routeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add route'**
  String get routeAdd;

  /// No description provided for @routeDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'Traffic via {gateway} for this destination stops.'**
  String routeDeleteConsequence(String gateway);

  /// No description provided for @routeDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete route to {destination}?'**
  String routeDeleteTitle(String destination);

  /// No description provided for @routesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No routes.'**
  String get routesEmpty;

  /// No description provided for @rrsetDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'All values of this record set are deleted.'**
  String get rrsetDeleteConsequence;

  /// No description provided for @rrsetProtectOffConsequence.
  ///
  /// In en, this message translates to:
  /// **'Its values can be changed and deleted again.'**
  String get rrsetProtectOffConsequence;

  /// No description provided for @rrsetProtectOnConsequence.
  ///
  /// In en, this message translates to:
  /// **'Its values cannot be changed or deleted until the protection is removed.'**
  String get rrsetProtectOnConsequence;

  /// No description provided for @ruleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get ruleAdd;

  /// No description provided for @ruleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 rule} other{{count} rules}}'**
  String ruleCount(int count);

  /// No description provided for @ruleDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'Traffic this rule allowed is blocked on every server of the firewall.'**
  String get ruleDeleteConsequence;

  /// No description provided for @ruleDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete rule {rule}?'**
  String ruleDeleteTitle(String rule);

  /// No description provided for @ruleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit rule'**
  String get ruleEdit;

  /// No description provided for @ruleInbound.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get ruleInbound;

  /// No description provided for @ruleOutbound.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get ruleOutbound;

  /// No description provided for @rulesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rules.'**
  String get rulesEmpty;

  /// No description provided for @secondsHint.
  ///
  /// In en, this message translates to:
  /// **'{min} to {max} seconds'**
  String secondsHint(int min, int max);

  /// No description provided for @sectionAppliedTo.
  ///
  /// In en, this message translates to:
  /// **'Applied to'**
  String get sectionAppliedTo;

  /// No description provided for @sectionMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get sectionMembers;

  /// No description provided for @sectionPrimaries.
  ///
  /// In en, this message translates to:
  /// **'Primary nameservers'**
  String get sectionPrimaries;

  /// No description provided for @sectionRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get sectionRecords;

  /// No description provided for @sectionRoutes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get sectionRoutes;

  /// No description provided for @sectionRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get sectionRules;

  /// No description provided for @sectionServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get sectionServices;

  /// No description provided for @sectionSubnets.
  ///
  /// In en, this message translates to:
  /// **'Subnets'**
  String get sectionSubnets;

  /// No description provided for @sectionTargets.
  ///
  /// In en, this message translates to:
  /// **'Targets'**
  String get sectionTargets;

  /// No description provided for @sectionUsedBy.
  ///
  /// In en, this message translates to:
  /// **'Used by'**
  String get sectionUsedBy;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @selectClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get selectClear;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @selectorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. role=web,env=prod'**
  String get selectorHint;

  /// No description provided for @serverNoNetworks.
  ///
  /// In en, this message translates to:
  /// **'No networks left to attach to. Create one under Network.'**
  String get serverNoNetworks;

  /// No description provided for @serviceAdd.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get serviceAdd;

  /// No description provided for @serviceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 service} other{{count} services}}'**
  String serviceCount(int count);

  /// No description provided for @serviceDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The load balancer stops listening on this port.'**
  String get serviceDeleteConsequence;

  /// No description provided for @serviceDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete service {service}?'**
  String serviceDeleteTitle(String service);

  /// No description provided for @serviceEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get serviceEdit;

  /// No description provided for @servicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No services.'**
  String get servicesEmpty;

  /// No description provided for @sortExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get sortExpiry;

  /// No description provided for @subnetAdd.
  ///
  /// In en, this message translates to:
  /// **'Add subnet'**
  String get subnetAdd;

  /// No description provided for @subnetCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 subnet} other{{count} subnets}}'**
  String subnetCount(int count);

  /// No description provided for @subnetDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'Servers in this subnet lose their private IPs in it.'**
  String get subnetDeleteConsequence;

  /// No description provided for @subnetDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete subnet {range}?'**
  String subnetDeleteTitle(String range);

  /// No description provided for @subnetRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, inside {range}. Empty picks the next free range.'**
  String subnetRangeHint(String range);

  /// No description provided for @subnetsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subnets.'**
  String get subnetsEmpty;

  /// No description provided for @targetAdd.
  ///
  /// In en, this message translates to:
  /// **'Add target'**
  String get targetAdd;

  /// No description provided for @targetCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 target} other{{count} targets}}'**
  String targetCount(int count);

  /// No description provided for @targetIpHint.
  ///
  /// In en, this message translates to:
  /// **'A public IP of a dedicated server, e.g. 203.0.113.7.'**
  String get targetIpHint;

  /// No description provided for @targetRemoveConsequence.
  ///
  /// In en, this message translates to:
  /// **'The load balancer no longer sends traffic to it.'**
  String get targetRemoveConsequence;

  /// No description provided for @targetRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove target {target}?'**
  String targetRemoveTitle(String target);

  /// No description provided for @targetsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No targets.'**
  String get targetsEmpty;

  /// No description provided for @ttlCreateHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, 60 seconds or more. Empty uses 3600.'**
  String get ttlCreateHint;

  /// No description provided for @ttlDefault.
  ///
  /// In en, this message translates to:
  /// **'Zone default ({ttl} s)'**
  String ttlDefault(int ttl);

  /// No description provided for @ttlHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, 60 seconds or more. Empty uses the zone default of {ttl} s.'**
  String ttlHint(int ttl);

  /// No description provided for @ttlLimits.
  ///
  /// In en, this message translates to:
  /// **'60 seconds or more.'**
  String get ttlLimits;

  /// No description provided for @ttlValue.
  ///
  /// In en, this message translates to:
  /// **'TTL {ttl} s'**
  String ttlValue(int ttl);

  /// No description provided for @valueAdd.
  ///
  /// In en, this message translates to:
  /// **'Add value'**
  String get valueAdd;

  /// No description provided for @valueRemoveConsequence.
  ///
  /// In en, this message translates to:
  /// **'This value is removed from the record set.'**
  String get valueRemoveConsequence;

  /// No description provided for @valueRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {value}?'**
  String valueRemoveTitle(String value);

  /// No description provided for @valuesHint.
  ///
  /// In en, this message translates to:
  /// **'One value per line. TXT gets quotes, host names a trailing dot.'**
  String get valuesHint;

  /// No description provided for @zoneCreate.
  ///
  /// In en, this message translates to:
  /// **'Create zone'**
  String get zoneCreate;

  /// No description provided for @zoneDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The zone and all its records are deleted. This cannot be undone.'**
  String get zoneDeleteConsequence;

  /// No description provided for @zoneExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get zoneExport;

  /// No description provided for @zoneExported.
  ///
  /// In en, this message translates to:
  /// **'Zone file saved'**
  String get zoneExported;

  /// No description provided for @zoneImport.
  ///
  /// In en, this message translates to:
  /// **'Import zone file'**
  String get zoneImport;

  /// No description provided for @zoneImportConsequence.
  ///
  /// In en, this message translates to:
  /// **'Every record of the zone is replaced by those of the file.'**
  String get zoneImportConsequence;

  /// No description provided for @zoneImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all records of {name}?'**
  String zoneImportTitle(String name);

  /// No description provided for @zonePrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get zonePrimary;

  /// No description provided for @zonePrimaryHint.
  ///
  /// In en, this message translates to:
  /// **'Hetzner holds the records; you edit them here.'**
  String get zonePrimaryHint;

  /// No description provided for @zoneSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get zoneSecondary;

  /// No description provided for @zoneSecondaryHint.
  ///
  /// In en, this message translates to:
  /// **'Hetzner copies the zone from your primary nameservers.'**
  String get zoneSecondaryHint;

  /// No description provided for @zonefileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The file is larger than 1 MiB.'**
  String get zonefileTooLarge;

  /// No description provided for @accessExternal.
  ///
  /// In en, this message translates to:
  /// **'Reachable externally'**
  String get accessExternal;

  /// No description provided for @accessReadonly.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get accessReadonly;

  /// No description provided for @accessSamba.
  ///
  /// In en, this message translates to:
  /// **'Samba (SMB)'**
  String get accessSamba;

  /// No description provided for @accessSsh.
  ///
  /// In en, this message translates to:
  /// **'SSH and SFTP'**
  String get accessSsh;

  /// No description provided for @accessWebdav.
  ///
  /// In en, this message translates to:
  /// **'WebDAV'**
  String get accessWebdav;

  /// No description provided for @accessZfs.
  ///
  /// In en, this message translates to:
  /// **'ZFS snapshot folder'**
  String get accessZfs;

  /// No description provided for @boxAccessSettings.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get boxAccessSettings;

  /// No description provided for @boxAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get boxAutomatic;

  /// No description provided for @boxAutomaticSnapshots.
  ///
  /// In en, this message translates to:
  /// **'Automatic snapshots'**
  String get boxAutomaticSnapshots;

  /// No description provided for @boxChangeType.
  ///
  /// In en, this message translates to:
  /// **'Change type'**
  String get boxChangeType;

  /// No description provided for @boxDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The Storage Box, its snapshots and subaccounts are deleted with all data. This cannot be undone.'**
  String get boxDeleteConsequence;

  /// No description provided for @boxEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get boxEveryDay;

  /// No description provided for @boxMaxSnapshots.
  ///
  /// In en, this message translates to:
  /// **'Snapshots to keep'**
  String get boxMaxSnapshots;

  /// No description provided for @boxNewFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get boxNewFolder;

  /// No description provided for @boxPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'12 to 128 characters with upper and lower case, a digit and a special character.'**
  String get boxPasswordHint;

  /// No description provided for @boxPlanDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily at {time}'**
  String boxPlanDaily(String time);

  /// No description provided for @boxPlanHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get boxPlanHour;

  /// No description provided for @boxPlanKeeps.
  ///
  /// In en, this message translates to:
  /// **'{when}, keeps {count}'**
  String boxPlanKeeps(String when, int count);

  /// No description provided for @boxPlanMinute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get boxPlanMinute;

  /// No description provided for @boxPlanMonthday.
  ///
  /// In en, this message translates to:
  /// **'Day of the month'**
  String get boxPlanMonthday;

  /// No description provided for @boxPlanMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly on day {day} at {time}'**
  String boxPlanMonthly(int day, String time);

  /// No description provided for @boxPlanUtc.
  ///
  /// In en, this message translates to:
  /// **'Times are UTC.'**
  String get boxPlanUtc;

  /// No description provided for @boxPlanWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get boxPlanWeekday;

  /// No description provided for @boxPlanWeekly.
  ///
  /// In en, this message translates to:
  /// **'{day}s at {time}'**
  String boxPlanWeekly(String day, String time);

  /// No description provided for @boxResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get boxResetPassword;

  /// No description provided for @boxRollback.
  ///
  /// In en, this message translates to:
  /// **'Roll back'**
  String get boxRollback;

  /// No description provided for @boxRollbackConsequence.
  ///
  /// In en, this message translates to:
  /// **'All data of the Storage Box is replaced with the state of this snapshot. Newer data is lost.'**
  String get boxRollbackConsequence;

  /// No description provided for @boxRollbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Roll back to {name}?'**
  String boxRollbackTitle(String name);

  /// No description provided for @boxSnapshotCreate.
  ///
  /// In en, this message translates to:
  /// **'Create snapshot'**
  String get boxSnapshotCreate;

  /// No description provided for @boxSnapshotDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The snapshot is deleted. This cannot be undone.'**
  String get boxSnapshotDeleteConsequence;

  /// No description provided for @boxSnapshotPlan.
  ///
  /// In en, this message translates to:
  /// **'Snapshot plan'**
  String get boxSnapshotPlan;

  /// No description provided for @boxUsage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get boxUsage;

  /// No description provided for @boxUsedData.
  ///
  /// In en, this message translates to:
  /// **'Used by data'**
  String get boxUsedData;

  /// No description provided for @boxUsedOf.
  ///
  /// In en, this message translates to:
  /// **'{used} of {size} used'**
  String boxUsedOf(String used, String size);

  /// No description provided for @boxUsedSnapshots.
  ///
  /// In en, this message translates to:
  /// **'Used by snapshots'**
  String get boxUsedSnapshots;

  /// No description provided for @bucketCreate.
  ///
  /// In en, this message translates to:
  /// **'Create bucket'**
  String get bucketCreate;

  /// No description provided for @bucketDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete bucket'**
  String get bucketDelete;

  /// No description provided for @bucketDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The bucket is deleted. It must be empty.'**
  String get bucketDeleteConsequence;

  /// No description provided for @bucketNameHint.
  ///
  /// In en, this message translates to:
  /// **'3 to 63 lower case letters, digits, dots and hyphens.'**
  String get bucketNameHint;

  /// No description provided for @bucketNotEmpty.
  ///
  /// In en, this message translates to:
  /// **'The bucket is not empty. Delete its objects first.'**
  String get bucketNotEmpty;

  /// No description provided for @bucketPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get bucketPrivate;

  /// No description provided for @bucketPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get bucketPublic;

  /// No description provided for @bucketPublicHint.
  ///
  /// In en, this message translates to:
  /// **'Public: everyone can read the objects without a link.'**
  String get bucketPublicHint;

  /// No description provided for @bucketSettings.
  ///
  /// In en, this message translates to:
  /// **'Bucket settings'**
  String get bucketSettings;

  /// No description provided for @bucketVersioning.
  ///
  /// In en, this message translates to:
  /// **'Versioning'**
  String get bucketVersioning;

  /// No description provided for @bucketVersioningHint.
  ///
  /// In en, this message translates to:
  /// **'Enabled keeps every version of an object. Suspended keeps existing versions but adds no new ones; versioning cannot be turned off again.'**
  String get bucketVersioningHint;

  /// No description provided for @bucketVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get bucketVisibility;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String days(int count);

  /// No description provided for @downloadSaved.
  ///
  /// In en, this message translates to:
  /// **'Download saved: {name}'**
  String downloadSaved(String name);

  /// No description provided for @downloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Downloading {name} in the background'**
  String downloadStarted(String name);

  /// No description provided for @emptyBoxSnapshots.
  ///
  /// In en, this message translates to:
  /// **'No snapshots yet.'**
  String get emptyBoxSnapshots;

  /// No description provided for @emptyBuckets.
  ///
  /// In en, this message translates to:
  /// **'No buckets in this project yet.'**
  String get emptyBuckets;

  /// No description provided for @emptyObjects.
  ///
  /// In en, this message translates to:
  /// **'This folder is empty.'**
  String get emptyObjects;

  /// No description provided for @emptyStorageBoxes.
  ///
  /// In en, this message translates to:
  /// **'No Storage Boxes in this project yet.'**
  String get emptyStorageBoxes;

  /// No description provided for @emptySubaccounts.
  ///
  /// In en, this message translates to:
  /// **'No subaccounts yet.'**
  String get emptySubaccounts;

  /// No description provided for @fieldContentType.
  ///
  /// In en, this message translates to:
  /// **'Content type'**
  String get fieldContentType;

  /// No description provided for @fieldEtag.
  ///
  /// In en, this message translates to:
  /// **'ETag'**
  String get fieldEtag;

  /// No description provided for @fieldFolderName.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get fieldFolderName;

  /// No description provided for @fieldHomeDirectory.
  ///
  /// In en, this message translates to:
  /// **'Home directory'**
  String get fieldHomeDirectory;

  /// No description provided for @fieldKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get fieldKey;

  /// No description provided for @fieldModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get fieldModified;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldPasswordRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get fieldPasswordRepeat;

  /// No description provided for @fieldServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get fieldServer;

  /// No description provided for @fieldUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get fieldUsername;

  /// No description provided for @folderCreate.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get folderCreate;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String hours(int count);

  /// No description provided for @objectCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get objectCopy;

  /// No description provided for @objectDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The objects are deleted. With versioning, older versions stay.'**
  String get objectDeleteConsequence;

  /// No description provided for @objectDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get objectDownload;

  /// No description provided for @objectInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get objectInfo;

  /// No description provided for @objectKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'This file cannot be stored under that name.'**
  String get objectKeyInvalid;

  /// No description provided for @objectKeyDotSegment.
  ///
  /// In en, this message translates to:
  /// **'Falco cannot open this object: its key contains \".\" or \"..\" as a folder name, which every link resolves to another key.'**
  String get objectKeyDotSegment;

  /// No description provided for @objectMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get objectMove;

  /// No description provided for @objectUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get objectUpload;

  /// No description provided for @objectVersions.
  ///
  /// In en, this message translates to:
  /// **'Versions'**
  String get objectVersions;

  /// No description provided for @objectsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 object?} other{Delete {count} objects?}}'**
  String objectsDeleteTitle(int count);

  /// No description provided for @objectsDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 object deleted} other{{count} objects deleted}}'**
  String objectsDeleted(int count);

  /// No description provided for @objectsDeletedPartly.
  ///
  /// In en, this message translates to:
  /// **'{deleted} deleted, {failed} failed and stay selected'**
  String objectsDeletedPartly(int deleted, int failed);

  /// No description provided for @resourceBoxSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Snapshot'**
  String get resourceBoxSnapshot;

  /// No description provided for @resourceBucket.
  ///
  /// In en, this message translates to:
  /// **'Bucket'**
  String get resourceBucket;

  /// No description provided for @resourceBuckets.
  ///
  /// In en, this message translates to:
  /// **'Buckets'**
  String get resourceBuckets;

  /// No description provided for @resourceObjectStorage.
  ///
  /// In en, this message translates to:
  /// **'Object Storage'**
  String get resourceObjectStorage;

  /// No description provided for @resourceStorageBox.
  ///
  /// In en, this message translates to:
  /// **'Storage Box'**
  String get resourceStorageBox;

  /// No description provided for @resourceStorageBoxes.
  ///
  /// In en, this message translates to:
  /// **'Storage Boxes'**
  String get resourceStorageBoxes;

  /// No description provided for @resourceSubaccount.
  ///
  /// In en, this message translates to:
  /// **'Subaccount'**
  String get resourceSubaccount;

  /// No description provided for @s3NoKeysHint.
  ///
  /// In en, this message translates to:
  /// **'This project has no S3 keys. Add them to the project to use Object Storage.'**
  String get s3NoKeysHint;

  /// No description provided for @sectionSnapshots.
  ///
  /// In en, this message translates to:
  /// **'Snapshots'**
  String get sectionSnapshots;

  /// No description provided for @sectionSubaccounts.
  ///
  /// In en, this message translates to:
  /// **'Subaccounts'**
  String get sectionSubaccounts;

  /// No description provided for @selectionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get selectionClear;

  /// No description provided for @shareExpiry.
  ///
  /// In en, this message translates to:
  /// **'Valid for'**
  String get shareExpiry;

  /// No description provided for @shareLink.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get shareLink;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get statusActive;

  /// No description provided for @statusLocked.
  ///
  /// In en, this message translates to:
  /// **'locked'**
  String get statusLocked;

  /// No description provided for @storageBoxCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Storage Box'**
  String get storageBoxCreate;

  /// No description provided for @subaccountCreate.
  ///
  /// In en, this message translates to:
  /// **'Add subaccount'**
  String get subaccountCreate;

  /// No description provided for @subaccountDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The subaccount can no longer log in. Its files stay in the Storage Box.'**
  String get subaccountDeleteConsequence;

  /// No description provided for @transferDone.
  ///
  /// In en, this message translates to:
  /// **'Transfer finished'**
  String get transferDone;

  /// No description provided for @transferFailed.
  ///
  /// In en, this message translates to:
  /// **'Transfer failed'**
  String get transferFailed;

  /// No description provided for @transferFailedNamed.
  ///
  /// In en, this message translates to:
  /// **'Transfer of {name} failed'**
  String transferFailedNamed(String name);

  /// No description provided for @transferRunning.
  ///
  /// In en, this message translates to:
  /// **'Transferring'**
  String get transferRunning;

  /// No description provided for @uploadDone.
  ///
  /// In en, this message translates to:
  /// **'Uploaded: {name}'**
  String uploadDone(String name);

  /// No description provided for @uploadLink.
  ///
  /// In en, this message translates to:
  /// **'Upload link'**
  String get uploadLink;

  /// No description provided for @uploadStarted.
  ///
  /// In en, this message translates to:
  /// **'Uploading {name} in the background'**
  String uploadStarted(String name);

  /// No description provided for @versionDeleteMarker.
  ///
  /// In en, this message translates to:
  /// **'deleted'**
  String get versionDeleteMarker;

  /// No description provided for @versionLatest.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get versionLatest;

  /// No description provided for @versionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get versionRestore;

  /// No description provided for @versionRestoreConsequence.
  ///
  /// In en, this message translates to:
  /// **'This version becomes the current object again; the current one stays as an older version.'**
  String get versionRestoreConsequence;

  /// No description provided for @versionRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this version of {name}?'**
  String versionRestoreTitle(String name);

  /// No description provided for @versioningEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get versioningEnabled;

  /// No description provided for @versioningNever.
  ///
  /// In en, this message translates to:
  /// **'Never enabled'**
  String get versioningNever;

  /// No description provided for @versioningSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get versioningSuspended;

  /// No description provided for @versionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No versions.'**
  String get versionsEmpty;

  /// No description provided for @addressCancelConsequence.
  ///
  /// In en, this message translates to:
  /// **'The address is cancelled at the chosen date and then no longer routed to the server.'**
  String get addressCancelConsequence;

  /// No description provided for @bootActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get bootActivate;

  /// No description provided for @bootActivated.
  ///
  /// In en, this message translates to:
  /// **'Active at the next reset'**
  String get bootActivated;

  /// No description provided for @bootDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get bootDeactivate;

  /// No description provided for @bootDist.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get bootDist;

  /// No description provided for @bootKeysHint.
  ///
  /// In en, this message translates to:
  /// **'Robot keys for the root login; without keys a password is used.'**
  String get bootKeysHint;

  /// No description provided for @bootLang.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get bootLang;

  /// No description provided for @bootLastLinux.
  ///
  /// In en, this message translates to:
  /// **'Last Linux installation'**
  String get bootLastLinux;

  /// No description provided for @bootLastRescue.
  ///
  /// In en, this message translates to:
  /// **'Last rescue activation'**
  String get bootLastRescue;

  /// No description provided for @bootLinux.
  ///
  /// In en, this message translates to:
  /// **'Linux installation'**
  String get bootLinux;

  /// No description provided for @bootNone.
  ///
  /// In en, this message translates to:
  /// **'No boot configuration active.'**
  String get bootNone;

  /// No description provided for @bootOffConsequence.
  ///
  /// In en, this message translates to:
  /// **'The next reset boots from the disks again.'**
  String get bootOffConsequence;

  /// No description provided for @bootOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate {config} for {name}?'**
  String bootOffTitle(String config, String name);

  /// No description provided for @bootOs.
  ///
  /// In en, this message translates to:
  /// **'Operating system'**
  String get bootOs;

  /// No description provided for @bootPasswordNote.
  ///
  /// In en, this message translates to:
  /// **'Active at the next reset. Copy the password now; Falco does not store it.'**
  String get bootPasswordNote;

  /// No description provided for @bootRescue.
  ///
  /// In en, this message translates to:
  /// **'Rescue system'**
  String get bootRescue;

  /// No description provided for @bootVnc.
  ///
  /// In en, this message translates to:
  /// **'VNC installation'**
  String get bootVnc;

  /// No description provided for @bootWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows installation'**
  String get bootWindows;

  /// No description provided for @cancelAtDate.
  ///
  /// In en, this message translates to:
  /// **'At a date (from {date})'**
  String cancelAtDate(String date);

  /// No description provided for @cancelConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server is cancelled at the chosen date. Its data is deleted then.'**
  String get cancelConsequence;

  /// No description provided for @cancelDate.
  ///
  /// In en, this message translates to:
  /// **'Cancellation date'**
  String get cancelDate;

  /// No description provided for @cancelEarliest.
  ///
  /// In en, this message translates to:
  /// **'Earliest date'**
  String get cancelEarliest;

  /// No description provided for @cancelNow.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get cancelNow;

  /// No description provided for @cancelReason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get cancelReason;

  /// No description provided for @cancelReserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve location'**
  String get cancelReserve;

  /// No description provided for @cancelReserveHint.
  ///
  /// In en, this message translates to:
  /// **'Keeps the rack location for a new server.'**
  String get cancelReserveHint;

  /// No description provided for @cancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel {name}?'**
  String cancelTitle(String name);

  /// No description provided for @cancelWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw cancellation'**
  String get cancelWithdraw;

  /// No description provided for @cancelWithdrawConsequence.
  ///
  /// In en, this message translates to:
  /// **'The cancellation is withdrawn; the contract continues.'**
  String get cancelWithdrawConsequence;

  /// No description provided for @cancelWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw the cancellation of {name}?'**
  String cancelWithdrawTitle(String name);

  /// No description provided for @cancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get cancellation;

  /// No description provided for @cancelledOn.
  ///
  /// In en, this message translates to:
  /// **'cancelled for {date}'**
  String cancelledOn(String date);

  /// No description provided for @failoverActive.
  ///
  /// In en, this message translates to:
  /// **'Active on'**
  String get failoverActive;

  /// No description provided for @failoverActiveOn.
  ///
  /// In en, this message translates to:
  /// **'Active on {server}'**
  String failoverActiveOn(String server);

  /// No description provided for @failoverEmpty.
  ///
  /// In en, this message translates to:
  /// **'No failover IPs.'**
  String get failoverEmpty;

  /// No description provided for @failoverNoTargets.
  ///
  /// In en, this message translates to:
  /// **'No other server to route to.'**
  String get failoverNoTargets;

  /// No description provided for @failoverOwner.
  ///
  /// In en, this message translates to:
  /// **'Ordered with'**
  String get failoverOwner;

  /// No description provided for @failoverRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get failoverRoute;

  /// No description provided for @failoverRouteConsequence.
  ///
  /// In en, this message translates to:
  /// **'Traffic to the address goes to the new server within seconds. The address must be configured there.'**
  String get failoverRouteConsequence;

  /// No description provided for @failoverRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Route {ip} to {server}?'**
  String failoverRouteTitle(String ip, String server);

  /// No description provided for @failoverUnroute.
  ///
  /// In en, this message translates to:
  /// **'Unroute'**
  String get failoverUnroute;

  /// No description provided for @failoverUnrouteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The address is routed nowhere; services on it become unreachable.'**
  String get failoverUnrouteConsequence;

  /// No description provided for @failoverUnrouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Unroute {ip}?'**
  String failoverUnrouteTitle(String ip);

  /// No description provided for @failoverUnrouted.
  ///
  /// In en, this message translates to:
  /// **'Not routed'**
  String get failoverUnrouted;

  /// No description provided for @fileNotText.
  ///
  /// In en, this message translates to:
  /// **'The file is not UTF-8 text.'**
  String get fileNotText;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The file is too large.'**
  String get fileTooLarge;

  /// No description provided for @filterCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get filterCancelled;

  /// No description provided for @firewallClear.
  ///
  /// In en, this message translates to:
  /// **'Clear firewall'**
  String get firewallClear;

  /// No description provided for @firewallClearConsequence.
  ///
  /// In en, this message translates to:
  /// **'All rules of the server firewall are removed.'**
  String get firewallClearConsequence;

  /// No description provided for @firewallClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the firewall?'**
  String get firewallClearTitle;

  /// No description provided for @firewallDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get firewallDisable;

  /// No description provided for @firewallEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get firewallEnable;

  /// No description provided for @firewallFilterIpv6.
  ///
  /// In en, this message translates to:
  /// **'Filter IPv6'**
  String get firewallFilterIpv6;

  /// No description provided for @firewallHetznerServices.
  ///
  /// In en, this message translates to:
  /// **'Allow Hetzner services'**
  String get firewallHetznerServices;

  /// No description provided for @firewallRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get firewallRules;

  /// No description provided for @firewallTemplateApplyConsequence.
  ///
  /// In en, this message translates to:
  /// **'All rules of the server firewall are replaced by the rules of the template.'**
  String get firewallTemplateApplyConsequence;

  /// No description provided for @firewallTemplateApplyTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply template {name}?'**
  String firewallTemplateApplyTitle(String name);

  /// No description provided for @firewallUnsaved.
  ///
  /// In en, this message translates to:
  /// **'not applied yet'**
  String get firewallUnsaved;

  /// No description provided for @firewallUseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Apply template'**
  String get firewallUseTemplate;

  /// No description provided for @installConsequence.
  ///
  /// In en, this message translates to:
  /// **'At the next reset the installation starts and deletes all data on the disks.'**
  String get installConsequence;

  /// No description provided for @installTitle.
  ///
  /// In en, this message translates to:
  /// **'Reinstall {name}?'**
  String installTitle(String name);

  /// No description provided for @keyBits.
  ///
  /// In en, this message translates to:
  /// **'Bits'**
  String get keyBits;

  /// No description provided for @keyFromFile.
  ///
  /// In en, this message translates to:
  /// **'From file'**
  String get keyFromFile;

  /// No description provided for @macOff.
  ///
  /// In en, this message translates to:
  /// **'Remove MAC'**
  String get macOff;

  /// No description provided for @macOffConsequence.
  ///
  /// In en, this message translates to:
  /// **'The address uses the MAC of the server again.'**
  String get macOffConsequence;

  /// No description provided for @macOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove the separate MAC of {ip}?'**
  String macOffTitle(String ip);

  /// No description provided for @macOn.
  ///
  /// In en, this message translates to:
  /// **'Separate MAC'**
  String get macOn;

  /// No description provided for @macOnConsequence.
  ///
  /// In en, this message translates to:
  /// **'Robot creates a separate MAC address, e.g. for a virtual machine.'**
  String get macOnConsequence;

  /// No description provided for @macOnTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a separate MAC for {ip}?'**
  String macOnTitle(String ip);

  /// No description provided for @macUnavailable.
  ///
  /// In en, this message translates to:
  /// **'not possible'**
  String get macUnavailable;

  /// No description provided for @notCancelled.
  ///
  /// In en, this message translates to:
  /// **'Not cancelled'**
  String get notCancelled;

  /// No description provided for @rdnsCreate.
  ///
  /// In en, this message translates to:
  /// **'Add reverse DNS'**
  String get rdnsCreate;

  /// No description provided for @rdnsDefault.
  ///
  /// In en, this message translates to:
  /// **'Default reverse DNS'**
  String get rdnsDefault;

  /// No description provided for @rdnsDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The address answers with the Hetzner default again.'**
  String get rdnsDeleteConsequence;

  /// No description provided for @rdnsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the reverse DNS of {ip}?'**
  String rdnsDeleteTitle(String ip);

  /// No description provided for @rdnsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reverse DNS entries.'**
  String get rdnsEmpty;

  /// No description provided for @resetHw.
  ///
  /// In en, this message translates to:
  /// **'Hardware reset'**
  String get resetHw;

  /// No description provided for @resetMan.
  ///
  /// In en, this message translates to:
  /// **'Manual reset by support'**
  String get resetMan;

  /// No description provided for @resetManConsequence.
  ///
  /// In en, this message translates to:
  /// **'A technician resets the server by hand; this can take a while.'**
  String get resetManConsequence;

  /// No description provided for @resetPower.
  ///
  /// In en, this message translates to:
  /// **'Power button'**
  String get resetPower;

  /// No description provided for @resetPowerLong.
  ///
  /// In en, this message translates to:
  /// **'Power button, long press'**
  String get resetPowerLong;

  /// No description provided for @resetSw.
  ///
  /// In en, this message translates to:
  /// **'Software reset (Ctrl+Alt+Del)'**
  String get resetSw;

  /// No description provided for @robotActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Robot changes in this session yet.'**
  String get robotActivityEmpty;

  /// No description provided for @robotBoot.
  ///
  /// In en, this message translates to:
  /// **'Boot configuration'**
  String get robotBoot;

  /// No description provided for @robotBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get robotBroadcast;

  /// No description provided for @robotCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel contract'**
  String get robotCancel;

  /// No description provided for @robotDatacenter.
  ///
  /// In en, this message translates to:
  /// **'Data center'**
  String get robotDatacenter;

  /// No description provided for @robotDone.
  ///
  /// In en, this message translates to:
  /// **'Action completed'**
  String get robotDone;

  /// No description provided for @robotFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed: {reason}'**
  String robotFailed(String reason);

  /// No description provided for @robotFailover.
  ///
  /// In en, this message translates to:
  /// **'Failover'**
  String get robotFailover;

  /// No description provided for @robotFirewall.
  ///
  /// In en, this message translates to:
  /// **'Firewall'**
  String get robotFirewall;

  /// No description provided for @robotIp.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get robotIp;

  /// No description provided for @robotIps.
  ///
  /// In en, this message translates to:
  /// **'IPs'**
  String get robotIps;

  /// No description provided for @robotIpsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No single IPs.'**
  String get robotIpsEmpty;

  /// No description provided for @robotIpv6Net.
  ///
  /// In en, this message translates to:
  /// **'IPv6 net'**
  String get robotIpv6Net;

  /// No description provided for @robotKeyDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The key is deleted from Robot. Servers keep keys installed earlier.'**
  String get robotKeyDeleteConsequence;

  /// No description provided for @robotKeysEmpty.
  ///
  /// In en, this message translates to:
  /// **'No SSH keys in Robot yet.'**
  String get robotKeysEmpty;

  /// No description provided for @robotLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get robotLocked;

  /// No description provided for @robotMac.
  ///
  /// In en, this message translates to:
  /// **'Separate MAC'**
  String get robotMac;

  /// No description provided for @robotNetmask.
  ///
  /// In en, this message translates to:
  /// **'Netmask'**
  String get robotNetmask;

  /// No description provided for @robotNoAccess.
  ///
  /// In en, this message translates to:
  /// **'This account has no Robot access.'**
  String get robotNoAccess;

  /// No description provided for @robotNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get robotNumber;

  /// No description provided for @robotPaidUntil.
  ///
  /// In en, this message translates to:
  /// **'paid until {date}'**
  String robotPaidUntil(String date);

  /// No description provided for @robotPaidUntilLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid until'**
  String get robotPaidUntilLabel;

  /// No description provided for @robotProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get robotProduct;

  /// No description provided for @robotResetConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server restarts; unsaved data is lost.'**
  String get robotResetConsequence;

  /// No description provided for @robotSectionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Enable this section for the webservice user in Hetzner Robot.'**
  String get robotSectionDisabled;

  /// No description provided for @robotServer.
  ///
  /// In en, this message translates to:
  /// **'Dedicated server'**
  String get robotServer;

  /// No description provided for @robotServers.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get robotServers;

  /// No description provided for @robotServersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No dedicated servers.'**
  String get robotServersEmpty;

  /// No description provided for @robotSubnet.
  ///
  /// In en, this message translates to:
  /// **'Subnet'**
  String get robotSubnet;

  /// No description provided for @robotSubnets.
  ///
  /// In en, this message translates to:
  /// **'Subnets'**
  String get robotSubnets;

  /// No description provided for @robotTemplate.
  ///
  /// In en, this message translates to:
  /// **'Firewall template'**
  String get robotTemplate;

  /// No description provided for @robotTemplates.
  ///
  /// In en, this message translates to:
  /// **'Firewall templates'**
  String get robotTemplates;

  /// No description provided for @robotTrafficQuota.
  ///
  /// In en, this message translates to:
  /// **'Traffic included'**
  String get robotTrafficQuota;

  /// No description provided for @robotVSwitch.
  ///
  /// In en, this message translates to:
  /// **'vSwitch'**
  String get robotVSwitch;

  /// No description provided for @robotVSwitches.
  ///
  /// In en, this message translates to:
  /// **'vSwitches'**
  String get robotVSwitches;

  /// No description provided for @robotWol.
  ///
  /// In en, this message translates to:
  /// **'Wake on LAN'**
  String get robotWol;

  /// No description provided for @ruleAccept.
  ///
  /// In en, this message translates to:
  /// **'accept'**
  String get ruleAccept;

  /// No description provided for @ruleAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get ruleAction;

  /// No description provided for @ruleAny.
  ///
  /// In en, this message translates to:
  /// **'any'**
  String get ruleAny;

  /// No description provided for @ruleDestIp.
  ///
  /// In en, this message translates to:
  /// **'Destination IP'**
  String get ruleDestIp;

  /// No description provided for @ruleDestPort.
  ///
  /// In en, this message translates to:
  /// **'Destination port'**
  String get ruleDestPort;

  /// No description provided for @ruleDiscard.
  ///
  /// In en, this message translates to:
  /// **'discard'**
  String get ruleDiscard;

  /// No description provided for @ruleFrom.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get ruleFrom;

  /// No description provided for @ruleInput.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get ruleInput;

  /// No description provided for @ruleIpVersion.
  ///
  /// In en, this message translates to:
  /// **'IP version'**
  String get ruleIpVersion;

  /// No description provided for @ruleOutput.
  ///
  /// In en, this message translates to:
  /// **'Outgoing'**
  String get ruleOutput;

  /// No description provided for @ruleSourceIp.
  ///
  /// In en, this message translates to:
  /// **'Source IP'**
  String get ruleSourceIp;

  /// No description provided for @ruleSourcePort.
  ///
  /// In en, this message translates to:
  /// **'Source port'**
  String get ruleSourcePort;

  /// No description provided for @ruleTcpFlags.
  ///
  /// In en, this message translates to:
  /// **'TCP flags'**
  String get ruleTcpFlags;

  /// No description provided for @ruleTo.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get ruleTo;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'cancelled'**
  String get statusCancelled;

  /// No description provided for @templateCreate.
  ///
  /// In en, this message translates to:
  /// **'Create template'**
  String get templateCreate;

  /// No description provided for @templateDefault.
  ///
  /// In en, this message translates to:
  /// **'Default template'**
  String get templateDefault;

  /// No description provided for @templateDeleteConsequence.
  ///
  /// In en, this message translates to:
  /// **'The template is deleted. Server firewalls keep their rules.'**
  String get templateDeleteConsequence;

  /// No description provided for @templatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No firewall templates.'**
  String get templatesEmpty;

  /// No description provided for @trafficDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily limit (MB)'**
  String get trafficDaily;

  /// No description provided for @trafficDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get trafficDay;

  /// No description provided for @trafficHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly limit (MB)'**
  String get trafficHourly;

  /// No description provided for @trafficIn.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get trafficIn;

  /// No description provided for @trafficMonth.
  ///
  /// In en, this message translates to:
  /// **'Traffic this month'**
  String get trafficMonth;

  /// No description provided for @trafficMonthType.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get trafficMonthType;

  /// No description provided for @trafficMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit (GB)'**
  String get trafficMonthly;

  /// No description provided for @trafficNone.
  ///
  /// In en, this message translates to:
  /// **'No traffic data for this period.'**
  String get trafficNone;

  /// No description provided for @trafficOut.
  ///
  /// In en, this message translates to:
  /// **'Outgoing'**
  String get trafficOut;

  /// No description provided for @trafficSum.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get trafficSum;

  /// No description provided for @trafficTitle.
  ///
  /// In en, this message translates to:
  /// **'Traffic'**
  String get trafficTitle;

  /// No description provided for @trafficWarnings.
  ///
  /// In en, this message translates to:
  /// **'Traffic warnings'**
  String get trafficWarnings;

  /// No description provided for @trafficWarningsOn.
  ///
  /// In en, this message translates to:
  /// **'warnings on'**
  String get trafficWarningsOn;

  /// No description provided for @trafficYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get trafficYear;

  /// No description provided for @vlanHint.
  ///
  /// In en, this message translates to:
  /// **'VLAN ID from 4000 to 4091'**
  String get vlanHint;

  /// No description provided for @vswitchAddServer.
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get vswitchAddServer;

  /// No description provided for @vswitchCancelConsequence.
  ///
  /// In en, this message translates to:
  /// **'The vSwitch is cancelled at the chosen date; its servers lose the connection.'**
  String get vswitchCancelConsequence;

  /// No description provided for @vswitchCreate.
  ///
  /// In en, this message translates to:
  /// **'Create vSwitch'**
  String get vswitchCreate;

  /// No description provided for @vswitchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No vSwitches yet.'**
  String get vswitchEmpty;

  /// No description provided for @vswitchNoServers.
  ///
  /// In en, this message translates to:
  /// **'No servers in this vSwitch.'**
  String get vswitchNoServers;

  /// No description provided for @vswitchRemoveConsequence.
  ///
  /// In en, this message translates to:
  /// **'The server leaves the VLAN; its traffic there stops.'**
  String get vswitchRemoveConsequence;

  /// No description provided for @vswitchRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {server} from {vswitch}?'**
  String vswitchRemoveTitle(String server, String vswitch);

  /// No description provided for @wolConsequence.
  ///
  /// In en, this message translates to:
  /// **'A Wake on LAN packet is sent to the server.'**
  String get wolConsequence;

  /// No description provided for @wolTitle.
  ///
  /// In en, this message translates to:
  /// **'Wake {name}?'**
  String wolTitle(String name);

  /// No description provided for @activityType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get activityType;

  /// No description provided for @activityTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get activityTime;

  /// No description provided for @activityAnyTime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get activityAnyTime;

  /// No description provided for @activityLastDay.
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours'**
  String get activityLastDay;

  /// No description provided for @activityLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get activityLastWeek;

  /// No description provided for @activityLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get activityLastMonth;

  /// No description provided for @activityToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get activityToday;

  /// No description provided for @activityYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get activityYesterday;

  /// No description provided for @activityEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get activityEarlier;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Name, IP, label or ID'**
  String get searchHint;

  /// No description provided for @searchStart.
  ///
  /// In en, this message translates to:
  /// **'Search servers, IPs, labels and IDs in all accounts, projects and Robot.'**
  String get searchStart;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecent;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get searchResults;

  /// No description provided for @searchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches.'**
  String get searchNoMatches;

  /// No description provided for @searchDedicated.
  ///
  /// In en, this message translates to:
  /// **'Dedicated servers'**
  String get searchDedicated;

  /// No description provided for @searchRobotKeys.
  ///
  /// In en, this message translates to:
  /// **'Robot SSH keys'**
  String get searchRobotKeys;
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
