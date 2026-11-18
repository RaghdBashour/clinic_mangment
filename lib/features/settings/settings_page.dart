import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/l10n/app_localizations.dart';
import '../../app/session/session_controller.dart';
import '../../app/settings/settings_controller.dart';
import '../../core/app_info.dart';
import '../../core/db/app_database.dart';
import '../../core/providers/core_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final session = ref.watch(sessionProvider);
    final profile = ref.watch(clinicProfileProvider).value;
    final pinConfigured = ref.watch(pinConfiguredProvider).value ?? false;
    final biometricsEnabled = ref.watch(biometricsEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          _ClinicHeader(
            profile: profile,
            fallbackName: l10n.appName,
            onTap: () => context.push('/settings/profile'),
          ),
          const SizedBox(height: 22),
          _SectionLabel(title: l10n.settingsLanguageAppearance),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(l10n.settingsLanguage),
                  subtitle: Text(_languageLabel(l10n, settings.languageCode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final choice = await _showChoiceDialog<String>(
                      context,
                      title: l10n.settingsLanguage,
                      current: settings.languageCode ?? 'system',
                      options: [
                        (value: 'system', label: l10n.languageSystem),
                        (value: 'ar', label: l10n.languageArabic),
                        (value: 'en', label: l10n.languageEnglish),
                      ],
                    );
                    if (choice == null) return;
                    await ref
                        .read(settingsProvider.notifier)
                        .setLanguage(choice == 'system' ? null : choice);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text(l10n.settingsTheme),
                  subtitle: Text(_themeLabel(l10n, settings.themeMode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final choice = await _showChoiceDialog<ThemeMode>(
                      context,
                      title: l10n.settingsTheme,
                      current: settings.themeMode,
                      options: [
                        (value: ThemeMode.system, label: l10n.themeSystem),
                        (value: ThemeMode.light, label: l10n.themeLight),
                        (value: ThemeMode.dark, label: l10n.themeDark),
                      ],
                    );
                    if (choice == null) return;
                    await ref
                        .read(settingsProvider.notifier)
                        .setThemeMode(choice);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SectionLabel(title: l10n.settingsSecurity),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.pin_outlined),
                  title: Text(
                    pinConfigured
                        ? l10n.settingsChangePin
                        : l10n.settingsSetPin,
                  ),
                  subtitle: Text(
                    pinConfigured
                        ? l10n.settingsPinSet
                        : l10n.settingsPinNotSet,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editPin(context, ref, hasPin: pinConfigured),
                ),
                if (pinConfigured) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_open_outlined),
                    title: Text(l10n.settingsRemovePin),
                    onTap: () => _removePin(context, ref),
                  ),
                ],
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.fingerprint),
                  title: Text(l10n.settingsBiometrics),
                  value: biometricsEnabled,
                  onChanged: pinConfigured
                      ? (value) => _toggleBiometrics(context, ref, value)
                      : null,
                ),
                if (session.securityEnabled) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: Text(l10n.settingsLockNow),
                    onTap: () => ref.read(sessionProvider.notifier).lock(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SectionLabel(title: l10n.settingsNotifications),
          Card(
            child: ListTile(
              enabled: false,
              leading: const Icon(Icons.notifications_outlined),
              title: Text(l10n.settingsNotifications),
              subtitle: Text(l10n.settingsComingSoon),
            ),
          ),
          const SizedBox(height: 22),
          _SectionLabel(title: l10n.settingsBackup),
          Card(
            child: ListTile(
              enabled: false,
              leading: const Icon(Icons.cloud_off_outlined),
              title: Text(l10n.settingsBackup),
              subtitle: Text(l10n.settingsComingSoon),
            ),
          ),
          const SizedBox(height: 22),
          _SectionLabel(title: l10n.settingsAbout),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.appName),
                  subtitle: Text(l10n.settingsVersion(appVersion)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: Text(
                    l10n.settingsDataLocal,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _languageLabel(AppLocalizations l10n, String? code) {
    return switch (code) {
      'ar' => l10n.languageArabic,
      'en' => l10n.languageEnglish,
      _ => l10n.languageSystem,
    };
  }

  String _themeLabel(AppLocalizations l10n, ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
      ThemeMode.system => l10n.themeSystem,
    };
  }

  Future<void> _toggleBiometrics(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (value) {
      final available = await ref.read(biometricServiceProvider).isAvailable();
      if (!available) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.biometricsUnavailable)));
        return;
      }
    }
    await ref
        .read(biometricsEnabledProvider.notifier)
        .setBiometricsEnabled(value);
  }

  Future<void> _editPin(
    BuildContext context,
    WidgetRef ref, {
    required bool hasPin,
  }) async {
    final l10n = AppLocalizations.of(context);
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PinDialog(hasPin: hasPin),
    );
    if (saved == true) {
      ref.invalidate(pinConfiguredProvider);
      await ref.read(sessionProvider.notifier).setSecurityEnabled(true);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.pinSaved)));
    }
  }

  Future<void> _removePin(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final removed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _RemovePinDialog(),
    );
    if (removed == true) {
      await ref.read(preferencesProvider).setBiometricsEnabled(false);
      await ref.read(sessionProvider.notifier).setSecurityEnabled(false);
      ref.invalidate(pinConfiguredProvider);
      ref.invalidate(biometricsEnabledProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.pinRemoved)));
    }
  }
}

