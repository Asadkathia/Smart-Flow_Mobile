// Material item model
class MaterialItem {
  final String name;
  final double pricePerUnit;
  final String? referenceId;

  MaterialItem({
    required this.name,
    required this.pricePerUnit,
    this.referenceId,
  });
}

