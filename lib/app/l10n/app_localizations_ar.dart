// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مدير العيادة';

  @override
  String get navToday => 'اليوم';

  @override
  String get navPatients => 'المرضى';

  @override
  String get navCalendar => 'المواعيد';

  @override
  String get navBilling => 'الفواتير';

  @override
  String get navMore => 'المزيد';

  @override
  String get actionContinue => 'متابعة';

  @override
  String get actionBack => 'رجوع';

  @override
  String get actionSkip => 'تخطي';

  @override
  String get actionSave => 'حفظ';

  @override
  String get actionDone => 'تم';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get actionAdd => 'إضافة';

  @override
  String get actionClose => 'إغلاق';

  @override
  String get onboardingWelcomeTitle => 'عيادتك في جيبك';

  @override
  String get onboardingWelcomeBody =>
      'المرضى والمواعيد والزيارات والمدفوعات — كلها محفوظة على هذا الجهاز.';

  @override
  String get onboardingClinicTitle => 'بيانات العيادة';

  @override
  String get onboardingClinicSubtitle =>
      'تظهر هذه البيانات على الوصفات والفواتير.';

  @override
  String get onboardingClinicName => 'اسم العيادة';

  @override
  String get onboardingDoctorName => 'اسم الطبيب';

  @override
  String get onboardingSpecialty => 'التخصص';

  @override
  String get onboardingPhone => 'الهاتف';

  @override
  String get onboardingCurrency => 'العملة';

  @override
  String get onboardingSlotDuration => 'مدة الموعد';

  @override
  String onboardingMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get onboardingSecurityTitle => 'حماية بيانات المرضى';

  @override
  String get onboardingSecurityBody =>
      'أضف رمزًا سريًا وفعّل فتح القفل بالبصمة أو الوجه. يمكنك تغيير ذلك لاحقًا من الإعدادات.';

  @override
  String get onboardingPin => 'الرمز السري';

  @override
  String get onboardingPinConfirm => 'تأكيد الرمز';

  @override
  String get onboardingPinHint => 'من 4 إلى 6 أرقام';

  @override
  String get onboardingPinOptional =>
      'اختياري — يمكنك إضافة رمز سري لاحقًا من الإعدادات.';

  @override
  String get onboardingEnableBiometrics => 'تفعيل البصمة أو التعرف على الوجه';

  @override
  String get onboardingFinish => 'ابدأ استخدام مدير العيادة';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationPinTooShort => 'استخدم 4 أرقام على الأقل';

  @override
  String get validationPinMismatch => 'الرمزان غير متطابقين';

  @override
  String get validationPinDigitsOnly => 'أرقام فقط';

  @override
  String dashboardGreeting(String name) {
    return 'مرحبًا، $name';
  }

  @override
  String get dashboardQuietTitle => 'يوم هادئ';

  @override
  String get dashboardQuietBody =>
      'ستظهر هنا مواعيد اليوم والمتابعات المستحقة.';

  @override
  String get dashboardAppointmentsToday => 'مواعيد اليوم';

  @override
  String get dashboardSeenToday => 'المرضى اليوم';

  @override
  String get dashboardRevenueToday => 'المحصّل اليوم';

  @override
  String get dashboardOutstanding => 'مبالغ مستحقة';

  @override
  String get dashboardNoAppointments => 'لا توجد مواعيد اليوم';

  @override
  String get dashboardOpenPatients => 'فتح ملفات المرضى';

  @override
  String get patientsEmptyTitle => 'لا يوجد مرضى بعد';

  @override
  String get patientsEmptyBody => 'ستظهر هنا ملفات المرضى مع تاريخهم الكامل.';

  @override
  String get calendarEmptyTitle => 'لا شيء مجدول';

  @override
  String get calendarEmptyBody => 'ستعرض هنا جميع المواعيد في اليوم والأسبوع.';

  @override
  String get billingEmptyTitle => 'لا توجد فواتير بعد';

  @override
  String get billingEmptyBody =>
      'ستظهر هنا الفواتير والمدفوعات والأرصدة المتبقية.';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsClinicProfile => 'ملف العيادة';

  @override
  String get settingsLanguageAppearance => 'اللغة والمظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsSecurity => 'الأمان';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsBackup => 'النسخ الاحتياطي والاستعادة';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get settingsLockNow => 'اقفل التطبيق الآن';

  @override
  String get settingsRequireLock => 'طلب الرمز عند الفتح';

  @override
  String get settingsBiometrics => 'فتح بالبصمة أو الوجه';

  @override
  String get settingsPinSet => 'الرمز السري مفعّل';

  @override
  String get settingsPinNotSet => 'لا يوجد رمز سري';

  @override
  String get settingsSetPin => 'إضافة رمز سري';

  @override
  String get settingsChangePin => 'تغيير الرمز السري';

  @override
  String get settingsRemovePin => 'إزالة الرمز السري';

  @override
  String get currentPin => 'الرمز الحالي';

  @override
  String get newPin => 'الرمز الجديد';

  @override
  String get pinSaved => 'تم حفظ الرمز السري';

  @override
  String get pinRemoved => 'تمت إزالة الرمز السري';

  @override
  String get biometricsUnavailable => 'البصمة غير متوفرة على هذا الجهاز';

  @override
  String get settingsDataLocal => 'بياناتك محفوظة على هذا الجهاز فقط';

  @override
  String settingsVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get settingsComingSoon => 'سيتوفر في مرحلة لاحقة';

  @override
  String get languageSystem => 'لغة الجهاز';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get lockTitle => 'مرحبًا بعودتك';

  @override
  String get lockSubtitle => 'أدخل رمزك السري لفتح مدير العيادة';

  @override
  String get lockUseBiometrics => 'استخدام البصمة أو الوجه';

  @override
  String get lockUnlock => 'فتح';

  @override
  String get lockWrongPin => 'رمز غير صحيح، حاول مرة أخرى';

  @override
  String lockAttemptsLeft(int count) {
    return 'المحاولات المتبقية: $count';
  }

  @override
  String get lockTooManyAttempts => 'محاولات كثيرة. حاول بعد دقيقة.';

  @override
  String get clinicProfileSaved => 'تم حفظ بيانات العيادة';

  @override
  String get dbInitError =>
      'تعذر فتح قاعدة البيانات المحلية. استعد نسخة احتياطية أو أعد تثبيت التطبيق.';

  @override
  String get genericError => 'حدث خطأ ما';

  @override
  String get unknownError => 'خطأ غير متوقع';
}
