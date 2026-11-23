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
/// Android 7 to 10 keeps the vault unbound: the plugin's key there needs
/// a fingerprint for every use and fails without one; the app lock checks
/// with local_auth instead.
/// The account list is no secret and stays in the plain store, so the
/// app can start before the unlock.
class SecretStore {
  /// Creates the store; tests pass nothing and use
  /// `FlutterSecureStorage.setMockInitialValues`.
  new([
    FlutterSecureStorage? plain,
    FlutterSecureStorage? bound,
    Future<bool> Function()? deviceLock,
    Future<AndroidDevice> Function()? android,
  ]) : _plain = plain ?? _plainStorage,
       _bound = bound ?? _boundStorage,
       _deviceLock = deviceLock ?? LocalAuthentication().isDeviceSupported,
       _device = android ?? _androidDevice;

  static Future<AndroidDevice> _androidDevice() async {
    final info = await const MethodChannel('falco/device')
        .invokeMapMethod<String, Object?>('info');
    return (
      sdk: info?['sdk'] as int? ?? 30,
      secure: info?['secure'] as bool? ?? true,
    );
  }

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

  /// Generation of the Keystore namespace on Android. A new one gets a new
  /// key from the plugin: after the system invalidated the old key, or to
  /// replace a key made without a screen lock.
  static const _generation = 'vault.ns';

  /// Set when the Keystore namespace was first used in a process while
  /// the device had no screen lock: the plugin may have made its key
  /// without user authentication, so reading it proves nothing.
  static const _weak = 'vault.weak';

  final FlutterSecureStorage _plain;
  final FlutterSecureStorage _bound;

  /// Whether the device has a screen lock the vault can bind to.
  final Future<bool> Function() _deviceLock;

  /// API level and screen lock of an Android device.
  final Future<AndroidDevice> Function() _device;
  Future<String>? _namespace;
  Map<String, String>? _open;
  Future<Map<String, String>>? _opening;
  Future<void> _writes = Future.value();

  /// Secret names (`cloud.<project>`, `s3.<project>`, `robot.<account>`)
  /// whose values the system deleted: Android drops the Keystore key when
  /// fingerprints or the face change, and with it the vault. Set once on
  /// the read that finds the vault gone; the app shows it and clears it.
  final lost = ValueNotifier<Set<String>>(const {});

  /// Title and subtitle of the system prompt on Android, localized by
  /// `localizeVaultPrompt` before the first vault access: the plugin keeps
  /// the texts of its first use of a namespace for the whole process.
  String? prompt;

  /// Subtitle of the system prompt on Android, see [prompt].
  String? promptSubtitle;

  /// Raw read, for non secret structured data (account list).
  Future<String?> read(String key) => _plain.read(key: key);

  /// Raw write.
  Future<void> write(String key, String value) =>
      _plain.write(key: key, value: value);

  /// Whether the vault is hardware bound; then [open] is the unlock.
  Future<bool> get bound async {
    if (await _plain.read(key: _unbound) != null) return false;
    try {
      return await _bound.containsKey(key: _vault, aOptions: await _android());
    } on PlatformException {
      // Android 7 to 10 without a fingerprint cannot make the key.
      if (await _keystoreUsable) rethrow;
      return false;
    }
  }

  static bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  /// Whether the plugin's authentication bound key works without a
  /// fingerprint: Android 11 and later, and iOS.
  Future<bool> get _keystoreUsable async =>
      !_isAndroid || (await _device()).sdk >= 30;

  /// Whether the vault goes to the bound store; on Android 7 to 10 only a
  /// vault bound before stays there.
  Future<bool> get _keystore async => await _keystoreUsable || await bound;

  Future<AndroidOptions> _android([String? namespace]) async =>
      AndroidOptions.biometric(
        storageNamespace: namespace ?? await (_namespace ??= _firstUse()),
        requireBiometricsPerOperation: true,
        biometricPromptTitle: prompt,
        biometricPromptSubtitle: promptSubtitle,
      );

