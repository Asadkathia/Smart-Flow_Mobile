import '../../../export/exports.dart';

class CreateQuotesServicePickerDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final VoidCallback onCancel;
  final VoidCallback onAdd;

  const CreateQuotesServicePickerDialog({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.quantityController,
    required this.onCancel,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Service',
        style: AppTextStyles.heading4.copyWith(color: AppColors.blackColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Service Name',
              hintText: 'e.g., Sub Zero refrigerator repair',
              labelStyle: AppTextStyles.textFieldLabel,
              hintStyle: AppTextStyles.textFieldHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.skyAqua),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Price per Unit',
              prefixText: '\$',
              hintText: '0.00',
              labelStyle: AppTextStyles.textFieldLabel,
              hintStyle: AppTextStyles.textFieldHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.skyAqua),
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(
              labelText: 'Quantity',
              hintText: '1',
              labelStyle: AppTextStyles.textFieldLabel,
              hintStyle: AppTextStyles.textFieldHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.skyAqua),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonMedium.copyWith(color: AppColors.neutralDarkGray),
          ),
        ),
        ElevatedButton(
          onPressed: onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.skyAqua,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Add Service',
            style: AppTextStyles.buttonMedium,
          ),
        ),
      ],
    );
  }
}
