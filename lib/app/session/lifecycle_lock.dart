import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers/core_providers.dart';
import 'session_controller.dart';

/// Locks the session when the app returns from the background.
class LifecycleLock extends ConsumerStatefulWidget {
  const LifecycleLock({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<LifecycleLock> createState() => _LifecycleLockState();
}

class _LifecycleLockState extends ConsumerState<LifecycleLock>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
      return;
    }
    if (state != AppLifecycleState.resumed) return;

    final backgroundedAt = _backgroundedAt;
    _backgroundedAt = null;
    if (backgroundedAt == null) return;

    final timeout = ref.read(preferencesProvider).lockAfterSeconds;
    if (DateTime.now().difference(backgroundedAt).inSeconds >= timeout) {
      ref.read(sessionProvider.notifier).lock();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
