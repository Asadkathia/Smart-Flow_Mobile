// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VisitModel _$VisitModelFromJson(Map<String, dynamic> json) {
  return _VisitModel.fromJson(json);
}

/// @nodoc
mixin _$VisitModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  @JsonKey(name: 'job_id')
  String get jobId => throw _privateConstructorUsedError;
  @JsonKey(name: 'technician_id')
  String get technicianId => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_start')
  DateTime get scheduledStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_end')
  DateTime get scheduledEnd => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_start')
  DateTime? get actualStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_end')
  DateTime? get actualEnd => throw _privateConstructorUsedError;
  VisitStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_reason')
  String? get statusReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'sequence_order')
  int? get sequenceOrder => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Extended fields for UI
  String? get title => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'signature_url')
  String? get signatureUrl => throw _privateConstructorUsedError;

  /// Serializes this VisitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VisitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VisitModelCopyWith<VisitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitModelCopyWith<$Res> {
  factory $VisitModelCopyWith(
          VisitModel value, $Res Function(VisitModel) then) =
      _$VisitModelCopyWithImpl<$Res, VisitModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'job_id') String jobId,
      @JsonKey(name: 'technician_id') String technicianId,
      @JsonKey(name: 'scheduled_start') DateTime scheduledStart,
      @JsonKey(name: 'scheduled_end') DateTime scheduledEnd,
      @JsonKey(name: 'actual_start') DateTime? actualStart,
      @JsonKey(name: 'actual_end') DateTime? actualEnd,
      VisitStatus status,
      @JsonKey(name: 'status_reason') String? statusReason,
      @JsonKey(name: 'sequence_order') int? sequenceOrder,
      int version,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      String? title,
      String? address,
      String? customerName,
      String? customerPhone,
      double? latitude,
      double? longitude,
      String? notes,
      @JsonKey(name: 'signature_url') String? signatureUrl});
}

/// @nodoc
class _$VisitModelCopyWithImpl<$Res, $Val extends VisitModel>
    implements $VisitModelCopyWith<$Res> {
  _$VisitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VisitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? jobId = null,
    Object? technicianId = null,
    Object? scheduledStart = null,
    Object? scheduledEnd = null,
    Object? actualStart = freezed,
    Object? actualEnd = freezed,
    Object? status = null,
    Object? statusReason = freezed,
    Object? sequenceOrder = freezed,
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? title = freezed,
    Object? address = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? notes = freezed,
    Object? signatureUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String,
      technicianId: null == technicianId
          ? _value.technicianId
          : technicianId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStart: null == scheduledStart
          ? _value.scheduledStart
          : scheduledStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledEnd: null == scheduledEnd
          ? _value.scheduledEnd
          : scheduledEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStart: freezed == actualStart
          ? _value.actualStart
          : actualStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEnd: freezed == actualEnd
          ? _value.actualEnd
          : actualEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VisitStatus,
      statusReason: freezed == statusReason
          ? _value.statusReason
          : statusReason // ignore: cast_nullable_to_non_nullable
              as String?,
      sequenceOrder: freezed == sequenceOrder
          ? _value.sequenceOrder
          : sequenceOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      signatureUrl: freezed == signatureUrl
          ? _value.signatureUrl
          : signatureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VisitModelImplCopyWith<$Res>
    implements $VisitModelCopyWith<$Res> {
  factory _$$VisitModelImplCopyWith(
          _$VisitModelImpl value, $Res Function(_$VisitModelImpl) then) =
      __$$VisitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'job_id') String jobId,
      @JsonKey(name: 'technician_id') String technicianId,
      @JsonKey(name: 'scheduled_start') DateTime scheduledStart,
      @JsonKey(name: 'scheduled_end') DateTime scheduledEnd,
      @JsonKey(name: 'actual_start') DateTime? actualStart,
      @JsonKey(name: 'actual_end') DateTime? actualEnd,
      VisitStatus status,
      @JsonKey(name: 'status_reason') String? statusReason,
      @JsonKey(name: 'sequence_order') int? sequenceOrder,
      int version,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      String? title,
      String? address,
      String? customerName,
      String? customerPhone,
      double? latitude,
      double? longitude,
      String? notes,
      @JsonKey(name: 'signature_url') String? signatureUrl});
}

