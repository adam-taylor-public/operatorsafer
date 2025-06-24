import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/lifting_tools_screen.dart';
import 'package:operatorsafe/screens/safety_equipment_screen.dart';

class LiftingConditionsScreen extends StatelessWidget {
  const LiftingConditionsScreen({super.key});

  Widget buildInputRow(String label, String defaultValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: defaultValue),
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lifting Conditions'),
        backgroundColor: Color(0xFFF5C400),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildInputRow('Weather', 'Rainy.'),
            buildInputRow('Wind', 'low'),
            buildInputRow('Tempreture', '+4c'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SafetyEquipmentScreen(),
                      ),
                    );
                  },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
