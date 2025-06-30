import 'package:flutter/material.dart';
import 'package:operatorsafe/painter/canvas_painter.dart';
import 'package:operatorsafe/painter/canvas_manager.dart';

class LiftingPlanBuilderScreen extends StatefulWidget {
  const LiftingPlanBuilderScreen({super.key});

  @override
  State<LiftingPlanBuilderScreen> createState() =>
      _LiftingPlanBuilderScreenState();
}

class _LiftingPlanBuilderScreenState extends State<LiftingPlanBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("lift plan"),
        backgroundColor: Color(0xFFF5C400),
      ),
      body: Container(
        color: Colors.black12,
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Stack(children: [CanvasManager()]),
            SizedBox(
              height: 50,
              child: Center(
                child: SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.8,
                  width: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.transparent, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // will need to be changed to icon button when ready
                        TextButton(onPressed: () {}, child: Text("Building")),
                        TextButton(onPressed: () {}, child: Text("Road")),
                        TextButton(onPressed: () {}, child: Text("Tree")),
                        TextButton(onPressed: () {}, child: Text("Pole")),
                        TextButton(onPressed: () {}, child: Text("Powerlines")),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Row(
            //   children: [
            //     ElevatedButton(onPressed: () => {}, child: Text("Back")),
            //     ElevatedButton(onPressed: () => {}, child: Text("Next")),
            //   ],
            // ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black54),
              child: Text("Account"),
            ),
            ListTile(title: Text('Menu')),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      //   // color: Colors.grey[200], // optional background color
      //   child: Row(
      //     mainAxisSize: MainAxisSize.min, // Wrap content horizontally
      //     mainAxisAlignment:
      //         MainAxisAlignment.end, // Center the buttons as a group
      //     children: [
      //       ElevatedButton(
      //         onPressed: () => print('Previous'),
      //         child: Text('Previous'),
      //       ),
      //       SizedBox(width: 12), // Space between buttons
      //       ElevatedButton(onPressed: () => print('Next'), child: Text('Next')),
      //     ],
      //   ),
      // ),
    );
  }
}
