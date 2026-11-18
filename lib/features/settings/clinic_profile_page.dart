import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/l10n/app_localizations.dart';
import '../../core/db/app_database.dart';
import '../../core/db/enums.dart';
import '../../core/providers/core_providers.dart';
import '../../core/utils/currencies.dart';

class ClinicProfilePage extends ConsumerStatefulWidget {
  const ClinicProfilePage({super.key});

  @override
  ConsumerState<ClinicProfilePage> createState() => _ClinicProfilePageState();
}

class _ClinicProfilePageState extends ConsumerState<ClinicProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _clinicName = TextEditingController();
  final _doctorName = TextEditingController();
  final _specialty = TextEditingController();
  final _phone = TextEditingController();

  String _currency = 'SYP';
  int _slotMinutes = 30;
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _clinicName.dispose();
    _doctorName.dispose();
    _specialty.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _applyProfile(ClinicProfile profile) {
    _clinicName.text = profile.name;
    _doctorName.text = profile.doctorName;
    _specialty.text = profile.specialty ?? '';
    _phone.text = profile.phone ?? '';
    _currency = profile.currencyCode;
    _slotMinutes = profile.slotMinutes;
    _loaded = true;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);

    try {
      final database = ref.read(databaseProvider);
      await database.clinicProfileDao.saveProfile(
        ClinicProfilesCompanion(
          name: Value(_clinicName.text.trim()),
          doctorName: Value(_doctorName.text.trim()),
          specialty: Value(_nullIfEmpty(_specialty.text)),
          phone: Value(_nullIfEmpty(_phone.text)),
          currencyCode: Value(_currency),
          slotMinutes: Value(_slotMinutes),
        ),
      );
      final profile = ref.read(clinicProfileProvider).value;
      await database.logAudit(
        entityType: 'clinic_profile',
        entityId: '${profile?.id ?? 1}',
        action: AuditAction.update,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.clinicProfileSaved)));
      context.pop();
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
    final profileAsync = ref.watch(clinicProfileProvider);
    final profile = profileAsync.value;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settingsClinicProfile)),
        body: Center(
          child: profileAsync.hasError
              ? Text(l10n.dbInitError)
              : const CircularProgressIndicator(),
        ),
      );
    }

    if (!_loaded) _applyProfile(profile);

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    String? requiredValidator(String? value) =>
        (value == null || value.trim().isEmpty)
        ? l10n.validationRequired
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsClinicProfile)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            TextFormField(
              controller: _clinicName,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.onboardingClinicName),
              validator: requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _doctorName,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.onboardingDoctorName),
              validator: requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specialty,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.onboardingSpecialty),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.onboardingPhone),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _currency,
              decoration: InputDecoration(labelText: l10n.onboardingCurrency),
              items: [
                for (final option in supportedCurrencies)
                  DropdownMenuItem(
                    value: option.code,
                    child: Text(option.label(isArabic)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _currency = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _slotMinutes,
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
              onChanged: (value) {
                if (value != null) setState(() => _slotMinutes = value);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : Text(l10n.actionSave),
          ),
        ),
      ),
    );
  }
}
