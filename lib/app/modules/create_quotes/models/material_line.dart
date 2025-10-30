import 'material_item.dart';

// Material line model
class MaterialLine {
  final MaterialItem material;
  final int quantity;

  MaterialLine({required this.material, required this.quantity});

  double get total => material.pricePerUnit * quantity;

  MaterialLine copyWith({MaterialItem? material, int? quantity}) =>
      MaterialLine(material: material ?? this.material, quantity: quantity ?? this.quantity);
}
