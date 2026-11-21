// SPDX-License-Identifier: GPL-3.0-or-later
/// The one formatting for values shown in Falco: bytes, dates, money, IPs.
library;

import 'package:falco/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

const _byteUnits = ['B', 'KiB', 'MiB', 'GiB', 'TiB', 'PiB'];

/// Formats [bytes] in binary units (1 KiB = 1024 B) with at most one
/// fraction digit, e.g. `1.5 GiB` (en) or `1,5 GiB` (de).
String formatBytes(int bytes, String locale) {
  var value = bytes.toDouble();
  var unit = 0;
  while (value.abs() >= 1024 && unit < _byteUnits.length - 1) {
    value /= 1024;
    unit++;
  }
  final number = NumberFormat('#,##0.#', locale).format(value);
  return '$number ${_byteUnits[unit]}';
}

/// Formats [time] relative to [now], e.g. `5 minutes ago`. Older than
/// 30 days falls back to [formatDateTime]. Future times read as "just now".
String formatRelative(DateTime time, DateTime now, AppLocalizations l10n) {
  final diff = now.difference(time);
  if (diff.inMinutes < 1) return l10n.relativeJustNow;
  if (diff.inHours < 1) return l10n.relativeMinutes(diff.inMinutes);
  if (diff.inDays < 1) return l10n.relativeHours(diff.inHours);
  if (diff.inDays <= 30) return l10n.relativeDays(diff.inDays);
  return formatDateTime(time, l10n.localeName);
}

/// Formats [time] as absolute date and time in local time,
/// e.g. `Nov 21, 2026 14:05` (en) or `21.11.2026 14:05` (de).
String formatDateTime(DateTime time, String locale) =>
    DateFormat.yMMMd(locale).add_Hm().format(time.toLocal());

/// Formats the day of [time] in local time, e.g. `Nov 21, 2026` (en) or
/// `21.11.2026` (de).
String formatDate(DateTime time, String locale) =>
    DateFormat.yMMMd(locale).format(time.toLocal());

/// Formats [amount] in [currency] (ISO 4217), e.g. `€4.51` (en) or
/// `4,51 €` (de). Hetzner returns prices as decimal strings; parse them
/// with `num.parse` before calling.
String formatMoney(num amount, String currency, String locale) =>
    NumberFormat.simpleCurrency(locale: locale, name: currency).format(amount);

/// Formats Hetzner labels as `key=value, key2=value2` (sorted by key).
String formatLabels(Map<String, String> labels) => [
  for (final key in labels.keys.toList()..sort())
    if (labels[key]!.isEmpty) key else '$key=${labels[key]}',
].join(', ');

// Optional DNS prefix with `/`, then a name; values the same without
// prefix and possibly empty (Hetzner label rules).
final _labelKey = RegExp(
  '^([a-z0-9]([a-z0-9.-]{0,251}[a-z0-9])?/)?'
  r'[a-zA-Z0-9]([a-zA-Z0-9._-]{0,61}[a-zA-Z0-9])?$',
);
final _labelValue = RegExp(
  r'^([a-zA-Z0-9]([a-zA-Z0-9._-]{0,61}[a-zA-Z0-9])?)?$',
);

/// Parses [formatLabels] text; null when a key or value breaks the
/// Hetzner label rules.
Map<String, String>? parseLabels(String text) {
  final labels = <String, String>{};
  for (final part in text.split(',')) {
    if (part.trim().isEmpty) continue;
    final eq = part.indexOf('=');
    final key = (eq < 0 ? part : part.substring(0, eq)).trim();
    final value = eq < 0 ? '' : part.substring(eq + 1).trim();
    if (!_labelKey.hasMatch(key) || !_labelValue.hasMatch(value)) return null;
    labels[key] = value;
  }
  return labels;
}

/// Normalizes an IPv4 or IPv6 address, optionally with `/prefix`, to its
/// canonical text form (RFC 5952: IPv6 lower case, no leading zeros,
/// longest zero run compressed). Unparsable input is returned trimmed.
String formatIp(String ip) {
  final trimmed = ip.trim();
  final slash = trimmed.indexOf('/');
  final address = slash < 0 ? trimmed : trimmed.substring(0, slash);
  final suffix = slash < 0 ? '' : trimmed.substring(slash);
  try {
    final canonical = address.contains(':')
        ? _compressV6(Uri.parseIPv6Address(address))
        : Uri.parseIPv4Address(address).join('.');
    return '$canonical$suffix';
  } on FormatException {
    return trimmed;
  }
}

String _compressV6(List<int> bytes) {
  final groups = [
    for (var i = 0; i < 16; i += 2)
      (bytes[i] << 8 | bytes[i + 1]).toRadixString(16),
  ];
  var bestStart = -1;
  var bestLength = 1; // RFC 5952: a single zero group is not compressed.
  for (var i = 0; i < groups.length;) {
    if (groups[i] != '0') {
      i++;
      continue;
    }
    var end = i;
    while (end < groups.length && groups[end] == '0') {
      end++;
    }
    if (end - i > bestLength) {
      bestStart = i;
      bestLength = end - i;
    }
    i = end;
  }
  if (bestStart < 0) return groups.join(':');
  final head = groups.sublist(0, bestStart).join(':');
  final tail = groups.sublist(bestStart + bestLength).join(':');
  return '$head::$tail';
}
