import '../../../export/exports.dart';
import '../controller/create_quotes_controller.dart';
import '../models/service_line.dart';
import 'create_quotes_edit_service_dialog.dart';

class CreateQuotesServiceQuantityEditorDialog extends StatelessWidget {
  final ServiceLine line;

  const CreateQuotesServiceQuantityEditorDialog({
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
            'Edit Service',
            style: AppTextStyles.heading4.copyWith(
              fontSize: 18.sp,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () => _showEditServiceDialog(context, line),
            icon: const Icon(Icons.edit),
            label: Text(
              'Edit Service Details',
              style: AppTextStyles.buttonSmall,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 40.h),
              backgroundColor: AppColors.skyAqua,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
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
                onPressed: () => Get.find<CreateQuotesController>().updateServiceQty(line, -1),
                icon: const Icon(Icons.remove_circle),
                iconSize: 32.sp,
              ),
              SizedBox(width: 24.w),
              Obx(() {
                final controller = Get.find<CreateQuotesController>();
                final updatedLine = controller.serviceLines
                    .firstWhere((l) => l.service.name == line.service.name);
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
                onPressed: () => Get.find<CreateQuotesController>().updateServiceQty(line, 1),
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

  void _showEditServiceDialog(BuildContext context, ServiceLine line) {
    Get.dialog(
      CreateQuotesEditServiceDialog(
        line: line,
      ),
    );
  }
}
