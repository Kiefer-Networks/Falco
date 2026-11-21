// SPDX-License-Identifier: GPL-3.0-or-later

/// Largest page size the Hetzner APIs accept.
const maxPerPage = 50;

/// One page of a list endpoint: its items and `meta.pagination.next_page`.
typedef Page<T> = ({List<T> items, int? nextPage});

/// Loads every page, starting at page 1 (QRS-016). [fetch] gets the page
/// number and is expected to request [maxPerPage] items.
///
/// Stops when the API reports no next page; a next page that does not
/// advance is treated as the end, so a broken response cannot loop forever.
Future<List<T>> fetchAll<T>(Future<Page<T>> Function(int page) fetch) async {
  final all = <T>[];
  int? page = 1;
  while (page != null) {
    final result = await fetch(page);
    all.addAll(result.items);
    final next = result.nextPage;
    page = next != null && next > page ? next : null;
  }
  return all;
}
