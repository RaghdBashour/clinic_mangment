/// Enumerations stored as text in SQLite through Drift's `textEnum`.
library;

enum Gender { male, female, other }

enum AppointmentStatus {
  scheduled,
  confirmed,
  waiting,
  inProgress,
  completed,
  noShow,
  cancelled,
}

enum AppointmentKind { newVisit, followUp, procedure, other }

enum VisitStatus { draft, completed }

enum InvoiceStatus { draft, unpaid, partial, paid, voided }

enum PaymentMethod { cash, card, transfer, other }

enum AttachmentKind { image, pdf, other }

enum AuditAction {
  create,
  update,
  archive,
  restore,
  delete,
  purge,
  amend,
  voidEntry,
}

enum NotificationStatus { scheduled, delivered, failed, cancelled }
