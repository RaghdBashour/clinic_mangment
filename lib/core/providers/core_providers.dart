import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap.dart';
import '../db/app_database.dart';
import '../prefs/app_preferences.dart';
import '../security/biometric_service.dart';
import '../security/pin_store.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(bootstrapProvider).requireValue.database;
});

final preferencesProvider = Provider<AppPreferences>((ref) {
  return ref.watch(bootstrapProvider).requireValue.preferences;
});

final pinStoreProvider = Provider<PinStore>((ref) {
  return ref.watch(bootstrapProvider).requireValue.pinStore;
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return ref.watch(bootstrapProvider).requireValue.biometrics;
});

final clinicProfileProvider = StreamProvider<ClinicProfile?>((ref) {
  return ref.watch(databaseProvider).clinicProfileDao.watchProfile();
});

final pinConfiguredProvider = FutureProvider<bool>((ref) {
  return ref.watch(pinStoreProvider).hasPin;
});
