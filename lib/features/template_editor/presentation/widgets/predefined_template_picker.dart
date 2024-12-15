import 'package:flutter/material.dart';

class PredefinedTemplatePicker extends StatelessWidget {
  final String selectedTemplate;
  final List<String> templates;
  final ValueChanged<String?> onTemplateSelected;

  const PredefinedTemplatePicker({
    Key? key,
    required this.selectedTemplate,
    required this.templates,
    required this.onTemplateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select a Template:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...templates.map((template) {
          return ListTile(
            title: Text(template),
            leading: Radio<String>(
              value: template,
              groupValue: selectedTemplate,
              onChanged: onTemplateSelected,
            ),
          );
        }).toList(),
      ],
    );
  }
}
