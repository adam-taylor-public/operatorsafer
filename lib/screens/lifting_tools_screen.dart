import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/lifting_plan_builder_screen.dart';
import 'package:operatorsafe/screens/lifting_plan_screen.dart';
import 'package:operatorsafe/screens/stabilizers_screen.dart';

class LiftingToolsScreen extends StatefulWidget {
  const LiftingToolsScreen({super.key});

  @override
  State<LiftingToolsScreen> createState() => _LiftingToolsScreenState();
}

class _LiftingToolsScreenState extends State<LiftingToolsScreen> {
  final List<String> selectedTools = [];

  void _addTool(String toolName) {
    setState(() {
      if (selectedTools.contains(toolName)) {
        selectedTools.remove(toolName);
      } else {
        selectedTools.insert(0, toolName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifting Tools'),
        backgroundColor: const Color(0xFFF5C400),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top selected items list
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selected Tools',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    selectedTools.map((tool) => _buildToolCard(tool)).toList(),
              ),
            ),

            const Spacer(), // Push bottom tool selectors to bottom
            // Slings / Chains
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Slings / Chains',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(8, (index) {
                  final tool = 'Sling ${index + 1}';
                  return GestureDetector(
                    onTap: () => _addTool(tool),
                    child: _buildToolCard(tool),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Other Equipment
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Other Lifting Equipment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(8, (index) {
                  final tool = 'Tool ${index + 1}';
                  return GestureDetector(
                    onTap: () => _addTool(tool),
                    child: _buildToolCard(tool),
                  );
                }),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StabilizersScreen(),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(String title) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
