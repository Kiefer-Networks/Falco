// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:async';

import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope_repository.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/secure/secret_store.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Covers [child] while the app is locked and asks for authentication at
/// start and when a return from background locked it. With "block
/// screenshots" on, the content is also covered while the app is away:
/// on iOS already when inactive, so the app switcher shows no data; on
/// Android FLAG_SECURE hides it there and only hidden or paused cover, so
/// a system dialog does not flash the cover (SET-014). While locked, back
/// (also the predictive gesture) never pops the pages below; the system
/// handles it. After the first unlock
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

  /// The app was hidden or paused and has not returned yet.
  bool _away = false;

  /// The return locked; the prompt waits for resumed.
  bool _askOnResume = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = ref.read(appLockProvider.notifier);
    setState(
      () => _inactive = switch (state) {
        AppLifecycleState.resumed => false,
        // Android passes inactive on the way back: covered until resumed.
        AppLifecycleState.inactive =>
          defaultTargetPlatform == TargetPlatform.iOS || _away,
        _ => true,
      },
    );
    switch (state) {
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        _away = true;
        lock.paused();
      case AppLifecycleState.inactive || AppLifecycleState.resumed:
        // The first state of the return decides, so the first frame
        // after the auto lock time already shows the cover. Only a return
        // that locked asks again: the resume that ends a cancelled prompt
        // leaves the Unlock button instead.
        if (_away) {
          _away = false;
          _askOnResume = lock.resumed();
        }
        if (state == AppLifecycleState.resumed && _askOnResume) {
          _askOnResume = false;
          _unlock();
        }
      case _:
    }
  }

  /// Back stays on the cover: the pages below must not pop while locked.
  @override
  Future<bool> didPopRoute() async => _locked;

  bool get _locked => ref.read(appLockProvider) != AppLockState.unlocked;

  /// What the navigator last reported about handling back.
  bool _canHandlePop = false;

  /// While locked the system handles back (Android leaves the app), so a
  /// predictive back gesture never reaches the pages below the cover.
  bool _onNavigation(NavigationNotification notification) {
    _canHandlePop = notification.canHandlePop;
    return _locked;
  }

  void _reportBack(bool locked) =>
      NavigationNotification(canHandlePop: !locked && _canHandlePop)
          .dispatch(context);

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
    ref.listen(
      appLockProvider.select((s) => s != AppLockState.unlocked),
      (_, locked) => _reportBack(locked),
    );
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
              child: ExcludeFocus(
                excluding: locked,
                child: NotificationListener<NavigationNotification>(
                  onNotification: _onNavigation,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
        ?cover,
      ],
    );
  }

  /// Its own messenger keeps snackbars of the pages off the cover.
  Widget _cover(AppLockState state) =>
      ScaffoldMessenger(child: _coverPage(state));

  Widget _coverPage(AppLockState state) {
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
