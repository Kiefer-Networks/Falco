// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';

import 'package:falco/core/errors/falco_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
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
/// On Android every vault read and write asks again
/// (`requireBiometricsPerOperation`), else the plugin would keep the key
/// open after [close]; [open] keeps one read per unlock and [apply] one
/// write per change. A cancelled check fails as [Locked].
/// The account list is no secret and stays in the plain store, so the
/// app can start before the unlock.
class SecretStore {
  /// Creates the store; tests pass nothing and use
  /// `FlutterSecureStorage.setMockInitialValues`.
  new([
    FlutterSecureStorage? plain,
    FlutterSecureStorage? bound,
    Future<bool> Function()? deviceLock,
  ]) : _plain = plain ?? _plainStorage,
       _bound = bound ?? _boundStorage,
       _deviceLock = deviceLock ?? LocalAuthentication().isDeviceSupported;

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
    aOptions: AndroidOptions.biometric(
      storageNamespace: 'vault',
      requireBiometricsPerOperation: true,
    ),
  );

  static const _vault = 'vault';
  static const _unbound = 'vault.unbound';

  /// Names of the secrets in the vault, no values: shows which access data
  /// is gone when the system deleted the vault.
  static const _keys = 'vault.keys';

  final FlutterSecureStorage _plain;
  final FlutterSecureStorage _bound;

  /// Whether the device has a screen lock the vault can bind to.
  final Future<bool> Function() _deviceLock;
  Map<String, String>? _open;
  Future<Map<String, String>>? _opening;
  Future<void> _writes = Future.value();

  /// Secret names (`cloud.<project>`, `s3.<project>`, `robot.<account>`)
  /// whose values the system deleted: Android drops the Keystore key when
  /// fingerprints or the face change, and with it the vault. Set once on
  /// the read that finds the vault gone; the app shows it and clears it.
  final lost = ValueNotifier<Set<String>>(const {});

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
    requireBiometricsPerOperation: true,
    biometricPromptTitle: prompt,
  );

  /// Reads the vault; the system asks for Face ID, fingerprint or the
  /// device PIN when it is bound. Throws [Locked] when the user cancels.
  /// Returns true once open.
  Future<bool> open() async {
    final closed = _closed;
    _closed = false;
    try {
      await _secrets();
    } on Object {
      _closed = closed;
      rethrow;
    }
    return true;
  }

  /// Reads the vault again even when it is open, so the system asks the
  /// user now; a failed check keeps the vault as it was.
  Future<bool> verify() async {
    final before = _open;
    _open = null;
    try {
      return await open();
    } on Object {
      _open ??= before;
      rethrow;
    }
  }

  /// Forgets the open vault; the next secret needs a fresh unlock. Until
  /// [open], reads fail with [Locked] instead of asking from background
  /// requests. A read still running is discarded.
  void close() {
    _open = null;
    _opening = null;
    _closed = true;
    _epoch++;
  }

  bool _closed = false;

  /// Counts [close] calls, so a read that started before one never opens
  /// the vault after it.
  int _epoch = 0;

  Future<Map<String, String>> _secrets() async =>
      _open ?? await (_opening ??= _read());

  Future<Map<String, String>> _read() async {
    final epoch = _epoch;
    try {
      final secrets = await _load();
      if (epoch == _epoch) _open = secrets;
      return secrets;
    } finally {
      if (epoch == _epoch) _opening = null;
    }
  }

  Future<Map<String, String>> _load() async {
    if (_closed && await bound) throw const Locked();
    String? raw;
    try {
      raw = await _bound.read(key: _vault, aOptions: _android);
    } on PlatformException catch (e) {
      if (!_invalidated(e)) throw const Locked();
      // New fingerprints or face: the system dropped the key, the vault
      // is lost. Reset it; the app lock falls back to the device check.
      await _bound.deleteAll(aOptions: _android);
    }
    raw ??= await _plain.read(key: _unbound);
    if (raw == null) {
      await _markLost();
      return {};
    }
    return (jsonDecode(raw) as Map).cast<String, String>();
  }

  static bool _invalidated(PlatformException e) =>
      '${e.message} ${e.details}'.contains('KeyPermanentlyInvalidated');

  Future<void> _markLost() async {
    final known = await _plain.read(key: _keys);
    if (known == null) return;
    lost.value = {...(jsonDecode(known) as List).cast<String>()};
    await _plain.delete(key: _keys);
  }

  Future<void> _save(Map<String, String> secrets) async {
    final raw = jsonEncode(secrets);
    try {
      await _bound.write(key: _vault, value: raw, aOptions: _android);
      await _plain.delete(key: _unbound);
    } on PlatformException {
      // Android stores unbound by itself without a screen lock, and with
      // a screen lock an error is a cancelled prompt: nothing changed.
      if (defaultTargetPlatform == TargetPlatform.android ||
          await _deviceLock()) {
        throw const Locked();
      }
      // No screen lock to bind to: keep a working, unbound vault and drop
      // the bound one, else its stale secrets would win the next read.
      await _plain.write(key: _unbound, value: raw);
      await _bound.delete(key: _vault);
    }
    _open = secrets;
    await _plain.write(key: _keys, value: jsonEncode(secrets.keys.toList()));
  }

  /// Applies [change] to the latest vault and saves it if [change] returns
  /// true. Writes run one after another, so none overwrites another.
  Future<void> _update(bool Function(Map<String, String> secrets) change) {
    final done = _writes.then((_) async {
      final secrets = {...await _secrets()};
      if (change(secrets)) await _save(secrets);
    });
    _writes = done.then((_) {}, onError: (Object _) {});
    return done;
  }

  /// Applies all changes [build] collects in one vault write, so the
  /// system asks once (Android asks per write) and a cancelled prompt
  /// changes nothing.
  Future<void> apply(void Function(SecretChanges changes) build) async {
    final changes = SecretChanges._();
    build(changes);
    // Secrets stored one by one before the vault.
    for (final key in changes._removed) {
      await _plain.delete(key: key);
    }
    await _update((secrets) {
      var changed = false;
      for (final key in changes._removed) {
        changed |= secrets.remove(key) != null;
      }
      for (final MapEntry(:key, :value) in changes._set.entries) {
        changed |= secrets[key] != value;
        secrets[key] = value;
      }
      return changed;
    });
  }

  Future<String?> _get(String key) async {
    final secrets = await _secrets();
    if (secrets[key] case final value?) return value;
    // Stored one by one before the vault: move it in, then delete it once
    // a saved vault holds it.
    final legacy = await _plain.read(key: key);
    if (legacy == null) return null;
    await _update((secrets) {
      secrets[key] = legacy;
      return true;
    });
    await _plain.delete(key: key);
    return legacy;
  }

  /// Cloud API token of a project (also used for Storage Boxes and DNS).
  Future<String?> cloudToken(String projectId) => _get('cloud.$projectId');

  /// Stores the Cloud API token of a project.
  Future<void> setCloudToken(String projectId, String token) =>
      apply((c) => c.cloudToken(projectId, token));

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
  Future<void> setRobot(String accountId, RobotCredentials c) =>
      apply((changes) => changes.robot(accountId, c));

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
  Future<void> setS3(String projectId, S3Credentials c) =>
      apply((changes) => changes.s3(projectId, c));

  /// Deletes every secret of a project.
  Future<void> deleteProject(String projectId) =>
      apply((c) => c.deleteProject(projectId));

  /// Deletes the S3 credentials of a project.
  Future<void> deleteS3(String projectId) =>
      apply((c) => c.deleteS3(projectId));

  /// Deletes the Robot credentials of an account.
  Future<void> deleteRobot(String accountId) =>
      apply((c) => c.deleteRobot(accountId));

  Future<Map<String, Object?>?> _json(String key) async {
    final raw = await _get(key);
    return raw == null
        ? null
        : (jsonDecode(raw) as Map).cast<String, Object?>();
  }
}

