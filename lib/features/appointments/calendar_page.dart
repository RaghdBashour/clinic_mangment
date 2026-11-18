import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/l10n/app_localizations.dart';
import '../../core/widgets/empty_state.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCalendar)),
      body: EmptyState(
        icon: Icons.calendar_month_outlined,
        title: l10n.calendarEmptyTitle,
        message: l10n.calendarEmptyBody,
      ),
    );
  }
}
