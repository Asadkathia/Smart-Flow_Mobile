import 'package:smartflowpro/app/export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quotes_paginated_provider.dart';
import 'package:smartflowpro/features/quotes/data/models/quote_model.dart';
import 'package:smartflowpro/router/app_router.dart';
import 'package:smartflowpro/shared/presentation/widgets/animations.dart';
import 'package:smartflowpro/shared/presentation/providers/conflict_provider.dart';

/// Quotes List Screen - Riverpod Version with Pagination
/// 
/// Displays a paginated list of quotes with pull-to-refresh and load more.
/// Uses Riverpod for state management.
class QuotesListScreen extends ConsumerWidget {
  const QuotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use paginated provider with key "all_all" for all quotes
    final quotesAsync = ref.watch(paginatedQuotesListProvider('all_all'));
    final paginatedNotifier = ref.read(paginatedQuotesListProvider('all_all').notifier);
    final conflictCount = ref.watch(conflictCountProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Quotes', showBackButton: true),
      body: Column(
        children: [
          // Conflict Banner
          if (conflictCount > 0)
            ConflictBanner(
              message: 'Data conflicts detected',
              conflictCount: conflictCount,
              onResolve: () {
                context.goToConflictResolution();
              },
              onDismiss: () {
                ref.read(conflictStateManagerProvider.notifier).clearConflicts();
              },
            ),
          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: RefreshIndicator(
                onRefresh: () async {
                  await paginatedNotifier.refresh();
                },
                child: AsyncListBuilder<QuoteModel>(
                  value: quotesAsync,
                  emptyTitle: 'No quotes found',
                  emptyMessage: 'Create a new quote to get started',
                  emptyIcon: Icons.description_outlined,
                  errorTitle: 'Unable to load quotes',
                  errorMessage: 'Please check your connection and try again',
                  onRetry: () => paginatedNotifier.refresh(),
                  loading: (context) => ListLoadingSkeleton(
                    itemCount: 5,
                    itemBuilder: (context, index) => const QuoteCardSkeleton(),
                  ),
                  builder: (context, quotes) {
                    final canLoadMore = paginatedNotifier.canLoadMore;
              
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: quotes.length + (canLoadMore ? 1 : 0),
                cacheExtent: 500.h,
                separatorBuilder: (_, index) {
                  // Don't add separator before Load More button
                  if (index == quotes.length - 1 && canLoadMore) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(height: 12.h);
                },
                itemBuilder: (context, index) {
                  // Show Load More button at the end
                  if (index == quotes.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () => paginatedNotifier.loadMore(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.whiteColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            'Load More',
                            style: AppTextStyles.buttonMedium,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  final q = quotes[index];
                  // Extract display values from QuoteModel
                  final quoteNumber = q.quoteNumber;
                  final total = q.grandTotal;
                  final status = q.status;
                  
                  return AnimatedListItem(
                    index: index,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.lightBeige),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        leading: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: AppColors.darkGrey,
                          child: Text(
                            quoteNumber.isNotEmpty ? quoteNumber[0] : 'Q',
                            style: AppTextStyles.buttonSmall
                                .copyWith(color: AppColors.whiteColor),
                          ),
                        ),
                        title: Text(
                          quoteNumber,
                          style: AppTextStyles.heading4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4.h),
                            Text(
                              'Status: ${status.name}',
                              style: AppTextStyles.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: AppTextStyles.heading4,
                            ),
                            SizedBox(height: 6.h),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14.sp,
                              color: AppColors.greyColor,
                            ),
                          ],
                        ),
                        onTap: () {
                          context.goToQuoteDetails(q.id);
                        },
                      ),
                    ),
                  );
                },
              );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to create quotes screen
          context.goToCreateQuotes('');
        },
        icon: const Icon(Icons.add),
        label: const Text('New Quote'),
      ),
    );
  }
}

