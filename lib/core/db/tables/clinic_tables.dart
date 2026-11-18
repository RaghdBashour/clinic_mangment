import 'package:drift/drift.dart';

/// The clinic owns exactly one profile row (id = 1).
class ClinicProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 160)();
  TextColumn get doctorName => text().withLength(min: 1, max: 160)();
  TextColumn get specialty => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  TextColumn get documentLanguage => text().withDefault(const Constant('ar'))();
  IntColumn get slotMinutes => integer().withDefault(const Constant(30))();
  TextColumn get workHoursJson => text().nullable()();
  TextColumn get logoPath => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
