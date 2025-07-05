import 'package:flutter/material.dart';
import 'package:operatorsafe/painter/canvas_painter.dart';
import 'package:operatorsafe/painter/foreground_painter.dart';
import 'package:operatorsafe/painter/shapes/shape_abstract.dart';
import 'package:operatorsafe/painter/shapes/shape_rect.dart';
import 'package:operatorsafe/widgets/shape_toolbar_widget.dart';
import 'canvas_gesture_controller.dart';

// manages everything in the canvas
class CanvasManager extends StatefulWidget {
  const CanvasManager({super.key});

  @override
  State<CanvasManager> createState() => _CanvasManagerState();
}

class _CanvasManagerState extends State<CanvasManager> {
  late Rect currentForegoundShape;
  bool isForegroundSet = false;
  List<Offset> points = [];
  final List<Shape> shapes = [];
  // not needed
  //CanvasGestureController canvasGestureController = CanvasGestureController();

  Shape? findShapeAt(Offset position) {}


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
      if (index != -1) shapes[index] = newShape;
    });
  }

  // handlers

  // #region ShapeToolbarhandler

  // response to pressing the icon button
  void handleAddingShapeToCanvas(Offset position) {
    // flutter can handle batch set states
    setState(() {
      // logic should check if foreground is currently set

      // if something is currently in foreground demote to background

      // else promote the shape to foreground

      isForegroundSet = true;
      currentForegoundShape = Rect.fromLTWH(
        position.dx - 50,
        position.dy - 50,
        100,
        100,
      );
    });
  }

  // promote a shape to foreground render for editing
  void promoteToForeground() {}

  // demote a shape to background render
  void demoteToBackground() {}

  void handleTap() {
    print('tapped');
    if(isForegroundSet) {
      
    } else {

    }
  }

  void handleLongPress() {
    print('long press');
  }

  void handleLongPressStart(LongPressStartDetails details) {
    print('long press start');
  }

  void handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    print('long press move update');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => handleTap(), // will bring to foreground edit state
          onLongPress: () => handleLongPress(), // will bring up a delete menu
          onLongPressStart: (details) => handleLongPressStart(details),
          onLongPressMoveUpdate:
              (details) => handleLongPressMoveUpdate(details),
          onLongPressEnd: (details) => print("end of long press"),
          child: CustomPaint(
            size: Size(double.infinity, double.infinity),
            // Background layer static state
            painter: CanvasPainter(shapes),
            // foreground layer edit state
            foregroundPainter:
                (isForegroundSet)
                    ? ForegroundPainter(editableShape: currentForegoundShape)
                    : null,
          ),
        ),
        ShapeToolBar(onButtonPressedCallback: handleAddingShapeToCanvas),
      ],
    );
  }
}
