// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Covers [child] while the app is locked and asks for authentication at
/// start and on return from background. With "block screenshots" on, the
/// content is also covered while the app is inactive, so the iOS app
/// switcher shows no data (SET-014).
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
  bool _inactive = false;

  /// An unlock is running: the system prompt is up, or the first start
  /// finds no account and opens without one. The cover then stays blank.
  bool _unlocking = false;

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
    setState(() => _inactive = state != AppLifecycleState.resumed);
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
    ref.read(secretStoreProvider).prompt = reason;
    setState(() => _unlocking = true);
    ref.read(appLockProvider.notifier).unlock(reason).whenComplete(() {
      if (mounted) setState(() => _unlocking = false);
    }).ignore();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appLockProvider);
    final secure = ref.watch(appSettingsProvider.select((s) => s.secureScreen));
    if (state == AppLockState.unlocked && !(secure && _inactive)) {
      return widget.child;
    }
    final l10n = AppLocalizations.of(context);
    if (_unlocking) return const Scaffold();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: switch (state) {
            AppLockState.unlocked => const SizedBox.shrink(),
            AppLockState.locked => ActionHint(
              icon: Icons.lock_outline,
              message: l10n.lockTitle,
              actionLabel: l10n.lockUnlock,
              onAction: _unlock,
            ),
            AppLockState.unavailable => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionHint(
                  icon: Icons.lock_open_outlined,
                  message: l10n.lockUnavailable,
                  actionLabel: l10n.commonRetry,
                  onAction: _unlock,
                ),
                TextButton(
                  onPressed: ref.read(appLockProvider.notifier).disable,
                  child: Text(l10n.lockContinueWithout),
                ),
              ],
            ),
          },
        ),
      ),
    );
  }
}
