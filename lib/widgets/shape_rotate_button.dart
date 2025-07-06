import 'package:flutter/material.dart';

class ShapeRotateButtonWidget extends StatelessWidget {
  final void Function(DragUpdateDetails) onRotateButtonPanUpdate;

  const ShapeRotateButtonWidget({
    super.key,
    required this.onRotateButtonPanUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,  // <-- Prevent gesture bubbling here
      onPanUpdate: onRotateButtonPanUpdate,
      child: const Icon(
        Icons.rotate_right_outlined,
        size: 24,
        color: Colors.black,
      ),
    );
  }
}
