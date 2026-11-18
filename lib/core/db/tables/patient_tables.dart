import 'package:drift/drift.dart';

import '../enums.dart';

@TableIndex(name: 'idx_patients_name', columns: {#fullName})
@TableIndex(name: 'idx_patients_phone', columns: {#phone})
class Patients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text().withLength(min: 1, max: 160)();
  TextColumn get phone => text().withLength(max: 40)();
  TextColumn get phoneAlt => text().nullable()();
  TextColumn get gender => textEnum<Gender>().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get allergies => text().nullable()();
  TextColumn get chronicConditions => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
