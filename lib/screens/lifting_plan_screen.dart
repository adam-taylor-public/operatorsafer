import 'package:flutter/material.dart';


class LiftingPlanScreen extends StatefulWidget {
  const LiftingPlanScreen({super.key});

  @override
  State<LiftingPlanScreen> createState() => _LiftingPlanScreenState();
}

class _LiftingPlanScreenState extends State<LiftingPlanScreen> {
  int nextId = 0;
  final Map<int, _PlacedItem> placedItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifting Plan'),
        backgroundColor: const Color(0xFFF5C400),
      ),
      body: Stack(
        children: [
          // Canvas Area
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                for (final entry in placedItems.entries)
                  Positioned(
                    left: entry.value.position.dx,
                    top: entry.value.position.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          placedItems[entry.key] = entry.value.copyWith(
                            position: entry.value.position + details.delta,
                          );
                        });
                      },
                      child: _buildShape(entry.value),
                    ),
                  ),
              ],
            ),
          ),

          // Selector bar at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              color: Colors.grey.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAddButton("Tree", Colors.green, ShapeType.circle),
                  _buildAddButton("Building", Colors.brown, ShapeType.square),
                  _buildAddButton("Powerline", Colors.black, ShapeType.line),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, Color color, ShapeType type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          placedItems[nextId] = _PlacedItem(
            position: const Offset(100, 100),
            color: color,
            shape: type,
          );
          nextId++;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: type == ShapeType.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
            ),
            child: type == ShapeType.line
                ? const Center(child: Text('—', style: TextStyle(fontSize: 24)))
                : null,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildShape(_PlacedItem item) {
    switch (item.shape) {
      case ShapeType.circle:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
          ),
        );
      case ShapeType.square:
        return Container(
          width: 40,
          height: 40,
          color: item.color,
        );
      case ShapeType.line:
        return Container(
          width: 60,
          height: 4,
          color: item.color,
        );
    }
  }
}

enum ShapeType { circle, square, line }

class _PlacedItem {
  final Offset position;
  final Color color;
  final ShapeType shape;

  _PlacedItem({
    required this.position,
    required this.color,
    required this.shape,
  });

  _PlacedItem copyWith({Offset? position}) {
    return _PlacedItem(
      position: position ?? this.position,
      color: color,
      shape: shape,
    );
  }
}
