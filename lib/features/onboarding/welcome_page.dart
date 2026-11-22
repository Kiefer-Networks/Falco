// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:math';

import 'package:falco/app/router.dart';
import 'package:falco/core/permissions/notifications.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/settings/settings_page.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// First start without an account: language, what Falco does, security,
/// permissions, start (ONB-001 to ONB-006, SET-024).
class WelcomePage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  static const _pages = 5;
  static const _permissions = 3;
  int _page = 0;

  /// The permission request runs; a second tap waits for it.
  bool _busy = false;

  void _addAccount() => const SetupRoute().push<void>(context);

  /// Leaving the permissions page asks for what it explained (SET-024).
  Future<void> _next() async {
    if (_busy) return;
    if (_page == _permissions) {
      _busy = true;
      try {
        await ref
            .read(notificationPermissionProvider)
            .request()
            .timeout(const Duration(seconds: 30));
      } on Object {
        // Not granted; the permissions page must not hold the user.
      } finally {
        _busy = false;
      }
      if (!mounted) return;
    }
    setState(() => _page = min(_page + 1, _pages - 1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsProvider);
    final ios = defaultTargetPlatform == TargetPlatform.iOS;

    Widget page(String title, List<Widget> children) => ListView(
      padding: const EdgeInsets.all(FalcoSpacing.xl),
      children: [
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: FalcoSpacing.l),
        ...children,
      ],
    );
    Widget point(IconData icon, String title, String text) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: c.accent),
      title: Text(title),
      subtitle: Text(text),
    );

    final last = _page == _pages - 1;
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!last)
            TextButton(onPressed: _addAccount, child: Text(l10n.welcomeSkip)),
        ],
      ),
      body: switch (_page) {
        0 => page(l10n.welcomeLanguage, [
          ChoiceList(
            options: languageOptions(l10n),
            selected: settings.language ?? 'system',
            onSelected: (v) => ref
                .read(appSettingsProvider.notifier)
                .update(
                  settings.copyWith(language: () => v == 'system' ? null : v),
                ),
          ),
        ]),
        1 => page(l10n.welcomeFeatures, [
          point(Icons.cloud_outlined, l10n.serviceCloud, l10n.welcomeCloud),
          point(Icons.dns_outlined, l10n.scopeRobot, l10n.welcomeRobot),
          point(Icons.language, 'DNS', l10n.welcomeDns),
          point(
            Icons.inventory_2_outlined,
            l10n.welcomeObjectStorage,
            l10n.welcomeObjectStorageText,
          ),
        ]),
        2 => page(l10n.welcomeSecurity, [
          point(
            Icons.key,
            l10n.welcomeSecretsTitle,
            ios ? l10n.welcomeSecretsIos : l10n.welcomeSecretsAndroid,
          ),
          point(
            Icons.lock_outline,
            l10n.welcomeLockTitle,
            ios ? l10n.welcomeLockIos : l10n.welcomeLockAndroid,
          ),
          point(
            Icons.verified_user_outlined,
            l10n.settingsPinning,
            l10n.welcomePinning,
          ),
        ]),
        _permissions => page(l10n.welcomePermissions, [
          point(
            Icons.notifications_outlined,
            l10n.welcomeNotificationsTitle,
            l10n.welcomeNotificationsText,
          ),
          point(
            ios ? Icons.face : Icons.fingerprint,
            l10n.welcomeLockTitle,
            ios ? l10n.welcomeBiometricsIos : l10n.welcomeBiometricsAndroid,
          ),
        ]),
        _ => page(l10n.welcomeStart, [
          Text(l10n.welcomeStartText, style: theme.textTheme.bodyLarge),
        ]),
      },
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: FalcoSpacing.m,
            children: [
              Semantics(
                label: l10n.wizardStep(_page + 1, _pages),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    for (var i = 0; i < _pages; i++)
                      Container(
                        width: i == _page ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == _page ? c.accent : c.hairline,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                spacing: FalcoSpacing.s,
                children: [
                  if (_page > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _page--),
                        child: Text(l10n.commonBack),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: last ? _addAccount : _next,
                      child: Text(last ? l10n.accountAdd : l10n.commonNext),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
