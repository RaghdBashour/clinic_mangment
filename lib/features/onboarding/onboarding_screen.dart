import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/l10n/app_localizations.dart';
import '../../app/session/session_controller.dart';
import '../../core/db/app_database.dart';
import '../../core/db/enums.dart';
import '../../core/providers/core_providers.dart';
import '../../core/utils/currencies.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _detailsFormKey = GlobalKey<FormState>();
  final _securityFormKey = GlobalKey<FormState>();

  final _clinicName = TextEditingController();
  final _doctorName = TextEditingController();
  final _specialty = TextEditingController();
  final _phone = TextEditingController();
  final _pin = TextEditingController();
  final _pinConfirm = TextEditingController();

  int _page = 0;
  String _currency = 'SYP';
  int _slotMinutes = 30;
  bool _biometricsAvailable = false;
  bool _biometricsEnabled = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final available = await ref.read(biometricServiceProvider).isAvailable();
      if (mounted) {
        setState(() => _biometricsAvailable = available);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _clinicName.dispose();
    _doctorName.dispose();
    _specialty.dispose();
    _phone.dispose();
    _pin.dispose();
    _pinConfirm.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    setState(() => _page = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_page == 0) {
      _goToPage(1);
      return;
    }
    if (_page == 1) {
      if (_detailsFormKey.currentState?.validate() ?? false) {
        _goToPage(2);
      }
      return;
    }
    _finish();
  }

  Future<void> _finish() async {
    if (_saving) return;
    if (!(_securityFormKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    setState(() => _saving = true);

    try {
      final database = ref.read(databaseProvider);
      final profileId = await database.clinicProfileDao.saveProfile(
        ClinicProfilesCompanion.insert(
          name: _clinicName.text.trim(),
          doctorName: _doctorName.text.trim(),
          currencyCode: _currency,
          specialty: Value(_nullIfEmpty(_specialty.text)),
          phone: Value(_nullIfEmpty(_phone.text)),
          slotMinutes: Value(_slotMinutes),
          documentLanguage: Value(isArabic ? 'ar' : 'en'),
        ),
      );
      await database.logAudit(
        entityType: 'clinic_profile',
        entityId: '$profileId',
        action: AuditAction.create,
      );

      final pin = _pin.text;
      if (pin.isNotEmpty) {
        await ref.read(pinStoreProvider).setPin(pin);
        if (_biometricsEnabled) {
          await ref.read(preferencesProvider).setBiometricsEnabled(true);
        }
      }

      await ref
          .read(sessionProvider.notifier)
          .completeOnboarding(securityEnabled: pin.isNotEmpty);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.genericError)));
    }
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: _page == 0
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: () => _goToPage(_page - 1),
                            icon: const Icon(Icons.arrow_back),
                            tooltip: l10n.actionBack,
                          ),
                  ),
                  const Spacer(),
                  _StepDots(current: _page, count: 3),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  _WelcomePage(l10n: l10n),
                  _ClinicDetailsPage(
                    formKey: _detailsFormKey,
                    clinicName: _clinicName,
                    doctorName: _doctorName,
                    specialty: _specialty,
                    phone: _phone,
                    currency: _currency,
                    slotMinutes: _slotMinutes,
                    onCurrencyChanged: (value) {
                      if (value != null) setState(() => _currency = value);
                    },
                    onSlotChanged: (value) {
                      if (value != null) setState(() => _slotMinutes = value);
                    },
                    isArabic: isArabic,
                  ),
                  _SecurityPage(
                    formKey: _securityFormKey,
                    pin: _pin,
                    pinConfirm: _pinConfirm,
                    biometricsAvailable: _biometricsAvailable,
                    biometricsEnabled: _biometricsEnabled,
                    onBiometricsChanged: (value) =>
                        setState(() => _biometricsEnabled = value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                children: [
                  if (_page == 2 && _pin.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        l10n.onboardingPinOptional,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  FilledButton(
                    onPressed: _saving ? null : _next,
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          )
                        : Text(
                            _page == 2
                                ? l10n.onboardingFinish
                                : l10n.actionContinue,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.current, required this.count});

  final int current;
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final active = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? scheme.primary : scheme.outlineVariant,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              size: 48,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.onboardingWelcomeTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingWelcomeBody,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicDetailsPage extends StatelessWidget {
  const _ClinicDetailsPage({
    required this.formKey,
    required this.clinicName,
    required this.doctorName,
    required this.specialty,
    required this.phone,
    required this.currency,
    required this.slotMinutes,
    required this.onCurrencyChanged,
    required this.onSlotChanged,
    required this.isArabic,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController clinicName;
  final TextEditingController doctorName;
  final TextEditingController specialty;
  final TextEditingController phone;
  final String currency;
  final int slotMinutes;
  final ValueChanged<String?> onCurrencyChanged;
  final ValueChanged<int?> onSlotChanged;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    String? requiredValidator(String? value) =>
        (value == null || value.trim().isEmpty)
        ? l10n.validationRequired
        : null;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.onboardingClinicTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.onboardingClinicSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: clinicName,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.onboardingClinicName),
              validator: requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: doctorName,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.onboardingDoctorName),
              validator: requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: specialty,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.onboardingSpecialty),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.onboardingPhone),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: currency,
              decoration: InputDecoration(labelText: l10n.onboardingCurrency),
              items: [
                for (final option in supportedCurrencies)
                  DropdownMenuItem(
                    value: option.code,
                    child: Text(option.label(isArabic)),
                  ),
              ],
              onChanged: onCurrencyChanged,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: slotMinutes,
              decoration: InputDecoration(
                labelText: l10n.onboardingSlotDuration,
              ),
              items: [
                for (final minutes in const [10, 15, 20, 30, 45, 60])
                  DropdownMenuItem(
                    value: minutes,
                    child: Text(l10n.onboardingMinutes(minutes)),
                  ),
              ],
              onChanged: onSlotChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityPage extends StatelessWidget {
  const _SecurityPage({
    required this.formKey,
    required this.pin,
    required this.pinConfirm,
    required this.biometricsAvailable,
    required this.biometricsEnabled,
    required this.onBiometricsChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController pin;
  final TextEditingController pinConfirm;
  final bool biometricsAvailable;
  final bool biometricsEnabled;
  final ValueChanged<bool> onBiometricsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    String? pinValidator(String? value) {
      final text = value ?? '';
      if (text.isEmpty) {
        return biometricsEnabled ? l10n.validationRequired : null;
      }
      if (text.length < 4) return l10n.validationPinTooShort;
      return null;
    }

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.onboardingSecurityTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.onboardingSecurityBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: pin,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.onboardingPin,
                helperText: l10n.onboardingPinHint,
                counterText: '',
              ),
              validator: pinValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: pinConfirm,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.onboardingPinConfirm,
                counterText: '',
              ),
              validator: (value) {
                if (pin.text.isEmpty) return null;
                if (value != pin.text) return l10n.validationPinMismatch;
                return null;
              },
            ),
            const SizedBox(height: 8),
            if (biometricsAvailable)
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: biometricsEnabled,
                title: Text(l10n.onboardingEnableBiometrics),
                onChanged: onBiometricsChanged,
              ),
            const SizedBox(height: 8),
            Text(
              l10n.settingsDataLocal,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
