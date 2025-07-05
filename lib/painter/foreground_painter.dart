import 'package:flutter/material.dart';

// Class for renderoutput of the shape being edited. (not meant to handle state or mutation)
class ForegroundPainter extends CustomPainter {
  final Rect? editableShape;

  ForegroundPainter({this.editableShape});

  @override
  void paint(Canvas canvas, Size size) {
    if (editableShape != null) {
      canvas.drawRect(
        editableShape!,
        Paint()
          ..color = Colors.blue.withOpacity(0.5)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ForegroundPainter oldDelegate) {
    return oldDelegate.editableShape != editableShape;
  }
}