/// @nodoc
class __$$VisitModelImplCopyWithImpl<$Res>
    extends _$VisitModelCopyWithImpl<$Res, _$VisitModelImpl>
    implements _$$VisitModelImplCopyWith<$Res> {
  __$$VisitModelImplCopyWithImpl(
      _$VisitModelImpl _value, $Res Function(_$VisitModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VisitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? jobId = null,
    Object? technicianId = null,
    Object? scheduledStart = null,
    Object? scheduledEnd = null,
    Object? actualStart = freezed,
    Object? actualEnd = freezed,
    Object? status = null,
    Object? statusReason = freezed,
    Object? sequenceOrder = freezed,
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? title = freezed,
    Object? address = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? notes = freezed,
    Object? signatureUrl = freezed,
  }) {
    return _then(_$VisitModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      jobId: null == jobId
          ? _value.jobId
          : jobId // ignore: cast_nullable_to_non_nullable
              as String,
      technicianId: null == technicianId
          ? _value.technicianId
          : technicianId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledStart: null == scheduledStart
          ? _value.scheduledStart
          : scheduledStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledEnd: null == scheduledEnd
          ? _value.scheduledEnd
          : scheduledEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actualStart: freezed == actualStart
          ? _value.actualStart
          : actualStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEnd: freezed == actualEnd
          ? _value.actualEnd
          : actualEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VisitStatus,
      statusReason: freezed == statusReason
          ? _value.statusReason
          : statusReason // ignore: cast_nullable_to_non_nullable
              as String?,
      sequenceOrder: freezed == sequenceOrder
          ? _value.sequenceOrder
          : sequenceOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      signatureUrl: freezed == signatureUrl
          ? _value.signatureUrl
          : signatureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VisitModelImpl implements _VisitModel {
  const _$VisitModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'job_id') required this.jobId,
      @JsonKey(name: 'technician_id') required this.technicianId,
      @JsonKey(name: 'scheduled_start') required this.scheduledStart,
      @JsonKey(name: 'scheduled_end') required this.scheduledEnd,
      @JsonKey(name: 'actual_start') this.actualStart,
      @JsonKey(name: 'actual_end') this.actualEnd,
      required this.status,
      @JsonKey(name: 'status_reason') this.statusReason,
      @JsonKey(name: 'sequence_order') this.sequenceOrder,
      this.version = 1,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.title,
      this.address,
      this.customerName,
      this.customerPhone,
      this.latitude,
      this.longitude,
      this.notes,
      @JsonKey(name: 'signature_url') this.signatureUrl});

  factory _$VisitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VisitModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  @JsonKey(name: 'job_id')
  final String jobId;
  @override
  @JsonKey(name: 'technician_id')
  final String technicianId;
  @override
  @JsonKey(name: 'scheduled_start')
  final DateTime scheduledStart;
  @override
  @JsonKey(name: 'scheduled_end')
  final DateTime scheduledEnd;
  @override
  @JsonKey(name: 'actual_start')
  final DateTime? actualStart;
  @override
  @JsonKey(name: 'actual_end')
  final DateTime? actualEnd;
  @override
  final VisitStatus status;
  @override
  @JsonKey(name: 'status_reason')
  final String? statusReason;
  @override
  @JsonKey(name: 'sequence_order')
  final int? sequenceOrder;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Extended fields for UI
  @override
  final String? title;
  @override
  final String? address;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'signature_url')
  final String? signatureUrl;

  @override
  String toString() {
    return 'VisitModel(id: $id, orgId: $orgId, jobId: $jobId, technicianId: $technicianId, scheduledStart: $scheduledStart, scheduledEnd: $scheduledEnd, actualStart: $actualStart, actualEnd: $actualEnd, status: $status, statusReason: $statusReason, sequenceOrder: $sequenceOrder, version: $version, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, address: $address, customerName: $customerName, customerPhone: $customerPhone, latitude: $latitude, longitude: $longitude, notes: $notes, signatureUrl: $signatureUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.technicianId, technicianId) ||
                other.technicianId == technicianId) &&
            (identical(other.scheduledStart, scheduledStart) ||
                other.scheduledStart == scheduledStart) &&
            (identical(other.scheduledEnd, scheduledEnd) ||
                other.scheduledEnd == scheduledEnd) &&
            (identical(other.actualStart, actualStart) ||
                other.actualStart == actualStart) &&
            (identical(other.actualEnd, actualEnd) ||
                other.actualEnd == actualEnd) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusReason, statusReason) ||
                other.statusReason == statusReason) &&
            (identical(other.sequenceOrder, sequenceOrder) ||
                other.sequenceOrder == sequenceOrder) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.signatureUrl, signatureUrl) ||
                other.signatureUrl == signatureUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orgId,
        jobId,
        technicianId,
        scheduledStart,
        scheduledEnd,
        actualStart,
        actualEnd,
        status,
        statusReason,
        sequenceOrder,
        version,
        createdAt,
        updatedAt,
        title,
        address,
        customerName,
        customerPhone,
        latitude,
        longitude,
        notes,
        signatureUrl
      ]);

  /// Create a copy of VisitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisitModelImplCopyWith<_$VisitModelImpl> get copyWith =>
      __$$VisitModelImplCopyWithImpl<_$VisitModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VisitModelImplToJson(
      this,
    );
  }
}

