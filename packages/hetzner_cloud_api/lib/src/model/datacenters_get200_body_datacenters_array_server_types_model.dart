// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i5;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// This field is deprecated, as all of it's properties are deprecated.
///
/// [Server Types](#tag/server-types) supported and available in this [Data Center](#tag/data-centers).
///
@_i2.immutable
@_i3.Deprecated('This class is deprecated.')
class DatacentersGet200BodyDatacentersArrayServerTypesModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const DatacentersGet200BodyDatacentersArrayServerTypesModel({
    required this.supported,
    required this.available,
    required this.availableForMigration,
  });

  factory DatacentersGet200BodyDatacentersArrayServerTypesModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {r'supported', r'available', r'available_for_migration'},
      listKeys: {r'supported', r'available', r'available_for_migration'},
      context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return DatacentersGet200BodyDatacentersArrayServerTypesModel(
      supported: _$values[r'supported']
          .decodeSimpleStringList(
            context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.supported',
            isHeader: isHeader,
          )
          .map(
            (e) => e.decodeSimpleInt(
              context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.supported',
            ),
          )
          .toList(),
      available: _$values[r'available']
          .decodeSimpleStringList(
            context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available',
            isHeader: isHeader,
          )
          .map(
            (e) => e.decodeSimpleInt(
              context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available',
            ),
          )
          .toList(),
      availableForMigration: _$values[r'available_for_migration']
          .decodeSimpleStringList(
            context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available_for_migration',
            isHeader: isHeader,
          )
          .map(
            (e) => e.decodeSimpleInt(
              context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available_for_migration',
            ),
          )
          .toList(),
    );
  }

  factory DatacentersGet200BodyDatacentersArrayServerTypesModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel',
    );
    return DatacentersGet200BodyDatacentersArrayServerTypesModel(
      supported: _$map[r'supported'].decodeJsonList<_i3.int>(
        context:
            r'DatacentersGet200BodyDatacentersArrayServerTypesModel.supported',
      ),
      available: _$map[r'available'].decodeJsonList<_i3.int>(
        context:
            r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available',
      ),
      availableForMigration: _$map[r'available_for_migration']
          .decodeJsonList<_i3.int>(
            context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available_for_migration',
          ),
    );
  }

  factory DatacentersGet200BodyDatacentersArrayServerTypesModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {r'supported', r'available', r'available_for_migration'},
      listKeys: {r'supported', r'available', r'available_for_migration'},
      context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel',
    );
    return DatacentersGet200BodyDatacentersArrayServerTypesModel(
      supported: _$values[r'supported']
          .decodeSimpleStringList(
            context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.supported',
          )
          .map(
            (e) => e.decodeFormInt(
              context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.supported',
            ),
          )
          .toList(),
      available: _$values[r'available']
          .decodeSimpleStringList(
            context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available',
          )
          .map(
            (e) => e.decodeFormInt(
              context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available',
            ),
          )
          .toList(),
      availableForMigration: _$values[r'available_for_migration']
          .decodeSimpleStringList(
            context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available_for_migration',
          )
          .map(
            (e) => e.decodeFormInt(
              context: r'DatacentersGet200BodyDatacentersArrayServerTypesModel.available_for_migration',
            ),
          )
          .toList(),
    );
  }

  /// This field is deprecated. Use the [Server Type](#tag/server-types) `locations` field instead.
  ///
  /// List of [Server Types](#tag/server-types) supported in this [Data Center](#tag/data-centers).
  ///
  /// These [Server Types](#tag/server-types) are generally available in this Data Center, but may be
  /// temporarily out of stock.
  ///
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   1,
  ///   2,
  ///   3
  /// ]
  /// ```
  @_i3.Deprecated('This property is deprecated.')
  final _i3.List<_i3.int> supported;

  /// This field is deprecated. Use the `available` flag in the [Server Type](#tag/server-types) `locations` field instead (`server_type.locations[].available`).
  ///
  /// [Server Types](#tag/server-types) currently available in this [Data Center](#tag/data-centers).
  ///
  /// These [Server Types](#tag/server-types) can currently be purchased. Types that are temporarily unavailable
  /// but are supported in this [Data Center](#tag/data-centers) are listed as `supported`.
  ///
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   1,
  ///   2,
  ///   3
  /// ]
  /// ```
  @_i3.Deprecated('This property is deprecated.')
  final _i3.List<_i3.int> available;

  /// This field is deprecated. Use the `available` flag in the [Server Type](#tag/server-types) `locations` field instead (`server_type.locations[].available`).
  ///
  /// [Server Types](#tag/server-types) available to migrate to in this [Data Center](#tag/data-centers).
  ///
  /// Existing [Servers](#tag/servers) can be migrated to these [Server Types](#tag/server-types).
  ///
  ///
  /// **Example**:
  /// ```json
  /// [
  ///   1,
  ///   2,
  ///   3
  /// ]
  /// ```
  @_i3.Deprecated('This property is deprecated.')
  final _i3.List<_i3.int> availableForMigration;

  @_i3.override
  _i3.Object? toJson() => {
    r'supported': this.supported,
    r'available': this.available,
    r'available_for_migration': this.availableForMigration,
  };

  DatacentersGet200BodyDatacentersArrayServerTypesModel Function({
    _i3.List<_i3.int>? supported,
    _i3.List<_i3.int>? available,
    _i3.List<_i3.int>? availableForMigration,
  })
  get copyWith {
    return ({
      _i3.List<_i3.int>? supported,
      _i3.List<_i3.int>? available,
      _i3.List<_i3.int>? availableForMigration,
    }) => DatacentersGet200BodyDatacentersArrayServerTypesModel(
      supported: supported ?? this.supported,
      available: available ?? this.available,
      availableForMigration:
          availableForMigration ?? this.availableForMigration,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i4.DeepCollectionEquality();
    return other is DatacentersGet200BodyDatacentersArrayServerTypesModel &&
        _$deepEquals.equals(other.supported, this.supported) &&
        _$deepEquals.equals(other.available, this.available) &&
        _$deepEquals.equals(
          other.availableForMigration,
          this.availableForMigration,
        );
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i4.DeepCollectionEquality();
    return _i3.Object.hashAll([
      deepEquals.hash(this.supported),
      deepEquals.hash(this.available),
      deepEquals.hash(this.availableForMigration),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'supported'] = _i1.PropertyValue.array(
      this.supported.map((e) => e.toString()).toList(),
    );
    _$result[r'available'] = _i1.PropertyValue.array(
      this.available.map((e) => e.toString()).toList(),
    );
    _$result[r'available_for_migration'] = _i1.PropertyValue.array(
      this.availableForMigration.map((e) => e.toString()).toList(),
    );
    return _$result;
  }

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i5.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode DatacentersGet200BodyDatacentersArrayServerTypesModel: complex types cannot be URI-encoded',
    );
  }
}
