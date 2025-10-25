import '../../../export/exports.dart';
import '../controller/quotes_list_controller.dart';

class QuotesListView extends GetView<QuotesListController> {
  const QuotesListView({super.key});

  

  String _statusText(QuoteStatus s) => s.name.capitalizeFirst!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Quotes', showBackButton: true),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async => controller.refreshQuotes(),
            child: controller.quotes.isEmpty
                ? Center(
                    child: Text('No quotes found', style: AppTextStyles.bodySmall),
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.quotes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final q = controller.quotes[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.lightBeige),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          leading: CircleAvatar(
                            radius: 22.r,
                            backgroundColor: AppColors.darkGrey,
                            child: Text(q.clientName.isNotEmpty ? q.clientName[0] : 'C',
                                style: AppTextStyles.buttonSmall.copyWith(color: AppColors.whiteColor)),
                          ),
                          title: Text('${q.jobTitle} · ${q.id}',
                              style: AppTextStyles.heading4,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h),
                              Text(q.clientName, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                              SizedBox(height: 6.h),
                              // Row(
                              //   children: [
                              //     _StatusChip(label: _statusText(q.status), color: _statusColor(q.status)),
                              //     SizedBox(width: 8.w),
                              //     Text(DateFormat.yMMMd().format(q.date), style: AppTextStyles.caption),
                              //   ],
                              // ),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$${q.total.toStringAsFixed(2)}', style: AppTextStyles.heading4),
                              SizedBox(height: 6.h),
                              Icon(Icons.arrow_forward_ios, size: 14.sp, color: AppColors.greyColor),
                            ],
                          ),
                          onTap: () {
                            // TODO: Navigate to quote details
                          },
                        ),
                      );
                    },
                  ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.createQuotes);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Quote'),
      ),
    );
  }
}

// class _StatusChip extends StatelessWidget {
//   final String label;
//   final Color color;
//   const _StatusChip({required this.label, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(999.r),
//         border: Border.all(color: color.withOpacity(0.4)),
//       ),
//       child: Text(label, style: AppTextStyles.captionBold.copyWith(color: color)),
//     );
//   }
// }
