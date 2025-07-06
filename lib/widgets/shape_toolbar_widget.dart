import 'package:flutter/material.dart';

enum ShapeType {
  house,
  road,
  shuttle,
  alignCenter,
  cable,
}

class DraggableShape {
  final IconData icon;
  final ShapeType type;

  DraggableShape({required this.icon, required this.type});
}

class ShapeToolBar extends StatelessWidget {
  final void Function(DraggableDetails details, ShapeType shape) onIconDropCallback;
  final void Function(ShapeType shape) onIconTappedCallback;

  const ShapeToolBar({
    super.key,
    required this.onIconDropCallback,
    required this.onIconTappedCallback,
  });

  @override
  Widget build(BuildContext context) {
    final List<DraggableShape> shapes = [
      DraggableShape(icon: Icons.add_home_outlined, type: ShapeType.house),
      DraggableShape(icon: Icons.add_road_outlined, type: ShapeType.road),
      DraggableShape(icon: Icons.airport_shuttle_outlined, type: ShapeType.shuttle),
      DraggableShape(icon: Icons.align_horizontal_center, type: ShapeType.alignCenter),
      DraggableShape(icon: Icons.cable_outlined, type: ShapeType.cable),
      DraggableShape(icon: Icons.add_road, type: ShapeType.road),
      DraggableShape(icon: Icons.add_road, type: ShapeType.road),
    ];

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 250,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: GestureDetector(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: shapes.length,
              separatorBuilder: (_, __) => VerticalDivider(),
              itemBuilder: (context, index) {
                final shape = shapes[index];

                return Draggable<DraggableShape>(
                  data: shape,
                  feedback: Icon(shape.icon, color: Colors.blue, size: 30),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: Icon(shape.icon),
                  ),
                  child: IconButton(
                    icon: Icon(shape.icon),
                    onPressed: () {
                      onIconTappedCallback(shape.type);
                    },
                  ),
                  onDragEnd: (details) {
                    onIconDropCallback(details, shape.type);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
