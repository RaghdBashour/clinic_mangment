import 'package:drift/drift.dart';

import '../enums.dart';

class AuditEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text().withLength(min: 1, max: 40)();
  TextColumn get entityId => text()();
  TextColumn get action => textEnum<AuditAction>()();
  TextColumn get payloadJson => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

class AppSettings extends Table {
  TextColumn get settingKey => text().withLength(min: 1, max: 80)();
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}
