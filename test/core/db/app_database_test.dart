import 'package:clinic_manager/core/db/app_database.dart';
import 'package:clinic_manager/core/db/enums.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('stores and updates the single clinic profile', () async {
    final id = await database.clinicProfileDao.saveProfile(
      ClinicProfilesCompanion.insert(
        name: 'Nour Clinic',
        doctorName: 'Dr. Nour',
        currencyCode: 'SYP',
      ),
    );
    expect(id, 1);

    var profile = await database.clinicProfileDao.getProfile();
    expect(profile?.name, 'Nour Clinic');
    expect(profile?.slotMinutes, 30);
    expect(profile?.documentLanguage, 'ar');

    await database.clinicProfileDao.saveProfile(
      const ClinicProfilesCompanion(
        name: Value('Nour Medical Center'),
        slotMinutes: Value(20),
      ),
    );

    profile = await database.clinicProfileDao.getProfile();
    expect(profile?.name, 'Nour Medical Center');
    expect(profile?.slotMinutes, 20);
  });

  test('stores a patient, appointment, invoice and payment', () async {
    final patientId = await database
        .into(database.patients)
        .insert(
          PatientsCompanion.insert(fullName: 'Sara Ahmad', phone: '0955000000'),
        );

    final appointmentId = await database
        .into(database.appointments)
        .insert(
          AppointmentsCompanion.insert(
            patientId: patientId,
            startsAt: DateTime.utc(2026, 11, 13, 9),
            endsAt: DateTime.utc(2026, 11, 13, 9, 30),
            kind: AppointmentKind.newVisit,
            status: AppointmentStatus.scheduled,
          ),
        );

    final invoiceId = await database
        .into(database.invoices)
        .insert(
          InvoicesCompanion.insert(
            patientId: patientId,
            status: InvoiceStatus.partial,
            issuedAt: DateTime.utc(2026, 11, 13, 9, 40),
            totalMinor: const Value(5000),
          ),
        );

    await database
        .into(database.payments)
        .insert(
          PaymentsCompanion.insert(
            invoiceId: invoiceId,
            amountMinor: 2000,
            method: PaymentMethod.cash,
            paidAt: DateTime.utc(2026, 11, 13, 9, 45),
          ),
        );

    expect(appointmentId, 1);
    expect(await database.select(database.patients).get(), hasLength(1));
    expect(await database.select(database.payments).get(), hasLength(1));
  });

  test('deleting a patient cascades clinical and billing rows', () async {
    final patientId = await database
        .into(database.patients)
        .insert(
          PatientsCompanion.insert(fullName: 'Omar', phone: '0944000000'),
        );
    await database
        .into(database.appointments)
        .insert(
          AppointmentsCompanion.insert(
            patientId: patientId,
            startsAt: DateTime.utc(2026, 11, 14, 10),
            endsAt: DateTime.utc(2026, 11, 14, 10, 30),
            kind: AppointmentKind.followUp,
            status: AppointmentStatus.scheduled,
          ),
        );
    await database
        .into(database.invoices)
        .insert(
          InvoicesCompanion.insert(
            patientId: patientId,
            status: InvoiceStatus.unpaid,
            issuedAt: DateTime.utc(2026, 11, 14, 11),
          ),
        );

    await (database.delete(
      database.patients,
    )..where((t) => t.id.equals(patientId))).go();

    expect(await database.select(database.patients).get(), isEmpty);
    expect(await database.select(database.appointments).get(), isEmpty);
    expect(await database.select(database.invoices).get(), isEmpty);
  });

  test('audit log records entity history', () async {
    await database.logAudit(
      entityType: 'patient',
      entityId: '1',
      action: AuditAction.create,
      payloadJson: '{"fullName":"Sara"}',
    );

    final events = await database.select(database.auditEvents).get();
    expect(events, hasLength(1));
    expect(events.single.action, AuditAction.create);
    expect(events.single.entityType, 'patient');
  });

  test('startup integrity check passes on a healthy database', () async {
    await expectLater(database.ensureHealthy(), completes);
  });
}
