# Clinic Manager

Offline, single-user clinic management for Android. Arabic-first (RTL) with an
English toggle. All patient data stays on the device — the app declares no
internet, storage or camera permission.

## Status

**M0 — foundation complete.**

- Flutter 3.50 / Dart 3.14, Material 3 via `package:material_ui`
- App identity: `Clinic Manager` / `com.clinicmanager.app`
- Drift (SQLite) schema v1: clinic profile, patients, appointments, visits,
  visit revisions, prescriptions, medicines, services, invoices, payments,
  expenses, attachments, audit log, notification log, settings
- Arabic + English localization (ARB), RTL, locale-aware dates and money
- Onboarding: clinic details, currency, slot length, optional PIN
- PIN lock (salted/iterated hash in secure storage) with biometrics and
  lock-on-background
- Navigation shell: Today, Patients, Calendar, Billing, Settings
- Settings: language, theme, PIN management, biometrics, lock now, clinic
  profile editing
- Startup integrity check (`PRAGMA quick_check`) and an error screen with retry

Next milestone: **M1 — patients, history timeline, archive/trash/restore.**

## Structure

```
lib/
  app/       app root, router, shell, theme, session, settings, l10n
  core/      bootstrap, db (tables/DAOs), prefs, security, utils, widgets
  features/  onboarding, lock, dashboard, patients, appointments, billing, settings
```

## Commands

Flutter is installed at `~/development/flutter` and is not on `PATH` by default.

```bash
export PATH="$HOME/development/flutter/bin:$PATH"
flutter pub get
dart run build_runner build        # after changing Drift tables
flutter gen-l10n                   # after changing ARB files
flutter analyze
flutter test
```

## Notes

- Tests use the Linux system SQLite through the `sqlite3` build hook (see
  `hooks:` in `pubspec.yaml`). That absolute path is specific to this
  development machine (`/lib/x86_64-linux-gnu/libsqlite3.so.0`); adjust it if
  tests fail on another Linux host. Android builds use the pinned bundled
  SQLite binary.
- The Android SDK is not configured on this machine, so APK/AAB builds and
  emulator runs must happen on a machine with Android Studio/SDK installed.
- The full product plan lives at `~/.opencode/plan/clinic-manager.md`.
