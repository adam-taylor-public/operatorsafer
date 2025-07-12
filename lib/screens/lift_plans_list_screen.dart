import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/delivery_api_screen.dart';
// Make sure LiftPlan and LiftPlanRepository are defined somewhere accessible

class LiftPlansListScreen extends StatelessWidget {
  const LiftPlansListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final List<plans>;

    return Scaffold(
      appBar: AppBar(title: const Text('Lift Plans')),
      body:
          plans.isEmpty
              ? const Center(child: Text('No lift plans created yet.'))
              : ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  final isComplete =
                      plan.street != null && plan.streetNumber != null;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        '${plan.streetNumber ?? ""} ${plan.street ?? ""}'
                            .trim(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isComplete ? Colors.black : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        '${plan.city ?? ""}, ${plan.country ?? ""}' +
                            (isComplete ? '' : ' (Pending)'),
                        style: TextStyle(
                          fontStyle:
                              isComplete ? FontStyle.normal : FontStyle.italic,
                          color: isComplete ? Colors.black54 : Colors.grey,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: isComplete ? () => _createPdf(plan) : null,
                        child: const Text('Create PDF'),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DeliveryAddressScreen()),
          );
        },
      ),
    );
  }
}
