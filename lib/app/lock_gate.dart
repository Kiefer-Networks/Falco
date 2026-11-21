// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Covers [child] while the app is locked and asks for authentication at
/// start and when a return from background locked it. With "block
/// screenshots" on, the content is also covered while the app is inactive,
/// so the iOS app switcher shows no data (SET-014). After the first unlock
/// [child] stays mounted below the cover: pages, forms and sheets survive.
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

  /// The app was unlocked once; from then on [LockGate.child] stays.
  bool _opened = false;

  /// An unlock is running: the system prompt is up, or the first start
  /// finds no account and opens without one. The cover then stays blank.
  bool _unlocking = false;

  late final SecretStore _secrets = ref.read(secretStoreProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _secrets.lost.addListener(_onLost);
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  @override
  void dispose() {
    _secrets.lost.removeListener(_onLost);
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
      // Only a return that locked asks again: the resume that ends a
      // cancelled prompt leaves the Unlock button instead.
      case AppLifecycleState.resumed:
        if (lock.resumed()) _unlock();
      case _:
    }
  }

  void _unlock() {
    if (!mounted) return;
    final reason = AppLocalizations.of(context).lockReason;
    _secrets.prompt = reason;
    setState(() => _unlocking = true);
    ref.read(appLockProvider.notifier).unlock(reason).whenComplete(() {
      if (mounted) setState(() => _unlocking = false);
      _onLost();
    }).ignore();
  }

  void _onLost() => unawaited(_reportLost());

  /// Names the accounts whose access data the system deleted, once the
  /// app is unlocked.
  Future<void> _reportLost() async {
    final keys = _secrets.lost.value;
    if (keys.isEmpty || ref.read(appLockProvider) != AppLockState.unlocked) {
      return;
    }
    _secrets.lost.value = const {};
    final ids = {for (final k in keys) k.substring(k.indexOf('.') + 1)};
    final accounts = await ref.read(scopeRepositoryProvider).accounts();
    final names = [
      for (final a in accounts)
        if (ids.contains(a.id) || a.projects.any((p) => ids.contains(p.id)))
          a.name,
    ];
    final context = ref
        .read(routerProvider)
        .routerDelegate
        .navigatorKey
        .currentContext;
    if (names.isEmpty || context == null || !context.mounted) return;
    final l10n = AppLocalizations.of(context);
    await showFalcoSheet<void>(
      context,
      SheetFrame(
        title: l10n.vaultLostTitle,
        children: [
          Text(l10n.vaultLostMessage(names.join(', '))),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appLockProvider);
    final secure = ref.watch(appSettingsProvider.select((s) => s.secureScreen));
    final locked = state != AppLockState.unlocked;
    final covered = locked || (secure && _inactive);
    _opened |= !locked;
    final cover = covered ? _cover(state) : null;
    if (!_opened) return cover!;
    return Stack(
      fit: StackFit.expand,
      children: [
        TickerMode(
          enabled: !covered,
          child: ExcludeSemantics(
            excluding: covered,
            child: IgnorePointer(
              ignoring: covered,
              // Keyboard input stays with the page only while unlocked.
              child: ExcludeFocus(excluding: locked, child: widget.child),
            ),
          ),
        ),
        ?cover,
      ],
    );
  }

  Widget _cover(AppLockState state) {
    if (_unlocking) return const Scaffold();
    final l10n = AppLocalizations.of(context);
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
