import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/l10n/app_localizations.dart';
import '../../core/widgets/empty_state.dart';

class PatientsPage extends ConsumerWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navPatients)),
      body: EmptyState(
        icon: Icons.people_outline,
        title: l10n.patientsEmptyTitle,
        message: l10n.patientsEmptyBody,
      ),
    );
  }
}
