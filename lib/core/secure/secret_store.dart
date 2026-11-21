// SPDX-License-Identifier: GPL-3.0-or-later
import 'dart:convert';

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

/// Tokens and keys, only in Keychain (iOS, this device, after unlock) and
/// Keystore (Android) (SET-017). Never cached in app state.
class SecretStore {
  /// Creates the store; tests pass nothing and use
  /// `FlutterSecureStorage.setMockInitialValues`.
  new([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.unlocked_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  /// Raw read, for non secret structured data (account list).
  Future<String?> read(String key) => _storage.read(key: key);

  /// Raw write.
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  /// Cloud API token of a project (also used for Storage Boxes and DNS).
  Future<String?> cloudToken(String projectId) => read('cloud.$projectId');

  /// Stores the Cloud API token of a project.
  Future<void> setCloudToken(String projectId, String token) =>
      write('cloud.$projectId', token);

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
  Future<void> setRobot(String accountId, RobotCredentials c) => write(
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
  Future<void> setS3(String projectId, S3Credentials c) => write(
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
    await _storage.delete(key: 'cloud.$projectId');
    await _storage.delete(key: 's3.$projectId');
  }

  /// Deletes the Robot credentials of an account.
  Future<void> deleteRobot(String accountId) =>
      _storage.delete(key: 'robot.$accountId');

  Future<Map<String, Object?>?> _json(String key) async {
    final raw = await read(key);
    return raw == null
        ? null
        : (jsonDecode(raw) as Map).cast<String, Object?>();
  }
}

/// The app wide secret store.
@Riverpod(keepAlive: true)
SecretStore secretStore(Ref ref) => SecretStore();
