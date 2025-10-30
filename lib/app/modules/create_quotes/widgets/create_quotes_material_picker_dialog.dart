import '../../../export/exports.dart';
import '../models/material_item.dart';

class CreateQuotesMaterialPickerDialog extends StatefulWidget {
  final List<MaterialItem> availableMaterials;

  const CreateQuotesMaterialPickerDialog({
    super.key,
    required this.availableMaterials,
  });

  @override
  State<CreateQuotesMaterialPickerDialog> createState() => _CreateQuotesMaterialPickerDialogState();
}

class _CreateQuotesMaterialPickerDialogState extends State<CreateQuotesMaterialPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<MaterialItem> _filteredMaterials = [];

  @override
  void initState() {
    super.initState();
    _filteredMaterials = widget.availableMaterials;
    _searchController.addListener(_filterMaterials);
  }

  void _filterMaterials() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMaterials = widget.availableMaterials.where((material) {
        return material.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Select Material',
              style: AppTextStyles.heading4.copyWith(
                fontSize: 18.sp,
                color: AppColors.blackColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.lightGray.withOpacity(0.3)),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMaterials.length,
              itemBuilder: (context, index) {
                final material = _filteredMaterials[index];
                return ListTile(
                  title: Text(
                    material.name,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackColor),
                  ),
                  subtitle: Text(
                    '\$${material.pricePerUnit.toStringAsFixed(2)}/Each',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralDarkGray),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(material);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
