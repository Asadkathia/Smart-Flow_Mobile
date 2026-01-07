import '../models/inventory_item_model.dart';

/// Mock Inventory Data
/// 
/// Provides sample inventory items for development and testing.
class InventoryMockData {
  static List<InventoryItemModel> getInventoryItems({String orgId = 'org-1'}) {
    return [
      InventoryItemModel(
        id: '1',
        orgId: orgId,
        name: 'HVAC Filter 16x20x1',
        unit: 'each',
        price: 24.99,
        sku: 'HVF-16201',
        category: 'HVAC Parts',
        description: 'Standard HVAC filter, 16x20x1 inch',
        imageUrl: null,
        isActive: true,
        isAiDetected: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      InventoryItemModel(
        id: '2',
        orgId: orgId,
        name: 'Copper Pipe 1/2 inch',
        unit: 'ft',
        price: 3.50,
        sku: 'CP-05',
        category: 'Plumbing',
        description: 'Copper pipe, 1/2 inch diameter',
        imageUrl: null,
        isActive: true,
        isAiDetected: false,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      InventoryItemModel(
        id: '3',
        orgId: orgId,
        name: 'PVC Elbow Joint',
        unit: 'each',
        price: 1.99,
        sku: 'PVC-ELB90',
        category: 'Plumbing',
        description: '90-degree PVC elbow joint',
        imageUrl: null,
        isActive: true,
        isAiDetected: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      InventoryItemModel(
        id: '4',
        orgId: orgId,
        name: 'Electrical Wire 12 AWG',
        unit: 'ft',
        price: 0.85,
        sku: 'EW-12AWG',
        category: 'Electrical',
        description: '12 AWG electrical wire',
        imageUrl: null,
        isActive: true,
        isAiDetected: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      InventoryItemModel(
        id: '5',
        orgId: orgId,
        name: 'Thermostat - Digital',
        unit: 'each',
        price: 89.99,
        sku: 'THERM-DIG',
        category: 'HVAC Parts',
        description: 'Digital programmable thermostat',
        imageUrl: null,
        isActive: true,
        isAiDetected: true, // AI detected item
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      InventoryItemModel(
        id: '6',
        orgId: orgId,
        name: 'Teflon Tape',
        unit: 'roll',
        price: 2.49,
        sku: 'TF-TAPE',
        category: 'Plumbing',
        description: 'White teflon tape for pipe threads',
        imageUrl: null,
        isActive: true,
        isAiDetected: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      InventoryItemModel(
        id: '7',
        orgId: orgId,
        name: 'Circuit Breaker 20A',
        unit: 'each',
        price: 12.99,
        sku: 'CB-20A',
        category: 'Electrical',
        description: '20 Amp circuit breaker',
        imageUrl: null,
        isActive: true,
        isAiDetected: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      InventoryItemModel(
        id: '8',
        orgId: orgId,
        name: 'Refrigerant R-410A',
        unit: 'lb',
        price: 45.00,
        sku: 'REF-410A',
        category: 'HVAC Parts',
        description: 'R-410A refrigerant',
        imageUrl: null,
        isActive: true,
        isAiDetected: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  /// Mock AI Price Suggestion
  static AiPriceSuggestion getMockPriceSuggestion() {
    return const AiPriceSuggestion(
      suggestedPrice: 34.99,
      currency: 'USD',
      confidence: 'high',
      reasoning: 'Based on similar items in the market and visual analysis',
      similarItems: [
        'HVAC Filter 16x20x1 - \$24.99',
        'HVAC Filter 20x25x1 - \$29.99',
        'Premium HVAC Filter 16x20x1 - \$39.99',
      ],
    );
  }

  /// Mock AI Item Detection
  static AiItemDetection getMockItemDetection() {
    return const AiItemDetection(
      name: 'Digital Thermostat',
      unit: 'each',
      suggestedPrice: 89.99,
      sku: 'THERM-DIG-001',
      category: 'HVAC Parts',
      description: 'Programmable digital thermostat with WiFi connectivity',
      brand: 'Honeywell',
      confidence: 'high',
    );
  }
}

