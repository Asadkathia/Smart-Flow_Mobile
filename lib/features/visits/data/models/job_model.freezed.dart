// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JobModel _$JobModelFromJson(Map<String, dynamic> json) {
  return _JobModel.fromJson(json);
}

/// @nodoc
mixin _$JobModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  String get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'job_number')
  String? get jobNumber => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  JobStatus get status => throw _privateConstructorUsedError;
  JobPriority get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_type')
  String? get serviceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_duration')
  int? get estimatedDuration => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_duration')
  int? get actualDuration => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_date')
  DateTime? get scheduledDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_date')
  DateTime? get completedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_technician_id')
  String? get assignedTechnicianId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  CustomerModel? get customer => throw _privateConstructorUsedError;
  PropertyModel? get property => throw _privateConstructorUsedError;

  /// Serializes this JobModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobModelCopyWith<JobModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobModelCopyWith<$Res> {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) then) =
      _$JobModelCopyWithImpl<$Res, JobModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'customer_id') String customerId,
      @JsonKey(name: 'property_id') String propertyId,
      @JsonKey(name: 'job_number') String? jobNumber,
      String title,
      String? description,
      JobStatus status,
      JobPriority priority,
      @JsonKey(name: 'service_type') String? serviceType,
      @JsonKey(name: 'estimated_duration') int? estimatedDuration,
      @JsonKey(name: 'actual_duration') int? actualDuration,
      @JsonKey(name: 'scheduled_date') DateTime? scheduledDate,
      @JsonKey(name: 'completed_date') DateTime? completedDate,
      @JsonKey(name: 'assigned_technician_id') String? assignedTechnicianId,
      String? notes,
      int version,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      CustomerModel? customer,
      PropertyModel? property});

  $CustomerModelCopyWith<$Res>? get customer;
  $PropertyModelCopyWith<$Res>? get property;
}

/// @nodoc
class _$JobModelCopyWithImpl<$Res, $Val extends JobModel>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? customerId = null,
    Object? propertyId = null,
    Object? jobNumber = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? priority = null,
    Object? serviceType = freezed,
    Object? estimatedDuration = freezed,
    Object? actualDuration = freezed,
    Object? scheduledDate = freezed,
    Object? completedDate = freezed,
    Object? assignedTechnicianId = freezed,
    Object? notes = freezed,
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? customer = freezed,
    Object? property = freezed,
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
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      propertyId: null == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as String,
      jobNumber: freezed == jobNumber
          ? _value.jobNumber
          : jobNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JobStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as JobPriority,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      actualDuration: freezed == actualDuration
          ? _value.actualDuration
          : actualDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledDate: freezed == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedDate: freezed == completedDate
          ? _value.completedDate
          : completedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assignedTechnicianId: freezed == assignedTechnicianId
          ? _value.assignedTechnicianId
          : assignedTechnicianId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
      customer: freezed == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerModel?,
      property: freezed == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as PropertyModel?,
    ) as $Val);
  }

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res>? get customer {
    if (_value.customer == null) {
      return null;
    }

    return $CustomerModelCopyWith<$Res>(_value.customer!, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropertyModelCopyWith<$Res>? get property {
    if (_value.property == null) {
      return null;
    }

    return $PropertyModelCopyWith<$Res>(_value.property!, (value) {
      return _then(_value.copyWith(property: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JobModelImplCopyWith<$Res>
    implements $JobModelCopyWith<$Res> {
  factory _$$JobModelImplCopyWith(
          _$JobModelImpl value, $Res Function(_$JobModelImpl) then) =
      __$$JobModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'customer_id') String customerId,
      @JsonKey(name: 'property_id') String propertyId,
      @JsonKey(name: 'job_number') String? jobNumber,
      String title,
      String? description,
      JobStatus status,
      JobPriority priority,
      @JsonKey(name: 'service_type') String? serviceType,
      @JsonKey(name: 'estimated_duration') int? estimatedDuration,
      @JsonKey(name: 'actual_duration') int? actualDuration,
      @JsonKey(name: 'scheduled_date') DateTime? scheduledDate,
      @JsonKey(name: 'completed_date') DateTime? completedDate,
      @JsonKey(name: 'assigned_technician_id') String? assignedTechnicianId,
      String? notes,
      int version,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      CustomerModel? customer,
      PropertyModel? property});

  @override
  $CustomerModelCopyWith<$Res>? get customer;
  @override
  $PropertyModelCopyWith<$Res>? get property;
}

/// @nodoc
class __$$JobModelImplCopyWithImpl<$Res>
    extends _$JobModelCopyWithImpl<$Res, _$JobModelImpl>
    implements _$$JobModelImplCopyWith<$Res> {
  __$$JobModelImplCopyWithImpl(
      _$JobModelImpl _value, $Res Function(_$JobModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? customerId = null,
    Object? propertyId = null,
    Object? jobNumber = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? priority = null,
    Object? serviceType = freezed,
    Object? estimatedDuration = freezed,
    Object? actualDuration = freezed,
    Object? scheduledDate = freezed,
    Object? completedDate = freezed,
    Object? assignedTechnicianId = freezed,
    Object? notes = freezed,
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? customer = freezed,
    Object? property = freezed,
  }) {
    return _then(_$JobModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      propertyId: null == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as String,
      jobNumber: freezed == jobNumber
          ? _value.jobNumber
          : jobNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as JobStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as JobPriority,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      actualDuration: freezed == actualDuration
          ? _value.actualDuration
          : actualDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      scheduledDate: freezed == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedDate: freezed == completedDate
          ? _value.completedDate
          : completedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assignedTechnicianId: freezed == assignedTechnicianId
          ? _value.assignedTechnicianId
          : assignedTechnicianId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
      customer: freezed == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerModel?,
      property: freezed == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as PropertyModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JobModelImpl implements _JobModel {
  const _$JobModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'customer_id') required this.customerId,
      @JsonKey(name: 'property_id') required this.propertyId,
      @JsonKey(name: 'job_number') this.jobNumber,
      required this.title,
      this.description,
      required this.status,
      this.priority = JobPriority.normal,
      @JsonKey(name: 'service_type') this.serviceType,
      @JsonKey(name: 'estimated_duration') this.estimatedDuration,
      @JsonKey(name: 'actual_duration') this.actualDuration,
      @JsonKey(name: 'scheduled_date') this.scheduledDate,
      @JsonKey(name: 'completed_date') this.completedDate,
      @JsonKey(name: 'assigned_technician_id') this.assignedTechnicianId,
      this.notes,
      this.version = 1,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.customer,
      this.property});

  factory _$JobModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  @JsonKey(name: 'property_id')
  final String propertyId;
  @override
  @JsonKey(name: 'job_number')
  final String? jobNumber;
  @override
  final String title;
  @override
  final String? description;
  @override
  final JobStatus status;
  @override
  @JsonKey()
  final JobPriority priority;
  @override
  @JsonKey(name: 'service_type')
  final String? serviceType;
  @override
  @JsonKey(name: 'estimated_duration')
  final int? estimatedDuration;
  @override
  @JsonKey(name: 'actual_duration')
  final int? actualDuration;
  @override
  @JsonKey(name: 'scheduled_date')
  final DateTime? scheduledDate;
  @override
  @JsonKey(name: 'completed_date')
  final DateTime? completedDate;
  @override
  @JsonKey(name: 'assigned_technician_id')
  final String? assignedTechnicianId;
  @override
  final String? notes;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Relations
  @override
  final CustomerModel? customer;
  @override
  final PropertyModel? property;

  @override
  String toString() {
    return 'JobModel(id: $id, orgId: $orgId, customerId: $customerId, propertyId: $propertyId, jobNumber: $jobNumber, title: $title, description: $description, status: $status, priority: $priority, serviceType: $serviceType, estimatedDuration: $estimatedDuration, actualDuration: $actualDuration, scheduledDate: $scheduledDate, completedDate: $completedDate, assignedTechnicianId: $assignedTechnicianId, notes: $notes, version: $version, createdAt: $createdAt, updatedAt: $updatedAt, customer: $customer, property: $property)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.jobNumber, jobNumber) ||
                other.jobNumber == jobNumber) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.actualDuration, actualDuration) ||
                other.actualDuration == actualDuration) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.completedDate, completedDate) ||
                other.completedDate == completedDate) &&
            (identical(other.assignedTechnicianId, assignedTechnicianId) ||
                other.assignedTechnicianId == assignedTechnicianId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.property, property) ||
                other.property == property));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orgId,
        customerId,
        propertyId,
        jobNumber,
        title,
        description,
        status,
        priority,
        serviceType,
        estimatedDuration,
        actualDuration,
        scheduledDate,
        completedDate,
        assignedTechnicianId,
        notes,
        version,
        createdAt,
        updatedAt,
        customer,
        property
      ]);

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      __$$JobModelImplCopyWithImpl<_$JobModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobModelImplToJson(
      this,
    );
  }
}

