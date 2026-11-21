// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Covers [child] while the app is locked and asks for authentication at
/// start and on return from background.
class LockGate extends ConsumerStatefulWidget {
  /// Creates the gate.
  const new({required this.child, super.key});

  /// The app.
  final Widget child;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = ref.read(appLockProvider.notifier);
    switch (state) {
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        lock.paused();
      case AppLifecycleState.resumed:
        lock.resumed();
        _unlock();
      case _:
    }
  }

  void _unlock() {
    if (!mounted) return;
    final reason = AppLocalizations.of(context).lockReason;
    ref.read(appLockProvider.notifier).unlock(reason).ignore();
  }

  @override
  Widget build(BuildContext context) {
    final locked = ref.watch(appLockProvider);
    if (!locked) return widget.child;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: EmptyHint(
          message: l10n.lockTitle,
          actionLabel: l10n.lockUnlock,
          onAction: _unlock,
        ),
      ),
    );
  }
}
