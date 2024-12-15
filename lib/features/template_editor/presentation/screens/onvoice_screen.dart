import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import '../../controllers/pdf_controller.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pdfController = Get.put(PDFController());
    final GlobalKey dragTargetKey = GlobalKey(); // GlobalKey for DragTarget

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Application'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: pdfController.loadInvoiceData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Row(
            children: [
              // Left Panel
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SELECT TEMPLATE', style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(
                              () => DropdownButton<int>(
                            value: pdfController.selectedTemplateIndex.value,
                            items: const [
                              DropdownMenuItem(value: 0, child: Text('Template 1')),
                              DropdownMenuItem(value: 1, child: Text('Template 2')),
                            ],
                            onChanged: (int? value) {
                              if (value != null) {
                                pdfController.switchTemplate(value);
                              }
                            },
                          ),
                        ),
                        const Text('TOGGLE OPTIONS', style: TextStyle(fontWeight: FontWeight.bold)),
                        Obx(
                              () => SwitchListTile(
                            title: const Text('Show Header'),
                            value: pdfController.showHeader.value,
                            onChanged: pdfController.toggleHeader,
                          ),
                        ),
                        Obx(
                              () => SwitchListTile(
                            title: const Text('Show Footer'),
                            value: pdfController.showFooter.value,
                            onChanged: pdfController.toggleFooter,
                          ),
                        ),
                        Obx(
                              () => SwitchListTile(
                            title: const Text('Show Pricing Details'),
                            value: pdfController.showPricingDetails.value,
                            onChanged: pdfController.togglePricingDetails,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('DRAGGABLE FIELDS', style: TextStyle(fontWeight: FontWeight.bold)),
                        Column(
                          children: pdfController.draggableFields.map((field) {
                            return Draggable<Map<String, String>>(
                              data: field,
                              feedback: Material(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.blue.withOpacity(0.7),
                                  child: Text(
                                    field['label']!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(field['label']!),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Right Panel
              Expanded(
                flex: 3,
                child: DragTarget<Map<String, String>>(
                  key: dragTargetKey, // Assign GlobalKey
                  onAcceptWithDetails: (details) {
                    final RenderBox renderBox =
                    dragTargetKey.currentContext!.findRenderObject() as RenderBox;
                    final Offset localOffset = renderBox.globalToLocal(details.offset); // Convert global offset to local
                    pdfController.updateFieldPosition(details.data, localOffset);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Stack(
                      children: [
                        GetBuilder<PDFController>(
                          builder: (controller) {
                            return PdfPreview(
                              build: (format) async => controller.pdf.save(),
                              allowPrinting: true,
                              allowSharing: true,
                            );
                          },
                        ),
                        ...pdfController.fieldPositions.map((field) {
                          return Positioned(
                            left: field['x'] ?? 0.0,
                            top: field['y'] ?? 0.0,
                            child: Draggable<Map<String, String>>(
                              data: {'key': field['key']},
                              feedback: Material(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.blue.withOpacity(0.7),
                                  child: Text(
                                    field['key']!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.transparent,
                                child: Text(
                                  field['key']!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
