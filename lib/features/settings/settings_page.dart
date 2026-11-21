// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/secure/app_lock.dart';
import 'package:falco/core/settings/settings.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Language choices; "system" follows the device.
Map<String, String> languageOptions(AppLocalizations l10n) => {
  'system': l10n.settingsSystem,
  'en': 'English',
  'de': 'Deutsch',
};

/// Readable auto lock time (SET-008).
String lockTimeoutText(int seconds, AppLocalizations l10n) => seconds == 0
    ? l10n.lockImmediately
    : seconds < 60
    ? l10n.lockSeconds(seconds)
    : l10n.lockMinutes(seconds ~/ 60);

/// Settings: accounts, appearance, language, security, about
/// (SET-001 to SET-016).
class SettingsPage extends ConsumerWidget {
  const new({this.activeAccountId, super.key});

  /// Account of the scope the user came from.
  final String? activeAccountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = FalcoColors.of(context);
    final s = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final accounts = ref.watch(accountsProvider).value ?? const [];
    final themes = {
      'system': l10n.settingsSystem,
      FalcoVariant.light.name: l10n.showcaseLight,
      FalcoVariant.dark.name: l10n.showcaseDark,
      FalcoVariant.oled.name: l10n.showcaseOled,
    };
    final accents = {
      for (final a in AccentPreset.values) a.name: accentName(a, l10n),
    };
    final languages = languageOptions(l10n);
    final timeouts = {
      for (final t in lockTimeouts) '$t': lockTimeoutText(t, l10n),
    };

    Widget label(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Semantics(
        header: true,
        child: Text(
          text.toUpperCase(),
          style: FalcoText.of(context).sectionLabel,
        ),
      ),
    );
    Widget choice({
      required IconData icon,
      required String title,
      required Map<String, String> options,
      required String selected,
      required void Function(String value) onSelected,
      bool enabled = true,
      Color? iconColor,
    }) => ListTile(
      enabled: enabled,
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(options[selected] ?? ''),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final v = await ChoiceList.show(
          context,
          title: title,
          options: options,
          selected: selected,
        );
        if (v != null) onSelected(v);
      },
    );

    return FalcoScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        padding: const EdgeInsets.only(bottom: FalcoSpacing.xxl),
        children: [
          label(l10n.accountsTitle),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: Text(l10n.accountsTitle),
            subtitle: Text(
              accounts.isEmpty
                  ? l10n.accountsEmpty
                  : l10n.accountsCount(accounts.length),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                AccountsRoute(active: activeAccountId).push<void>(context),
          ),
          label(l10n.settingsGeneral),
          choice(
            icon: Icons.palette_outlined,
            title: l10n.settingsTheme,
            options: themes,
            selected: s.variant?.name ?? 'system',
            onSelected: (v) => notifier.update(
              s.copyWith(variant: () => FalcoVariant.values.asNameMap()[v]),
            ),
          ),
          choice(
            icon: Icons.circle,
            iconColor: c.accent,
            title: l10n.showcaseAccent,
            options: accents,
            selected: s.accent.name,
            onSelected: (v) => notifier.update(
              s.copyWith(accent: AccentPreset.values.byName(v)),
            ),
          ),
          choice(
            icon: Icons.language,
            title: l10n.settingsLanguage,
            options: languages,
            selected: s.language ?? 'system',
            onSelected: (v) => notifier.update(
              s.copyWith(language: () => v == 'system' ? null : v),
            ),
          ),
          label(l10n.settingsSecurity),
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline),
            title: Text(l10n.settingsLock),
            subtitle: Text(l10n.settingsLockHint),
            value: s.lock,
            onChanged: (on) async {
              // Turning the lock off needs the same check as unlocking.
              if (!on &&
                  await ref.read(authenticatorProvider)(l10n.lockReason) ==
                      false) {
                return;
              }
              await notifier.update(
                ref.read(appSettingsProvider).copyWith(lock: on),
              );
            },
          ),
          choice(
            icon: Icons.timer_outlined,
            title: l10n.settingsAutoLock,
            options: timeouts,
            selected: '${s.lockTimeout}',
            enabled: s.lock,
            onSelected: (v) =>
                notifier.update(s.copyWith(lockTimeout: int.parse(v))),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.screenshot_monitor_outlined),
            title: Text(l10n.settingsSecureScreen),
            subtitle: Text(l10n.settingsSecureScreenHint),
            value: s.secureScreen,
            onChanged: (on) => notifier.update(s.copyWith(secureScreen: on)),
          ),
          ListTile(
            leading: Icon(Icons.verified_user_outlined, color: c.accent),
            title: Text(l10n.settingsPinning),
            subtitle: Text(l10n.settingsPinningHint),
          ),
          label(l10n.aboutTitle),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutTitle),
            subtitle: Text(l10n.aboutVersion(appVersion)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => const AboutRoute().push<void>(context),
          ),
        ],
      ),
    );
  }
}

/// Localized name of an accent (SET-003).
String accentName(AccentPreset a, AppLocalizations l10n) => switch (a) {
  AccentPreset.amber => l10n.accentAmber,
  AccentPreset.blue => l10n.accentBlue,
  AccentPreset.green => l10n.accentGreen,
  AccentPreset.red => l10n.accentRed,
  AccentPreset.purple => l10n.accentPurple,
  AccentPreset.orange => l10n.accentOrange,
};

/// About: version, links, license, open source licenses (ONB-040, ONB-041).
class AboutPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget link(IconData icon, String title, String url, [String? sub]) =>
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(sub ?? Uri.parse(url).host),
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () => LinkButton.open(Uri.parse(url)).ignore(),
        );
    return FalcoScaffold(
      title: l10n.aboutTitle,
      body: ListView(
        padding: const EdgeInsets.only(bottom: FalcoSpacing.xxl),
        children: [
          Padding(
            padding: const EdgeInsets.all(FalcoSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FalcoSpacing.s,
              children: [
                Text(l10n.appTitle, style: theme.textTheme.headlineSmall),
                Mono(l10n.aboutVersion(appVersion)),
                Text(l10n.aboutDescription, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          link(Icons.public, l10n.aboutWebsite, 'https://kiefer-networks.de'),
          link(
            Icons.favorite_outline,
            l10n.aboutDonate,
            'https://de.liberapay.com/beli3ver',
          ),
          link(
            Icons.code,
            l10n.aboutSource,
            'https://github.com/Kiefer-Networks/Falco',
            'github.com/Kiefer-Networks/Falco',
          ),
          link(
            Icons.business_outlined,
            l10n.aboutDeveloper,
            'https://kiefer-networks.de',
            'Kiefer Networks',
          ),
          link(
            Icons.gavel_outlined,
            l10n.aboutLicense,
            'https://www.gnu.org/licenses/gpl-3.0.html',
            'GPL-3.0-or-later',
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.aboutLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
              applicationVersion: appVersion,
              applicationLegalese: 'GPL-3.0-or-later',
            ),
          ),
        ],
      ),
    );
  }
}
