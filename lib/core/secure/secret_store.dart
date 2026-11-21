// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secret_store.g.dart';

/// Robot webservice credentials.
class RobotCredentials {
  /// Creates credentials.
  const new({required this.user, required this.password});

  /// Webservice user, e.g. `#ws+abc`.
  final String user;

  /// Webservice password.
  final String password;

  @override
  String toString() => 'RobotCredentials(***)';
}

/// S3 credentials of a project (SET-018).
class S3Credentials {
  /// Creates credentials.
  const new({
    required this.accessKey,
    required this.secretKey,
    required this.endpoint,
    required this.region,
  });

  /// Access key id.
  final String accessKey;

  /// Secret key.
  final String secretKey;

  /// Endpoint URL, e.g. `https://fsn1.your-objectstorage.com`.
  final String endpoint;

  /// Region, e.g. `fsn1`.
  final String region;

  @override
  String toString() => 'S3Credentials(***)';
}

/// Tokens and keys, only in Keychain (iOS) and Keystore (Android)
/// (SET-017), never in app state.
///
/// Hardware bound (SET-015): all secrets sit in one vault item that the
/// system releases only after a fresh unlock: a Keychain item with user
/// presence (Face ID, Touch ID or passcode) on iOS, data wrapped by an
/// authentication bound Keystore key on Android. [open] reads it once per
/// unlock, [close] forgets it when the app locks. A device without a
/// screen lock cannot bind the vault; it then lives in the plain store.
/// The account list is no secret and stays in the plain store, so the
/// app can start before the unlock.
class SecretStore {
  /// Creates the store; tests pass nothing and use
  /// `FlutterSecureStorage.setMockInitialValues`.
  new([FlutterSecureStorage? plain, FlutterSecureStorage? bound])
    : _plain = plain ?? _plainStorage,
      _bound = bound ?? _boundStorage;

  static const _plainStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
    ),
  );

  static const _boundStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accountName: 'falco.vault',
      accessibility: KeychainAccessibility.unlocked_this_device,
      accessControlFlags: [AccessControlFlag.userPresence],
    ),
    aOptions: AndroidOptions.biometric(storageNamespace: 'vault'),
  );

  static const _vault = 'vault';
  static const _unbound = 'vault.unbound';

  final FlutterSecureStorage _plain;
  final FlutterSecureStorage _bound;
  Map<String, String>? _open;
  Future<Map<String, String>>? _opening;

  /// Title of the system prompt on Android; set to a localized text by
  /// the app lock.
  String? prompt;

  /// Raw read, for non secret structured data (account list).
  Future<String?> read(String key) => _plain.read(key: key);

  /// Raw write.
  Future<void> write(String key, String value) =>
      _plain.write(key: key, value: value);

  /// Whether the vault is hardware bound; then [open] is the unlock.
  Future<bool> get bound async =>
      await _plain.read(key: _unbound) == null &&
      await _bound.containsKey(key: _vault, aOptions: _android);

  AndroidOptions get _android => AndroidOptions.biometric(
    storageNamespace: 'vault',
    biometricPromptTitle: prompt,
  );

  /// Reads the vault; the system asks for Face ID, fingerprint or the
  /// device PIN when it is bound. Throws a `PlatformException` when the
  /// user cancels. Returns true once open.
  Future<bool> open() async {
    await _secrets();
    return true;
  }

  /// Forgets the open vault; the next secret needs a fresh unlock.
  void close() => _open = null;

  Future<Map<String, String>> _secrets() async =>
      _open ??
      await (_opening ??= () async {
        try {
          final raw =
              await _bound.read(key: _vault, aOptions: _android) ??
              await _plain.read(key: _unbound);
          return _open = raw == null
              ? <String, String>{}
              : (jsonDecode(raw) as Map).cast<String, String>();
        } finally {
          _opening = null;
        }
      }());

  Future<void> _save(Map<String, String> secrets) async {
    final raw = jsonEncode(secrets);
    try {
      await _bound.write(key: _vault, value: raw, aOptions: _android);
      await _plain.delete(key: _unbound);
    } on PlatformException {
      // No screen lock to bind to: keep a working, unbound vault.
      await _plain.write(key: _unbound, value: raw);
    }
    _open = secrets;
  }

  Future<String?> _get(String key) async {
    final secrets = await _secrets();
    if (secrets[key] case final value?) return value;
    // Stored one by one before the vault: move it in.
    final legacy = await _plain.read(key: key);
    if (legacy == null) return null;
    await _set(key, legacy);
    await _plain.delete(key: key);
    return legacy;
  }

  Future<void> _set(String key, String value) async {
    await _save({...await _secrets(), key: value});
  }

  Future<void> _delete(String key) async {
    await _plain.delete(key: key);
    final secrets = await _secrets();
    if (!secrets.containsKey(key)) return;
    await _save({...secrets}..remove(key));
  }

  /// Cloud API token of a project (also used for Storage Boxes and DNS).
  Future<String?> cloudToken(String projectId) => _get('cloud.$projectId');

  /// Stores the Cloud API token of a project.
  Future<void> setCloudToken(String projectId, String token) =>
      _set('cloud.$projectId', token);

  /// Robot credentials of an account.
  Future<RobotCredentials?> robot(String accountId) async {
    final json = await _json('robot.$accountId');
    return json == null
        ? null
        : RobotCredentials(
            user: json['user']! as String,
            password: json['password']! as String,
          );
  }

  /// Stores the Robot credentials of an account.
  Future<void> setRobot(String accountId, RobotCredentials c) => _set(
    'robot.$accountId',
    jsonEncode({'user': c.user, 'password': c.password}),
  );

  /// S3 credentials of a project.
  Future<S3Credentials?> s3(String projectId) async {
    final json = await _json('s3.$projectId');
    return json == null
        ? null
        : S3Credentials(
            accessKey: json['accessKey']! as String,
            secretKey: json['secretKey']! as String,
            endpoint: json['endpoint']! as String,
            region: json['region']! as String,
          );
  }

  /// Stores the S3 credentials of a project.
  Future<void> setS3(String projectId, S3Credentials c) => _set(
    's3.$projectId',
    jsonEncode({
      'accessKey': c.accessKey,
      'secretKey': c.secretKey,
      'endpoint': c.endpoint,
      'region': c.region,
    }),
  );

  /// Deletes every secret of a project.
  Future<void> deleteProject(String projectId) async {
    await _delete('cloud.$projectId');
    await _delete('s3.$projectId');
  }

  /// Deletes the S3 credentials of a project.
  Future<void> deleteS3(String projectId) => _delete('s3.$projectId');

  /// Deletes the Robot credentials of an account.
  Future<void> deleteRobot(String accountId) => _delete('robot.$accountId');

  Future<Map<String, Object?>?> _json(String key) async {
    final raw = await _get(key);
    return raw == null
        ? null
        : (jsonDecode(raw) as Map).cast<String, Object?>();
  }
}

/// The app wide secret store.
@Riverpod(keepAlive: true)
SecretStore secretStore(Ref ref) => SecretStore();