abstract class _JobModel implements JobModel {
  const factory _JobModel(
      {required final String id,
      @JsonKey(name: 'org_id') required final String orgId,
      @JsonKey(name: 'customer_id') required final String customerId,
      @JsonKey(name: 'property_id') required final String propertyId,
      @JsonKey(name: 'job_number') final String? jobNumber,
      required final String title,
      final String? description,
      required final JobStatus status,
      final JobPriority priority,
      @JsonKey(name: 'service_type') final String? serviceType,
      @JsonKey(name: 'estimated_duration') final int? estimatedDuration,
      @JsonKey(name: 'actual_duration') final int? actualDuration,
      @JsonKey(name: 'scheduled_date') final DateTime? scheduledDate,
      @JsonKey(name: 'completed_date') final DateTime? completedDate,
      @JsonKey(name: 'assigned_technician_id')
      final String? assignedTechnicianId,
      final String? notes,
      final int version,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final CustomerModel? customer,
      final PropertyModel? property}) = _$JobModelImpl;

  factory _JobModel.fromJson(Map<String, dynamic> json) =
      _$JobModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  @JsonKey(name: 'property_id')
  String get propertyId;
  @override
  @JsonKey(name: 'job_number')
  String? get jobNumber;
  @override
  String get title;
  @override
  String? get description;
  @override
  JobStatus get status;
  @override
  JobPriority get priority;
  @override
  @JsonKey(name: 'service_type')
  String? get serviceType;
  @override
  @JsonKey(name: 'estimated_duration')
  int? get estimatedDuration;
  @override
  @JsonKey(name: 'actual_duration')
  int? get actualDuration;
  @override
  @JsonKey(name: 'scheduled_date')
  DateTime? get scheduledDate;
  @override
  @JsonKey(name: 'completed_date')
  DateTime? get completedDate;
  @override
  @JsonKey(name: 'assigned_technician_id')
  String? get assignedTechnicianId;
  @override
  String? get notes;
  @override
  int get version;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // Relations
  @override
  CustomerModel? get customer;
  @override
  PropertyModel? get property;

  /// Create a copy of JobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobModelImplCopyWith<_$JobModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
