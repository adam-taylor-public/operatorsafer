import 'package:flutter/material.dart';

// shapeToolbar
class ShapeToolBar extends StatelessWidget {
  const ShapeToolBar({super.key});

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
          ),
          // gesture detector for capturing drag events
          child: GestureDetector(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // will need to be changed to icon button when ready
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_home_outlined),
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
