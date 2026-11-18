import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Clinic Manager'**
  String get appName;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navPatients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get navPatients;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get navBilling;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your clinic, in your pocket'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Patients, appointments, visits and payments — all stored on this device.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingClinicTitle.
  ///
  /// In en, this message translates to:
  /// **'Clinic details'**
  String get onboardingClinicTitle;

  /// No description provided for @onboardingClinicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These details appear on prescriptions and receipts.'**
  String get onboardingClinicSubtitle;

  /// No description provided for @onboardingClinicName.
  ///
  /// In en, this message translates to:
  /// **'Clinic name'**
  String get onboardingClinicName;

  /// No description provided for @onboardingDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor name'**
  String get onboardingDoctorName;

  /// No description provided for @onboardingSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get onboardingSpecialty;

  /// No description provided for @onboardingPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get onboardingPhone;

  /// No description provided for @onboardingCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get onboardingCurrency;

  /// No description provided for @onboardingSlotDuration.
  ///
  /// In en, this message translates to:
  /// **'Appointment length'**
  String get onboardingSlotDuration;

  /// No description provided for @onboardingMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String onboardingMinutes(int minutes);

  /// No description provided for @onboardingSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect patient data'**
  String get onboardingSecurityTitle;

  /// No description provided for @onboardingSecurityBody.
  ///
  /// In en, this message translates to:
  /// **'Add a PIN and enable fingerprint or face unlock. You can change this later in Settings.'**
  String get onboardingSecurityBody;

  /// No description provided for @onboardingPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get onboardingPin;

  /// No description provided for @onboardingPinConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get onboardingPinConfirm;

  /// No description provided for @onboardingPinHint.
  ///
  /// In en, this message translates to:
  /// **'4 to 6 digits'**
  String get onboardingPinHint;

  /// No description provided for @onboardingPinOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional — you can add a PIN later in Settings.'**
  String get onboardingPinOptional;

  /// No description provided for @onboardingEnableBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Enable fingerprint / face unlock'**
  String get onboardingEnableBiometrics;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Start using Clinic Manager'**
  String get onboardingFinish;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validationRequired;

  /// No description provided for @validationPinTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 4 digits'**
  String get validationPinTooShort;

  /// No description provided for @validationPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get validationPinMismatch;

  /// No description provided for @validationPinDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Digits only'**
  String get validationPinDigitsOnly;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String dashboardGreeting(String name);

  /// No description provided for @dashboardQuietTitle.
  ///
  /// In en, this message translates to:
  /// **'A quiet day'**
  String get dashboardQuietTitle;

  /// No description provided for @dashboardQuietBody.
  ///
  /// In en, this message translates to:
  /// **'Today\'s appointments and follow-ups will appear here.'**
  String get dashboardQuietBody;

  /// No description provided for @dashboardAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'Appointments today'**
  String get dashboardAppointmentsToday;

  /// No description provided for @dashboardSeenToday.
  ///
  /// In en, this message translates to:
  /// **'Patients seen'**
  String get dashboardSeenToday;

  /// No description provided for @dashboardRevenueToday.
  ///
  /// In en, this message translates to:
  /// **'Collected today'**
  String get dashboardRevenueToday;

  /// No description provided for @dashboardOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get dashboardOutstanding;

  /// No description provided for @dashboardNoAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments scheduled today'**
  String get dashboardNoAppointments;

  /// No description provided for @dashboardOpenPatients.
  ///
  /// In en, this message translates to:
  /// **'Open patient files'**
  String get dashboardOpenPatients;

  /// No description provided for @patientsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No patients yet'**
  String get patientsEmptyTitle;

  /// No description provided for @patientsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Patient files will appear here with their complete history.'**
  String get patientsEmptyBody;

  /// No description provided for @calendarEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled'**
  String get calendarEmptyTitle;

  /// No description provided for @calendarEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your day and week views will show every appointment.'**
  String get calendarEmptyBody;

  /// No description provided for @billingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get billingEmptyTitle;

  /// No description provided for @billingEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Invoices, payments and outstanding balances will live here.'**
  String get billingEmptyBody;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsClinicProfile.
  ///
  /// In en, this message translates to:
  /// **'Clinic profile'**
  String get settingsClinicProfile;

  /// No description provided for @settingsLanguageAppearance.
  ///
  /// In en, this message translates to:
  /// **'Language & appearance'**
  String get settingsLanguageAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackup;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock the app now'**
  String get settingsLockNow;

  /// No description provided for @settingsRequireLock.
  ///
  /// In en, this message translates to:
  /// **'Require PIN on open'**
  String get settingsRequireLock;

  /// No description provided for @settingsBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint / face unlock'**
  String get settingsBiometrics;

  /// No description provided for @settingsPinSet.
  ///
  /// In en, this message translates to:
  /// **'PIN is set'**
  String get settingsPinSet;

  /// No description provided for @settingsPinNotSet.
  ///
  /// In en, this message translates to:
  /// **'No PIN set'**
  String get settingsPinNotSet;

  /// No description provided for @settingsSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get settingsSetPin;

  /// No description provided for @settingsChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get settingsChangePin;

  /// No description provided for @settingsRemovePin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get settingsRemovePin;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @pinSaved.
  ///
  /// In en, this message translates to:
  /// **'PIN saved'**
  String get pinSaved;

  /// No description provided for @pinRemoved.
  ///
  /// In en, this message translates to:
  /// **'PIN removed'**
  String get pinRemoved;

  /// No description provided for @biometricsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics are not available on this device'**
  String get biometricsUnavailable;

  /// No description provided for @settingsDataLocal.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this device only'**
  String get settingsDataLocal;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming in a later milestone'**
  String get settingsComingSoon;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get lockTitle;

  /// No description provided for @lockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to open Clinic Manager'**
  String get lockSubtitle;

  /// No description provided for @lockUseBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint / face'**
  String get lockUseBiometrics;

  /// No description provided for @lockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockUnlock;

  /// No description provided for @lockWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN, try again'**
  String get lockWrongPin;

  /// No description provided for @lockAttemptsLeft.
  ///
  /// In en, this message translates to:
  /// **'Attempts left: {count}'**
  String lockAttemptsLeft(int count);

  /// No description provided for @lockTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in a minute.'**
  String get lockTooManyAttempts;

  /// No description provided for @clinicProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Clinic profile saved'**
  String get clinicProfileSaved;

  /// No description provided for @dbInitError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the local database. Restore a backup or reinstall the app.'**
  String get dbInitError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get genericError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get unknownError;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
