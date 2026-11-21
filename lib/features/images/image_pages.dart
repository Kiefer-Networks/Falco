// SPDX-License-Identifier: GPL-3.0-or-later
import 'package:falco/app/router.dart';
import 'package:falco/core/errors/falco_error.dart';
import 'package:falco/core/format/format.dart';
import 'package:falco/core/scope/scope.dart';
import 'package:falco/features/accounts/accounts.dart';
import 'package:falco/features/activity/activity.dart';
import 'package:falco/features/activity/activity_page.dart';
import 'package:falco/features/compute/compute_ui.dart';
import 'package:falco/features/images/images.dart';
import 'package:falco/l10n/app_localizations.dart';
import 'package:falco/ui/error_text.dart';
import 'package:falco/ui/ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Localized kind of an image.
String imageKindText(ImageKind kind, AppLocalizations l10n) => switch (kind) {
  ImageKind.system => l10n.imageSystem,
  ImageKind.app => l10n.imageApp,
  ImageKind.snapshot => l10n.imageSnapshot,
  ImageKind.backup => l10n.imageBackup,
};

/// Own snapshots and backups of a scope with size, date and source
/// (CMP-090).
class ImageList extends ConsumerWidget {
  const new({required this.scope, super.key});

  final Scope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = imagesProvider(scope);
    final async = ref.watch(provider);
    final accounts = scope is AllProjectsScope
        ? ref.watch(accountsProvider.select((a) => a.value))
        : null;
    return ResourceList<CloudImage>(
      title: l10n.resourceImages,
      items: async.value?.where((i) => i.own).toList(),
      failedProjects: switch (async.value) {
        final PartialList<CloudImage> l => l.failed,
        _ => null,
      },
      loading: async.isLoading,
      error: async.hasError
          ? errorText(toFalcoError(async.error!), l10n)
          : null,
      onRefresh: () => refreshQuietly(ref, provider.future),
      empty: EmptyHint(message: l10n.emptyImages),
      searchText: (i) => '${i.description} ${i.source ?? ''}',
      filters: [
        ResourceFilter(l10n.filterAll, (_) => true),
        ResourceFilter(l10n.imageSnapshot, (i) => i.kind == ImageKind.snapshot),
        ResourceFilter(l10n.imageBackup, (i) => i.kind == ImageKind.backup),
      ],
      sorts: [
        ResourceSort(
          l10n.sortCreated,
          (a, b) => b.created.compareTo(a.created),
        ),
        ResourceSort(
          l10n.sortName,
          (a, b) => a.description.compareTo(b.description),
        ),
      ],
      itemBuilder: (context, i) => ResourceRow(
        status: i.status,
        name: i.description,
        monoLine: [
          imageKindText(i.kind, l10n),
          if (i.sizeGb case final size?) gb(size, l10n.localeName),
          formatDateTime(i.created, l10n.localeName),
          ?i.source,
          if (accounts != null) projectName(accounts, i.projectId),
        ].join(' · '),
        onTap: () => openDetail(
          context,
          ImageRoute(
            accountId: scope.accountId,
            projectId: i.projectId,
            imageId: i.id,
          ),
        ),
      ),
    );
  }
}

/// One snapshot or backup: edit, protection, convert, delete
/// (CMP-093 to CMP-096).
class ImageDetailPage extends ConsumerWidget {
  const new({required this.scope, required this.imageId, super.key});

  final ProjectScope scope;
  final int imageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = imageProvider(scope, imageId);
    final async = ref.watch(provider);
    final i = async.value;
    if (i == null) {
      return DetailLoading(
        title: l10n.resourceImage,
        error: async.error,
        onRetry: () => ref.invalidate(provider),
      );
    }
    final t = (
      scope: scope,
      type: CloudType.image,
      id: i.id,
      name: i.description,
    );
    final progress = ref
        .watch(trackedActionProvider(scope, CloudType.image, i.id))
        .value;
    final busy = progress != null && !progress.done;
    Future<void> protect() async {
      if (await confirmProtection(context, t, protect: !i.protectDelete) &&
          context.mounted) {
        await runAction(
          context,
          ref,
          scope,
          (api) => protectImage(api, i.id, delete: !i.protectDelete),
        );
      }
    }

    Future<void> convert() async {
      final confirmed = await ConfirmSheet.show(
        context,
        title: l10n.imageConvertTitle(i.description),
        consequence: l10n.imageConvertConsequence,
        confirmLabel: l10n.imageConvert,
        resourceName: i.description,
      );
      if (confirmed && context.mounted) {
        await runChange(
          context,
          ref,
          t,
          (api) => updateImage(api, i.id, toSnapshot: true),
        );
      }
    }

    return FalcoScaffold(
      title: l10n.resourceImage,
      body: DetailPage(
        status: busy ? ResourceStatus.inProgress : i.status,
        name: i.description,
        ids: [
          imageKindText(i.kind, l10n),
          if (i.sizeGb case final size?) gb(size, l10n.localeName),
        ],
        onRefresh: () => refreshQuietly(ref, provider.future),
        actions: [
          DetailAction(
            icon: Icons.edit_outlined,
            label: l10n.commonEdit,
            onTap: () => editNameAndLabels(
              context,
              ref,
              t,
              i.labels,
              (api, name, labels) =>
                  updateImage(api, i.id, description: name, labels: labels),
              nameLabel: l10n.fieldImageDescription,
            ),
          ),
          DetailAction(
            icon: i.protectDelete ? Icons.lock : Icons.lock_open,
            label: l10n.fieldProtection,
            onTap: busy ? null : protect,
          ),
          if (i.kind == ImageKind.backup)
            DetailAction(
              icon: Icons.photo_camera_outlined,
              label: l10n.imageConvert,
              onTap: convert,
            ),
        ],
        sections: [
          DetailSection(
            title: l10n.sectionOverview,
            child: FactRows([
              ConfirmFact(l10n.fieldType, imageKindText(i.kind, l10n)),
              if (i.sizeGb case final size?)
                ConfirmFact(l10n.fieldSize, gb(size, l10n.localeName)),
              ConfirmFact(l10n.fieldDisk, gb(i.diskGb, l10n.localeName)),
              ConfirmFact(l10n.fieldSource, i.source ?? l10n.commonNone),
              ConfirmFact(l10n.fieldArchitecture, i.architecture),
              ConfirmFact(
                l10n.fieldDeleteProtection,
                yesNo(i.protectDelete, l10n),
              ),
              ConfirmFact(
                l10n.fieldCreated,
                formatDateTime(i.created, l10n.localeName),
              ),
              ConfirmFact(l10n.fieldLabels, labelsText(i.labels, l10n)),
            ]),
          ),
          activitySection(l10n, scope, CloudType.image, i.id),
        ],
        dangerZone: [
          DeleteButton(
            onPressed: () async {
              if (!await confirmDelete(
                    context,
                    t,
                    l10n.imageDeleteConsequence,
                  ) ||
                  !context.mounted) {
                return;
              }
              final deleted = await runChange(
                context,
                ref,
                t,
                (api) => deleteImage(api, i.id),
                done: l10n.deletedMessage(i.description),
              );
              if (deleted && context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
