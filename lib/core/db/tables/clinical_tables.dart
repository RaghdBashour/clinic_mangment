import 'package:drift/drift.dart';

import '../enums.dart';
import 'patient_tables.dart';
import 'scheduling_tables.dart';

@TableIndex(name: 'idx_visits_patient', columns: {#patientId})
@TableIndex(name: 'idx_visits_date', columns: {#visitedAt})
class Visits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId =>
      integer().references(Patients, #id, onDelete: KeyAction.cascade)();
  IntColumn get appointmentId => integer().nullable().references(
    Appointments,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get visitedAt => dateTime()();
  TextColumn get chiefComplaint => text().nullable()();
  TextColumn get history => text().nullable()();
  TextColumn get examination => text().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get temperatureC => real().nullable()();
  IntColumn get systolic => integer().nullable()();
  IntColumn get diastolic => integer().nullable()();
  IntColumn get pulse => integer().nullable()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get heightCm => real().nullable()();
  DateTimeColumn get followUpOn => dateTime().nullable()();
  TextColumn get status => textEnum<VisitStatus>()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Finalized visits are append-only. Every edit stores a snapshot here.
class VisitRevisions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId =>
      integer().references(Visits, #id, onDelete: KeyAction.cascade)();
  IntColumn get revisionNo => integer()();
  TextColumn get snapshotJson => text()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

class Medicines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 160)();
  TextColumn get form => text().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get defaultDose => text().nullable()();
  TextColumn get defaultFrequency => text().nullable()();
  IntColumn get defaultDurationDays => integer().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

class PrescriptionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get visitId =>
      integer().references(Visits, #id, onDelete: KeyAction.cascade)();
  TextColumn get medicineName => text().withLength(min: 1, max: 160)();
  TextColumn get form => text().nullable()();
  TextColumn get dose => text().nullable()();
  TextColumn get frequency => text().nullable()();
  IntColumn get durationDays => integer().nullable()();
  IntColumn get quantity => integer().nullable()();
  TextColumn get instructions => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@TableIndex(name: 'idx_attachments_patient', columns: {#patientId})
class Attachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId =>
      integer().references(Patients, #id, onDelete: KeyAction.cascade)();
  IntColumn get visitId => integer().nullable().references(
    Visits,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get kind => textEnum<AttachmentKind>()();

  /// Relative to the app documents directory so restores keep working.
  TextColumn get storagePath => text()();
  TextColumn get originalName => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  TextColumn get caption => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
