import 'package:flutter/material.dart';
import 'package:operatorsafe/painter/shapes/shape_abstract.dart';

// implementation of the abstract class custom painter
class CanvasPainter extends CustomPainter {
  final List<Shape> shapes;

  CanvasPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    

    for (Shape aShape in shapes) {
      aShape.paintout(canvas);
    }

    // Start drawing here!

    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    // Draw a rectangle
    canvas.drawRect(
      Rect.fromLTWH(20, 20, size.width - 40, size.height - 40),
      paint,
    );

    // Draw a circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      30,
      paint..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
