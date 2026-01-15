import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:smartflowpro/features/quotes/data/models/create_quotes/service_item.dart';
import 'package:smartflowpro/features/quotes/data/models/create_quotes/material_item.dart';
import 'package:smartflowpro/features/quotes/data/models/create_quotes/service_line.dart';
import 'package:smartflowpro/features/quotes/data/models/create_quotes/material_line.dart';
import 'package:smartflowpro/core/validation/validation_rules.dart';
import 'package:smartflowpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:smartflowpro/features/quotes/data/models/quote_model.dart';
import 'package:smartflowpro/features/quotes/data/models/line_item_model.dart';
import '../../../billing/presentation/providers/billing_provider.dart';

part 'create_quotes_provider.g.dart';

/// Create Quotes Provider
/// 
/// Manages quote creation state including services, materials, tax, and message.
/// Automatically adds and locks service call fee per PRD requirements.
@riverpod
class CreateQuotes extends _$CreateQuotes {
  @override
  CreateQuotesState build() {
    // Watch billing settings
    final billingSettingsAsync = ref.watch(billingSettingsProvider);
    
    // Get service call fee and tax rate from billing settings
    final serviceCallFee = billingSettingsAsync.valueOrNull?.serviceCallFee ?? 75.0;
    final taxRate = billingSettingsAsync.valueOrNull?.taxRate ?? 0.082;
    
    // Auto-add service call fee from billing settings
    final serviceCallFeeLine = ServiceLine(
      service: ServiceItem(name: 'Service Call Fee', pricePerUnit: serviceCallFee),
      quantity: 1,
    );

    return CreateQuotesState(
      serviceLines: [serviceCallFeeLine],
      materialLines: [],
      isTaxable: true,
      taxRate: taxRate * 100, // Convert to percentage for display
      estimateMessage: 'Thank you for trusting us with your appliance repairs!',
      availableMaterials: _getDefaultMaterials(),
      serviceCallFeeLine: serviceCallFeeLine,
    );
  }

  /// Get default available materials (mock data)
  List<MaterialItem> _getDefaultMaterials() {
    return [
      MaterialItem(name: 'Ice maker', pricePerUnit: 268.43),
      MaterialItem(name: 'Air filter', pricePerUnit: 45.00),
      MaterialItem(name: 'Thermostat', pricePerUnit: 85.00),
    ];
  }

  /// Add a custom service
  void addCustomService(String name, double pricePerUnit, int quantity) {
    final service = ServiceItem(name: name, pricePerUnit: pricePerUnit);
    final existing = state.serviceLines.firstWhere(
      (l) => l.service.name == service.name,
      orElse: () => ServiceLine(service: ServiceItem(name: '', pricePerUnit: 0), quantity: 0),
    );
    
    if (existing.service.name.isNotEmpty) {
      updateServiceQty(existing, quantity - existing.quantity);
    } else {
      state = state.copyWith(
        serviceLines: [...state.serviceLines, ServiceLine(service: service, quantity: quantity)],
      );
    }
  }

  /// Add a material
  void addMaterial(MaterialItem material) {
    final existing = state.materialLines.firstWhere(
      (l) => l.material.name == material.name,
      orElse: () => MaterialLine(material: MaterialItem(name: '', pricePerUnit: 0), quantity: 0),
    );
    
    if (existing.material.name.isNotEmpty) {
      updateMaterialQty(existing, 1);
    } else {
      state = state.copyWith(
        materialLines: [...state.materialLines, MaterialLine(material: material, quantity: 1)],
      );
    }
  }

  /// Remove service line
  /// Service call fee cannot be removed (PRD requirement)
  void removeService(ServiceLine line) {
    // Validate using ValidationRules
    final lineItemType = _isServiceCallFee(line) 
        ? 'service_call_fee' 
        : 'service';
    
    final validation = ValidationRules.canDeleteLineItem(
      lineItemType: lineItemType,
      quoteStatus: QuoteStatus.draft, // Quotes in creation are always draft
    );
    
    if (!validation.isValid) {
      // Silently fail or could show error - for now, just return
      return;
    }

    state = state.copyWith(
      serviceLines: state.serviceLines.where((l) => l.service.name != line.service.name).toList(),
    );
  }

  /// Check if a service line is the service call fee
  bool _isServiceCallFee(ServiceLine line) {
    return line.service.name.toLowerCase().contains('service call fee');
  }

  /// Remove material line
  void removeMaterial(MaterialLine line) {
    state = state.copyWith(
      materialLines: state.materialLines.where((l) => l.material.name != line.material.name).toList(),
    );
  }

