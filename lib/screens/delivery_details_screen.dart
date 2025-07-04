import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/lifting_conditions_screen.dart';
import 'package:operatorsafe/screens/stabilizers_screen.dart';
// import 'package:operatorsafe/screens/lifting_tools_screen.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  const DeliveryDetailsScreen({super.key});

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
        title: Text('Delivery Details'),
        backgroundColor: Color(0xFFF5C400),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildInputRow('Time', '08:30 AM'),
            buildInputRow('Date', '24 June 2025'),
            buildInputRow('Location', '123 Lift Lane, Craneville'),
            buildInputRow('Order #', 'ORD-45678'),
            buildInputRow('Customer', 'SafeLift Construction Ltd.'),
            buildInputRow('Notes', 'Ensure site supervisor is present.'),
            buildInputRow('Contact', 'John Taylor'),
            buildInputRow('Contact No.', '+44 7911 123456'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiftingConditionsScreen(),
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
