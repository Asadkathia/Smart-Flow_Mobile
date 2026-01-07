// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) {
  return _InvoiceModel.fromJson(json);
}

/// @nodoc
mixin _$InvoiceModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  String get visitId => throw _privateConstructorUsedError;
  String? get quoteId => throw _privateConstructorUsedError;
  String get invoiceNumber => throw _privateConstructorUsedError;
  InvoiceStatus get status => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  List<LineItemModel> get lineItems => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerEmail => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  String? get propertyAddress => throw _privateConstructorUsedError;
  String? get visitTitle => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this InvoiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceModelCopyWith<InvoiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceModelCopyWith<$Res> {
  factory $InvoiceModelCopyWith(
          InvoiceModel value, $Res Function(InvoiceModel) then) =
      _$InvoiceModelCopyWithImpl<$Res, InvoiceModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      String visitId,
      String? quoteId,
      String invoiceNumber,
      InvoiceStatus status,
      double total,
      double subtotal,
      double taxAmount,
      List<LineItemModel> lineItems,
      String? customerName,
      String? customerEmail,
      String? customerPhone,
      String? propertyAddress,
      String? visitTitle,
      String? notes,
      DateTime? dueDate,
      DateTime? paidAt,
      int version,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$InvoiceModelCopyWithImpl<$Res, $Val extends InvoiceModel>
    implements $InvoiceModelCopyWith<$Res> {
  _$InvoiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? visitId = null,
    Object? quoteId = freezed,
    Object? invoiceNumber = null,
    Object? status = null,
    Object? total = null,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? lineItems = null,
    Object? customerName = freezed,
    Object? customerEmail = freezed,
    Object? customerPhone = freezed,
    Object? propertyAddress = freezed,
    Object? visitTitle = freezed,
    Object? notes = freezed,
    Object? dueDate = freezed,
    Object? paidAt = freezed,
    Object? version = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteId: freezed == quoteId
          ? _value.quoteId
          : quoteId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvoiceStatus,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lineItems: null == lineItems
          ? _value.lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<LineItemModel>,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyAddress: freezed == propertyAddress
          ? _value.propertyAddress
          : propertyAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      visitTitle: freezed == visitTitle
          ? _value.visitTitle
          : visitTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceModelImplCopyWith<$Res>
    implements $InvoiceModelCopyWith<$Res> {
  factory _$$InvoiceModelImplCopyWith(
          _$InvoiceModelImpl value, $Res Function(_$InvoiceModelImpl) then) =
      __$$InvoiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      String visitId,
      String? quoteId,
      String invoiceNumber,
      InvoiceStatus status,
      double total,
      double subtotal,
      double taxAmount,
      List<LineItemModel> lineItems,
      String? customerName,
      String? customerEmail,
      String? customerPhone,
      String? propertyAddress,
      String? visitTitle,
      String? notes,
      DateTime? dueDate,
      DateTime? paidAt,
      int version,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$InvoiceModelImplCopyWithImpl<$Res>
    extends _$InvoiceModelCopyWithImpl<$Res, _$InvoiceModelImpl>
    implements _$$InvoiceModelImplCopyWith<$Res> {
  __$$InvoiceModelImplCopyWithImpl(
      _$InvoiceModelImpl _value, $Res Function(_$InvoiceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? visitId = null,
    Object? quoteId = freezed,
    Object? invoiceNumber = null,
    Object? status = null,
    Object? total = null,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? lineItems = null,
    Object? customerName = freezed,
    Object? customerEmail = freezed,
    Object? customerPhone = freezed,
    Object? propertyAddress = freezed,
    Object? visitTitle = freezed,
    Object? notes = freezed,
    Object? dueDate = freezed,
    Object? paidAt = freezed,
    Object? version = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$InvoiceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteId: freezed == quoteId
          ? _value.quoteId
          : quoteId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvoiceStatus,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lineItems: null == lineItems
          ? _value._lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<LineItemModel>,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerEmail: freezed == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyAddress: freezed == propertyAddress
          ? _value.propertyAddress
          : propertyAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      visitTitle: freezed == visitTitle
          ? _value.visitTitle
          : visitTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceModelImpl implements _InvoiceModel {
  const _$InvoiceModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      required this.visitId,
      this.quoteId,
      required this.invoiceNumber,
      required this.status,
      required this.total,
      required this.subtotal,
      required this.taxAmount,
      required final List<LineItemModel> lineItems,
      this.customerName,
      this.customerEmail,
      this.customerPhone,
      this.propertyAddress,
      this.visitTitle,
      this.notes,
      this.dueDate,
      this.paidAt,
      this.version = 1,
      this.createdAt,
      this.updatedAt})
      : _lineItems = lineItems;

  factory _$InvoiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  final String visitId;
  @override
  final String? quoteId;
  @override
  final String invoiceNumber;
  @override
  final InvoiceStatus status;
  @override
  final double total;
  @override
  final double subtotal;
  @override
  final double taxAmount;
  final List<LineItemModel> _lineItems;
  @override
  List<LineItemModel> get lineItems {
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lineItems);
  }

  @override
  final String? customerName;
  @override
  final String? customerEmail;
  @override
  final String? customerPhone;
  @override
  final String? propertyAddress;
  @override
  final String? visitTitle;
  @override
  final String? notes;
  @override
  final DateTime? dueDate;
  @override
  final DateTime? paidAt;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'InvoiceModel(id: $id, orgId: $orgId, visitId: $visitId, quoteId: $quoteId, invoiceNumber: $invoiceNumber, status: $status, total: $total, subtotal: $subtotal, taxAmount: $taxAmount, lineItems: $lineItems, customerName: $customerName, customerEmail: $customerEmail, customerPhone: $customerPhone, propertyAddress: $propertyAddress, visitTitle: $visitTitle, notes: $notes, dueDate: $dueDate, paidAt: $paidAt, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.visitId, visitId) || other.visitId == visitId) &&
            (identical(other.quoteId, quoteId) || other.quoteId == quoteId) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            const DeepCollectionEquality()
                .equals(other._lineItems, _lineItems) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.propertyAddress, propertyAddress) ||
                other.propertyAddress == propertyAddress) &&
            (identical(other.visitTitle, visitTitle) ||
                other.visitTitle == visitTitle) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orgId,
        visitId,
        quoteId,
        invoiceNumber,
        status,
        total,
        subtotal,
        taxAmount,
        const DeepCollectionEquality().hash(_lineItems),
        customerName,
        customerEmail,
        customerPhone,
        propertyAddress,
        visitTitle,
        notes,
        dueDate,
        paidAt,
        version,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceModelImplCopyWith<_$InvoiceModelImpl> get copyWith =>
      __$$InvoiceModelImplCopyWithImpl<_$InvoiceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceModelImplToJson(
      this,
    );
  }
}

