import '../../../export/exports.dart';
import '../models/service_item.dart';
import '../models/material_item.dart';
import '../models/service_line.dart';
import '../models/material_line.dart';

class CreateQuotesController extends GetxController {
  // Service items
  final RxList<ServiceLine> serviceLines = <ServiceLine>[].obs;
  
  // Material items (renamed from products)
  final RxList<MaterialLine> materialLines = <MaterialLine>[].obs;
  
  // Taxable toggle
  final RxBool isTaxable = true.obs;
  
  // Tax rate (8.2%)
  final RxDouble taxRate = 8.2.obs;
  
  // Estimate message
  final RxString estimateMessage = 'Thank you for trusting us with your appliance repairs!'.obs;

  // Demo materials (to be replaced by API later)
  final List<MaterialItem> availableMaterials = [
    MaterialItem(
      name: 'Ice maker',
      pricePerUnit: 268.43,
    ),
    MaterialItem(
      name: 'Air filter',
      pricePerUnit: 45.00,
    ),
    MaterialItem(
      name: 'Thermostat',
      pricePerUnit: 85.00,
    ),
  ];

  // Add a custom service
  void addCustomService(String name, double pricePerUnit, int quantity) {
    final service = ServiceItem(name: name, pricePerUnit: pricePerUnit);
    final existing = serviceLines.firstWhereOrNull((l) => l.service.name == service.name);
    if (existing != null) {
      updateServiceQty(existing, quantity - existing.quantity);
    } else {
      serviceLines.add(ServiceLine(service: service, quantity: quantity));
    }
    CustomToast.success('Added $name');
  }

  // Add a material
  void addMaterial(MaterialItem material) {
    final existing = materialLines.firstWhereOrNull((l) => l.material.name == material.name);
    if (existing != null) {
      updateMaterialQty(existing, 1);
    } else {
      materialLines.add(MaterialLine(material: material, quantity: 1));
    }
    CustomToast.success('Added ${material.name}');
  }

  // Remove service line
  void removeService(ServiceLine line) {
    serviceLines.removeWhere((l) => l.service.name == line.service.name);
  }

  // Remove material line
  void removeMaterial(MaterialLine line) {
    materialLines.removeWhere((l) => l.material.name == line.material.name);
  }

  // Update service quantity
  void updateServiceQty(ServiceLine line, int delta) {
    final idx = serviceLines.indexWhere((l) => l.service.name == line.service.name);
    if (idx < 0) return;
    final newQty = (serviceLines[idx].quantity + delta).clamp(1, 999);
    serviceLines[idx] = serviceLines[idx].copyWith(quantity: newQty);
  }

  // Update service details
  void updateService(ServiceLine line, String newName, double newPrice) {
    final idx = serviceLines.indexWhere((l) => l.service.name == line.service.name);
    if (idx < 0) return;

    final updatedService = ServiceItem(name: newName, pricePerUnit: newPrice);
    serviceLines[idx] = ServiceLine(service: updatedService, quantity: serviceLines[idx].quantity);
  }

  // Update material quantity
  void updateMaterialQty(MaterialLine line, int delta) {
    final idx = materialLines.indexWhere((l) => l.material.name == line.material.name);
    if (idx < 0) return;
    final newQty = (materialLines[idx].quantity + delta).clamp(1, 999);
    materialLines[idx] = materialLines[idx].copyWith(quantity: newQty);
  }

  // Calculate subtotal (services + materials)
  double get subtotal {
    final servicesTotal = serviceLines.fold(0.0, (sum, l) => sum + l.total);
    final materialsTotal = materialLines.fold(0.0, (sum, l) => sum + l.total);
    return servicesTotal + materialsTotal;
  }

  // Calculate tax amount
  double get taxAmount {
    if (!isTaxable.value) return 0.0;
    return subtotal * (taxRate.value / 100);
  }

  // Calculate total
  double get total => subtotal + taxAmount;

  void saveQuote() {
    CustomToast.success('Quote saved');
  }

  void sendEmail() {
    CustomToast.info('Email sent');
  }
  
  void cancel() {
    Get.back();
  }
  
  void done() {
    // Save and go back
    saveQuote();
    Get.back();
  }
}
