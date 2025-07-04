import 'package:flutter/material.dart';
import 'package:operatorsafe/painter/canvas_painter.dart';
import 'package:operatorsafe/painter/foreground_painter.dart';
import 'package:operatorsafe/painter/shapes/shape_abstract.dart';
import 'package:operatorsafe/painter/shapes/shape_rect.dart';
import 'canvas_gesture_controller.dart';

// manages everything in the canvas
class CanvasManager extends StatefulWidget {
  const CanvasManager({super.key});

  @override
  State<CanvasManager> createState() => _CanvasManagerState();
}

class _CanvasManagerState extends State<CanvasManager> {
  Shape? aShape;
  List<Offset> points = [];
  final List<Shape> shapes = [];
  // not needed
  //CanvasGestureController canvasGestureController = CanvasGestureController();

  Shape? findShapeAt(Offset position) {}

  void checkShapeIntercept(LongPressStartDetails details) {
    print("");
  }

  void setForegroudShape(Shape aShape) {}

  // Managing the list

  // Add shape to list
  void addShapeToCanvas(Shape aShape) {
    setState(() {
      shapes.add(aShape);
    });
  }

  // delete shape from list
  void deleteShapeFromCanvas(Shape aShape) {
    setState(() {
      shapes.removeWhere((shape) => shape == aShape);
    });
  }

  // Update shape in list
  void updateShapeInCanvas(Shape oldShape, Shape newShape) {
    setState(() {
      final index = shapes.indexOf(oldShape);
      if(index != -1) shapes[index] = newShape;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print("tapped"),
      onLongPress: () => print("long press"),
      onLongPressStart: (details) => checkShapeIntercept(details),
      onLongPressMoveUpdate:
          (details) => print("moving updates from long press"),
      onLongPressEnd: (details) => print("end of long press"),
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        // Background layer static state
        painter: CanvasPainter(shapes),
        // foreground layer edit state
        foregroundPainter: ForegroundPainter(aShape),
      ),
    );
  }
}
