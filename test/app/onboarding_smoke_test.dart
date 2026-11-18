import 'package:clinic_manager/app/app.dart';
import 'package:clinic_manager/core/bootstrap.dart';
import 'package:clinic_manager/core/db/app_database.dart';
import 'package:clinic_manager/core/prefs/app_preferences.dart';
import 'package:clinic_manager/core/security/biometric_service.dart';
import 'package:clinic_manager/core/security/pin_store.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('first launch shows onboarding and reaches clinic details', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await AppPreferences.load();
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() => database.close());

    final bootstrap = AppBootstrap(
      database: database,
      preferences: preferences,
      pinStore: PinStore(),
      biometrics: BiometricService(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [bootstrapProvider.overrideWith((ref) async => bootstrap)],
        child: const ClinicApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your clinic, in your pocket'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Clinic details'), findsOneWidget);
    expect(find.text('Clinic name'), findsOneWidget);
    expect(find.text('Doctor name'), findsOneWidget);
  });
}
