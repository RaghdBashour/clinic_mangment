import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers/core_providers.dart';

class AppSettings {
  const AppSettings({required this.languageCode, required this.themeMode});

  final String? languageCode;
  final ThemeMode themeMode;
}

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final preferences = ref.watch(preferencesProvider);
    final index = preferences.themeModeIndex;
    final mode = index >= 0 && index < ThemeMode.values.length
        ? ThemeMode.values[index]
        : ThemeMode.system;
    return AppSettings(languageCode: preferences.languageCode, themeMode: mode);
  }

  Future<void> setLanguage(String? code) async {
    await ref.read(preferencesProvider).setLanguageCode(code);
    state = AppSettings(languageCode: code, themeMode: state.themeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(preferencesProvider).setThemeModeIndex(mode.index);
    state = AppSettings(languageCode: state.languageCode, themeMode: mode);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class SecuritySettingsController extends Notifier<bool> {
  @override
  bool build() => ref.watch(preferencesProvider).biometricsEnabled;

  Future<void> setBiometricsEnabled(bool enabled) async {
    await ref.read(preferencesProvider).setBiometricsEnabled(enabled);
    state = enabled;
  }
}

final biometricsEnabledProvider =
    NotifierProvider<SecuritySettingsController, bool>(
      SecuritySettingsController.new,
    );
