import '../../../export/exports.dart';


class CreateQuotesView extends GetView<CreateQuotesController> {
  const CreateQuotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: controller.cancel,
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonMedium.copyWith(color: AppColors.skyAqua),
          ),
        ),
        leadingWidth: 80.w,
        title: Text(
          'Line items',
          style: AppTextStyles.heading4.copyWith(color: AppColors.blackColor),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: controller.done,
            child: Text(
              'Done',
              style: AppTextStyles.buttonMedium.copyWith(color: AppColors.skyAqua),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SERVICES Section
            CreateQuotesSectionHeader(
              title: 'SERVICES',
            ),
            Obx(() => Column(
                  children: [
                    ...controller.serviceLines
                        .map((line) => CreateQuotesLineItem(
                              title: line.service.name,
                              subtitle:
                                  'Qty ${line.quantity} @ \$${line.service.pricePerUnit.toStringAsFixed(2)}/Each',
                              amount: '\$${line.total.toStringAsFixed(2)}',
                              onRemove: () => controller.removeService(line),
                              onTap: () => _showServiceQuantityEditor(context, line),
                            ))
                        ,
                    CreateQuotesAddButton(
                      label: 'Add Services',
                      onTap: () => _showServicePicker(context),
                    ),
                  ],
                )),

            SizedBox(height: 16.h),

            // MATERIALS Section
            CreateQuotesSectionHeader(
              title: 'Products',
              bookLink: 'Products Price Book',
              onBookTap: () => _showMaterialPicker(context),
            ),
            Obx(() => Column(
                  children: [
                    ...controller.materialLines
                        .map((line) => CreateQuotesLineItem(
                              title: line.material.name,
                              subtitle:
                                  'Qty ${line.quantity} @ \$${line.material.pricePerUnit.toStringAsFixed(2)}/Each',
                              amount: '\$${line.total.toStringAsFixed(2)}',
                              onRemove: () => controller.removeMaterial(line),
                              onTap: () => _showMaterialQuantityEditor(context, line),
                            ))
                        ,
                    CreateQuotesAddButton(
                      label: 'Add Materials',
                      onTap: () => _showMaterialPicker(context),
                    ),
                  ],
                )),

            SizedBox(height: 16.h),

            // Subtotal
            Obx(() => CreateQuotesSummaryRow(
                  label: 'Subtotal',
                  amount: '\$${controller.subtotal.toStringAsFixed(2)}',
                )),

            Divider(height: 32.h, thickness: 8.h, color: AppColors.lightGray.withOpacity(0.3)),

            // Taxable toggle
            Obx(() => CreateQuotesTaxableRow(
                  isTaxable: controller.isTaxable.value,
                  onChanged: (value) => controller.isTaxable.value = value,
                )),

            // Tax row
            Obx(() => controller.isTaxable.value
                ? CreateQuotesSummaryRow(
                    label: 'TAX (${controller.taxRate.value.toStringAsFixed(1)}%)',
                    amount: '\$${controller.taxAmount.toStringAsFixed(2)}',
                  )
                : const SizedBox.shrink()),

            Divider(height: 32.h, thickness: 8.h, color: AppColors.lightGray.withOpacity(0.3)),

            // Total
            Obx(() => CreateQuotesSummaryRow(
                  label: 'Total',
                  amount: '\$${controller.total.toStringAsFixed(2)}',
                  isTotal: true,
                )),

            Divider(height: 32.h, thickness: 8.h, color: AppColors.lightGray.withOpacity(0.3)),

            // ESTIMATE MESSAGE Section
            CreateQuotesSectionHeader(
              title: 'ESTIMATE MESSAGE',
            ),
            Obx(() => CreateQuotesMessageRow(
                  message: controller.estimateMessage.value,
                  onTap: () => _showMessageEditor(context),
                )),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }



  // Show service picker dialog
  void _showServicePicker(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController(text: '1');

    Get.dialog(
      CreateQuotesServicePickerDialog(
        nameController: nameController,
        priceController: priceController,
        quantityController: quantityController,
        onCancel: () => Get.back(),
        onAdd: () {
          final name = nameController.text.trim();
          final price = double.tryParse(priceController.text.trim()) ?? 0;
          final quantity = int.tryParse(quantityController.text.trim()) ?? 1;

          if (name.isNotEmpty && price > 0 && quantity > 0) {
            controller.addCustomService(name, price, quantity);
            Get.back();
          } else {
            CustomToast.error('Please enter valid service name, price, and quantity');
          }
        },
      ),
    );
  }

  // Show material picker dialog
  void _showMaterialPicker(BuildContext context) {
    Get.bottomSheet(
      CreateQuotesMaterialPickerDialog(
        availableMaterials: controller.availableMaterials,
      ),
    ).then((selectedMaterial) {
      if (selectedMaterial != null) {
        controller.addMaterial(selectedMaterial);
      }
    });
  }

  // Show service quantity editor
  void _showServiceQuantityEditor(BuildContext context, ServiceLine line) {
    Get.bottomSheet(
      CreateQuotesServiceQuantityEditorDialog(
        line: line,
      ),
    );
  }



  // Show material quantity editor
  void _showMaterialQuantityEditor(BuildContext context, MaterialLine line) {
    Get.bottomSheet(
      CreateQuotesMaterialQuantityEditorDialog(
        line: line,
      ),
    );
  }

  // Show message editor
  void _showMessageEditor(BuildContext context) {
    final messageController = TextEditingController(text: controller.estimateMessage.value);

    Get.dialog(
      CreateQuotesMessageEditorDialog(
        messageController: messageController,
        onCancel: () => Get.back(),
        onSave: () {
          final message = messageController.text.trim();
          if (message.isNotEmpty) {
            controller.estimateMessage.value = message;
            Get.back();
          } else {
            CustomToast.error('Message cannot be empty');
          }
        },
      ),
    );
  }
}