abstract class _InvoiceModel implements InvoiceModel {
  const factory _InvoiceModel(
      {required final String id,
      @JsonKey(name: 'org_id') required final String orgId,
      required final String visitId,
      final String? quoteId,
      required final String invoiceNumber,
      required final InvoiceStatus status,
      required final double total,
      required final double subtotal,
      required final double taxAmount,
      required final List<LineItemModel> lineItems,
      final String? customerName,
      final String? customerEmail,
      final String? customerPhone,
      final String? propertyAddress,
      final String? visitTitle,
      final String? notes,
      final DateTime? dueDate,
      final DateTime? paidAt,
      final int version,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$InvoiceModelImpl;

  factory _InvoiceModel.fromJson(Map<String, dynamic> json) =
      _$InvoiceModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  String get visitId;
  @override
  String? get quoteId;
  @override
  String get invoiceNumber;
  @override
  InvoiceStatus get status;
  @override
  double get total;
  @override
  double get subtotal;
  @override
  double get taxAmount;
  @override
  List<LineItemModel> get lineItems;
  @override
  String? get customerName;
  @override
  String? get customerEmail;
  @override
  String? get customerPhone;
  @override
  String? get propertyAddress;
  @override
  String? get visitTitle;
  @override
  String? get notes;
  @override
  DateTime? get dueDate;
  @override
  DateTime? get paidAt;
  @override
  int get version;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceModelImplCopyWith<_$InvoiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  String get id => throw _privateConstructorUsedError;
  String get invoiceId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  PaymentMethod get method => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  String? get receivedBy => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
          PaymentModel value, $Res Function(PaymentModel) then) =
      _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call(
      {String id,
      String invoiceId,
      double amount,
      PaymentMethod method,
      String? reference,
      String? receivedBy,
      DateTime? receivedAt,
      DateTime? createdAt});
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? amount = null,
    Object? method = null,
    Object? reference = freezed,
    Object? receivedBy = freezed,
    Object? receivedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedBy: freezed == receivedBy
          ? _value.receivedBy
          : receivedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
          _$PaymentModelImpl value, $Res Function(_$PaymentModelImpl) then) =
      __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String invoiceId,
      double amount,
      PaymentMethod method,
      String? reference,
      String? receivedBy,
      DateTime? receivedAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
      _$PaymentModelImpl _value, $Res Function(_$PaymentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? amount = null,
    Object? method = null,
    Object? reference = freezed,
    Object? receivedBy = freezed,
    Object? receivedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$PaymentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedBy: freezed == receivedBy
          ? _value.receivedBy
          : receivedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl implements _PaymentModel {
  const _$PaymentModelImpl(
      {required this.id,
      required this.invoiceId,
      required this.amount,
      required this.method,
      this.reference,
      this.receivedBy,
      this.receivedAt,
      this.createdAt});

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String invoiceId;
  @override
  final double amount;
  @override
  final PaymentMethod method;
  @override
  final String? reference;
  @override
  final String? receivedBy;
  @override
  final DateTime? receivedAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PaymentModel(id: $id, invoiceId: $invoiceId, amount: $amount, method: $method, reference: $reference, receivedBy: $receivedBy, receivedAt: $receivedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.receivedBy, receivedBy) ||
                other.receivedBy == receivedBy) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, invoiceId, amount, method,
      reference, receivedBy, receivedAt, createdAt);

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentModel implements PaymentModel {
  const factory _PaymentModel(
      {required final String id,
      required final String invoiceId,
      required final double amount,
      required final PaymentMethod method,
      final String? reference,
      final String? receivedBy,
      final DateTime? receivedAt,
      final DateTime? createdAt}) = _$PaymentModelImpl;

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get invoiceId;
  @override
  double get amount;
  @override
  PaymentMethod get method;
  @override
  String? get reference;
  @override
  String? get receivedBy;
  @override
  DateTime? get receivedAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
