// SPDX-License-Identifier: GPL-3.0-or-later
/// Handwritten Robot webservice client (no OpenAPI spec exists). Every
/// endpoint has a fixture under test/fixtures/robot/.
library;

import 'package:dio/dio.dart';

/// Base URL of the Robot webservice.
const robotBaseUrl = 'https://robot-ws.your-server.de';

/// A dedicated server as listed by `GET /server`.
class RobotServer {
  /// Creates a server.
  const new({
    required this.number,
    required this.name,
    required this.product,
    required this.dc,
    required this.status,
    required this.cancelled,
    this.ipv4,
    this.ipv6Net,
  });

  /// Parses one `{"server": {...}}` entry.
  factory fromJson(Map<String, Object?> json) {
    final s = (json['server']! as Map).cast<String, Object?>();
    return RobotServer(
      number: s['server_number']! as int,
      name: (s['server_name'] as String?) ?? '',
      ipv4: s['server_ip'] as String?,
      ipv6Net: s['server_ipv6_net'] as String?,
      product: s['product']! as String,
      dc: s['dc']! as String,
      status: s['status']! as String,
      cancelled: s['cancelled']! as bool,
    );
  }

  /// Server number, the id in Robot.
  final int number;

  /// User given name, may be empty.
  final String name;

  /// Main IPv4 address.
  final String? ipv4;

  /// IPv6 net.
  final String? ipv6Net;

  /// Product name, e.g. `AX41-NVMe`.
  final String product;

  /// Data center, e.g. `FSN1-DC14`.
  final String dc;

  /// `ready` or `in process`.
  final String status;

  /// Whether a cancellation is pending.
  final bool cancelled;
}

/// Robot API calls. Errors arrive as [DioException] carrying a
/// FalcoError (see ErrorInterceptor).
class RobotClient {
  /// Creates the client on a pinned, basic auth `dio`.
  const new(this._dio);

  final Dio _dio;

  /// `GET /server`.
  Future<List<RobotServer>> servers() async {
    final response = await _dio.get<List<Object?>>('/server');
    return [
      for (final e in response.data ?? const <Object?>[])
        RobotServer.fromJson((e! as Map).cast<String, Object?>()),
    ];
  }

  /// `GET /reset/{number}`: the reset types the server offers (BUG-012).
  Future<List<String>> resetTypes(int number) async {
    final response = await _dio.get<Map<String, Object?>>('/reset/$number');
    final reset = (response.data!['reset']! as Map).cast<String, Object?>();
    return [for (final t in reset['type']! as List) '$t'];
  }
}