abstract class _VisitModel implements VisitModel {
  const factory _VisitModel(
      {required final String id,
      @JsonKey(name: 'org_id') required final String orgId,
      @JsonKey(name: 'job_id') required final String jobId,
      @JsonKey(name: 'technician_id') required final String technicianId,
      @JsonKey(name: 'scheduled_start') required final DateTime scheduledStart,
      @JsonKey(name: 'scheduled_end') required final DateTime scheduledEnd,
      @JsonKey(name: 'actual_start') final DateTime? actualStart,
      @JsonKey(name: 'actual_end') final DateTime? actualEnd,
      required final VisitStatus status,
      @JsonKey(name: 'status_reason') final String? statusReason,
      @JsonKey(name: 'sequence_order') final int? sequenceOrder,
      final int version,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final String? title,
      final String? address,
      final String? customerName,
      final String? customerPhone,
      final double? latitude,
      final double? longitude,
      final String? notes,
      @JsonKey(name: 'signature_url')
      final String? signatureUrl}) = _$VisitModelImpl;

  factory _VisitModel.fromJson(Map<String, dynamic> json) =
      _$VisitModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  @JsonKey(name: 'job_id')
  String get jobId;
  @override
  @JsonKey(name: 'technician_id')
  String get technicianId;
  @override
  @JsonKey(name: 'scheduled_start')
  DateTime get scheduledStart;
  @override
  @JsonKey(name: 'scheduled_end')
  DateTime get scheduledEnd;
  @override
  @JsonKey(name: 'actual_start')
  DateTime? get actualStart;
  @override
  @JsonKey(name: 'actual_end')
  DateTime? get actualEnd;
  @override
  VisitStatus get status;
  @override
  @JsonKey(name: 'status_reason')
  String? get statusReason;
  @override
  @JsonKey(name: 'sequence_order')
  int? get sequenceOrder;
  @override
  int get version;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // Extended fields for UI
  @override
  String? get title;
  @override
  String? get address;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'signature_url')
  String? get signatureUrl;

  /// Create a copy of VisitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisitModelImplCopyWith<_$VisitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