  /// The namespace of the current generation. The plugin makes a missing
  /// key on the first use in a process; without a screen lock that key is
  /// not authentication bound, which [_moveKey] repairs later.
  Future<String> _firstUse() async {
    final generation = await _plain.read(key: _generation);
    if (_isAndroid && !(await _device()).secure) {
      await _plain.write(key: _weak, value: '1');
    }
    return generation == null ? 'vault' : 'vault.$generation';
  }

  Future<String> _nextGeneration() async {
    final current = await _plain.read(key: _generation);
    return '${(int.tryParse(current ?? '') ?? 0) + 1}';
  }

  static int _generationOf(String namespace) =>
      int.tryParse(namespace.replaceFirst('vault.', '')) ?? 0;

  /// Drops the vault of an invalidated key and moves to a fresh namespace,
  /// else the plugin would keep the dead key and fail every write.
  Future<void> _dropInvalidated() async {
    await _bound.deleteAll(aOptions: await _android());
    await _plain.write(key: _generation, value: await _nextGeneration());
    _namespace = null;
  }

  /// Whether the vault key was made without a screen lock and the device
  /// has one now, so [_moveKey] can replace it.
  Future<bool> get _weakNow async =>
      await _plain.read(key: _weak) != null &&
      await _keystoreUsable &&
      (await _device()).secure;

  /// Reads the vault; the system asks for Face ID, fingerprint or the
  /// device PIN when it is bound. Throws [Locked] when the user cancels.
  /// Returns true once open.
  Future<bool> open() async {
    final closed = _closed;
    _closed = false;
    if (closed) {
      // A read that started while closed fails as Locked: do not join it.
      _opening = null;
      _epoch++;
    }
    try {
      await _secrets();
    } on Object {
      _closed = closed;
      rethrow;
    }
    return true;
  }

  /// Reads the vault again even when it is open, so the system asks the
  /// user now; a failed check keeps the vault as it was, closed included.
  /// The check reads on its own: readers of an open vault never wait for
  /// it, and nothing is published before it (and the re-key of a weak key)
  /// succeeded.
  Future<bool> verify() async {
    final epoch = _epoch;
    final before = _open;
    var secrets = await _load();
    void publish() {
      if (epoch != _epoch) return;
      // A write since the read published newer secrets: keep those.
      if (identical(_open, before)) _open = secrets;
      _closed = false;
    }

    if (!await _weakNow) {
      publish();
      return true;
    }
    // In line with the writes, so the latest secrets move and a write
    // queued behind the re-key finds the vault open.
    await _serial(() async {
      if (await _weakNow) {
        if (!identical(_open, before)) secrets = _open ?? secrets;
        await _moveKey(secrets, _epoch);
      }
      publish();
    });
    return true;
  }

  /// Re-keys a weak vault after its first read (of close [epoch]) with the
  /// lock off; a cancelled prompt keeps the old key until the next write
  /// or check. Skipped when the vault closed since the read, so no prompt
  /// rises over the lock cover and no stale secrets are published, and
  /// when a move ran since, so a cancelled prompt is not asked again.
  void _rekey(int epoch) {
    final moves = _moves;
    _serial(() async {
      if (!await _weakNow) return;
      final open = _open;
      if (epoch != _epoch || open == null || moves != _moves) return;
      await _moveKey(open, epoch);
    }).ignore();
  }

  /// Counts [_moveKey] attempts, see [_rekey].
  int _moves = 0;

