import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/l10n/app_localizations.dart';
import '../../app/session/session_controller.dart';
import '../../app/settings/settings_controller.dart';
import '../../core/providers/core_providers.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _pinController = TextEditingController();

  bool _biometricsAvailable = false;
  bool _busy = false;
  String? _error;
  int _attempts = 5;
  DateTime? _lockedUntil;
  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepare());
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  bool get _lockedOut =>
      _lockedUntil != null && DateTime.now().isBefore(_lockedUntil!);

  Future<void> _prepare() async {
    final available = await ref.read(biometricServiceProvider).isAvailable();
    if (!mounted) return;
    setState(() => _biometricsAvailable = available);
    if (available && ref.read(biometricsEnabledProvider)) {
      await _tryBiometrics();
    }
  }

  Future<void> _tryBiometrics() async {
    if (_busy || _lockedOut) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final success = await ref
        .read(biometricServiceProvider)
        .authenticate(reason: l10n.lockSubtitle);
    if (!mounted) return;
    if (success) {
      ref.read(sessionProvider.notifier).unlock();
      return;
    }
    setState(() => _busy = false);
  }

  Future<void> _submit() async {
    if (_busy || _lockedOut) return;
    final pin = _pinController.text;
    if (pin.isEmpty) return;

    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });

    final success = await ref.read(pinStoreProvider).verifyPin(pin);
    if (!mounted) return;
    if (success) {
      ref.read(sessionProvider.notifier).unlock();
      return;
    }

    _pinController.clear();
    setState(() {
      _busy = false;
      _attempts -= 1;
      if (_attempts <= 0) {
        _attempts = 5;
        _lockedUntil = DateTime.now().add(const Duration(seconds: 60));
        _error = null;
        _startLockoutTimer();
      } else {
        _error = l10n.lockWrongPin;
      }
    });
  }

  void _startLockoutTimer() {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (!_lockedOut) {
        timer.cancel();
        setState(() => _lockedUntil = null);
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final biometricsEnabled = ref.watch(biometricsEnabledProvider);
    final showBiometrics = biometricsEnabled && _biometricsAvailable;

    final remaining = _lockedUntil == null
        ? 0
        : _lockedUntil!.difference(DateTime.now()).inSeconds + 1;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 38,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.lockTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.lockSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _pinController,
                    autofocus: !showBiometrics,
                    enabled: !_lockedOut && !_busy,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (_) => _submit(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      letterSpacing: 12,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '••••',
                      errorText: _lockedOut
                          ? l10n.lockTooManyAttempts
                          : (_error ??
                                (_attempts < 5 && _attempts > 0
                                    ? l10n.lockAttemptsLeft(_attempts)
                                    : null)),
                    ),
                  ),
                  if (_lockedOut) ...[
                    const SizedBox(height: 8),
                    Text(
                      '$remaining s',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy || _lockedOut ? null : _submit,
                    child: _busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          )
                        : Text(l10n.lockUnlock),
                  ),
                  if (showBiometrics) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _busy || _lockedOut ? null : _tryBiometrics,
                      icon: const Icon(Icons.fingerprint),
                      label: Text(l10n.lockUseBiometrics),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
