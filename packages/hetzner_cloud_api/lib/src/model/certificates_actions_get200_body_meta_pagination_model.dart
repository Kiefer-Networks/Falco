// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// See "[Pagination](#description/pagination)" for more information.
@_i2.immutable
class CertificatesActionsGet200BodyMetaPaginationModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const CertificatesActionsGet200BodyMetaPaginationModel({
    required this.previousPage,
    required this.nextPage,
    required this.lastPage,
    required this.totalEntries,
    this.page = pageDefault,
    this.perPage = perPageDefault,
  });

  factory CertificatesActionsGet200BodyMetaPaginationModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'page',
        r'per_page',
        r'previous_page',
        r'next_page',
        r'last_page',
        r'total_entries',
      },
      listKeys: {},
      context: r'CertificatesActionsGet200BodyMetaPaginationModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return CertificatesActionsGet200BodyMetaPaginationModel(
      page: _$values.containsKey(r'page')
          ? _$values[r'page'].decodeSimpleInt(
              context: r'CertificatesActionsGet200BodyMetaPaginationModel.page',
            )
          : pageDefault,
      perPage: _$values.containsKey(r'per_page')
          ? _$values[r'per_page'].decodeSimpleInt(
              context:
                  r'CertificatesActionsGet200BodyMetaPaginationModel.per_page',
            )
          : perPageDefault,
      previousPage: _$values[r'previous_page'].decodeSimpleNullableInt(
        context:
            r'CertificatesActionsGet200BodyMetaPaginationModel.previous_page',
      ),
      nextPage: _$values[r'next_page'].decodeSimpleNullableInt(
        context: r'CertificatesActionsGet200BodyMetaPaginationModel.next_page',
      ),
      lastPage: _$values[r'last_page'].decodeSimpleNullableInt(
        context: r'CertificatesActionsGet200BodyMetaPaginationModel.last_page',
      ),
      totalEntries: _$values[r'total_entries'].decodeSimpleNullableInt(
        context:
            r'CertificatesActionsGet200BodyMetaPaginationModel.total_entries',
      ),
    );
  }

  factory CertificatesActionsGet200BodyMetaPaginationModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'CertificatesActionsGet200BodyMetaPaginationModel',
    );
    return CertificatesActionsGet200BodyMetaPaginationModel(
      page: _$map.containsKey(r'page')
          ? _$map[r'page'].decodeJsonInt(
              context: r'CertificatesActionsGet200BodyMetaPaginationModel.page',
            )
          : pageDefault,
      perPage: _$map.containsKey(r'per_page')
          ? _$map[r'per_page'].decodeJsonInt(
              context:
                  r'CertificatesActionsGet200BodyMetaPaginationModel.per_page',
            )
          : perPageDefault,
      previousPage: _$map[r'previous_page'].decodeJsonNullableInt(
        context:
            r'CertificatesActionsGet200BodyMetaPaginationModel.previous_page',
      ),
      nextPage: _$map[r'next_page'].decodeJsonNullableInt(
        context: r'CertificatesActionsGet200BodyMetaPaginationModel.next_page',
      ),
      lastPage: _$map[r'last_page'].decodeJsonNullableInt(
        context: r'CertificatesActionsGet200BodyMetaPaginationModel.last_page',
      ),
      totalEntries: _$map[r'total_entries'].decodeJsonNullableInt(
        context:
            r'CertificatesActionsGet200BodyMetaPaginationModel.total_entries',
      ),
    );
  }

  factory CertificatesActionsGet200BodyMetaPaginationModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'page',
        r'per_page',
        r'previous_page',
        r'next_page',
        r'last_page',
        r'total_entries',
      },
      listKeys: {},
      context: r'CertificatesActionsGet200BodyMetaPaginationModel',
    );
    return CertificatesActionsGet200BodyMetaPaginationModel(
      page: _$values.containsKey(r'page')
          ? _$values[r'page'].decodeFormInt(
              context: r'CertificatesActionsGet200BodyMetaPaginationModel.page',
            )
          : pageDefault,
      perPage: _$values.containsKey(r'per_page')
          ? _$values[r'per_page'].decodeFormInt(
              context:
                  r'CertificatesActionsGet200BodyMetaPaginationModel.per_page',
            )
          : perPageDefault,
      previousPage: _$values[r'previous_page'].decodeFormNullableInt(
        context:
            r'CertificatesActionsGet200BodyMetaPaginationModel.previous_page',
      ),
      nextPage: _$values[r'next_page'].decodeFormNullableInt(
        context: r'CertificatesActionsGet200BodyMetaPaginationModel.next_page',
      ),
      lastPage: _$values[r'last_page'].decodeFormNullableInt(
        context: r'CertificatesActionsGet200BodyMetaPaginationModel.last_page',
      ),
      totalEntries: _$values[r'total_entries'].decodeFormNullableInt(
        context:
            r'CertificatesActionsGet200BodyMetaPaginationModel.total_entries',
      ),
    );
  }

  static const _i3.int pageDefault = 1;

  static const _i3.int perPageDefault = 25;

  /// Current page number.
  ///
  /// **Example**:
  /// ```json
  /// 3
  /// ```
  final _i3.int page;

  /// Maximum number of entries returned per page.
  ///
  /// **Example**:
  /// ```json
  /// 25
  /// ```
  final _i3.int perPage;

  /// Page number of the previous page. Can be null if the current page is the first one.
  ///
  /// **Example**:
  /// ```json
  /// 2
  /// ```
  final _i3.int? previousPage;

  /// Page number of the next page. Can be null if the current page is the last one.
  ///
  /// **Example**:
  /// ```json
  /// 4
  /// ```
  final _i3.int? nextPage;

  /// Page number of the last page available. Can be null if the current page is the last one.
  ///
  /// **Example**:
  /// ```json
  /// 4
  /// ```
  final _i3.int? lastPage;

  /// Total number of entries that exist for this query. Can be null if unknown.
  ///
  /// **Example**:
  /// ```json
  /// 100
  /// ```
  final _i3.int? totalEntries;

  @_i3.override
  _i3.Object? toJson() => {
    r'page': this.page,
    r'per_page': this.perPage,
    r'previous_page': this.previousPage,
    r'next_page': this.nextPage,
    r'last_page': this.lastPage,
    r'total_entries': this.totalEntries,
  };

  CertificatesActionsGet200BodyMetaPaginationModel Function({
    _i3.int? page,
    _i3.int? perPage,
    _i3.int? previousPage,
    _i3.int? nextPage,
    _i3.int? lastPage,
    _i3.int? totalEntries,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? page,
      _i3.int? perPage,
      _i3.Object? previousPage = _sentinel,
      _i3.Object? nextPage = _sentinel,
      _i3.Object? lastPage = _sentinel,
      _i3.Object? totalEntries = _sentinel,
    }) => CertificatesActionsGet200BodyMetaPaginationModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      previousPage: _i3.identical(previousPage, _sentinel)
          ? this.previousPage
          : (previousPage as _i3.int?),
      nextPage: _i3.identical(nextPage, _sentinel)
          ? this.nextPage
          : (nextPage as _i3.int?),
      lastPage: _i3.identical(lastPage, _sentinel)
          ? this.lastPage
          : (lastPage as _i3.int?),
      totalEntries: _i3.identical(totalEntries, _sentinel)
          ? this.totalEntries
          : (totalEntries as _i3.int?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is CertificatesActionsGet200BodyMetaPaginationModel &&
        other.page == this.page &&
        other.perPage == this.perPage &&
        other.previousPage == this.previousPage &&
        other.nextPage == this.nextPage &&
        other.lastPage == this.lastPage &&
        other.totalEntries == this.totalEntries;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.page,
      this.perPage,
      this.previousPage,
      this.nextPage,
      this.lastPage,
      this.totalEntries,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'page'] = _i1.PropertyValue.scalar(this.page.toString());
    _$result[r'per_page'] = _i1.PropertyValue.scalar(this.perPage.toString());
    if (this.previousPage != null) {
      _$result[r'previous_page'] = _i1.PropertyValue.scalar(
        this.previousPage!.toString(),
      );
    }
    if (this.nextPage != null) {
      _$result[r'next_page'] = _i1.PropertyValue.scalar(
        this.nextPage!.toString(),
      );
    }
    if (this.lastPage != null) {
      _$result[r'last_page'] = _i1.PropertyValue.scalar(
        this.lastPage!.toString(),
      );
    }
    if (this.totalEntries != null) {
      _$result[r'total_entries'] = _i1.PropertyValue.scalar(
        this.totalEntries!.toString(),
      );
    }
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i4.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode CertificatesActionsGet200BodyMetaPaginationModel: complex types cannot be URI-encoded',
    );
  }
}
