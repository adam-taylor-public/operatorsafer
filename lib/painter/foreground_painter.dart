import 'package:flutter/material.dart';

// Class for renderoutput of the shape being edited. (not meant to handle state or mutation)
class ForegroundPainter extends CustomPainter {
  // final just means its a record?S
  final Rect? editableShape;
  final double rotationAngle;

  ForegroundPainter({this.editableShape, required this.rotationAngle}) {}

  @override
  void paint(Canvas canvas, Size size) {
    // saves the canvas state
    canvas.save();

    // rotation pivot point
    canvas.translate(editableShape!.center.dx, editableShape!.center.dy);

    // rotation of canvas
    canvas.rotate(rotationAngle*10);

    canvas.translate(-editableShape!.center.dx, -editableShape!.center.dy);

    if (editableShape != null) {
      canvas.drawRect(
        editableShape!,
        Paint()
          ..color = Colors.blue.withOpacity(0.5)
          ..style = PaintingStyle.fill,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ForegroundPainter oldDelegate) {
    return oldDelegate.editableShape != editableShape ||
        oldDelegate.rotationAngle != rotationAngle;
  }
}
