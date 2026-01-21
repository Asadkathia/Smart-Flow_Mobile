import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/router/app_router.dart';
import 'package:smartflowpro/core/validation/validation_rules.dart';
import '../../data/models/invoice_model.dart';
import '../providers/invoice_provider.dart';
import '../providers/invoice_paginated_provider.dart';
import '../widgets/invoice_card.dart';
import 'package:smartflowpro/shared/presentation/widgets/loading_skeleton.dart';
import 'package:smartflowpro/shared/presentation/widgets/animations.dart';
import 'package:smartflowpro/shared/presentation/widgets/conflict_banner.dart';
import 'package:smartflowpro/shared/presentation/widgets/standard_states.dart';
import 'package:smartflowpro/shared/presentation/providers/conflict_provider.dart';

/// Invoice List Screen
/// 
/// Displays all invoices with tabs for different statuses.
/// Technicians can view, preview, and finalize invoices.
class InvoiceListScreen extends ConsumerStatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  ConsumerState<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends ConsumerState<InvoiceListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  InvoiceStatus? _getStatusForTab(int index) {
    switch (index) {
      case 0:
        return null; // All
      case 1:
        return InvoiceStatus.draft;
      case 2:
        return InvoiceStatus.unpaid;
      case 3:
        return InvoiceStatus.paid;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final conflictCount = ref.watch(conflictCountProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Invoices',
          style: AppTextStyles.heading3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryTextColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.whiteColor,
          labelColor: AppColors.whiteColor,
          unselectedLabelColor: AppColors.whiteColor.withOpacity(0.7),
          labelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Drafts'),
            Tab(text: 'Unpaid'),
            Tab(text: 'Paid'),
          ],
        ),
      ),
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
          // Tab Content
          Expanded(
            child: TabBarView(
        controller: _tabController,
        children: List.generate(4, (index) {
          return _InvoiceListTab(status: _getStatusForTab(index));
        }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Invoice List Tab
/// 
/// Displays invoices for a specific status or all invoices.
/// Uses AutomaticKeepAliveClientMixin to preserve state when switching tabs.
class _InvoiceListTab extends ConsumerStatefulWidget {
  final InvoiceStatus? status;

  const _InvoiceListTab({this.status});

  @override
  ConsumerState<_InvoiceListTab> createState() => _InvoiceListTabState();
}

class _InvoiceListTabState extends ConsumerState<_InvoiceListTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Preserve state when switching tabs

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final invoicesAsync = ref.watch(paginatedInvoiceListProvider(widget.status));
    final paginatedNotifier = ref.read(paginatedInvoiceListProvider(widget.status).notifier);
    final actionsState = ref.watch(invoiceActionsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await paginatedNotifier.refresh();
      },
      child: AsyncListBuilder<InvoiceModel>(
        value: invoicesAsync,
        emptyTitle: 'No invoices found',
        emptyMessage: widget.status == InvoiceStatus.draft
            ? 'Create a quote to generate invoices'
            : 'Invoices will appear here',
        emptyIcon: Icons.receipt_long_outlined,
        errorTitle: 'Unable to load invoices',
        errorMessage: 'Please check your connection and try again',
        onRetry: () => paginatedNotifier.refresh(),
        loading: (context) => ListLoadingSkeleton(
          itemCount: 5,
          itemBuilder: (context, index) => const InvoiceCardSkeleton(),
        ),
        builder: (context, invoices) {
          final canLoadMore = paginatedNotifier.canLoadMore;
          
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: invoices.length + (canLoadMore ? 1 : 0),
            itemExtent: null,
            cacheExtent: 500.h,
            itemBuilder: (context, index) {
              // Show Load More button at the end
              if (index == invoices.length) {
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
              
              final isLoading = actionsState.isLoading;
              return AnimatedListItem(
                index: index,
                child: InvoiceCard(
                  invoice: invoices[index],
                  isFinalizing: isLoading,
                  onTap: () {
                    context.goToInvoicePreview(invoices[index].id);
                  },
                  onFinalize: invoices[index].canFinalize && !isLoading
                      ? () async {
                          // Validate invoice can be finalized
                          final validation = ValidationRules.canFinalizeInvoice(
                            invoices[index].status,
                          );
                          
                          if (!validation.isValid) {
                            if (context.mounted) {
                              context.showErrorSnackBar(
                                validation.errorMessage ?? 'Cannot finalize invoice',
                              );
                            }
                            return;
                          }
                          
                          final confirmed = await _showFinalizeDialog(context);
                          if (confirmed == true) {
                            final result = await ref
                                .read(invoiceActionsProvider.notifier)
                                .finalize(invoices[index].id);
                            if (result != null && context.mounted) {
                              context.showSuccessSnackBar('Invoice finalized successfully');
                            } else if (context.mounted) {
                              context.showErrorSnackBar('Failed to finalize invoice');
                            }
                          }
                        }
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showFinalizeDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Finalize Invoice'),
        content: Text('Are you sure you want to finalize this invoice? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text('Finalize'),
          ),
        ],
      ),
    );
  }
}

