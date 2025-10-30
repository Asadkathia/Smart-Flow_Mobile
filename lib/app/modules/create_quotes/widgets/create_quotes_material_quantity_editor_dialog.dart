import '../../../export/exports.dart';
import '../controller/create_quotes_controller.dart';
import '../models/material_line.dart';

class CreateQuotesMaterialQuantityEditorDialog extends StatelessWidget {
  final MaterialLine line;

  const CreateQuotesMaterialQuantityEditorDialog({
    super.key,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            line.material.name,
            style: AppTextStyles.heading4.copyWith(
              fontSize: 18.sp,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Adjust Quantity',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.neutralDarkGray,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => Get.find<CreateQuotesController>().updateMaterialQty(line, -1),
                icon: const Icon(Icons.remove_circle),
                iconSize: 32.sp,
              ),
              SizedBox(width: 24.w),
              Obx(() {
                final controller = Get.find<CreateQuotesController>();
                final updatedLine = controller.materialLines
                    .firstWhere((l) => l.material.name == line.material.name);
                return Text(
                  '${updatedLine.quantity}',
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: 24.sp,
                    color: AppColors.blackColor,
                  ),
                );
              }),
              SizedBox(width: 24.w),
              IconButton(
                onPressed: () => Get.find<CreateQuotesController>().updateMaterialQty(line, 1),
                icon: const Icon(Icons.add_circle),
                iconSize: 32.sp,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: AppColors.skyAqua,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Done',
              style: AppTextStyles.buttonMedium,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
