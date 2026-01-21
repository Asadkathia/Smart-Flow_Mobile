import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../data/models/invoice_model.dart';
import '../../../quotes/data/models/line_item_model.dart';

/// Invoice PDF Service
/// 
/// Generates client-side PDF invoices for preview and printing.
/// PRD Section 9.3: Invoice preview functionality.
class InvoicePdfService {
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '\$');

  /// Generate PDF bytes from invoice
  Future<Uint8List> generatePdf(InvoiceModel invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => _buildInvoicePage(invoice),
      ),
    );

    return pdf.save();
  }

  /// Preview PDF on device
  Future<void> previewPdf(InvoiceModel invoice) async {
    final pdfBytes = await generatePdf(invoice);
    await Printing.layoutPdf(
      onLayout: (_) async => pdfBytes,
      name: 'Invoice_${invoice.invoiceNumber}.pdf',
    );
  }

  /// Share PDF
  Future<void> sharePdf(InvoiceModel invoice) async {
    final pdfBytes = await generatePdf(invoice);
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Invoice_${invoice.invoiceNumber}.pdf',
    );
  }

  /// Build the invoice page content
  pw.Widget _buildInvoicePage(InvoiceModel invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(invoice),
        pw.SizedBox(height: 30),
        
        // Customer/Property Info
        _buildCustomerInfo(invoice),
        pw.SizedBox(height: 20),
        
        // Line Items Table
        _buildLineItemsTable(invoice),
        pw.SizedBox(height: 20),
        
        // Totals
        _buildTotals(invoice),
        pw.SizedBox(height: 30),
        
        // Footer
        _buildFooter(invoice),
      ],
    );
  }

  /// Build header with invoice number and status
  pw.Widget _buildHeader(InvoiceModel invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'INVOICE',
              style: pw.TextStyle(
                fontSize: 32,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              invoice.invoiceNumber,
              style: pw.TextStyle(
                fontSize: 16,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: pw.BoxDecoration(
            color: _getStatusColor(invoice.status),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            invoice.statusText.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// Build customer and property info section
  pw.Widget _buildCustomerInfo(InvoiceModel invoice) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Bill To
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'BILL TO',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey600,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                invoice.customerName ?? 'Customer',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (invoice.propertyAddress != null)
                pw.Text(
                  invoice.propertyAddress!,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              if (invoice.customerPhone != null)
                pw.Text(
                  invoice.customerPhone!,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              if (invoice.customerEmail != null)
                pw.Text(
                  invoice.customerEmail!,
                  style: const pw.TextStyle(fontSize: 12),
                ),
            ],
          ),
        ),
        // Invoice Details
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _buildInfoRow('Date', _formatDate(invoice.createdAt)),
            if (invoice.dueDate != null)
              _buildInfoRow('Due Date', _formatDate(invoice.dueDate)),
            if (invoice.visitTitle != null)
              _buildInfoRow('Service', invoice.visitTitle!),
          ],
        ),
      ],
    );
  }

  /// Build line items table
  pw.Widget _buildLineItemsTable(InvoiceModel invoice) {
    final headers = ['Description', 'Qty', 'Unit', 'Unit Price', 'Total'];
    
    return pw.Table(
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      ),
      columnWidths: {
        0: const pw.FlexColumnWidth(4),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            color: PdfColors.blueGrey50,
          ),
          children: headers.map((h) => pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              h,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800,
              ),
            ),
          )).toList(),
        ),
        // Data rows
        ...invoice.lineItems.map((item) => pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                item.description,
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                item.qty.toStringAsFixed(item.qty == item.qty.toInt() ? 0 : 2),
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                item.unit,
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                _currencyFormat.format(item.unitPrice),
                style: const pw.TextStyle(fontSize: 11),
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                _currencyFormat.format(item.total),
                style: const pw.TextStyle(fontSize: 11),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        )),
      ],
    );
  }

  /// Build totals section
  pw.Widget _buildTotals(InvoiceModel invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          child: pw.Column(
            children: [
              _buildTotalRow('Subtotal', invoice.subtotal, isBold: false),
              if (invoice.taxAmount > 0)
                _buildTotalRow('Tax', invoice.taxAmount, isBold: false),
              pw.Divider(color: PdfColors.grey400),
              _buildTotalRow('Total', invoice.total, isBold: true, fontSize: 16),
            ],
          ),
        ),
      ],
    );
  }

  /// Build footer with notes and payment info
  pw.Widget _buildFooter(InvoiceModel invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
          pw.Text(
            'Notes',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            invoice.notes!,
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 20),
        ],
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.grey600,
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods
  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTotalRow(String label, double amount, {bool isBold = false, double fontSize = 12}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            _currencyFormat.format(amount),
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return _dateFormat.format(date);
  }

  PdfColor _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
        return PdfColors.grey600;
      case InvoiceStatus.unpaid:
        return PdfColors.orange;
      case InvoiceStatus.partiallyPaid:
        return PdfColors.amber700;
      case InvoiceStatus.paid:
        return PdfColors.green;
      case InvoiceStatus.void_:
        return PdfColors.red;
      case InvoiceStatus.refunded:
        return PdfColors.purple;
    }
  }
}
