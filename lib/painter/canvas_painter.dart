import 'package:flutter/material.dart';

class CanvasPainter extends CustomPainter {
  final List<Rect> shapes;

  CanvasPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Draw background rectangle
    canvas.drawRect(
      Rect.fromLTWH(20, 20, size.width - 40, size.height - 40),
      paint,
    );

    // Draw background circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      30,
      paint..color = Colors.red,
    );

    // Draw all user-added shapes
    paint.color = const Color.fromARGB(255, 170, 170, 170);
    for (var rect in shapes) {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    // Only repaint if the shape list has changed
    return oldDelegate.shapes != shapes;
  }
}
