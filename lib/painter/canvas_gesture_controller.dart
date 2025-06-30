import 'package:flutter/material.dart';

// specific class used to handle specifc guestures for the canvas
class CanvasGestureController extends ChangeNotifier {
  void handlePan(Offset offset) {
    // Do stuff — like update drawing data
    notifyListeners();
  }

  void handleScale(double scale, double rotation) {
    // Update zoom/rotate state
    notifyListeners();
  }

  void handleOnTap()
  {
    print("on tap pressed");
    
  }

  void handleLongPress() {
    // Update with new details
    print("Long press activated");
    notifyListeners();
  }
}
