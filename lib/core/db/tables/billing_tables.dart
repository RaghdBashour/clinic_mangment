import 'package:drift/drift.dart';

import '../enums.dart';
import 'clinical_tables.dart';
import 'patient_tables.dart';

class Services extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  IntColumn get priceMinor => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@TableIndex(name: 'idx_invoices_patient', columns: {#patientId})
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get patientId =>
      integer().references(Patients, #id, onDelete: KeyAction.cascade)();
  IntColumn get visitId => integer().nullable().references(
    Visits,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get subtotalMinor => integer().withDefault(const Constant(0))();
  IntColumn get discountMinor => integer().withDefault(const Constant(0))();
  IntColumn get totalMinor => integer().withDefault(const Constant(0))();
  TextColumn get status => textEnum<InvoiceStatus>()();
  DateTimeColumn get issuedAt => dateTime()();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  TextColumn get voidReason => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId =>
      integer().references(Invoices, #id, onDelete: KeyAction.cascade)();
  IntColumn get serviceId => integer().nullable().references(
    Services,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get description => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get unitPriceMinor => integer().withDefault(const Constant(0))();
  IntColumn get lineTotalMinor => integer().withDefault(const Constant(0))();
}

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId =>
      integer().references(Invoices, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountMinor => integer()();
  TextColumn get method => textEnum<PaymentMethod>()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80).unique()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

@TableIndex(name: 'idx_expenses_date', columns: {#spentOn})
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().nullable().references(
    ExpenseCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get amountMinor => integer()();
  DateTimeColumn get spentOn => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
