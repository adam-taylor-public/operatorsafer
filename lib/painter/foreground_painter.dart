import 'package:flutter/material.dart';
import 'package:operatorsafe/painter/shapes/shape_abstract.dart';

class ForegroundPainter extends CustomPainter {
  final Shape? editableShape;
  Shape? previousShapeDetails;

  ForegroundPainter(this.editableShape){
    previousShapeDetails = editableShape;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}