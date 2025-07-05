import 'dart:ui';
import 'package:operatorsafe/painter/shapes/shape_abstract.dart';

class RectangleShape extends Shape {
  late Rect rect;
  // rect doesnt require position, nor size seoerate.
  @override
  RectangleShape({required super.position, required super.size, required super.paint}) {
    rect = Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
  }

  // if the point is within the rectangluar area
  @override
  bool contains(Offset point) {
    if (rect.contains(point)) {
      return true;
    } else {
      return false;
    }
  }

  // paintout to canvas the rect
  @override
  void paintout(Canvas canvas) {
    canvas.drawRect(rect, paint);
  }
  
}