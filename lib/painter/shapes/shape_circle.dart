
import 'dart:ui';

import 'package:operatorsafe/painter/shapes/shape_abstract.dart';

class ShapeCircle extends Shape {
  double radius;

  ShapeCircle({required this.radius, required super.position, required super.size, required super.paint});

  @override
  void paintout(Canvas canvas) {
    // TODO: implement paintout
    canvas.drawCircle(position, radius, paint);
  }

}