  /// Update service quantity
  /// Service call fee quantity cannot be modified (always 1)
  void updateServiceQty(ServiceLine line, int delta) {
    // Prevent modification of service call fee
    if (_isServiceCallFee(line)) {
      return; // Service call fee cannot be modified
    }

    final idx = state.serviceLines.indexWhere((l) => l.service.name == line.service.name);
    if (idx < 0) return;
    
    final newQty = (state.serviceLines[idx].quantity + delta).clamp(1, 999);
    final updatedLines = List<ServiceLine>.from(state.serviceLines);
    updatedLines[idx] = updatedLines[idx].copyWith(quantity: newQty);
    
    state = state.copyWith(serviceLines: updatedLines);
  }

  /// Update service details
  /// Service call fee cannot be modified (PRD requirement)
  void updateService(ServiceLine line, String newName, double newPrice) {
    // Validate using ValidationRules
    final lineItemType = _isServiceCallFee(line) 
        ? 'service_call_fee' 
        : 'service';
    
    final validation = ValidationRules.canEditLineItem(
      lineItemType: lineItemType,
      quoteStatus: QuoteStatus.draft, // Quotes in creation are always draft
    );
    
    if (!validation.isValid) {
      // Silently fail or could show error - for now, just return
      return;
    }

    final idx = state.serviceLines.indexWhere((l) => l.service.name == line.service.name);
    if (idx < 0) return;

    final updatedService = ServiceItem(name: newName, pricePerUnit: newPrice);
    final updatedLines = List<ServiceLine>.from(state.serviceLines);
    updatedLines[idx] = ServiceLine(service: updatedService, quantity: updatedLines[idx].quantity);
    
    state = state.copyWith(serviceLines: updatedLines);
  }

  /// Update material quantity
  void updateMaterialQty(MaterialLine line, int delta) {
    final idx = state.materialLines.indexWhere((l) => l.material.name == line.material.name);
    if (idx < 0) return;
    
    final newQty = (state.materialLines[idx].quantity + delta).clamp(1, 999);
    final updatedLines = List<MaterialLine>.from(state.materialLines);
    updatedLines[idx] = updatedLines[idx].copyWith(quantity: newQty);
    
    state = state.copyWith(materialLines: updatedLines);
  }

  /// Set taxable status
  void setTaxable(bool value) {
    state = state.copyWith(isTaxable: value);
  }

  /// Set tax rate
  void setTaxRate(double rate) {
    state = state.copyWith(taxRate: rate);
  }

  /// Set estimate message
  void setEstimateMessage(String message) {
    state = state.copyWith(estimateMessage: message);
  }

  /// Calculate subtotal (excluding service call fee for tax calculation)
  double get subtotal {
    final servicesTotal = state.serviceLines.fold(0.0, (sum, l) => sum + l.total);
    final materialsTotal = state.materialLines.fold(0.0, (sum, l) => sum + l.total);
    return servicesTotal + materialsTotal;
  }

  /// Calculate tax amount using ValidationRules (PRD Section 18)
  double get taxAmount {
    if (!state.isTaxable) return 0.0;

    // Separate service call fee from other services
    final regularServicesTotal = state.serviceLines
        .where((l) => !_isServiceCallFee(l))
        .fold(0.0, (sum, l) => sum + l.total);
    final serviceCallFee = state.serviceCallFeeLine?.total ?? 0.0;
    final materialsTotal = state.materialLines.fold(0.0, (sum, l) => sum + l.total);
    final discountTotal = 0.0; // Add discount support if needed

    return ValidationRules.calculateTax(
      quoteTaxable: state.isTaxable,
      taxRate: state.taxRate / 100, // Convert percentage to decimal
      servicesTotal: regularServicesTotal,
      materialsTotal: materialsTotal,
      serviceCallFee: serviceCallFee,
      discountTotal: discountTotal,
    );
  }

  /// Calculate total
  double get total => subtotal + taxAmount;

