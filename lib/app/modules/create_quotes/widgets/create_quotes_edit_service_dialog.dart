import '../../../export/exports.dart';
import '../controller/create_quotes_controller.dart';
import '../models/service_line.dart';

class CreateQuotesEditServiceDialog extends StatelessWidget {
  final ServiceLine line;

  const CreateQuotesEditServiceDialog({
    super.key,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: line.service.name);
    final priceController = TextEditingController(text: line.service.pricePerUnit.toString());

    return AlertDialog(
      title: Text(
        'Edit Service',
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonMedium.copyWith(color: AppColors.neutralDarkGray),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final price = double.tryParse(priceController.text.trim()) ?? 0;

            if (name.isNotEmpty && price > 0) {
              Get.find<CreateQuotesController>().updateService(line, name, price);
              Get.back(); // Close dialog
              Get.back(); // Close bottom sheet
              CustomToast.success('Service updated');
            } else {
              CustomToast.error('Please enter valid service name and price');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.skyAqua,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Update',
            style: AppTextStyles.buttonMedium,
          ),
        ),
      ],
    );
  }
}
