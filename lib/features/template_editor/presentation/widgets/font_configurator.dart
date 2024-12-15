import 'package:flutter/material.dart';

class FontConfigurator extends StatelessWidget {
  final String fontStyle;
  final double fontSize;
  final Color fontColor;
  final ValueChanged<String?> onFontStyleChanged;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<Color> onFontColorChanged;

  const FontConfigurator({
    Key? key,
    required this.fontStyle,
    required this.fontSize,
    required this.fontColor,
    required this.onFontStyleChanged,
    required this.onFontSizeChanged,
    required this.onFontColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          value: fontStyle,
          items: ['Arial', 'Helvetica', 'Times New Roman']
              .map((style) => DropdownMenuItem(value: style, child: Text(style)))
              .toList(),
          onChanged: onFontStyleChanged,
        ),
        Slider(
          value: fontSize,
          min: 8.0,
          max: 48.0,
          onChanged: onFontSizeChanged,
        ),
        Row(
          children: [
            const Text('Font Color:'),
            GestureDetector(
              onTap: () {
                // Implement a color picker dialog if needed
              },
              child: Container(
                width: 24,
                height: 24,
                color: fontColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
