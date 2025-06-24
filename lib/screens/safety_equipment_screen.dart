import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/lifting_tools_screen.dart';

class SafetyEquipmentScreen extends StatefulWidget {
  const SafetyEquipmentScreen({super.key});

  @override
  State<SafetyEquipmentScreen> createState() => _SafetyEquipmentScreenState();
}

class _SafetyEquipmentScreenState extends State<SafetyEquipmentScreen> {
  final List<Map<String, dynamic>> ppeItems = [
    {'label': 'Hard Hat', 'icon': Icons.construction},
    {'label': 'Gloves', 'icon': Icons.handshake},
    {'label': 'Earplugs', 'icon': Icons.hearing},
    {'label': 'Boots', 'icon': Icons.hiking},
    {'label': 'Glasses', 'icon': Icons.visibility},
    {'label': 'Hi‑Viz', 'icon': Icons.shield},
    {'label': 'Long Sleeves', 'icon': Icons.checkroom},
    {'label': 'Pants', 'icon': Icons.checkroom},
    {'label': 'Working Lights', 'icon': Icons.lightbulb},
  ];

  final Set<String> selectedItems = {
    'Hard Hat',
    'Gloves',
    'Hi‑Viz',
    'Long Sleeves',
    'Pants',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPE'),
        backgroundColor: const Color(0xFFF5C400),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: ppeItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  final item = ppeItems[index];
                  final label = item['label'] as String;
                  final icon = item['icon'] as IconData;
                  final isSelected = selectedItems.contains(label);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) selectedItems.remove(label);
                        else selectedItems.add(label);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.yellow.shade400
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.orange : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: isSelected ? Colors.black : Colors.grey.shade800),
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LiftingToolsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5C400),
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
