import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:operatorsafe/painter/canvas_painter.dart';
import 'package:operatorsafe/painter/foreground_painter.dart';
import 'package:operatorsafe/painter/shapes/shape_abstract.dart';
import 'package:operatorsafe/widgets/shape_delete_bin_widget.dart';
import 'package:operatorsafe/widgets/shape_resize_button.dart';
import 'package:operatorsafe/widgets/shape_rotate_button.dart';
// import 'package:operatorsafe/painter/shapes/shape_rect.dart';
import 'package:operatorsafe/widgets/shape_toolbar_widget.dart';
// import 'canvas_gesture_controller.dart';

// manages everything in the canvas
class CanvasManager extends StatefulWidget {
  const CanvasManager({super.key});

  @override
  State<CanvasManager> createState() => _CanvasManagerState();
}

class _CanvasManagerState extends State<CanvasManager> {
  late Rect currentForegroundShape;
  bool isForegroundSet = false;
  List<Offset> points = [];
  final List<Rect> rect = [];
  double _rotation = 0.0;
  // final List<Shape> shapes = [];
  // not needed
  //CanvasGestureController canvasGestureController = CanvasGestureController();

  Shape? findShapeAt(Offset position) {}

  void setForegroudShape(Shape aShape) {}

  // Managing the list

  // // Add shape to list
  // void addShapeToCanvas(Shape aShape) {
  //   setState(() {
  //     shapes.add(aShape);
  //   });
  // }

  // // delete shape from list
  // void deleteShapeFromCanvas(Shape aShape) {
  //   setState(() {
  //     shapes.removeWhere((shape) => shape == aShape);
  //   });
  // }

  // // Update shape in list
  // void updateShapeInCanvas(Shape oldShape, Shape newShape) {
  //   setState(() {
  //     final index = shapes.indexOf(oldShape);
  //     if (index != -1) shapes[index] = newShape;
  //   });
  // }

  // handlers

  // #region ShapeToolbarhandler

  // handle icon dragged and dropped in position
  void handleOnIconDrop(DraggableDetails details, ShapeType shape) {
    if (isForegroundSet) {
      demoteToBackground();
    }
    setState(() {
      // print('handleIconDrop');
      currentForegroundShape = Rect.fromLTWH(
        details.offset.dx - 50,
        details.offset.dy - 50,
        100,
        100,
      );
      isForegroundSet = true;
    });
  }

  // handle icon button pressed
  void handleOnIconTapped(ShapeType shape) {
    print('handleIconTapped');
  }

  // promote a shape to foreground render for editing
  void promoteToForeground() {}

  // demote a shape to background render
  void demoteToBackground() {
    setState(() {
      rect.add(currentForegroundShape);
      isForegroundSet = !isForegroundSet;
    });
  }

  void onCanvasTapDown(TapDownDetails details) {
    final Offset tapPosition = details.localPosition;

    if (isForegroundSet && currentForegroundShape.contains(tapPosition)) {
      // ✅ Case 1: Tapped on the foreground shape — do nothing
      return;
    }

    if (isForegroundSet) {
      // ✅ Case 2: Tapped elsewhere while foreground is active — demote it
      demoteToBackground();

      // 🔁 Then check if we tapped a background shape to promote
      for (int i = rect.length - 1; i >= 0; i--) {
        if (rect[i].contains(tapPosition)) {
          setState(() {
            currentForegroundShape = rect[i];
            rect.removeAt(i);
            isForegroundSet = true;
          });
          return;
        }
      }
    } else {
      // ✅ Case 3: No foreground shape was active — just check background
      for (int i = rect.length - 1; i >= 0; i--) {
        if (rect[i].contains(tapPosition)) {
          setState(() {
            currentForegroundShape = rect[i];
            rect.removeAt(i);
            isForegroundSet = true;
          });
          print('Promoted background shape to foreground');
          return;
        }
      }

      print('Tapped on empty canvas');
    }
  }

  void onCanvasLongPress() {
    print('long press');
  }

  void onCanvasLongPressStart(LongPressStartDetails details) {
    print('long press start');
  }

  void onCanvasLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    print('long press move update');
  }

  // allows shapes to be dragged around
  void onCanvasPanUpdate(DragUpdateDetails details) {
    if (isForegroundSet) {
      setState(() {
        currentForegroundShape = currentForegroundShape.shift(details.delta);
      });
    }
  }

  // corrects button position on drag event and updates state of selected item
  void handleOnResizeButtonPanUpdate(DragUpdateDetails details) {
    setState(() {
      // Calculate new width and height based on drag delta
      final newWidth = (currentForegroundShape.width + details.delta.dx).clamp(
        20.0,
        double.infinity,
      );
      final newHeight = (currentForegroundShape.height + details.delta.dy)
          .clamp(20.0, double.infinity);

      // Update currentForegroundShape with new size, keeping top-left position fixed
      currentForegroundShape = Rect.fromLTWH(
        currentForegroundShape.left,
        currentForegroundShape.top,
        newWidth,
        newHeight,
      );
    });
  }

  void handleOnRotateButtonPanUpdate(DragUpdateDetails details) {
    setState(() {
      final Offset center = currentForegroundShape.center;
      final Offset currentHandlePos = details.localPosition;
      final Offset previousHandlePos = currentHandlePos - details.delta;

      // Vector from center to handle
      final Offset prevVector = previousHandlePos - center;
      final Offset currVector = currentHandlePos - center;

      // Angle between vectors
      final double prevAngle = prevVector.direction;
      final double currAngle = currVector.direction;
      final double angleDelta = currAngle - prevAngle;

      // Update rotation (in radians)
      _rotation += angleDelta;

      print(currentForegroundShape.left);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTapDown:
              (details) => onCanvasTapDown(
                details,
              ), // will bring to foreground edit state
          onPanUpdate: (details) => onCanvasPanUpdate(details),
          onLongPress: () => onCanvasLongPress(), // will bring up a delete menu
          onLongPressStart: (details) => onCanvasLongPressStart(details),
          onLongPressMoveUpdate:
              (details) => onCanvasLongPressMoveUpdate(details),
          // onLongPressEnd: (details) => print("end of long press"),
          child: CustomPaint(
            size: Size(double.infinity, double.infinity),
            // Background layer static state
            painter: CanvasPainter(rect),
            // foreground layer edit state
            foregroundPainter:
                (isForegroundSet)
                    ? ForegroundPainter(
                      editableShape: currentForegroundShape,
                      rotationAngle: _rotation,
                    )
                    : null,
          ),
        ),
        ShapeToolBar(
          onIconDropCallback: handleOnIconDrop,
          onIconTappedCallback: handleOnIconTapped,
        ),
        // add buttons for managing edits
        if (isForegroundSet)
          Positioned(
            left: currentForegroundShape.right - 10,
            top: currentForegroundShape.bottom - 10,
            child: ShapeResizeButtonWidget(
              onResizeButtonPanUpdate: handleOnResizeButtonPanUpdate,
            ),
          ),
        if (isForegroundSet)
          Positioned(
            left: currentForegroundShape.left - 10,
            top: currentForegroundShape.top - 10,
            child: ShapeRotateButtonWidget(
              onRotateButtonPanUpdate: handleOnRotateButtonPanUpdate,
            ),
          ),
        // add a deletebox
        if (isForegroundSet)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ShapeDeleteBinWidget(
                onHover: () {},
                onLeave: () {},
                onDrop: (DragTargetDetails details) => {},
              ),
            ),
          ),
      ],
    );
  }
}
