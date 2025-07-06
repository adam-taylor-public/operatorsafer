import 'package:flutter/material.dart';

class ShapeResizeButtonWidget extends StatelessWidget {
  final void Function(DragUpdateDetails) onResizeButtonPanUpdate;

  const ShapeResizeButtonWidget({super.key, required this.onResizeButtonPanUpdate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,  // <-- Prevent gesture bubbling here
      onPanUpdate: onResizeButtonPanUpdate,
      child: const Icon(
        Icons.circle_outlined,
        size: 24,
        color: Colors.black,
      ),
    );
  }
}
