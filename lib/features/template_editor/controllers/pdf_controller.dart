import 'dart:ui';

import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../database/dummy_data.dart';

class PDFController extends GetxController {
  late pw.Document pdf;

  // Observable toggle options
  final showHeader = true.obs;
  final showFooter = true.obs;
  final showPricingDetails = true.obs;
  final selectedTemplateIndex = 0.obs;

  // Draggable fields
  final draggableFields = [
    {'label': 'Invoice Number', 'key': 'invoiceNumber'},
    {'label': 'Customer Name', 'key': 'customerName'},
    {'label': 'Date', 'key': 'date'},
    {'label': 'Product Details', 'key': 'productDetails'},
    {'label': 'Total Amount', 'key': 'totalAmount'},
  ];

  // Field positions for draggable items
  final fieldPositions = <Map<String, dynamic>>[].obs;

  // Invoice data and product details
  final invoiceData = {}.obs;
  final productDetails = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    pdf = pw.Document();
    loadInvoiceData();
  }

  /// Fetches and assigns data from the dummy database
  Future<void> loadInvoiceData() async {
    try {
      final data = await DummyDatabase.fetchInvoiceData();
      invoiceData.assignAll(data);
      productDetails.assignAll(data['productDetails'] as List<Map<String, dynamic>>);
      generatePdf();
    } catch (e) {
      print('Error loading invoice data: $e');
    }
  }

  /// Generates the PDF based on the selected template and settings
  void generatePdf() {
    pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return selectedTemplateIndex.value == 0 ? _templateOne() : _templateTwo();
        },
      ),
    );
    update(); // Triggers GetBuilder rebuilds
  }

  /// Template One Layout
  pw.Widget _templateOne() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (showHeader.value)
          pw.Text(
            'Template 1 - ${invoiceData['invoiceNumber'] ?? ''}',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
          ),
        pw.SizedBox(height: 10),
        pw.Text('Customer Name: ${invoiceData['customerName'] ?? ''}'),
        pw.Text('Date: ${invoiceData['date'] ?? ''}'),
        pw.SizedBox(height: 20),
        if (showPricingDetails.value) ...[
          pw.Text('ITEM DETAILS',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
          pw.SizedBox(height: 10),
          _buildTable(),
        ],
        pw.SizedBox(height: 20),
        if (showFooter.value)
          pw.Text(
            'Total Amount: \$${invoiceData['totalAmount']?.toStringAsFixed(2) ?? ''}',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.green),
          ),
        pw.SizedBox(height: 30),
        if (showFooter.value)
          pw.Text('Terms & Conditions: Payment is due within 30 days.'),
      ],
    );
  }

  /// Template Two Layout
  pw.Widget _templateTwo() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (showHeader.value)
          pw.Text(
            'Template 2 - ${invoiceData['invoiceNumber'] ?? ''}',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.green),
          ),
        pw.SizedBox(height: 10),
        pw.Text('Customer Name: ${invoiceData['customerName'] ?? ''}'),
        pw.Text('Date: ${invoiceData['date'] ?? ''}'),
        pw.SizedBox(height: 20),
        if (showPricingDetails.value) ...[
          pw.Text('ITEM DETAILS',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
          pw.SizedBox(height: 10),
          _buildTable(),
        ],
        pw.SizedBox(height: 20),
        if (showFooter.value)
          pw.Text(
            'Total Amount: \$${invoiceData['totalAmount']?.toStringAsFixed(2) ?? ''}',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.red),
          ),
        pw.SizedBox(height: 30),
        if (showFooter.value)
          pw.Text('Footer Notes: Prices are final and inclusive of GST.'),
      ],
    );
  }

  /// Builds a table for product details
  pw.Widget _buildTable() {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildCell('Description', isHeader: true),
            _buildCell('Quantity', isHeader: true),
            _buildCell('Price', isHeader: true),
            _buildCell('GST', isHeader: true),
            _buildCell('Total', isHeader: true),
          ],
        ),
        ...productDetails.map((item) {
          final total = (item['qty'] * item['price']) + item['gst'];
          return pw.TableRow(
            children: [
              _buildCell(item['description']),
              _buildCell('${item['qty']}'),
              _buildCell('\$${item['price']}'),
              _buildCell('\$${item['gst']}'),
              _buildCell('\$${total.toStringAsFixed(2)}'),
            ],
          );
        }).toList(),
      ],
    );
  }

  /// Helper method to build a cell for the table
  pw.Widget _buildCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.blue : PdfColors.black,
        ),
      ),
    );
  }

  /// Updates field position for draggable elements
  void updateFieldPosition(Map<String, String> field, Offset offset) {
    // Check if the field already exists in the list
    final existingIndex = fieldPositions.indexWhere((f) => f['key'] == field['key']);

    if (existingIndex != -1) {
      // Update the position of the existing field
      fieldPositions[existingIndex]['x'] = offset.dx;
      fieldPositions[existingIndex]['y'] = offset.dy;
    } else {
      // Add a new field with its position
      fieldPositions.add({
        'key': field['key']!,
        'x': offset.dx,
        'y': offset.dy,
      });
    }

    generatePdf(); // Regenerate the PDF with updated positions
  }

  /// Toggles header visibility
  void toggleHeader(bool value) {
    showHeader.value = value;
    generatePdf();
  }

  /// Toggles footer visibility
  void toggleFooter(bool value) {
    showFooter.value = value;
    generatePdf();
  }

  /// Toggles pricing details visibility
  void togglePricingDetails(bool value) {
    showPricingDetails.value = value;
    generatePdf();
  }

  /// Switches between templates
  void switchTemplate(int index) {
    selectedTemplateIndex.value = index;
    generatePdf();
  }
}
