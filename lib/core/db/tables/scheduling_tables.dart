import 'package:drift/drift.dart';

import '../enums.dart';
import 'patient_tables.dart';

@TableIndex(name: 'idx_appointments_starts_at', columns: {#startsAt})
@TableIndex(name: 'idx_appointments_patient', columns: {#patientId})
class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId =>
      integer().references(Patients, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startsAt => dateTime()();
  DateTimeColumn get endsAt => dateTime()();
  TextColumn get kind => textEnum<AppointmentKind>()();
  TextColumn get reason => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => textEnum<AppointmentStatus>()();
  IntColumn get feeMinor => integer().withDefault(const Constant(0))();
  IntColumn get reminderMinutes => integer().withDefault(const Constant(30))();
  TextColumn get scheduledNotificationIds => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

class NotificationLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get appointmentId => integer().nullable().references(
    Appointments,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get scheduledFor => dateTime()();
  TextColumn get kind => text().withLength(max: 40)();
  TextColumn get status => textEnum<NotificationStatus>()();
  TextColumn get error => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
