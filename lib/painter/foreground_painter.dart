import 'package:flutter/material.dart';
import 'package:operatorsafe/painter/shapes/shape_abstract.dart';

// Class for renderoutput of the shape being edited. (not meant to handle state or mutation)
class ForegroundPainter extends CustomPainter {
  final Shape? editableShape;

  ForegroundPainter(this.editableShape);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    // paintout the shape to canvas
    if (editableShape != null) {
      editableShape!.paintout(canvas);
    }
  }
  
  // update and repaint when the editableShape changes.
  @override
  bool shouldRepaint(covariant ForegroundPainter oldDelegate) {
    return oldDelegate.editableShape != editableShape;
  }
}