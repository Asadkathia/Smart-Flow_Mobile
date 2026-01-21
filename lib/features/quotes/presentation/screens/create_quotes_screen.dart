import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/app/export/exports.dart' show CustomToast;
import '../providers/create_quotes_provider.dart';
import 'package:smartflowpro/features/quotes/data/models/create_quotes/service_line.dart';
import 'package:smartflowpro/features/quotes/data/models/create_quotes/material_line.dart';
import 'package:smartflowpro/router/app_router.dart';
import 'package:smartflowpro/core/validation/validation_rules.dart';
import 'package:smartflowpro/features/quotes/data/models/quote_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../invoices/data/repositories/invoice_repository.dart';
import '../widgets/create_quotes/create_quotes_section_header.dart';
import '../widgets/create_quotes/create_quotes_line_item.dart';
import '../widgets/create_quotes/create_quotes_add_button.dart';
import '../widgets/create_quotes/create_quotes_summary_row.dart';
import '../widgets/create_quotes/create_quotes_taxable_row.dart';
import '../widgets/create_quotes/create_quotes_message_row.dart';
import '../widgets/create_quotes/create_quotes_service_picker_dialog.dart';
import '../widgets/create_quotes/create_quotes_material_picker_dialog.dart';
import '../widgets/create_quotes/create_quotes_service_quantity_editor_dialog.dart';
import '../widgets/create_quotes/create_quotes_material_quantity_editor_dialog.dart';
import '../widgets/create_quotes/create_quotes_message_editor_dialog.dart';

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
          onPressed: () => context.pop(),
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

            // Notes Section
            CreateQuotesSectionHeader(
              title: 'NOTES',
            ),
            CreateQuotesMessageRow(
              message: quoteState.notes ?? 'Tap to add notes',
              onTap: () => _showNotesEditor(context, ref),
            ),

            SizedBox(height: 16.h),

            // Terms Section
            CreateQuotesSectionHeader(
              title: 'TERMS',
            ),
            CreateQuotesMessageRow(
              message: quoteState.terms ?? 'Tap to add terms',
              onTap: () => _showTermsEditor(context, ref),
            ),

            SizedBox(height: 16.h),

            // Expiration Date Section
            CreateQuotesSectionHeader(
              title: 'EXPIRATION DATE',
            ),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: quoteState.expirationDate ?? DateTime.now().add(Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  quoteNotifier.updateExpirationDate(date);
                }
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20.sp, color: AppColors.greyColor),
                    SizedBox(width: 12.w),
                    Text(
                      quoteState.expirationDate != null
                          ? 'Valid until ${DateFormat('MMM d, yyyy').format(quoteState.expirationDate!)}'
                          : 'Tap to set expiration date',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: quoteState.expirationDate != null 
                            ? AppColors.primaryTextColor 
                            : AppColors.greyColor,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.chevron_right, color: AppColors.greyColor),
                  ],
                ),
              ),
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
    
    // Validate visitId is provided
    if (visitId.isEmpty) {
      if (context.mounted) {
        context.showErrorSnackBar('Visit ID is required. Please navigate from a visit.');
      }
      return;
    }
    
    // In development mode, allow proceeding without strict orgId check
    // In production, this should be required
    
    try {
      // Save the quote and get the returned quote ID
      final savedQuoteId = await quoteNotifier.saveQuote(
        visitId: visitId,
      );
      
      if (context.mounted) {
        context.showSuccessSnackBar('Quote saved successfully');
        context.pop(); // Return to previous screen
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar('Failed to save quote: ${e.toString()}');
      }
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
            ref.read(createQuotesProvider.notifier).updateEstimateMessage(message);
            Navigator.pop(dialogContext);
          } else {
            CustomToast.error('Message cannot be empty');
          }
        },
      ),
    );
  }

  void _showNotesEditor(BuildContext context, WidgetRef ref) {
    final quoteNotifier = ref.read(createQuotesProvider.notifier);
    final currentNotes = ref.read(createQuotesProvider).notes ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quote Notes'),
        content: TextField(
          controller: TextEditingController(text: currentNotes),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Add any additional notes or instructions',
            border: OutlineInputBorder(),
          ),
          onChanged: quoteNotifier.updateNotes,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showTermsEditor(BuildContext context, WidgetRef ref) {
    final quoteNotifier = ref.read(createQuotesProvider.notifier);
    final currentTerms = ref.read(createQuotesProvider).terms ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms & Conditions'),
        content: TextField(
          controller: TextEditingController(text: currentTerms),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Payment terms, warranty info, etc.',
            border: OutlineInputBorder(),
          ),
          onChanged: quoteNotifier.updateTerms,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}
