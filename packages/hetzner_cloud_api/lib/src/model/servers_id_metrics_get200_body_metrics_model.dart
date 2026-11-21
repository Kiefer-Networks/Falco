// Generated code - do not modify by hand

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:convert' as _i6;
import 'dart:core' as _i3;

import 'package:collection/collection.dart' as _i5;
import 'package:hetzner_cloud_api/src/model/servers_id_metrics_get200_body_metrics_time_series_map_model.dart'
    as _i4;
import 'package:meta/meta.dart' as _i2;
import 'package:tonik_util/tonik_util.dart' as _i1;

@_i2.immutable
class ServersIdMetricsGet200BodyMetricsModel
    extends _i1.ObjectParameterEncodable
    implements _i1.UriEncodable {
  const ServersIdMetricsGet200BodyMetricsModel({
    required this.start,
    required this.end,
    required this.step,
    required this.timeSeries,
  });

  factory ServersIdMetricsGet200BodyMetricsModel.fromSimple(
    _i3.String? value, {
    required _i3.bool explode,
    _i3.bool isHeader = false,
  }) {
    throw _i1.SimpleDecodingException(
      r'Simple encoding not supported for ServersIdMetricsGet200BodyMetricsModel: contains complex types',
    );
  }

  factory ServersIdMetricsGet200BodyMetricsModel.fromJson(_i3.Object? json) {
    final _$map = json.decodeMap(
      context: r'ServersIdMetricsGet200BodyMetricsModel',
    );
    return ServersIdMetricsGet200BodyMetricsModel(
      start: _$map[r'start'].decodeJsonDateTime(
        context: r'ServersIdMetricsGet200BodyMetricsModel.start',
      ),
      end: _$map[r'end'].decodeJsonDateTime(
        context: r'ServersIdMetricsGet200BodyMetricsModel.end',
      ),
      step: _$map[r'step'].decodeJsonNum(
        context: r'ServersIdMetricsGet200BodyMetricsModel.step',
      ),
      timeSeries: _$map[r'time_series'].decodeJsonMap(
        (v) =>
            _i4.ServersIdMetricsGet200BodyMetricsTimeSeriesMapModel.fromJson(v),
        context: r'ServersIdMetricsGet200BodyMetricsModel.time_series',
      ),
    );
  }

  factory ServersIdMetricsGet200BodyMetricsModel.fromForm(
    _i3.String? value, {
    required _i3.bool explode,
  }) {
    throw _i1.FormDecodingException(
      r'Form encoding not supported for ServersIdMetricsGet200BodyMetricsModel: contains complex types',
    );
  }

  /// Start of period of metrics reported (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2017-01-01T00:00:00Z
  /// ```
  final _i3.DateTime start;

  /// End of period of metrics reported (in [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6) format).
  ///
  /// **Example**:
  /// ```
  /// 2017-01-01T23:00:00Z
  /// ```
  final _i3.DateTime end;

  /// Resolution of results in seconds.
  ///
  /// **Example**:
  /// ```json
  /// 60
  /// ```
  final _i3.num step;

  /// Hash with timeseries information, containing the name of timeseries as key.
  ///
  /// **Example**:
  /// ```json
  /// {
  ///   "name_of_timeseries": {
  ///     "values": [
  ///       [
  ///         1435781470.622,
  ///         "42"
  ///       ],
  ///       [
  ///         1435781471.622,
  ///         "43"
  ///       ]
  ///     ]
  ///   }
  /// }
  /// ```
  final _i3.Map<
    _i3.String,
    _i4.ServersIdMetricsGet200BodyMetricsTimeSeriesMapModel
  >
  timeSeries;

  @_i3.override
  _i3.Object? toJson() => {
    r'start': this.start.toTimeZonedIso8601String(),
    r'end': this.end.toTimeZonedIso8601String(),
    r'step': this.step,
    r'time_series': this.timeSeries.map((k, v) => _i3.MapEntry(k, v.toJson())),
  };

  ServersIdMetricsGet200BodyMetricsModel Function({
    _i3.DateTime? start,
    _i3.DateTime? end,
    _i3.num? step,
    _i3.Map<
      _i3.String,
      _i4.ServersIdMetricsGet200BodyMetricsTimeSeriesMapModel
    >?
    timeSeries,
  })
  get copyWith {
    return ({
      _i3.DateTime? start,
      _i3.DateTime? end,
      _i3.num? step,
      _i3.Map<
        _i3.String,
        _i4.ServersIdMetricsGet200BodyMetricsTimeSeriesMapModel
      >?
      timeSeries,
    }) => ServersIdMetricsGet200BodyMetricsModel(
      start: start ?? this.start,
      end: end ?? this.end,
      step: step ?? this.step,
      timeSeries: timeSeries ?? this.timeSeries,
    );
  }

  @_i3.override
  _i3.bool operator ==(_i3.Object other) {
    if (_i3.identical(this, other)) return true;
    const _$deepEquals = _i5.DeepCollectionEquality();
    return other is ServersIdMetricsGet200BodyMetricsModel &&
        other.start == this.start &&
        other.end == this.end &&
        other.step == this.step &&
        _$deepEquals.equals(other.timeSeries, this.timeSeries);
  }

  @_i3.override
  _i3.int get hashCode {
    const deepEquals = _i5.DeepCollectionEquality();
    return _i3.Object.hashAll([
      this.start,
      this.end,
      this.step,
      deepEquals.hash(this.timeSeries),
    ]);
  }

  _i1.EncodingShape get currentEncodingShape => _i1.EncodingShape.complex;

  @_i3.override
  _i3.Map<_i3.String, _i1.PropertyValue> parameterProperties({
    _i3.bool allowEmpty = true,
  }) => throw _i1.EncodingException(
    r'parameterProperties not supported for ServersIdMetricsGet200BodyMetricsModel: contains complex types',
  );

  @_i3.override
  _i3.String uriEncode({
    required _i3.bool allowEmpty,
    required _i6.Encoding textEncoding,
    _i3.bool useQueryComponent = false,
    _i3.bool allowReserved = false,
  }) {
    throw _i1.EncodingException(
      r'Cannot uriEncode ServersIdMetricsGet200BodyMetricsModel: complex types cannot be URI-encoded',
    );
  }
}
