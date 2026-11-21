// SPDX-License-Identifier: GPL-3.0-or-later
// Steps and data of the search and activity tests (widget, golden,
// integration). Data is made up.
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'fake_cloud.dart';
import 'steps.dart';

/// One resource of every Cloud type, a Storage Box and a bucket next to
/// the default servers `web-1` (label env=prod) and `db-1`; Robot has
/// its fake servers, failover IP, vSwitch `backend` and key `laptop`.
FakeCloud searchCloud({List<Map<String, Object?>>? actions}) => FakeCloud(
  servers: [
    serverJson(id: 1, name: 'web-1', labels: const {'env': 'prod'}),
    serverJson(id: 2, name: 'db-1', status: 'off'),
  ],
  actions: actions,
  volumes: [volumeJson(id: 21, name: 'data')],
  images: [
    imageJson(id: 7, name: 'debian-12', description: 'Debian 12'),
    imageJson(id: 8, description: 'web-1 nightly', type: 'snapshot'),
  ],
  placementGroups: [placementGroupJson(id: 23, name: 'spread-web')],
  sshKeys: [sshKeyJson(id: 24, name: 'deploy')],
  networks: [networkJson(id: 31, name: 'backend-net')],
  firewalls: [firewallJson(id: 32, name: 'web-fw')],
  floatingIps: [floatingIpJson(id: 33, name: 'web-ip')],
  primaryIps: [primaryIpJson(id: 34, name: 'mail-ip')],
  loadBalancers: [loadBalancerJson(id: 35, name: 'web-lb')],
  certificates: [certificateJson(id: 36, name: 'web-cert')],
  zones: [zoneJson(id: 37, name: 'example.com', records: 3)],
  storage: FakeStorage(
    boxes: [storageBoxJson(id: 41, name: 'backup')],
    buckets: {
      'fsn1': {'media': FakeBucket()},
    },
  ),
);

/// Opens the search of [cloud] (Acme with Robot and S3 keys) and types
/// [query]. On a device the real screen stays ([surface] false), so the
/// keyboard keeps its real size.
Future<FakeCloud> openSearch(
  WidgetTester tester, {
  FakeCloud? cloud,
  String? query,
  bool surface = true,
}) async {
  final c = cloud ?? searchCloud();
  if (surface) setSurface(tester);
  await pumpFalco(tester, c, accounts: const [acmeRobot], s3: true);
  await tester.tap(find.byTooltip('Search'));
  await tester.pumpAndSettle();
  if (query != null) await search(tester, query);
  return c;
}

/// Types [query] into the search field.
Future<void> search(WidgetTester tester, String query) async {
  await tester.enterText(find.byType(TextField).first, query);
  await tester.pumpAndSettle();
}
