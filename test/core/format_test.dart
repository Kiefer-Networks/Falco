// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/core/format/format.dart';
import 'package:falco/l10n/app_localizations_de.dart';
import 'package:falco/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('de');
  });

  group('formatBytes', () {
    test('QRS-015 uses binary units', () {
      expect(formatBytes(0, 'en'), '0 B');
      expect(formatBytes(1023, 'en'), '1,023 B');
      expect(formatBytes(1024, 'en'), '1 KiB');
      expect(formatBytes(1536, 'en'), '1.5 KiB');
      expect(formatBytes(80 * 1024 * 1024 * 1024, 'en'), '80 GiB');
      expect(formatBytes(5 * 1024 * 1024 * 1024 * 1024 * 1024, 'en'), '5 PiB');
    });

    test('respects the locale', () {
      expect(formatBytes(1536, 'de'), '1,5 KiB');
    });
  });

  test('formatDecimal keeps the digits and the locale', () {
    expect(formatDecimal(1234.5, 2, 'en'), '1,234.50');
    expect(formatDecimal(1234.5, 2, 'de'), '1.234,50');
    expect(formatDecimal(3.25, 0, 'de'), '3');
  });

  group('formatRelative', () {
    final now = DateTime(2026, 11, 21, 12);
    final en = AppLocalizationsEn();
    final de = AppLocalizationsDe();

    test('steps from just now to days', () {
      expect(formatRelative(now, now, en), 'just now');
      expect(
        formatRelative(now.add(const Duration(minutes: 5)), now, en),
        'just now',
      );
      expect(
        formatRelative(now.subtract(const Duration(minutes: 1)), now, en),
        '1 minute ago',
      );
      expect(
        formatRelative(now.subtract(const Duration(minutes: 5)), now, en),
        '5 minutes ago',
      );
      expect(
        formatRelative(now.subtract(const Duration(hours: 3)), now, de),
        'vor 3 Stunden',
      );
      expect(
        formatRelative(DateTime(2026, 10, 11, 12), now, en),
        'Oct 11, 2026 12:00',
      );
      expect(
        formatRelative(now.subtract(const Duration(days: 2)), now, de),
        'vor 2 Tagen',
      );
    });
  });

  test('formatDateTime uses local time and locale', () {
    final t = DateTime(2026, 11, 21, 14, 5);
    expect(formatDateTime(t, 'en'), 'Nov 21, 2026 14:05');
    expect(formatDateTime(t, 'de'), '21. Nov. 2026 14:05');
    expect(formatDateTime(t.toUtc(), 'en'), 'Nov 21, 2026 14:05');
  });

  test('formatMoney', () {
    expect(formatMoney(4.51, 'EUR', 'en'), '€4.51');
    expect(formatMoney(4.51, 'EUR', 'de'), '4,51\u00a0€');
    expect(formatMoney(1234.5, 'EUR', 'de'), '1.234,50\u00a0€');
  });

  test('formatIp normalizes v4, v6 and prefixes', () {
    expect(formatIp(' 49.13.204.17 '), '49.13.204.17');
    expect(formatIp('2A01:04F8:0C17:03B2:0:0:0:1'), '2a01:4f8:c17:3b2::1');
    expect(formatIp('2a01:4f8:c17:3b2::/64'), '2a01:4f8:c17:3b2::/64');
    expect(formatIp('2a01:4f8:0:0:1:0:0:1'), '2a01:4f8::1:0:0:1');
    expect(formatIp('::1'), '::1');
    expect(formatIp('not-an-ip'), 'not-an-ip');
  });
}
