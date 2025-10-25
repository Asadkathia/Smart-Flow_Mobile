import '../../../export/exports.dart';

class CreateQuotesController extends GetxController {
  // Prefilled client name (can be set from previous screen via arguments later)
  final RxString clientName = 'John Doe'.obs;

  // Search query
  final RxString query = ''.obs;

  // All demo products (to be replaced by API later)
  final RxList<QuoteProduct> allProducts = <QuoteProduct>[
    QuoteProduct(
      sku: 'HVF-001',
      name: 'Premium HVAC Filter',
      description: 'High-efficiency filter suitable for residential HVAC systems. Captures dust, pollen and allergens.',
      price: 59.99,
      inventoryCount: 24,
      imageUrl: 'https://picsum.photos/seed/hvac/80/80',
    ),
    QuoteProduct(
      sku: 'THERM-200',
      name: 'Smart Thermostat',
      description: 'Wi‑Fi enabled thermostat with remote scheduling and energy reports.',
      price: 189.00,
      inventoryCount: 9,
      imageUrl: 'https://picsum.photos/seed/thermo/80/80',
    ),
    QuoteProduct(
      sku: 'DUCT-12',
      name: 'Flexible Duct 12ft',
      description: 'Insulated flexible ducting for HVAC installs and repairs.',
      price: 29.50,
      inventoryCount: 52,
      imageUrl: 'https://picsum.photos/seed/duct/80/80',
    ),
    QuoteProduct(
      sku: 'UV-01',
      name: 'UV Air Purifier',
      description: 'In-duct UV purifier to reduce airborne contaminants.',
      price: 249.99,
      inventoryCount: 4,
      imageUrl: 'https://picsum.photos/seed/uv/80/80',
    ),
  ].obs;

  // Filtered products based on query
  final RxList<QuoteProduct> filteredProducts = <QuoteProduct>[].obs;

  // Selected products (quote lines)
  final RxList<QuoteLine> selectedLines = <QuoteLine>[].obs;

  // Service notes
  final RxString servicesText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    filteredProducts.assignAll(allProducts);
    ever<String>(query, (_) => _applyFilter());
  }

  void _applyFilter() {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(allProducts.where((p) {
        return p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q);
      }));
    }
  }

  void addProduct(QuoteProduct p) {
    final idx = selectedLines.indexWhere((l) => l.product.sku == p.sku);
    if (idx >= 0) {
      selectedLines[idx] = selectedLines[idx].copyWith(quantity: selectedLines[idx].quantity + 1);
    } else {
      selectedLines.add(QuoteLine(product: p, quantity: 1));
    }
    CustomToast.success('Added ${p.name}');
  }

  void removeLine(QuoteLine line) {
    selectedLines.removeWhere((l) => l.product.sku == line.product.sku);
  }

  void updateQty(QuoteLine line, int delta) {
    final idx = selectedLines.indexWhere((l) => l.product.sku == line.product.sku);
    if (idx < 0) return;
    final newQty = (selectedLines[idx].quantity + delta).clamp(0, 999);
    if (newQty == 0) {
      selectedLines.removeAt(idx);
    } else {
      selectedLines[idx] = selectedLines[idx].copyWith(quantity: newQty);
    }
  }

  double get total => selectedLines.fold(0.0, (sum, l) => sum + l.product.price * l.quantity);

  void saveQuote() {
    CustomToast.success('Quote saved');
  }

  void sendEmail() {
    CustomToast.info('Email sent');
  }
}

class QuoteProduct {
  final String sku;
  final String name;
  final String description;
  final double price;
  final int inventoryCount;
  final String imageUrl;

  QuoteProduct({
    required this.sku,
    required this.name,
    required this.description,
    required this.price,
    required this.inventoryCount,
    required this.imageUrl,
  });
}

class QuoteLine {
  final QuoteProduct product;
  final int quantity;

  QuoteLine({required this.product, required this.quantity});

  QuoteLine copyWith({QuoteProduct? product, int? quantity}) =>
      QuoteLine(product: product ?? this.product, quantity: quantity ?? this.quantity);
}
