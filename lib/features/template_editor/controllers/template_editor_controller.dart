import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplateEditorController extends GetxController {
  // Toggle Options
  RxBool showHeader = true.obs;
  RxBool showFooter = true.obs;
  RxBool showPricingDetails = true.obs;

  // Dynamic Field Positions
  RxMap<String, Offset> fieldPositions = {
    'Invoice Number': const Offset(50, 50),
    'Customer Name': const Offset(50, 100),
    'Date': const Offset(50, 150),
    'Product Details': const Offset(50, 200),
    'Total Amount': const Offset(50, 250),
  }.obs;

  // Template Data
  RxString companyName = "Company Name".obs;
  RxString companyAddress = "123 Business Street, City, State - 12345".obs;
  RxString contactNumber = "1234567890".obs;
  RxString invoiceNumber = "INV-001".obs;

  // Styling Options
  RxString selectedFont = 'Helvetica'.obs;
  RxDouble fontSize = 14.0.obs;
  Rx<Color> fontColor = Colors.black.obs;

  // Predefined Templates
  RxString selectedTemplate = 'Template 1'.obs;
}
