import 'package:flutter/material.dart';
import 'package:operatorsafe/painter/canvas_painter.dart';
import 'package:operatorsafe/painter/foreground_painter.dart';
import 'package:operatorsafe/painter/shapes/shape_abstract.dart';
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
  CanvasGestureController canvasGestureController = CanvasGestureController();



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => canvasGestureController.handleOnTap() ,
      onLongPress: () => canvasGestureController.handleLongPress(),
      onLongPressStart:
          (details) => print("do something on start with details"),
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
