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
  @JsonKey(name: 'visit_id')
  String get visitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_id')
  String? get quoteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;
  InvoiceStatus get status => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount')
  double get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_items')
  List<LineItemModel> get lineItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_email')
  String? get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_address')
  String? get propertyAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'visit_title')
  String? get visitTitle => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
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
      @JsonKey(name: 'visit_id') String visitId,
      @JsonKey(name: 'quote_id') String? quoteId,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      InvoiceStatus status,
      double total,
      double subtotal,
      @JsonKey(name: 'tax_amount') double taxAmount,
      @JsonKey(name: 'line_items') List<LineItemModel> lineItems,
      @JsonKey(name: 'customer_name') String? customerName,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'property_address') String? propertyAddress,
      @JsonKey(name: 'visit_title') String? visitTitle,
      String? notes,
      @JsonKey(name: 'due_date') DateTime? dueDate,
      @JsonKey(name: 'paid_at') DateTime? paidAt,
      int version,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
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
      @JsonKey(name: 'visit_id') String visitId,
      @JsonKey(name: 'quote_id') String? quoteId,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      InvoiceStatus status,
      double total,
      double subtotal,
      @JsonKey(name: 'tax_amount') double taxAmount,
      @JsonKey(name: 'line_items') List<LineItemModel> lineItems,
      @JsonKey(name: 'customer_name') String? customerName,
      @JsonKey(name: 'customer_email') String? customerEmail,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      @JsonKey(name: 'property_address') String? propertyAddress,
      @JsonKey(name: 'visit_title') String? visitTitle,
      String? notes,
      @JsonKey(name: 'due_date') DateTime? dueDate,
      @JsonKey(name: 'paid_at') DateTime? paidAt,
      int version,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
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
      @JsonKey(name: 'visit_id') required this.visitId,
      @JsonKey(name: 'quote_id') this.quoteId,
      @JsonKey(name: 'invoice_number') required this.invoiceNumber,
      required this.status,
      required this.total,
      this.subtotal = 0.0,
      @JsonKey(name: 'tax_amount') this.taxAmount = 0.0,
      @JsonKey(name: 'line_items')
      final List<LineItemModel> lineItems = const [],
      @JsonKey(name: 'customer_name') this.customerName,
      @JsonKey(name: 'customer_email') this.customerEmail,
      @JsonKey(name: 'customer_phone') this.customerPhone,
      @JsonKey(name: 'property_address') this.propertyAddress,
      @JsonKey(name: 'visit_title') this.visitTitle,
      this.notes,
      @JsonKey(name: 'due_date') this.dueDate,
      @JsonKey(name: 'paid_at') this.paidAt,
      this.version = 1,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _lineItems = lineItems;

  factory _$InvoiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  @JsonKey(name: 'visit_id')
  final String visitId;
  @override
  @JsonKey(name: 'quote_id')
  final String? quoteId;
  @override
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @override
  final InvoiceStatus status;
  @override
  final double total;
  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey(name: 'tax_amount')
  final double taxAmount;
  final List<LineItemModel> _lineItems;
  @override
  @JsonKey(name: 'line_items')
  List<LineItemModel> get lineItems {
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lineItems);
  }

  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  @JsonKey(name: 'customer_email')
  final String? customerEmail;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
  @override
  @JsonKey(name: 'property_address')
  final String? propertyAddress;
  @override
  @JsonKey(name: 'visit_title')
  final String? visitTitle;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @override
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
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
          @JsonKey(name: 'visit_id') required final String visitId,
          @JsonKey(name: 'quote_id') final String? quoteId,
          @JsonKey(name: 'invoice_number') required final String invoiceNumber,
          required final InvoiceStatus status,
          required final double total,
          final double subtotal,
          @JsonKey(name: 'tax_amount') final double taxAmount,
          @JsonKey(name: 'line_items') final List<LineItemModel> lineItems,
          @JsonKey(name: 'customer_name') final String? customerName,
          @JsonKey(name: 'customer_email') final String? customerEmail,
          @JsonKey(name: 'customer_phone') final String? customerPhone,
          @JsonKey(name: 'property_address') final String? propertyAddress,
          @JsonKey(name: 'visit_title') final String? visitTitle,
          final String? notes,
          @JsonKey(name: 'due_date') final DateTime? dueDate,
          @JsonKey(name: 'paid_at') final DateTime? paidAt,
          final int version,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$InvoiceModelImpl;

  factory _InvoiceModel.fromJson(Map<String, dynamic> json) =
      _$InvoiceModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  @JsonKey(name: 'visit_id')
  String get visitId;
  @override
  @JsonKey(name: 'quote_id')
  String? get quoteId;
  @override
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @override
  InvoiceStatus get status;
  @override
  double get total;
  @override
  double get subtotal;
  @override
  @JsonKey(name: 'tax_amount')
  double get taxAmount;
  @override
  @JsonKey(name: 'line_items')
  List<LineItemModel> get lineItems;
  @override
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @override
  @JsonKey(name: 'customer_email')
  String? get customerEmail;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override
  @JsonKey(name: 'property_address')
  String? get propertyAddress;
  @override
  @JsonKey(name: 'visit_title')
  String? get visitTitle;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'due_date')
  DateTime? get dueDate;
  @override
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;
  @override
  int get version;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
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
  @JsonKey(name: 'org_id')
  String get orgId =>
      throw _privateConstructorUsedError; // PRD: required for multi-tenancy
  @JsonKey(name: 'invoice_id')
  String get invoiceId => throw _privateConstructorUsedError;
  double get amount =>
      throw _privateConstructorUsedError; // Must be > 0, cannot exceed remaining invoice balance
  PaymentMethod get method =>
      throw _privateConstructorUsedError; // cash, bank_transfer, card, stripe_link
  String? get reference =>
      throw _privateConstructorUsedError; // Optional reference number
  @JsonKey(name: 'received_by')
  String get receivedBy =>
      throw _privateConstructorUsedError; // User who recorded the payment
  @JsonKey(name: 'received_at')
  DateTime get receivedAt =>
      throw _privateConstructorUsedError; // When payment was received
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'invoice_id') String invoiceId,
      double amount,
      PaymentMethod method,
      String? reference,
      @JsonKey(name: 'received_by') String receivedBy,
      @JsonKey(name: 'received_at') DateTime receivedAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
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
    Object? orgId = null,
    Object? invoiceId = null,
    Object? amount = null,
    Object? method = null,
    Object? reference = freezed,
    Object? receivedBy = null,
    Object? receivedAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      receivedBy: null == receivedBy
          ? _value.receivedBy
          : receivedBy // ignore: cast_nullable_to_non_nullable
              as String,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'invoice_id') String invoiceId,
      double amount,
      PaymentMethod method,
      String? reference,
      @JsonKey(name: 'received_by') String receivedBy,
      @JsonKey(name: 'received_at') DateTime receivedAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
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
    Object? orgId = null,
    Object? invoiceId = null,
    Object? amount = null,
    Object? method = null,
    Object? reference = freezed,
    Object? receivedBy = null,
    Object? receivedAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PaymentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
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
      receivedBy: null == receivedBy
          ? _value.receivedBy
          : receivedBy // ignore: cast_nullable_to_non_nullable
              as String,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl implements _PaymentModel {
  const _$PaymentModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'invoice_id') required this.invoiceId,
      required this.amount,
      required this.method,
      this.reference,
      @JsonKey(name: 'received_by') required this.receivedBy,
      @JsonKey(name: 'received_at') required this.receivedAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
