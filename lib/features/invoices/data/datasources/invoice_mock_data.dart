import '../models/invoice_model.dart';
import '../../../quotes/data/models/line_item_model.dart';

/// Mock Invoice Data
/// 
/// Provides sample invoices for development and testing.
class InvoiceMockData {
  static List<InvoiceModel> getInvoices() {
    return [
      // Draft Invoice
      InvoiceModel(
        id: '1',
        orgId: 'org-1',
        visitId: '1',
        quoteId: 'quote-1',
        invoiceNumber: 'INV-DEMO-0001',
        status: InvoiceStatus.draft,
        total: 450.00,
        subtotal: 400.00,
        taxAmount: 50.00,
        lineItems: [
          LineItemModel(
            id: 'li-1',
            orgId: 'org-1',
            type: LineItemType.service_call_fee,
            description: 'Service Call Fee',
            unit: 'each',
            qty: 1,
            unitPrice: 100.00,
            taxable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          LineItemModel(
            id: 'li-2',
            orgId: 'org-1',
            type: LineItemType.service,
            description: 'AC Repair & Maintenance - 2 hours of labor',
            unit: 'hour',
            qty: 2,
            unitPrice: 150.00,
            taxable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        customerName: 'John Smith',
        customerEmail: 'john.smith@example.com',
        customerPhone: '(555) 123-4567',
        propertyAddress: '123 Main St, Phoenix, AZ 85001',
        visitTitle: 'AC Repair',
        notes: 'Customer requested early morning visit',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),

      // Unpaid Invoice
      InvoiceModel(
        id: '2',
        orgId: 'org-1',
        visitId: '2',
        quoteId: 'quote-2',
        invoiceNumber: 'INV-DEMO-0002',
        status: InvoiceStatus.unpaid,
        total: 675.00,
        subtotal: 600.00,
        taxAmount: 75.00,
        lineItems: [
          LineItemModel(
            id: 'li-3',
            orgId: 'org-1',
            type: LineItemType.service_call_fee,
            description: 'Service Call Fee',
            unit: 'each',
            qty: 1,
            unitPrice: 100.00,
            taxable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          LineItemModel(
            id: 'li-4',
            orgId: 'org-1',
            type: LineItemType.service,
            description: 'Plumbing Repair - 3 hours of labor',
            unit: 'hour',
            qty: 3,
            unitPrice: 125.00,
            taxable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          LineItemModel(
            id: 'li-5',
            orgId: 'org-1',
            type: LineItemType.material,
            description: 'Copper Pipe 1/2 inch',
            unit: 'ft',
            qty: 20,
            unitPrice: 3.50,
            taxable: true,
            referenceId: '2',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          LineItemModel(
            id: 'li-6',
            orgId: 'org-1',
            type: LineItemType.material,
            description: 'PVC Elbow Joint',
            unit: 'each',
            qty: 5,
            unitPrice: 1.99,
            taxable: true,
            referenceId: '3',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        customerName: 'Jane Doe',
        customerEmail: 'jane.doe@example.com',
        customerPhone: '(555) 987-6543',
        propertyAddress: '456 Oak Ave, Phoenix, AZ 85002',
        visitTitle: 'Plumbing Service',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      // Partially Paid Invoice
      InvoiceModel(
        id: '3',
        orgId: 'org-1',
        visitId: '3',
        quoteId: 'quote-3',
        invoiceNumber: 'INV-DEMO-0003',
        status: InvoiceStatus.partiallyPaid,
        total: 850.00,
        subtotal: 750.00,
        taxAmount: 100.00,
        lineItems: [
          LineItemModel(
            id: 'li-7',
            orgId: 'org-1',
            type: LineItemType.service_call_fee,
            description: 'Service Call Fee',
            unit: 'each',
            qty: 1,
            unitPrice: 100.00,
            taxable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          LineItemModel(
            id: 'li-8',
            orgId: 'org-1',
            type: LineItemType.service,
            description: 'HVAC Installation - 4 hours of labor',
            unit: 'hour',
            qty: 4,
            unitPrice: 150.00,
            taxable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          LineItemModel(
            id: 'li-9',
            orgId: 'org-1',
            type: LineItemType.material,
            description: 'Thermostat - Digital',
            unit: 'each',
            qty: 1,
            unitPrice: 89.99,
            taxable: true,
            referenceId: '5',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        customerName: 'Bob Johnson',
        customerEmail: 'bob.johnson@example.com',
        customerPhone: '(555) 456-7890',
        propertyAddress: '789 Elm St, Phoenix, AZ 85003',
        visitTitle: 'HVAC Service',
        dueDate: DateTime.now().add(const Duration(days: 25)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),

      // Paid Invoice
      InvoiceModel(
        id: '4',
        orgId: 'org-1',
        visitId: '4',
        quoteId: 'quote-4',
        invoiceNumber: 'INV-DEMO-0004',
        status: InvoiceStatus.paid,
        total: 550.00,
        subtotal: 500.00,
        taxAmount: 50.00,
        lineItems: [
          LineItemModel(
            id: 'li-10',
            orgId: 'org-1',
            type: LineItemType.service_call_fee,
            description: 'Service Call Fee',
            unit: 'each',
            qty: 1,
            unitPrice: 100.00,
            taxable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          LineItemModel(
            id: 'li-11',
            orgId: 'org-1',
            type: LineItemType.service,
            description: 'Electrical Repair - 2 hours of labor',
            unit: 'hour',
            qty: 2,
            unitPrice: 175.00,
            taxable: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          LineItemModel(
            id: 'li-12',
            orgId: 'org-1',
            type: LineItemType.material,
            description: 'Circuit Breaker 20A',
            unit: 'each',
            qty: 2,
            unitPrice: 12.99,
            taxable: true,
            referenceId: '7',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        customerName: 'Alice Williams',
        customerEmail: 'alice.williams@example.com',
        customerPhone: '(555) 321-0987',
        propertyAddress: '321 Pine Rd, Phoenix, AZ 85004',
        visitTitle: 'Electrical Service',
        paidAt: DateTime.now().subtract(const Duration(hours: 6)),
        dueDate: DateTime.now().add(const Duration(days: 27)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  /// Get mock payments
  static List<PaymentModel> getMockPayments(String invoiceId) {
    if (invoiceId == '3') {
      // Partially paid invoice
      final now = DateTime.now().subtract(const Duration(days: 1));
      return [
        PaymentModel(
          id: 'pay-1',
          orgId: 'org-1', // PRD: required for multi-tenancy
          invoiceId: invoiceId,
          amount: 425.00, // 50% of 850
          method: PaymentMethod.cash,
          reference: null,
          receivedBy: 'tech-1',
          receivedAt: now,
          createdAt: now,
          updatedAt: now, // PRD: required
        ),
      ];
    } else if (invoiceId == '4') {
      // Fully paid invoice
      final now = DateTime.now().subtract(const Duration(hours: 6));
      return [
        PaymentModel(
          id: 'pay-2',
          orgId: 'org-1', // PRD: required for multi-tenancy
          invoiceId: invoiceId,
          amount: 550.00,
          method: PaymentMethod.card,
          reference: 'CH_1234567890',
          receivedBy: 'tech-1',
          receivedAt: now,
          createdAt: now,
          updatedAt: now, // PRD: required
        ),
      ];
    }
    return [];
  }
}

