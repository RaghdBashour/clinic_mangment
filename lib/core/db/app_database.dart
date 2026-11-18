import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/clinic_profile_dao.dart';
import 'enums.dart';
import 'tables/billing_tables.dart';
import 'tables/clinic_tables.dart';
import 'tables/clinical_tables.dart';
import 'tables/patient_tables.dart';
import 'tables/scheduling_tables.dart';
import 'tables/system_tables.dart';

part 'app_database.g.dart';

class DatabaseUnhealthyException implements Exception {
  const DatabaseUnhealthyException(this.message);

  final String message;

  @override
  String toString() => 'DatabaseUnhealthyException: $message';
}

@DriftDatabase(
  tables: [
    ClinicProfiles,
    Patients,
    Appointments,
    NotificationLogs,
    Visits,
    VisitRevisions,
    Medicines,
    PrescriptionItems,
    Attachments,
    Services,
    Invoices,
    InvoiceItems,
    Payments,
    ExpenseCategories,
    Expenses,
    AuditEvents,
    AppSettings,
  ],
  daos: [ClinicProfileDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'clinic_manager'));

  /// Used by tests with an in-memory executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );

  /// Cheap structural check performed once at startup.
  Future<void> ensureHealthy() async {
    final rows = await customSelect('PRAGMA quick_check').get();
    final healthy =
        rows.isNotEmpty && rows.every((row) => row.data.values.first == 'ok');
    if (!healthy) {
      throw const DatabaseUnhealthyException(
        'SQLite quick_check reported corruption',
      );
    }
  }

  Future<void> logAudit({
    required String entityType,
    required String entityId,
    required AuditAction action,
    String? payloadJson,
  }) {
    return into(auditEvents).insert(
      AuditEventsCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        action: action,
        payloadJson: Value(payloadJson),
      ),
    );
  }
}