  /// Moves the vault to a new key now that the device has a screen lock:
  /// the old key opened without asking, the write under the new one asks,
  /// and that is the check. The new generation is stored only after that
  /// write succeeded, so a cancelled prompt or the process ending in it
  /// keeps the old vault; until then reads stay on the old namespace.
  /// Call in line with the other writes.
  Future<void> _moveKey(Map<String, String> secrets, int epoch) async {
    _moves++;
    final oldOptions = await _android();
    final target = await _save(
      secrets,
      epoch,
      target: 'vault.${await _nextGeneration()}',
    );
    await _plain.write(key: _generation, value: '${_generationOf(target!)}');
    _namespace = Future.value(target);
    await _plain.delete(key: _weak);
    await _bound.deleteAll(aOptions: oldOptions);
  }

  /// Ends the closed state without reading the vault, when the app opens
  /// without a check: no account yet, or the lock turned off.
  void release() => _closed = false;

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
      if (_closed && await bound) throw const Locked();
      final secrets = await _load();
      if (epoch == _epoch) {
        _open = secrets;
        if (await _weakNow) _rekey(epoch);
      }
      return secrets;
    } finally {
      if (epoch == _epoch) _opening = null;
    }
  }

  Future<Map<String, String>> _load() async {
    String? raw;
    if (await _keystore) {
      try {
        raw = await _bound.read(key: _vault, aOptions: await _android());
      } on PlatformException catch (e) {
        if (!_invalidated(e)) throw const Locked();
        // New fingerprints or face: the system dropped the key, the vault
        // is lost. Reset it; the app lock falls back to the device check.
        await _dropInvalidated();
      }
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

  /// Saves [secrets]; they become the open vault only when no [close]
  /// came since [epoch]. A re-key passes its [target] namespace and gets
  /// back the one written.
  Future<String?> _save(
    Map<String, String> secrets,
    int epoch, {
    bool retry = true,
    String? target,
  }) async {
    final raw = jsonEncode(secrets);
    if (!await _keystore) {
      await _plain.write(key: _unbound, value: raw);
    } else {
      try {
        await _bound.write(
          key: _vault,
          value: raw,
          aOptions: await _android(target),
        );
        await _plain.delete(key: _unbound);
      } on PlatformException catch (e) {
        if (retry && _invalidated(e)) {
          if (target == null) {
            await _dropInvalidated();
            return await _save(secrets, epoch, retry: false);
          }
          // The re-key target is invalidated: move past it, still storing
          // no generation before a write succeeded.
          await _bound.deleteAll(aOptions: await _android(target));
          return await _save(
            secrets,
            epoch,
            retry: false,
            target: 'vault.${_generationOf(target) + 1}',
          );
        }
        // Android stores unbound by itself without a screen lock, and with
        // a screen lock an error is a cancelled prompt: nothing changed.
        if (_isAndroid || await _deviceLock()) throw const Locked();
        // No screen lock to bind to: keep a working, unbound vault and drop
        // the bound one, else its stale secrets would win the next read.
        await _plain.write(key: _unbound, value: raw);
        await _bound.delete(key: _vault);
      }
    }
    // Every close counts up the epoch: a write that ends after one does
    // not reopen the vault. A closed but unbound vault reads without a
    // check, so a write there publishes like a read does.
    if (epoch == _epoch) _open = secrets;
    await _plain.write(key: _keys, value: jsonEncode(secrets.keys.toList()));
    return target;
  }

  /// Applies [change] to the latest vault and saves it if [change] returns
  /// true. Writes run one after another, so none overwrites another. A
  /// weak vault moves to an asking key with that write.
  Future<void> _update(bool Function(Map<String, String> secrets) change) =>
      _serial(() async {
        final epoch = _epoch;
        final secrets = {...await _secrets()};
        if (!change(secrets)) return;
        if (await _weakNow) {
          await _moveKey(secrets, epoch);
        } else {
          await _save(secrets, epoch);
        }
      });

  /// Runs [work] after all earlier writes; a failed one does not stop the
  /// next.
  Future<void> _serial(Future<void> Function() work) {
    final done = _writes.then((_) => work());
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

/// API level and screen lock (keyguard secure) of an Android device.
typedef AndroidDevice = ({int sdk, bool secure});

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
