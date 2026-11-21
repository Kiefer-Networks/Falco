// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i4;
import 'dart:core' as _i3;

import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

/// Details of the active snapshot plan.
///
/// Not available if the `status` is `initializing`.
///
@_i2.immutable
class $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel({
    required this.maxSnapshots,
    required this.minute,
    required this.hour,
    required this.dayOfWeek,
    required this.dayOfMonth,
  });

  factory $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: ',',
      expectedKeys: {
        r'max_snapshots',
        r'minute',
        r'hour',
        r'day_of_week',
        r'day_of_month',
      },
      listKeys: {},
      context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel',
      isHeader: isHeader,
      percentDecodeKeys: false,
    );
    return $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel(
      maxSnapshots: _$values[r'max_snapshots'].decodeSimpleInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.max_snapshots',
      ),
      minute: _$values[r'minute'].decodeSimpleInt(
        context:
            r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.minute',
      ),
      hour: _$values[r'hour'].decodeSimpleInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.hour',
      ),
      dayOfWeek: _$values[r'day_of_week'].decodeSimpleNullableInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.day_of_week',
      ),
      dayOfMonth: _$values[r'day_of_month'].decodeSimpleNullableInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.day_of_month',
      ),
    );
  }

  factory $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.fromJson(
    _i3.Object? json,
  ) {
    final _$map = json.decodeMap(
      context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel',
    );
    return $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel(
      maxSnapshots: _$map[r'max_snapshots'].decodeJsonInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.max_snapshots',
      ),
      minute: _$map[r'minute'].decodeJsonInt(
        context:
            r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.minute',
      ),
      hour: _$map[r'hour'].decodeJsonInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.hour',
      ),
      dayOfWeek: _$map[r'day_of_week'].decodeJsonNullableInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.day_of_week',
      ),
      dayOfMonth: _$map[r'day_of_month'].decodeJsonNullableInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.day_of_month',
      ),
    );
  }

  factory $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    final _$values = value.decodeObject(
      explode: explode,
      explodeSeparator: '&',
      expectedKeys: {
        r'max_snapshots',
        r'minute',
        r'hour',
        r'day_of_week',
        r'day_of_month',
      },
      listKeys: {},
      context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel',
    );
    return $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel(
      maxSnapshots: _$values[r'max_snapshots'].decodeFormInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.max_snapshots',
      ),
      minute: _$values[r'minute'].decodeFormInt(
        context:
            r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.minute',
      ),
      hour: _$values[r'hour'].decodeFormInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.hour',
      ),
      dayOfWeek: _$values[r'day_of_week'].decodeFormNullableInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.day_of_week',
      ),
      dayOfMonth: _$values[r'day_of_month'].decodeFormNullableInt(
        context: r'$RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel.day_of_month',
      ),
    );
  }

  /// Maximum amount of Snapshots that will be created by this Snapshot Plan.
  ///
  /// Older Snapshots will be deleted.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 10
  /// ```
  final _i3.int maxSnapshots;

  /// Minute when the Snapshot Plan is executed (UTC).
  ///
  ///
  /// **Example**:
  /// ```json
  /// 30
  /// ```
  final _i3.int minute;

  /// Hour when the Snapshot Plan is executed (UTC).
  ///
  ///
  /// **Example**:
  /// ```json
  /// 3
  /// ```
  final _i3.int hour;

  /// Day of the week when the Snapshot Plan is executed.
  ///
  /// Starts at 1 for Monday til 7 for Sunday. Null means every day.
  ///
  ///
  /// **Example**:
  /// ```json
  /// 7
  /// ```
  final _i3.int? dayOfWeek;

  /// Day of the month when the Snapshot Plan is executed.
  ///
  /// Null means every day.
  ///
  final _i3.int? dayOfMonth;

  @_i3.override
  _i3.Object? toJson() => {
    r'max_snapshots': this.maxSnapshots,
    r'minute': this.minute,
    r'hour': this.hour,
    r'day_of_week': this.dayOfWeek,
    r'day_of_month': this.dayOfMonth,
  };

  $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel Function({
    _i3.int? maxSnapshots,
    _i3.int? minute,
    _i3.int? hour,
    _i3.int? dayOfWeek,
    _i3.int? dayOfMonth,
  })
  get copyWith {
    const _i3.Object _sentinel = _i3.Object();
    return ({
      _i3.int? maxSnapshots,
      _i3.int? minute,
      _i3.int? hour,
      _i3.Object? dayOfWeek = _sentinel,
      _i3.Object? dayOfMonth = _sentinel,
    }) => $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel(
      maxSnapshots: maxSnapshots ?? this.maxSnapshots,
      minute: minute ?? this.minute,
      hour: hour ?? this.hour,
      dayOfWeek: _i3.identical(dayOfWeek, _sentinel)
          ? this.dayOfWeek
          : (dayOfWeek as _i3.int?),
      dayOfMonth: _i3.identical(dayOfMonth, _sentinel)
          ? this.dayOfMonth
          : (dayOfMonth as _i3.int?),
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    return other is $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel &&
        other.maxSnapshots == this.maxSnapshots &&
        other.minute == this.minute &&
        other.hour == this.hour &&
        other.dayOfWeek == this.dayOfWeek &&
        other.dayOfMonth == this.dayOfMonth;
  }

  @_i3.override
  _i3.int get hashCode {
    return _i3.Object.hashAll([
      this.maxSnapshots,
      this.minute,
      this.hour,
      this.dayOfWeek,
      this.dayOfMonth,
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) {
    final _$result = <_i3.String, _i1.PropertyValue>{};
    _$result[r'max_snapshots'] = _i1.PropertyValue.scalar(
      this.maxSnapshots.toString(),
    );
    _$result[r'minute'] = _i1.PropertyValue.scalar(this.minute.toString());
    _$result[r'hour'] = _i1.PropertyValue.scalar(this.hour.toString());
    if (this.dayOfWeek != null) {
      _$result[r'day_of_week'] = _i1.PropertyValue.scalar(
        this.dayOfWeek!.toString(),
      );
    }
    if (this.dayOfMonth != null) {
      _$result[r'day_of_month'] = _i1.PropertyValue.scalar(
        this.dayOfMonth!.toString(),
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
      r'Cannot uriEncode $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel: complex types cannot be URI-encoded',
    );
  }
}

typedef StorageBoxesPost201BodyStorageBoxSnapshotPlanModel =
    $RawStorageBoxesPost201BodyStorageBoxSnapshotPlanModel?;
