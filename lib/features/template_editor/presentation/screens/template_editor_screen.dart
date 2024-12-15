import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/template_editor_controller.dart';
import '../widgets/draggable_field_widget.dart';
import '../widgets/toggle_option_widget.dart';
import '../widgets/font_configurator.dart';
import '../widgets/predefined_template_picker.dart';

class TemplateEditorScreen extends StatelessWidget {
  TemplateEditorScreen({Key? key}) : super(key: key);

  final TemplateEditorController controller = Get.put(TemplateEditorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic PDF Template Editor'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Left Panel: Editor Options
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Template Options', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // Predefined Template Picker
                    Obx(() => PredefinedTemplatePicker(
                      selectedTemplate: controller.selectedTemplate.value,
                      templates: ['Template 1', 'Template 2'],
                      onTemplateSelected: (template) {
                        if (template != null) {
                          controller.selectedTemplate.value = template;
                        }
                      },
                    )),
                    const SizedBox(height: 20),

                    // Toggle Options
                    Obx(() => ToggleOptionWidget(
                      title: 'Show Header',
                      value: controller.showHeader.value,
                      onChanged: (value) {
                        controller.showHeader.value = value!;
                      },
                    )),
                    Obx(() => ToggleOptionWidget(
                      title: 'Show Footer',
                      value: controller.showFooter.value,
                      onChanged: (value) {
                        controller.showFooter.value = value!;
                      },
                    )),
                    Obx(() => ToggleOptionWidget(
                      title: 'Show Pricing Details',
                      value: controller.showPricingDetails.value,
                      onChanged: (value) {
                        controller.showPricingDetails.value = value!;
                      },
                    )),
                    const SizedBox(height: 20),

                    // Font Configurator
                    Obx(() => FontConfigurator(
                      fontStyle: controller.selectedFont.value,
                      fontSize: controller.fontSize.value,
                      fontColor: controller.fontColor.value,
                      onFontStyleChanged: (style) {
                        if (style != null) {
                          controller.selectedFont.value = style;
                        }
                      },
                      onFontSizeChanged: (size) {
                        controller.fontSize.value = size;
                      },
                      onFontColorChanged: (color) {
                        controller.fontColor.value = color;
                      },
                    )),
                  ],
                ),
              ),
            ),
          ),

          // Right Panel: Real-Time Preview
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Obx(() => Stack(
                  children: controller.fieldPositions.entries.map(
                        (entry) {
                      return DraggableFieldWidget(
                        fieldName: entry.key,
                        position: entry.value,
                        onPositionChanged: (newPosition) {
                          controller.fieldPositions[entry.key] = newPosition;
                        },
                      );
                    },
                  ).toList(),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
