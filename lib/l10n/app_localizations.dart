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
