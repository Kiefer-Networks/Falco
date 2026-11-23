// SPDX-License-Identifier: GPL-3.0-or-later
/// Just enough DER to read issuer, subject and SubjectPublicKeyInfo of an
/// X.509 certificate. Pure Dart: shared by the app and `tool/pins.dart`.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Raw DER parts of a certificate.
class X509Parts {
  /// Parses [der]; throws [FormatException] on malformed input.
  factory parse(List<int> der) {
    final bytes = der is Uint8List ? der : Uint8List.fromList(der);
    final cert = _Tlv.read(bytes, 0);
    final tbs = _Tlv.read(bytes, cert.contentStart);
    var at = tbs.contentStart;
    final first = _Tlv.read(bytes, at);
    // Optional explicit [0] version.
    if (first.tag == 0xA0) at = first.end;
    final serial = _Tlv.read(bytes, at);
    final sigAlg = _Tlv.read(bytes, serial.end);
    final issuer = _Tlv.read(bytes, sigAlg.end);
    final validity = _Tlv.read(bytes, issuer.end);
    final subject = _Tlv.read(bytes, validity.end);
    final spki = _Tlv.read(bytes, subject.end);
    if (spki.tag != 0x30 || spki.end > tbs.end) {
      throw const FormatException('No SubjectPublicKeyInfo');
    }
    return X509Parts._(
      issuer: issuer.raw(bytes),
      subject: subject.raw(bytes),
      spki: spki.raw(bytes),
    );
  }

  new _({required this.issuer, required this.subject, required this.spki});

  /// DER of the issuer Name.
  final Uint8List issuer;

  /// DER of the subject Name.
  final Uint8List subject;

  /// DER of the SubjectPublicKeyInfo.
  final Uint8List spki;

  /// Base64 SHA-256 of [spki], the usual pin format (RFC 7469).
  String get spkiPin => base64.encode(sha256.convert(spki).bytes);

  /// True when the certificate is self issued (a root).
  bool get selfIssued => _equal(issuer, subject);
}

bool _equal(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

class _Tlv {
  new(this.tag, this.start, this.contentStart, this.end);

  factory read(Uint8List bytes, int at) {
    if (at + 2 > bytes.length) throw const FormatException('Truncated DER');
    final tag = bytes[at];
    var length = bytes[at + 1];
    var content = at + 2;
    if (length & 0x80 != 0) {
      final count = length & 0x7F;
      if (count == 0 || count > 4 || content + count > bytes.length) {
        throw const FormatException('Bad DER length');
      }
      length = 0;
      for (var i = 0; i < count; i++) {
        length = (length << 8) | bytes[content + i];
      }
      content += count;
    }
    if (content + length > bytes.length) {
      throw const FormatException('Truncated DER');
    }
    return _Tlv(tag, at, content, content + length);
  }

  final int tag;
  final int start;
  final int contentStart;
  final int end;

  Uint8List raw(Uint8List bytes) => Uint8List.sublistView(bytes, start, end);
}

/// Extracts the DER bodies of all certificates in a PEM text.
List<Uint8List> pemCertificates(String pem) => [
  for (final m in RegExp(
    '-----BEGIN CERTIFICATE-----([^-]+)-----END CERTIFICATE-----',
  ).allMatches(pem))
    base64.decode(m.group(1)!.replaceAll(RegExp(r'\s'), '')),
];
