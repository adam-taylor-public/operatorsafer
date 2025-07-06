import 'package:flutter/material.dart';

class ShapeDeleteBinWidget extends StatelessWidget {
  final void Function() onHover;
  final void Function() onLeave;
  final void Function(DragTargetDetails details) onDrop;

  const ShapeDeleteBinWidget({
    super.key,
    required this.onHover,
    required this.onLeave,
    required this.onDrop,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 80,
        height: 60,
        child: DragTarget<Object>(
          onWillAcceptWithDetails: (data) {
            onHover();
            return true;
          },
          onLeave: (data) => onLeave(),
          onAcceptWithDetails: onDrop,
          builder: (context, candidateData, rejectedData) {
            final isHovered = candidateData.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isHovered ? Colors.red[300] : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.delete_outline,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
