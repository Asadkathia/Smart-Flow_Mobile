import '../../../export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/create_quotes_provider.dart';
import '../models/service_line.dart';
import '../models/material_line.dart';
import '../../../../router/app_router.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../features/quotes/data/models/quote_model.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

/// Create Quotes Screen - Riverpod Version
/// 
/// Allows creating quotes with services, materials, tax, and message.
/// Uses Riverpod for state management.
class CreateQuotesScreen extends ConsumerWidget {
  /// The visit ID this quote is for
  final String visitId;

  const CreateQuotesScreen({super.key, this.visitId = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteState = ref.watch(createQuotesProvider);
    final quoteNotifier = ref.read(createQuotesProvider.notifier);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
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
            onPressed: () => _handleDone(context, ref),
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
            Column(
              children: [
                ...quoteState.serviceLines
                    .map((line) {
                      final isServiceCallFee = line.service.name.toLowerCase().contains('service call fee');
                      return CreateQuotesLineItem(
                        title: line.service.name,
                        subtitle:
                            'Qty ${line.quantity} @ \$${line.service.pricePerUnit.toStringAsFixed(2)}/Each',
                        amount: '\$${line.total.toStringAsFixed(2)}',
                        onRemove: isServiceCallFee
                            ? null  // Disable remove for service call fee
                            : () => quoteNotifier.removeService(line),
                        onTap: isServiceCallFee
                            ? null  // Disable edit for service call fee
                            : () => _showServiceQuantityEditor(context, ref, line),
                      );
                    }),
                CreateQuotesAddButton(
                  label: 'Add Services',
                  onTap: () => _showServicePicker(context, ref),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // MATERIALS Section
            CreateQuotesSectionHeader(
              title: 'Products',
              bookLink: 'Products Price Book',
              onBookTap: () => _showMaterialPicker(context, ref),
            ),
            Column(
              children: [
                ...quoteState.materialLines
                    .map((line) => CreateQuotesLineItem(
                          title: line.material.name,
                          subtitle:
                              'Qty ${line.quantity} @ \$${line.material.pricePerUnit.toStringAsFixed(2)}/Each',
                          amount: '\$${line.total.toStringAsFixed(2)}',
                          onRemove: () => quoteNotifier.removeMaterial(line),
                          onTap: () => _showMaterialQuantityEditor(context, ref, line),
                        )),
                CreateQuotesAddButton(
                  label: 'Add Materials',
                  onTap: () => _showMaterialPicker(context, ref),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Subtotal
            CreateQuotesSummaryRow(
              label: 'Subtotal',
              amount: '\$${quoteNotifier.subtotal.toStringAsFixed(2)}',
            ),

            Divider(height: 32.h, thickness: 8.h, color: AppColors.lightGray.withOpacity(0.3)),

            // Taxable toggle
            CreateQuotesTaxableRow(
              isTaxable: quoteState.isTaxable,
              onChanged: (value) => quoteNotifier.setTaxable(value),
            ),

            // Tax row
            if (quoteState.isTaxable)
              CreateQuotesSummaryRow(
                label: 'TAX (${quoteState.taxRate.toStringAsFixed(1)}%)',
                amount: '\$${quoteNotifier.taxAmount.toStringAsFixed(2)}',
              ),

            Divider(height: 32.h, thickness: 8.h, color: AppColors.lightGray.withOpacity(0.3)),

            // Total
            CreateQuotesSummaryRow(
              label: 'Total',
              amount: '\$${quoteNotifier.total.toStringAsFixed(2)}',
              isTotal: true,
            ),

            Divider(height: 32.h, thickness: 8.h, color: AppColors.lightGray.withOpacity(0.3)),

            // ESTIMATE MESSAGE Section
            CreateQuotesSectionHeader(
              title: 'ESTIMATE MESSAGE',
            ),
            CreateQuotesMessageRow(
              message: quoteState.estimateMessage,
              onTap: () => _showMessageEditor(context, ref),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  void _handleDone(BuildContext context, WidgetRef ref) async {
    final quoteState = ref.read(createQuotesProvider);
    final quoteNotifier = ref.read(createQuotesProvider.notifier);
    
    // Validate quote can be finalized
    final totalLineItems = quoteState.serviceLines.length + quoteState.materialLines.length;
    final hasServiceCallFee = quoteState.serviceCallFeeLine != null;
    
    final validation = ValidationRules.canFinalizeQuote(
      currentStatus: QuoteStatus.draft, // Assuming draft status
      lineItemCount: totalLineItems,
      hasServiceCallFee: hasServiceCallFee,
    );
    
    if (!validation.isValid) {
      if (context.mounted) {
        context.showErrorSnackBar(validation.errorMessage ?? 'Cannot finalize quote');
      }
      return;
    }
    
    // Get orgId from auth provider
    final authState = ref.read(authProvider);
    final orgId = authState.user?.orgId;
    if (orgId == null) {
      if (context.mounted) {
        context.showErrorSnackBar('Organization ID not found. Please log in again.');
      }
      return;
    }
    
    await quoteNotifier.saveQuote(
      visitId: visitId.isNotEmpty ? visitId : 'visit-1', // TODO: Get from route params
      orgId: orgId,
    );
    if (context.mounted) {
      context.showSuccessSnackBar('Quote saved');
    }
    
    // Show dialog to create invoice
    final createInvoice = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Quote Saved'),
        content: Text('Would you like to create an invoice from this quote?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text('Create Invoice'),
          ),
        ],
      ),
    );

    if (createInvoice == true && context.mounted) {
      // Navigate to invoice list
      // TODO: Pass quote data to invoice creation screen
      context.push(AppRoutePaths.invoiceList);
    } else {
      Navigator.pop(context);
    }
  }



  // Show service picker dialog
  void _showServicePicker(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (dialogContext) => CreateQuotesServicePickerDialog(
        nameController: nameController,
        priceController: priceController,
        quantityController: quantityController,
        onCancel: () => Navigator.pop(dialogContext),
        onAdd: () {
          final name = nameController.text.trim();
          final price = double.tryParse(priceController.text.trim()) ?? 0;
          final quantity = int.tryParse(quantityController.text.trim()) ?? 1;

          if (name.isNotEmpty && price > 0 && quantity > 0) {
            ref.read(createQuotesProvider.notifier).addCustomService(name, price, quantity);
            CustomToast.success('Added $name');
            Navigator.pop(dialogContext);
          } else {
            CustomToast.error('Please enter valid service name, price, and quantity');
          }
        },
      ),
    );
  }

  // Show material picker dialog
  void _showMaterialPicker(BuildContext context, WidgetRef ref) {
    final quoteState = ref.read(createQuotesProvider);
    showModalBottomSheet(
      context: context,
      builder: (context) => CreateQuotesMaterialPickerDialog(
        availableMaterials: quoteState.availableMaterials,
      ),
    ).then((selectedMaterial) {
      if (selectedMaterial != null) {
        ref.read(createQuotesProvider.notifier).addMaterial(selectedMaterial);
        CustomToast.success('Added ${selectedMaterial.name}');
      }
    });
  }

  // Show service quantity editor
  void _showServiceQuantityEditor(BuildContext context, WidgetRef ref, ServiceLine line) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CreateQuotesServiceQuantityEditorDialog(
        line: line,
        onUpdate: (delta) {
          ref.read(createQuotesProvider.notifier).updateServiceQty(line, delta);
        },
        onEditService: (name, price) {
          ref.read(createQuotesProvider.notifier).updateService(line, name, price);
        },
      ),
    );
  }

  // Show material quantity editor
  void _showMaterialQuantityEditor(BuildContext context, WidgetRef ref, MaterialLine line) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CreateQuotesMaterialQuantityEditorDialog(
        line: line,
        onUpdate: (delta) {
          ref.read(createQuotesProvider.notifier).updateMaterialQty(line, delta);
        },
      ),
    );
  }

  // Show message editor
  void _showMessageEditor(BuildContext context, WidgetRef ref) {
    final quoteState = ref.read(createQuotesProvider);
    final messageController = TextEditingController(text: quoteState.estimateMessage);

    showDialog(
      context: context,
      builder: (dialogContext) => CreateQuotesMessageEditorDialog(
        messageController: messageController,
        onCancel: () => Navigator.pop(dialogContext),
        onSave: () {
          final message = messageController.text.trim();
          if (message.isNotEmpty) {
            ref.read(createQuotesProvider.notifier).setEstimateMessage(message);
            Navigator.pop(dialogContext);
          } else {
            CustomToast.error('Message cannot be empty');
          }
        },
      ),
    );
  }
}
