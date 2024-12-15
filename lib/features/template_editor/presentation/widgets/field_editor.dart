import 'package:flutter/material.dart';

class FieldEditor extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  final ValueChanged<String> onFieldValueChanged;

  const FieldEditor({
    Key? key,
    required this.fieldName,
    required this.fieldValue,
    required this.onFieldValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          initialValue: fieldValue,
          onChanged: onFieldValueChanged,
        ),
      ],
    );
  }
}