// PRD: required for multi-tenancy
  @override
  @JsonKey(name: 'invoice_id')
  final String invoiceId;
  @override
  final double amount;
// Must be > 0, cannot exceed remaining invoice balance
  @override
  final PaymentMethod method;
// cash, bank_transfer, card, stripe_link
  @override
  final String? reference;
// Optional reference number
  @override
  @JsonKey(name: 'received_by')
  final String receivedBy;
// User who recorded the payment
  @override
  @JsonKey(name: 'received_at')
  final DateTime receivedAt;
// When payment was received
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PaymentModel(id: $id, orgId: $orgId, invoiceId: $invoiceId, amount: $amount, method: $method, reference: $reference, receivedBy: $receivedBy, receivedAt: $receivedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
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
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgId, invoiceId, amount,
      method, reference, receivedBy, receivedAt, createdAt, updatedAt);

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
          @JsonKey(name: 'org_id') required final String orgId,
          @JsonKey(name: 'invoice_id') required final String invoiceId,
          required final double amount,
          required final PaymentMethod method,
          final String? reference,
          @JsonKey(name: 'received_by') required final String receivedBy,
          @JsonKey(name: 'received_at') required final DateTime receivedAt,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$PaymentModelImpl;

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId; // PRD: required for multi-tenancy
  @override
  @JsonKey(name: 'invoice_id')
  String get invoiceId;
  @override
  double get amount; // Must be > 0, cannot exceed remaining invoice balance
  @override
  PaymentMethod get method; // cash, bank_transfer, card, stripe_link
  @override
  String? get reference; // Optional reference number
  @override
  @JsonKey(name: 'received_by')
  String get receivedBy; // User who recorded the payment
  @override
  @JsonKey(name: 'received_at')
  DateTime get receivedAt; // When payment was received
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
