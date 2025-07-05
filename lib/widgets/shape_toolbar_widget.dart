import 'package:flutter/material.dart';

// shapeToolbar
class ShapeToolBar extends StatelessWidget {
  final void Function(Offset details) onButtonPressedCallback;

  const ShapeToolBar({super.key, required this.onButtonPressedCallback});
  // late Offset _iconStartPosition;

  // // setter and getters
  // set iconStartPosition(Offset position) => _iconStartPosition;
  // Offset get startPosition => _iconStartPosition;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        // width: MediaQuery.of(context).size.width * 0.8,
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
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          // gesture detector for capturing drag events
          child: GestureDetector(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // will need to be changed to icon button when ready
                Draggable<IconData>(
                  data: Icons.add_home_outlined, // pass what’s needed
                  feedback: Icon(
                    Icons.add_home_outlined,
                    // size: 36,
                    color: Colors.blue,
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: Icon(Icons.add_home_outlined),
                  ),
                  child: IconButton(
                    onPressed: () {
                      onButtonPressedCallback(Offset(100.0, 100.0));
                    },
                    icon: Icon(Icons.add_home_outlined),
                  ),
                  onDragEnd: (details) {
                    onButtonPressedCallback(details.offset);
                  },
                ),

                VerticalDivider(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_road_outlined),
                ),
                VerticalDivider(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.airport_shuttle_outlined),
                ),
                VerticalDivider(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.align_horizontal_center),
                ),
                VerticalDivider(),
                IconButton(onPressed: () {}, icon: Icon(Icons.cable_outlined)),
                VerticalDivider(),
                IconButton(onPressed: () {}, icon: Icon(Icons.add_road)),
                VerticalDivider(),
                IconButton(onPressed: () {}, icon: Icon(Icons.add_road)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
