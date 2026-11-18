import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/l10n/app_localizations.dart';
import '../../core/widgets/empty_state.dart';

class BillingPage extends ConsumerWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navBilling)),
      body: EmptyState(
        icon: Icons.receipt_long_outlined,
        title: l10n.billingEmptyTitle,
        message: l10n.billingEmptyBody,
      ),
    );
  }
}
