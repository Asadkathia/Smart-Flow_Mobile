import '../../../export/exports.dart';
import '../controller/create_quotes_controller.dart';

class CreateQuotesView extends GetView<CreateQuotesController> {
  const CreateQuotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Quotes', showBackButton: true),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client name (prefilled)
              Text('Client', style: AppTextStyles.heading4),
              SizedBox(height: 8.h),
              Obx(() => TextFormField(
                    initialValue: controller.clientName.value,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: 'Client Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                  )),
              SizedBox(height: 20.h),

              // Product selector with search
              Text('Products', style: AppTextStyles.heading4),
              SizedBox(height: 8.h),
              SearchAnchor.bar(
                barHintText: 'Search by name or SKU',
                viewHintText: 'Search products...',
                suggestionsBuilder: (context, searchCtrl) {
                  final q = searchCtrl.text.trim().toLowerCase();
                  final items = q.isEmpty
                      ? controller.allProducts
                      : controller.allProducts.where((p) =>
                          p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q)).toList();

                  return items.map((p) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: CachedNetworkImage(
                          imageUrl: p.imageUrl,
                          width: 40.w,
                          height: 40.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text('${p.name} · ${p.sku}',
                          style: AppTextStyles.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4.h),
                          Text(p.description,
                              style: AppTextStyles.caption,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          SizedBox(height: 6.h),
                          Text('\$${p.price.toStringAsFixed(2)}  •  In stock: ${p.inventoryCount}',
                              style: AppTextStyles.captionBold),
                        ],
                      ),
                      onTap: () {
                        controller.addProduct(p);
                        searchCtrl.closeView(searchCtrl.text);
                        searchCtrl.clear();
                      },
                    );
                  });
                },
              ),

              SizedBox(height: 16.h),

              // Selected products list
              Obx(() {
                if (controller.selectedLines.isEmpty) {
                  return Text('No products added yet', style: AppTextStyles.bodySmall);
                }
                return Column(
                  children: controller.selectedLines.map((line) => _SelectedLineCard(
                        line: line,
                        onMinus: () => controller.updateQty(line, -1),
                        onPlus: () => controller.updateQty(line, 1),
                        onRemove: () => controller.removeLine(line),
                      )).toList(),
                );
              }),

              SizedBox(height: 20.h),

              // Services text field
              Text('Services Performed', style: AppTextStyles.heading4),
              SizedBox(height: 8.h),
              Obx(() => TextFormField(
                    initialValue: controller.servicesText.value,
                    maxLines: 5,
                    onChanged: (v) => controller.servicesText.value = v,
                    decoration: InputDecoration(
                      hintText: 'Describe the services provided... ',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      suffixIcon: Align(
                        alignment: Alignment.bottomRight,
                        child: PopupMenuButton<String>(
                          tooltip: 'AI suggestions',
                          icon: Icon(Icons.auto_awesome, color: AppColors.skyAqua, size: 20.sp),
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'Decent', child: Text('Decent', style: AppTextStyles.bodySmall)),
                            PopupMenuItem(value: 'Formal way', child: Text('Formal way', style: AppTextStyles.bodySmall)),
                            PopupMenuItem(value: 'Fantastic', child: Text('Fantastic', style: AppTextStyles.bodySmall)),
                          ],
                          onSelected: (choice) {
                            // TODO: Hook up to AI summarize API using controller.servicesText.value
                            CustomToast.info('AI: $choice style coming soon');
                          },
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
                    ),
                  )),

              SizedBox(height: 24.h),

              // Total summary
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: Text('Total: \$${controller.total.toStringAsFixed(2)}',
                        style: AppTextStyles.heading3),
                  )),

              SizedBox(height: 12.h),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.saveQuote,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.sendEmail,
                      icon: const Icon(Icons.email_outlined),
                      label: const Text('Send Email'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedLineCard extends StatelessWidget {
  final QuoteLine line;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;
  const _SelectedLineCard({required this.line, required this.onMinus, required this.onPlus, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final p = line.product;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightBeige),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: CachedNetworkImage(
            imageUrl: p.imageUrl,
            width: 48.w,
            height: 48.w,
            fit: BoxFit.cover,
          ),
        ),
        title: Text('${p.name} · ${p.sku}', style: AppTextStyles.heading4, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(p.description, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 6.h),
            Text('\$${p.price.toStringAsFixed(2)}  •  In stock: ${p.inventoryCount}', style: AppTextStyles.captionBold),
          ],
        ),
        trailing: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 180.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onMinus,
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 20.sp,
                  padding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                ),
                SizedBox(width: 6.w),
                Text('${line.quantity}', style: AppTextStyles.bodyMedium),
                SizedBox(width: 6.w),
                IconButton(
                  onPressed: onPlus,
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 20.sp,
                  padding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                ),
                SizedBox(width: 4.w),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  iconSize: 20.sp,
                  padding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}