class _ClinicHeader extends StatelessWidget {
  const _ClinicHeader({
    required this.profile,
    required this.fallbackName,
    required this.onTap,
  });

  final ClinicProfile? profile;
  final String fallbackName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = profile?.name ?? '';
    final initial = name.trim().isEmpty ? '?' : name.trim().substring(0, 1);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  initial,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? fallbackName : name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (profile?.doctorName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        profile!.doctorName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (profile?.phone != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        profile!.phone!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.edit_outlined),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Future<T?> _showChoiceDialog<T>(
  BuildContext context, {
  required String title,
  required T current,
  required List<({T value, String label})> options,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(title),
        children: [
          for (final option in options)
            ListTile(
              title: Text(option.label),
              trailing: option.value == current
                  ? const Icon(Icons.check, size: 20)
                  : null,
              onTap: () => Navigator.of(context).pop(option.value),
            ),
        ],
      );
    },
  );
}

class _PinDialog extends ConsumerStatefulWidget {
  const _PinDialog({required this.hasPin});

  final bool hasPin;

  @override
  ConsumerState<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends ConsumerState<_PinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _newPin = TextEditingController();
  final _confirm = TextEditingController();

  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _newPin.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });

    final store = ref.read(pinStoreProvider);
    if (widget.hasPin) {
      final valid = await store.verifyPin(_current.text);
      if (!valid) {
        if (!mounted) return;
        setState(() {
          _saving = false;
          _error = l10n.lockWrongPin;
        });
        return;
      }
    }

    await store.setPin(_newPin.text);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String? pinValidator(String? value) {
      final pin = value ?? '';
      if (pin.isEmpty) return l10n.validationRequired;
      if (pin.length < 4) return l10n.validationPinTooShort;
      return null;
    }

    return AlertDialog(
      title: Text(widget.hasPin ? l10n.settingsChangePin : l10n.settingsSetPin),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.hasPin) ...[
                TextFormField(
                  controller: _current,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.currentPin,
                    counterText: '',
                    errorText: _error,
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? l10n.validationRequired
                      : null,
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _newPin,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l10n.newPin,
                  counterText: '',
                ),
                validator: pinValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirm,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l10n.onboardingPinConfirm,
                  counterText: '',
                ),
                validator: (value) =>
                    value == _newPin.text ? null : l10n.validationPinMismatch,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.actionSave),
        ),
      ],
    );
  }
}

class _RemovePinDialog extends ConsumerStatefulWidget {
  const _RemovePinDialog();

  @override
  ConsumerState<_RemovePinDialog> createState() => _RemovePinDialogState();
}

class _RemovePinDialogState extends ConsumerState<_RemovePinDialog> {
  final _pin = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _remove() async {
    if (_pin.text.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final store = ref.read(pinStoreProvider);
    final valid = await store.verifyPin(_pin.text);
    if (!valid) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l10n.lockWrongPin;
      });
      return;
    }
    await store.clearPin();
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.settingsRemovePin),
      content: TextField(
        controller: _pin,
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: 6,
        autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: l10n.currentPin,
          counterText: '',
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: _busy ? null : _remove,
          child: Text(l10n.settingsRemovePin),
        ),
      ],
    );
  }
}
