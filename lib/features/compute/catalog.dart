// SPDX-License-Identifier: GPL-3.0-or-later
/// What a project offers for creating and changing resources: locations,
/// server types with prices, ISOs, networks, firewalls and pricing
/// (CMP-009, CMP-078, CMP-079). Locations only: Hetzner drops
/// `datacenter` in 2026 (CMP-080, CMP-092, BUG-011).
library;

import 'package:falco/api/cloud/cloud.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/http/http.dart';
import 'package:falco/core/http/pagination.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:flutter/foundation.dart';
import 'package:hetzner_cloud_api/hetzner_cloud_api.dart' as cloud;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog.g.dart';

/// A resource known by id and name (networks, firewalls, locations, ISOs).
@immutable
class Named {
  const new(this.id, this.name, [this.detail = '']);

  final int id;
  final String name;

  /// Description, city or similar.
  final String detail;
}

/// A server type with its monthly gross price per location
/// (CMP-010, CMP-098).
@immutable
class ServerType {
  const new({
    required this.id,
    required this.name,
    required this.cores,
    required this.memoryGb,
    required this.diskGb,
    required this.architecture,
    required this.prices,
    this.deprecated = false,
  });

  final int id;
  final String name;
  final int cores;
  final num memoryGb;
  final num diskGb;

  /// `x86` or `arm`.
  final String architecture;

  /// Location name to monthly gross price; a location without price
  /// does not offer the type.
  final Map<String, num> prices;
  final bool deprecated;
}

/// Currency and the volume price per GB and month (CMP-055).
typedef Pricing = ({
  String currency,
  num volumeGross,
  num volumeNet,
  num vatRate,
});

num _num(Object decimal) => num.parse('$decimal');

/// Locations of the project.
@riverpod
Future<List<Named>> locations(Ref ref, ProjectScope scope) =>
    fetchAll((page) async {
      final r = await unwrap(
        cloud.LocationsApi(ref.watch(cloudApiProvider(scope.projectId)))
            .listLocations(page: page, perPage: maxPerPage),
      );
      if (r is! cloud.ListLocationsResponse200) throw const Server();
      return (
        items: [
          for (final l in r.body.locations) Named(l.id, l.name, l.description),
        ],
        nextPage: r.body.meta.pagination.nextPage,
      );
    });

/// Server types with prices per location.
@riverpod
Future<List<ServerType>> serverTypes(Ref ref, ProjectScope scope) =>
    fetchAll((page) async {
      final r = await unwrap(
        cloud.ServerTypesApi(ref.watch(cloudApiProvider(scope.projectId)))
            .listServerTypes(page: page, perPage: maxPerPage),
      );
      if (r is! cloud.ListServerTypesResponse200) throw const Server();
      return (
        items: [
          for (final t in r.body.serverTypes)
            ServerType(
              id: t.id,
              name: t.name,
              cores: t.cores.toInt(),
              memoryGb: t.memory,
              diskGb: t.disk,
              architecture: t.architecture.name,
              // Deprecation is per location now; deprecated everywhere means
              // the type is gone.
              deprecated: t.locations.every((l) => l.deprecation != null),
              prices: {
                for (final p in t.prices)
                  if (t.locations.any(
                    (l) =>
                        l.name == p.location &&
                        l.available &&
                        l.deprecation == null,
                  ))
                    p.location: _num(p.priceMonthly.gross),
              },
            ),
        ],
        nextPage: r.body.meta.pagination.nextPage,
      );
    });

/// ISOs of the project (public and private), deprecated ones marked in
/// [Named.detail] by the caller (CMP-035).
@riverpod
Future<List<({Named iso, bool deprecated, String? architecture})>> isos(
  Ref ref,
  ProjectScope scope,
) => fetchAll((page) async {
  final r = await unwrap(
    cloud.IsOsApi(ref.watch(cloudApiProvider(scope.projectId)))
        .listIsos(page: page, perPage: maxPerPage),
  );
  if (r is! cloud.ListIsosResponse200) throw const Server();
  return (
    items: [
      for (final i in r.body.isos)
        (
          iso: Named(i.id, i.name ?? i.description, i.description),
          deprecated: i.deprecation != null,
          architecture: i.architecture?.name,
        ),
    ],
    nextPage: r.body.meta.pagination.nextPage,
  );
});

/// Private networks of the project (CMP-081).
@riverpod
Future<List<Named>> networks(Ref ref, ProjectScope scope) => fetchAll((
  page,
) async {
  final r = await unwrap(
    cloud.NetworksApi(ref.watch(cloudApiProvider(scope.projectId)))
        .listNetworks(page: page, perPage: maxPerPage),
  );
  if (r is! cloud.ListNetworksResponse200) throw const Server();
  return (
    items: [for (final n in r.body.networks) Named(n.id, n.name, n.ipRange)],
    nextPage: r.body.meta.pagination.nextPage,
  );
});

/// Firewalls of the project (CMP-082).
@riverpod
Future<List<Named>> firewalls(Ref ref, ProjectScope scope) =>
    fetchAll((page) async {
      final r = await unwrap(
        cloud.FirewallsApi(ref.watch(cloudApiProvider(scope.projectId)))
            .listFirewalls(page: page, perPage: maxPerPage),
      );
      if (r is! cloud.ListFirewallsResponse200) throw const Server();
      return (
        items: [for (final f in r.body.firewalls) Named(f.id, f.name)],
        nextPage: r.body.meta.pagination.nextPage,
      );
    });

/// Currency and volume prices of the project (CMP-078).
@riverpod
Future<Pricing> pricing(Ref ref, ProjectScope scope) async {
  final r = await unwrap(
    cloud.PricingApi(ref.watch(cloudApiProvider(scope.projectId))).getPricing(),
  );
  if (r is! cloud.GetPricingResponse200) throw const Server();
  final p = r.body.pricing;
  return (
    currency: p.currency,
    volumeGross: _num(p.volume.pricePerGbMonth.gross),
    volumeNet: _num(p.volume.pricePerGbMonth.net),
    vatRate: _num(p.vatRate),
  );
}
