import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'db/app_database.dart';
import 'prefs/app_preferences.dart';
import 'security/biometric_service.dart';
import 'security/pin_store.dart';

/// Everything that must be ready before the first screen is shown.
class AppBootstrap {
  const AppBootstrap({
    required this.database,
    required this.preferences,
    required this.pinStore,
    required this.biometrics,
  });

  final AppDatabase database;
  final AppPreferences preferences;
  final PinStore pinStore;
  final BiometricService biometrics;
}

final bootstrapProvider = FutureProvider<AppBootstrap>((ref) async {
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');

  final preferences = await AppPreferences.load();
  final database = AppDatabase();
  try {
    await database.ensureHealthy();
  } catch (_) {
    await database.close();
    rethrow;
  }

  ref.onDispose(() => unawaited(database.close()));

  return AppBootstrap(
    database: database,
    preferences: preferences,
    pinStore: PinStore(),
    biometrics: BiometricService(),
  );
});
