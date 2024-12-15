import 'package:get/get.dart';

import '../features/template_editor/presentation/screens/onvoice_screen.dart';
import '../features/template_editor/presentation/screens/template_editor_screen.dart';
import '../main.dart';

class Routes {
  static const String templateEditorScreen = '/template-editor';
  static const String invoiceScreen = '/invoice-screen';

  static final pages = [

    GetPage(
      name: invoiceScreen,
      page: () =>  InvoiceScreen(),
    ),
  ];
}