  /// Save quote - now with repository
  /// 
  /// Validates quote before saving using ValidationRules.
  Future<void> saveQuote({required String visitId, required String orgId}) async {
    // Validate quote before saving
    final totalLineItems = state.serviceLines.length + state.materialLines.length;
    final hasServiceCallFee = state.serviceCallFeeLine != null;
    
    final validation = ValidationRules.canFinalizeQuote(
      currentStatus: QuoteStatus.draft,
      lineItemCount: totalLineItems,
      hasServiceCallFee: hasServiceCallFee,
    );
    
    if (!validation.isValid) {
      throw Exception(validation.errorMessage ?? 'Cannot save quote');
    }
    
    final quoteRepository = ref.read(quoteRepositoryProvider);
    final uuid = const Uuid();
    
    // Convert state to QuoteModel
    // Note: quoteNumber will be generated by backend via SequenceCounters table
    // Format: QT-{org_prefix}-{incremented_sequence:04d} (PRD Section 3.10, 29.2)
    final quote = QuoteModel(
      id: uuid.v4(),
      orgId: orgId,
      visitId: visitId,
      quoteNumber: '', // Backend will generate via sequence counter
      status: QuoteStatus.draft,
      taxable: state.isTaxable,
      subtotal: subtotal,
      discountTotal: 0.0, // Discount feature to be implemented in future release
      taxTotal: taxAmount,
      grandTotal: total,
      lineItems: _convertToLineItems(orgId),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Save via repository (handles offline queue automatically)
    await quoteRepository.createQuote(quote);
  }
  
  /// Convert CreateQuotesState to LineItemModel list
  List<LineItemModel> _convertToLineItems(String orgId) {
    final items = <LineItemModel>[];
    final uuid = const Uuid();
    final now = DateTime.now();
    
    // Add service call fee
    if (state.serviceCallFeeLine != null) {
      items.add(LineItemModel(
        id: uuid.v4(),
        orgId: orgId,
        type: LineItemType.service_call_fee,
        description: 'Service Call Fee',
        unit: 'each',
        qty: 1,
        unitPrice: state.serviceCallFeeLine!.service.pricePerUnit,
        taxable: true,
        createdAt: now,
        updatedAt: now,
      ));
    }
    
    // Add services
    for (var line in state.serviceLines) {
      if (!_isServiceCallFee(line)) {
        items.add(LineItemModel(
          id: uuid.v4(),
          orgId: orgId,
          type: LineItemType.service,
          description: line.service.name,
          unit: 'each',
          qty: line.quantity,
          unitPrice: line.service.pricePerUnit,
          taxable: state.isTaxable,
          createdAt: now,
          updatedAt: now,
        ));
      }
    }
    
    // Add materials
    for (var line in state.materialLines) {
      items.add(LineItemModel(
        id: uuid.v4(),
        orgId: orgId,
        type: LineItemType.material,
        description: line.material.name,
        unit: 'each',
        qty: line.quantity,
        unitPrice: line.material.pricePerUnit,
        taxable: state.isTaxable,
        createdAt: now,
        updatedAt: now,
      ));
    }
    
    return items;
  }

  /// Send email
  /// 
  /// Sends quote via email to customer.
  /// Backend integration required for email functionality.
  Future<void> sendEmail() async {
    // Email sending will be implemented when backend email service is available
    throw UnimplementedError('Email sending requires backend integration');
  }

  /// Reset quote
  void reset() {
    // Get billing settings for reset
    final billingSettingsAsync = ref.read(billingSettingsProvider);
    final serviceCallFee = billingSettingsAsync.valueOrNull?.serviceCallFee ?? 75.0;
    final taxRate = billingSettingsAsync.valueOrNull?.taxRate ?? 0.082;
    
    // Re-add service call fee on reset
    final serviceCallFeeLine = ServiceLine(
      service: ServiceItem(name: 'Service Call Fee', pricePerUnit: serviceCallFee),
      quantity: 1,
    );

    state = CreateQuotesState(
      serviceLines: [serviceCallFeeLine],
      materialLines: [],
      isTaxable: true,
      taxRate: taxRate * 100, // Convert to percentage for display
      estimateMessage: 'Thank you for trusting us with your appliance repairs!',
      availableMaterials: _getDefaultMaterials(),
      serviceCallFeeLine: serviceCallFeeLine,
    );
  }
}

/// Create Quotes State
/// 
/// Immutable state class for quote creation.
class CreateQuotesState {
  final List<ServiceLine> serviceLines;
  final List<MaterialLine> materialLines;
  final bool isTaxable;
  final double taxRate;
  final String estimateMessage;
  final List<MaterialItem> availableMaterials;
  final ServiceLine? serviceCallFeeLine; // Track service call fee separately

  CreateQuotesState({
    required this.serviceLines,
    required this.materialLines,
    required this.isTaxable,
    required this.taxRate,
    required this.estimateMessage,
    required this.availableMaterials,
    this.serviceCallFeeLine,
  });

  CreateQuotesState copyWith({
    List<ServiceLine>? serviceLines,
    List<MaterialLine>? materialLines,
    bool? isTaxable,
    double? taxRate,
    String? estimateMessage,
    List<MaterialItem>? availableMaterials,
    ServiceLine? serviceCallFeeLine,
  }) {
    return CreateQuotesState(
      serviceLines: serviceLines ?? this.serviceLines,
      materialLines: materialLines ?? this.materialLines,
      isTaxable: isTaxable ?? this.isTaxable,
      taxRate: taxRate ?? this.taxRate,
      estimateMessage: estimateMessage ?? this.estimateMessage,
      availableMaterials: availableMaterials ?? this.availableMaterials,
      serviceCallFeeLine: serviceCallFeeLine ?? this.serviceCallFeeLine,
    );
  }
}

