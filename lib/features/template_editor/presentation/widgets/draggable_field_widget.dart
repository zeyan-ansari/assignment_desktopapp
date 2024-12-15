import 'package:flutter/material.dart';

class DraggableFieldWidget extends StatelessWidget {
  final String fieldName;
  final Offset position;
  final Function(Offset) onPositionChanged;

  const DraggableFieldWidget({
    Key? key,
    required this.fieldName,
    required this.position,
    required this.onPositionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: Material(
          color: Colors.transparent,
          child: Text(
            fieldName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) => onPositionChanged(details.offset),
        child: Text(
          fieldName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
