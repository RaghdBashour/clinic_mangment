import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight, non-clinical preferences. Clinical data lives in SQLite.
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _kOnboarding = 'onboarding_complete';
  static const _kLanguage = 'language_code';
  static const _kThemeMode = 'theme_mode';
  static const _kSecurityEnabled = 'security_enabled';
  static const _kBiometricsEnabled = 'biometrics_enabled';
  static const _kLockAfterSeconds = 'lock_after_seconds';

  static Future<AppPreferences> load() async =>
      AppPreferences(await SharedPreferences.getInstance());

  bool get onboardingComplete => _prefs.getBool(_kOnboarding) ?? false;

  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(_kOnboarding, value);

  String? get languageCode => _prefs.getString(_kLanguage);

  Future<void> setLanguageCode(String? code) async {
    if (code == null) {
      await _prefs.remove(_kLanguage);
    } else {
      await _prefs.setString(_kLanguage, code);
    }
  }

  int get themeModeIndex => _prefs.getInt(_kThemeMode) ?? 0;

  Future<void> setThemeModeIndex(int index) =>
      _prefs.setInt(_kThemeMode, index);

  bool get securityEnabled => _prefs.getBool(_kSecurityEnabled) ?? false;

  Future<void> setSecurityEnabled(bool value) =>
      _prefs.setBool(_kSecurityEnabled, value);

  bool get biometricsEnabled => _prefs.getBool(_kBiometricsEnabled) ?? false;

  Future<void> setBiometricsEnabled(bool value) =>
      _prefs.setBool(_kBiometricsEnabled, value);

  int get lockAfterSeconds => _prefs.getInt(_kLockAfterSeconds) ?? 30;

  Future<void> setLockAfterSeconds(int value) =>
      _prefs.setInt(_kLockAfterSeconds, value);
}
