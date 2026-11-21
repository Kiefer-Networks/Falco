// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/dns/zone_pages.dart';
import 'package:falco/features/network/certificate_pages.dart';
import 'package:falco/features/network/firewall_pages.dart';
import 'package:falco/features/network/ip_pages.dart';
import 'package:falco/features/network/ips.dart';
import 'package:falco/features/network/load_balancer_pages.dart';
import 'package:falco/features/network/network_pages.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The Network area: networks, firewalls, Floating and Primary IPs, load
/// balancers, certificates and DNS zones as tabs, each a list with its
/// create action (README section 3 and 4: DNS is part of Network).
class NetworkPage extends StatefulWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 7, vsync: this)
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = widget.scope;
    final (kind, label) = switch (_tabs.index) {
      0 => (CreateKind.network, l10n.networkCreate),
      1 => (CreateKind.firewall, l10n.firewallCreate),
      2 => (CreateKind.floatingIp, l10n.floatingIpCreate),
      3 => (CreateKind.primaryIp, l10n.primaryIpCreate),
      4 => (CreateKind.loadBalancer, l10n.loadBalancerCreate),
      5 => (CreateKind.certificate, l10n.certificateCreate),
      _ => (CreateKind.zone, l10n.zoneCreate),
    };
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: kind,
        onPressed: () => CreateRoute.of(scope, kind).push<void>(context),
        icon: const Icon(Icons.add),
        label: Text(label),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.resourceNetworks),
              Tab(text: l10n.resourceFirewalls),
              Tab(text: l10n.resourceFloatingIps),
              Tab(text: l10n.resourcePrimaryIps),
              Tab(text: l10n.resourceLoadBalancers),
              Tab(text: l10n.resourceCertificates),
              Tab(text: l10n.resourceZones),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                NetworkList(scope: scope),
                FirewallList(scope: scope),
                IpList(scope: scope, kind: IpKind.floating),
                IpList(scope: scope, kind: IpKind.primary),
                LoadBalancerList(scope: scope),
                CertificateList(scope: scope),
                ZoneList(scope: scope),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
