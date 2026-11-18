// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Clinic Manager';

  @override
  String get navToday => 'Today';

  @override
  String get navPatients => 'Patients';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navBilling => 'Billing';

  @override
  String get navMore => 'More';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDone => 'Done';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionClose => 'Close';

  @override
  String get onboardingWelcomeTitle => 'Your clinic, in your pocket';

  @override
  String get onboardingWelcomeBody =>
      'Patients, appointments, visits and payments — all stored on this device.';

  @override
  String get onboardingClinicTitle => 'Clinic details';

  @override
  String get onboardingClinicSubtitle =>
      'These details appear on prescriptions and receipts.';

  @override
  String get onboardingClinicName => 'Clinic name';

  @override
  String get onboardingDoctorName => 'Doctor name';

  @override
  String get onboardingSpecialty => 'Specialty';

  @override
  String get onboardingPhone => 'Phone';

  @override
  String get onboardingCurrency => 'Currency';

  @override
  String get onboardingSlotDuration => 'Appointment length';

  @override
  String onboardingMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get onboardingSecurityTitle => 'Protect patient data';

  @override
  String get onboardingSecurityBody =>
      'Add a PIN and enable fingerprint or face unlock. You can change this later in Settings.';

  @override
  String get onboardingPin => 'PIN';

  @override
  String get onboardingPinConfirm => 'Confirm PIN';

  @override
  String get onboardingPinHint => '4 to 6 digits';

  @override
  String get onboardingPinOptional =>
      'Optional — you can add a PIN later in Settings.';

  @override
  String get onboardingEnableBiometrics => 'Enable fingerprint / face unlock';

  @override
  String get onboardingFinish => 'Start using Clinic Manager';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationPinTooShort => 'Use at least 4 digits';

  @override
  String get validationPinMismatch => 'PINs do not match';

  @override
  String get validationPinDigitsOnly => 'Digits only';

  @override
  String dashboardGreeting(String name) {
    return 'Welcome, $name';
  }

  @override
  String get dashboardQuietTitle => 'A quiet day';

  @override
  String get dashboardQuietBody =>
      'Today\'s appointments and follow-ups will appear here.';

  @override
  String get dashboardAppointmentsToday => 'Appointments today';

  @override
  String get dashboardSeenToday => 'Patients seen';

  @override
  String get dashboardRevenueToday => 'Collected today';

  @override
  String get dashboardOutstanding => 'Outstanding';

  @override
  String get dashboardNoAppointments => 'No appointments scheduled today';

  @override
  String get dashboardOpenPatients => 'Open patient files';

  @override
  String get patientsEmptyTitle => 'No patients yet';

  @override
  String get patientsEmptyBody =>
      'Patient files will appear here with their complete history.';

  @override
  String get calendarEmptyTitle => 'Nothing scheduled';

  @override
  String get calendarEmptyBody =>
      'Your day and week views will show every appointment.';

  @override
  String get billingEmptyTitle => 'No invoices yet';

  @override
  String get billingEmptyBody =>
      'Invoices, payments and outstanding balances will live here.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsClinicProfile => 'Clinic profile';

  @override
  String get settingsLanguageAppearance => 'Language & appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsBackup => 'Backup & restore';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLockNow => 'Lock the app now';

  @override
  String get settingsRequireLock => 'Require PIN on open';

  @override
  String get settingsBiometrics => 'Fingerprint / face unlock';

  @override
  String get settingsPinSet => 'PIN is set';

  @override
  String get settingsPinNotSet => 'No PIN set';

  @override
  String get settingsSetPin => 'Set a PIN';

  @override
  String get settingsChangePin => 'Change PIN';

  @override
  String get settingsRemovePin => 'Remove PIN';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get newPin => 'New PIN';

  @override
  String get pinSaved => 'PIN saved';

  @override
  String get pinRemoved => 'PIN removed';

  @override
  String get biometricsUnavailable =>
      'Biometrics are not available on this device';

  @override
  String get settingsDataLocal => 'Your data stays on this device only';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsComingSoon => 'Coming in a later milestone';

  @override
  String get languageSystem => 'System';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get lockTitle => 'Welcome back';

  @override
  String get lockSubtitle => 'Enter your PIN to open Clinic Manager';

  @override
  String get lockUseBiometrics => 'Use fingerprint / face';

  @override
  String get lockUnlock => 'Unlock';

  @override
  String get lockWrongPin => 'Wrong PIN, try again';

  @override
  String lockAttemptsLeft(int count) {
    return 'Attempts left: $count';
  }

  @override
  String get lockTooManyAttempts => 'Too many attempts. Try again in a minute.';

  @override
  String get clinicProfileSaved => 'Clinic profile saved';

  @override
  String get dbInitError =>
      'Could not open the local database. Restore a backup or reinstall the app.';

  @override
  String get genericError => 'Something went wrong';

  @override
  String get unknownError => 'Unexpected error';
}
