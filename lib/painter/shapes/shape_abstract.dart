import 'package:flutter/widgets.dart';

// enum ShapeType {
//   square,
//   rectangle,
//   circle,
//   triangle,
// }

// abstract concrete class for all shapes
abstract class Shape {
  // required fields
  Offset _position;
  Size _size; // object handling width height and radius
  Paint _paint; // Paint object defines coloe, stroke, fill style ect...
  double _rotation; //
  // bool _isEditing = false;

  Shape({
    required Offset position,
    required Size size,
    required Paint paint,
    double rotation = 0.0,
  }) : _position = position,
       _rotation = rotation,
       _paint = paint,
       _size = size;

  // shared logic
  // getters & setters
  Offset get position => _position;
  set position(Offset newPosition) {
    _position = newPosition;
  }

  Size get size => _size;
  set size(Size newSize) {
    _size = newSize;
  }

  Paint get paint => _paint;
  set paint(Paint newPaint) {
    _paint = newPaint;
  }

  double get rotation => _rotation;
  set rotation(double newRotation) {
    _rotation = newRotation;
  }

  // bool get isEditing => _isEditing;
  
  // void setEditing() {
  //   _isEditing != _isEditing;
  // }

  bool contains(Offset point);

  void paintout(Canvas canvas);
}

// class for path based shapes
abstract class PathShape {
  Path path;

  PathShape({
    required this.path,
    required Offset position,
    double rotation = 0.0,
    required Paint paint,
  });
}
