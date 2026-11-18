# AGENTS.md

Offline, single-user Android clinic app (Flutter + Drift). Arabic-first RTL with
an English toggle. Milestone scope and acceptance criteria live in
`~/.opencode/plan/clinic-manager.md` — read it before starting a milestone.

## Commands

Flutter is **not on `PATH`** (installed at `~/development/flutter`).

```bash
export PATH="$HOME/development/flutter/bin:$PATH"
flutter analyze
flutter test                                  # whole suite
flutter test test/core/db/app_database_test.dart   # single file
dart format lib test
```

Order after codegen changes: `build_runner`/`gen-l10n` → `flutter analyze` → `flutter test`.

## Codegen (run after the matching edits)

```bash
dart run build_runner build     # any Drift table/DAO change
flutter gen-l10n                # any ARB change (or `flutter run` does it)
```

- Never hand-edit `lib/core/db/**/*.g.dart` or `lib/app/l10n/app_localizations*.dart`;
  they are regenerated and l10n files are analyzer-excluded.
- Adding a UI string: add the key to `lib/app/l10n/app_en.arb` first (template),
  then `app_ar.arb`, then `gen-l10n`. Do not hardcode user-visible English/Arabic
  in widgets.

## Architecture

- `lib/main.dart` → `ClinicApp` (`lib/app/app.dart`): waits on
  `bootstrapProvider`, then `MaterialApp.router`.
- `lib/core/bootstrap.dart` opens the DB and prefs; `core_providers.dart`
  exposes them. Anything needing the DB must read those providers, not
  construct its own.
- Router: `StatefulShellRoute` with 5 branches (`/today`, `/patients`,
  `/calendar`, `/billing`, `/settings`); onboarding/lock are top-level and
  enforced by a redirect driven by `sessionProvider`.
- State: Riverpod `Notifier` controllers (`session`, `settings`) plus
  `StreamProvider`s over Drift watches (`clinicProfileProvider`).
- Money and dates in UI go through `lib/core/utils/formatters.dart`.

## Gotchas

- Use `package:material_ui/material_ui.dart`, **not** `package:flutter/material.dart`
  (Material was extracted; the old import only produces deprecation warnings).
- Riverpod 3: read async state with `.value`; `.valueOrNull` does not exist.
- `AppLocalizations.of(context)` is non-null (`nullable-getter: false`).
- DB: monetary columns are integer minor units named `*Minor`; timestamps are
  UTC. Deletion is soft: `archivedAt` / `deletedAt` / `voidedAt` columns —
  filter them out in list queries, don't `DELETE` rows unless the plan says so.
- Finished visits are append-only: write a `VisitRevisions` row instead of
  editing visit content. Record mutations via `database.logAudit(...)`.
- After adding a table, register it in `@DriftDatabase(tables: [...])` in
  `lib/core/db/app_database.dart`; bump `schemaVersion` + add a migration once
  v1 has shipped (v1 is still the only schema).
- Tests: DB tests use `AppDatabase.forTesting(NativeDatabase.memory())` in
  `setUp` and `await database.close()` in `tearDown`. Widget tests override
  `bootstrapProvider` with a hand-built `AppBootstrap` and call
  `SharedPreferences.setMockInitialValues({})`.

## Environment

- No Android SDK or JDK on this machine: APK/AAB builds and emulator runs are
  impossible here. Verify with `flutter analyze` + `flutter test` only.
- Tests load the **system** SQLite because `pubspec.yaml` sets an absolute
  `hooks.user_defines.sqlite3.name.linux` path
  (`/lib/x86_64-linux-gnu/libsqlite3.so.0`). On another Linux host, fix that
  path instead of removing the hook.
- Android: `applicationId`/namespace `com.clinicmanager.app`, minSdk 24,
  `MainActivity extends FlutterFragmentActivity` (required by `local_auth`).
  Only the debug manifest declares `INTERNET`; the release manifest must stay
  free of internet/storage/camera permissions — do not add networking deps.
- Not a git repository; there is no commit/PR flow to follow.
