import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/truck_details_screen.dart';

class LiftConfigurationScreen extends StatefulWidget {
  const LiftConfigurationScreen({super.key});

  @override
  State<LiftConfigurationScreen> createState() =>
      _LiftConfigurationScreenState();
}

class _LiftConfigurationScreenState extends State<LiftConfigurationScreen> {
  final borderRadius = BorderRadius.circular(16);

  // ─────────────────────────────────────────────────────────────
  // SECTION: Sling Config & Type Data
  // ─────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> slingConfigs = [
    {'name': 'Choke', 'icon': Icons.close},
    {'name': 'Straight', 'icon': Icons.arrow_upward},
    {'name': 'Basket', 'icon': Icons.circle},
    {'name': 'Bridle', 'icon': Icons.change_history},
    {'name': 'Double Basket', 'icon': Icons.crop_square},
  ];

  final List<Map<String, dynamic>> slingTypes = [
    {'name': 'Green', 'color': Colors.green, 'capacity': 2000},
    {'name': 'Yellow', 'color': Colors.yellow[700]!, 'capacity': 1800},
    {'name': 'Chains', 'color': Colors.grey, 'capacity': 5000},
    {'name': 'Pig\'s Ears', 'color': Colors.brown, 'capacity': 1500},
  ];

  // ─────────────────────────────────────────────────────────────
  // SECTION: State Variables
  // ─────────────────────────────────────────────────────────────
  List<Map<String, int>> configuredLifts = [];

  // ─────────────────────────────────────────────────────────────
  // SECTION: Helper Methods
  // ─────────────────────────────────────────────────────────────
  void addNewLift() {
    setState(() {
      configuredLifts.insert(0, {'configIndex': 0, 'slingIndex': 0});
    });
  }

  void updateLift(int index, {int? configIndex, int? slingIndex}) {
    setState(() {
      if (configIndex != null)
        configuredLifts[index]['configIndex'] = configIndex;
      if (slingIndex != null) configuredLifts[index]['slingIndex'] = slingIndex;
    });
  }

  void deleteLift(int index) {
    setState(() {
      configuredLifts.removeAt(index);
    });
  }

  String getLiftDetails(int configIndex, int slingIndex) {
    final sling = slingTypes[slingIndex];
    final config = slingConfigs[configIndex];
    return 'Using the ${sling['name']} sling, configured as ${config['name']}, rated to lift ${sling['capacity']} kg.';
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Card Builders
  // ─────────────────────────────────────────────────────────────
  Widget buildAddCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: addNewLift,
        child: SizedBox(
          height: 100,
          child: Center(
            child: Icon(
              Icons.add,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLiftCard(int idx) {
    final lift = configuredLifts[idx];
    final cIdx = lift['configIndex']!;
    final sIdx = lift['slingIndex']!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row with icon, type circle, and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      slingConfigs[cIdx]['icon'],
                      size: 36,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      slingConfigs[cIdx]['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: slingTypes[sIdx]['color'],
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        slingTypes[sIdx]['name'][0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete this lift config',
                      onPressed: () => deleteLift(idx),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              value: cIdx,
              decoration: const InputDecoration(
                labelText: 'Lifting Method',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: List.generate(
                slingConfigs.length,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(slingConfigs[i]['name']),
                ),
              ),
              onChanged: (val) {
                if (val != null) updateLift(idx, configIndex: val);
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              value: sIdx,
              decoration: const InputDecoration(
                labelText: 'Sling Type',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: List.generate(
                slingTypes.length,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 16,
                        color: slingTypes[i]['color'],
                      ),
                      const SizedBox(width: 8),
                      Text(slingTypes[i]['name']),
                    ],
                  ),
                ),
              ),
              onChanged: (val) {
                if (val != null) updateLift(idx, slingIndex: val);
              },
            ),

            const SizedBox(height: 12),

            Text(
              getLiftDetails(cIdx, sIdx),
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Build Method + Bottom Button Row
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lift Configurations')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildAddCard(),
                      for (int i = 0; i < configuredLifts.length; i++)
                        buildLiftCard(i),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Next pressed')),
                        );
                      },
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