/// Changes to several secrets, applied by [SecretStore.apply] at once.
class SecretChanges {
  new _();

  final _set = <String, String>{};
  final _removed = <String>{};

  void _put(String key, String value) {
    _removed.remove(key);
    _set[key] = value;
  }

  void _remove(String key) {
    _set.remove(key);
    _removed.add(key);
  }

  /// Sets the Cloud API token of a project.
  void cloudToken(String projectId, String token) =>
      _put('cloud.$projectId', token);

  /// Sets the S3 credentials of a project.
  void s3(String projectId, S3Credentials c) => _put(
    's3.$projectId',
    jsonEncode({
      'accessKey': c.accessKey,
      'secretKey': c.secretKey,
      'endpoint': c.endpoint,
      'region': c.region,
    }),
  );

  /// Sets the Robot credentials of an account.
  void robot(String accountId, RobotCredentials c) => _put(
    'robot.$accountId',
    jsonEncode({'user': c.user, 'password': c.password}),
  );

  /// Removes every secret of a project.
  void deleteProject(String projectId) {
    _remove('cloud.$projectId');
    _remove('s3.$projectId');
  }

  /// Removes the S3 credentials of a project.
  void deleteS3(String projectId) => _remove('s3.$projectId');

  /// Removes the Robot credentials of an account.
  void deleteRobot(String accountId) => _remove('robot.$accountId');
}

/// The app wide secret store.
@Riverpod(keepAlive: true)
SecretStore secretStore(Ref ref) => SecretStore();
