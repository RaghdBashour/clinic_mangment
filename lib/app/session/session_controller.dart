import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/core_providers.dart';

class SessionState {
  const SessionState({
    required this.onboardingComplete,
    required this.securityEnabled,
    required this.locked,
  });

  final bool onboardingComplete;
  final bool securityEnabled;
  final bool locked;

  SessionState copyWith({
    bool? onboardingComplete,
    bool? securityEnabled,
    bool? locked,
  }) {
    return SessionState(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      securityEnabled: securityEnabled ?? this.securityEnabled,
      locked: locked ?? this.locked,
    );
  }
}

class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() {
    final preferences = ref.watch(preferencesProvider);
    final onboardingComplete = preferences.onboardingComplete;
    final securityEnabled = preferences.securityEnabled;
    return SessionState(
      onboardingComplete: onboardingComplete,
      securityEnabled: securityEnabled,
      locked: onboardingComplete && securityEnabled,
    );
  }

  Future<void> completeOnboarding({required bool securityEnabled}) async {
    final preferences = ref.read(preferencesProvider);
    await preferences.setOnboardingComplete(true);
    await preferences.setSecurityEnabled(securityEnabled);
    state = SessionState(
      onboardingComplete: true,
      securityEnabled: securityEnabled,
      locked: false,
    );
  }

  Future<void> setSecurityEnabled(bool enabled) async {
    await ref.read(preferencesProvider).setSecurityEnabled(enabled);
    state = state.copyWith(
      securityEnabled: enabled,
      locked: enabled ? state.locked : false,
    );
  }

  void lock() {
    if (state.securityEnabled) {
      state = state.copyWith(locked: true);
    }
  }

  void unlock() {
    state = state.copyWith(locked: false);
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);
