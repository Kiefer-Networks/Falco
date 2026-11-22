// SPDX-License-Identifier: GPL-3.0-or-later
/// OpenSSH key formats: reading public keys, the MD5 fingerprint Hetzner
/// shows, and generating Ed25519 key pairs (CMP-073, CMP-100).
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:cryptography/cryptography.dart';

/// A generated key pair. `privateKey` is the unencrypted OpenSSH PEM: hand
/// it to the user once, never store or log it.
typedef SshKeyPair = ({String publicKey, String privateKey});

/// Public key types the Cloud and Robot accept (CMP-073).
const sshKeyTypes = {
  'ssh-ed25519',
  'ssh-rsa',
  'ssh-dss',
  'ecdsa-sha2-nistp256',
  'ecdsa-sha2-nistp384',
  'ecdsa-sha2-nistp521',
  'sk-ecdsa-sha2-nistp256@openssh.com',
  'sk-ssh-ed25519@openssh.com',
};

/// The key blob of an OpenSSH public key line (`type base64 [comment]`);
/// null when the type is unknown, the base64 is broken or cut, or the
/// blob names another type than the line.
Uint8List? publicKeyBlob(String line) {
  final parts = line.trim().split(RegExp(r'\s+'));
  if (parts.length < 2 || !sshKeyTypes.contains(parts[0])) return null;
  final Uint8List blob;
  try {
    blob = base64.decode(parts[1]);
  } on FormatException {
    return null;
  }
  // Length prefixed fields that fill the blob exactly: the type and at
  // least one more, so a cut blob does not pass.
  final data = ByteData.sublistView(blob);
  final fields = <Uint8List>[];
  for (var at = 0; at < blob.length;) {
    if (blob.length - at < 4) return null;
    final n = data.getUint32(at);
    if (blob.length - at - 4 < n) return null;
    fields.add(blob.sublist(at + 4, at + 4 + n));
    at += 4 + n;
  }
  return fields.length >= 2 &&
          utf8.decode(fields.first, allowMalformed: true) == parts[0]
      ? blob
      : null;
}

/// The MD5 fingerprint of a public key as Hetzner shows it
/// (`aa:bb:…`, 16 bytes); null when the line is no public key.
String? md5Fingerprint(String line) {
  final blob = publicKeyBlob(line);
  if (blob == null) return null;
  return [
    for (final b in hash.md5.convert(blob).bytes)
      b.toRadixString(16).padLeft(2, '0'),
  ].join(':');
}

/// Generates an Ed25519 key pair; [seed] (32 bytes) only in tests.
Future<SshKeyPair> generateEd25519({
  required String comment,
  List<int>? seed,
}) async {
  final algo = Ed25519();
  final pair = seed == null
      ? await algo.newKeyPair()
      : await algo.newKeyPairFromSeed(seed);
  final priv = await pair.extractPrivateKeyBytes();
  final pub = (await pair.extractPublicKey()).bytes;
  final pubBlob =
      (_SshWriter()
            ..string(utf8.encode('ssh-ed25519'))
            ..string(pub))
          .bytes;
  final check = Random.secure().nextInt(1 << 32);
  final secret = _SshWriter()
    ..uint32(check)
    ..uint32(check)
    ..string(utf8.encode('ssh-ed25519'))
    ..string(pub)
    ..string([...priv, ...pub])
    ..string(utf8.encode(comment));
  // Padding 1, 2, 3 … to the cipher block size (8 for "none").
  for (var i = 1; secret.length % 8 != 0; i++) {
    secret.byte(i);
  }
  final body = _SshWriter()
    ..raw(utf8.encode('openssh-key-v1\x00'))
    ..string(utf8.encode('none'))
    ..string(utf8.encode('none'))
    ..string(const [])
    ..uint32(1)
    ..string(pubBlob)
    ..string(secret.bytes);
  final b64 = base64.encode(body.bytes);
  final lines = [
    for (var i = 0; i < b64.length; i += 70)
      b64.substring(i, min(i + 70, b64.length)),
  ];
  return (
    publicKey: 'ssh-ed25519 ${base64.encode(pubBlob)} $comment'.trim(),
    privateKey:
        '-----BEGIN OPENSSH PRIVATE KEY-----\n'
        '${lines.join('\n')}\n'
        '-----END OPENSSH PRIVATE KEY-----\n',
  );
}

/// SSH wire format (RFC 4251): uint32 and length prefixed strings.
class _SshWriter {
  final _b = BytesBuilder(copy: false);

  int get length => _b.length;
  Uint8List get bytes => _b.toBytes();

  void byte(int v) => _b.addByte(v);
  void raw(List<int> v) => _b.add(v);
  void uint32(int v) =>
      _b.add((ByteData(4)..setUint32(0, v)).buffer.asUint8List());
  void string(List<int> v) => this
    ..uint32(v.length)
    ..raw(v);
}
