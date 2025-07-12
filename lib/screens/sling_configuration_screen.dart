import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/truck_details_screen.dart';

class SlingConfigurationScreen extends StatefulWidget {
  const SlingConfigurationScreen({super.key});

  @override
  State<SlingConfigurationScreen> createState() =>
      _SlingConfigurationScreenState();
}

class _SlingConfigurationScreenState extends State<SlingConfigurationScreen> {
  final borderRadius = BorderRadius.circular(16);

  final List<Map<String, dynamic>> slingConfigs = [
    {'name': 'Choke', 'icon': Icons.close},
    {'name': 'Straight', 'icon': Icons.arrow_upward},
    {'name': 'Basket', 'icon': Icons.circle},
    {'name': 'Bridle', 'icon': Icons.change_history},
    {'name': 'Double Basket', 'icon': Icons.crop_square},
  ];

  final List<Map<String, dynamic>> slingTypes = [
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Yellow', 'color': Colors.yellow[700]!},
    {'name': 'Chains', 'color': Colors.grey},
    {'name': 'Pig\'s Ears', 'color': Colors.brown},
  ];

  int selectedConfigIndex = 0;
  Set<int> selectedTypeIndices = {};

  final _slingLengthController = TextEditingController(text: '2.5');
  final _slingCapacityController = TextEditingController(text: '2000');

  @override
  void dispose() {
    _slingLengthController.dispose();
    _slingCapacityController.dispose();
    super.dispose();
  }

  Widget selectedSlingImage() {
    final config = slingConfigs[selectedConfigIndex];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(config['icon'], size: 80, color: Colors.black),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children:
              selectedTypeIndices.isEmpty
                  ? [const Text('No sling types selected')]
                  : selectedTypeIndices.map((i) {
                    final type = slingTypes[i];
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: type['color'],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Center(
                        child: Text(
                          type['name'][0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sling Configuration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Lifting Sling Configuration',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(child: selectedSlingImage()),
                        const SizedBox(height: 16),

                        // Sling Configurations (horizontal list)
                        const Text(
                          'Select Configuration',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: slingConfigs.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final sling = slingConfigs[index];
                              final isSelected = index == selectedConfigIndex;

                              return GestureDetector(
                                onTap:
                                    () => setState(
                                      () => selectedConfigIndex = index,
                                    ),
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Theme.of(
                                              context,
                                            ).primaryColor.withOpacity(0.2)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey.shade400,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        sling['icon'],
                                        size: isSelected ? 30 : 24,
                                        color:
                                            isSelected
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey[700],
                                      ),
                                      const SizedBox(height: 4),
                                      Flexible(
                                        child: Text(
                                          sling['name'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color:
                                                isSelected
                                                    ? Theme.of(
                                                      context,
                                                    ).primaryColor
                                                    : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sling Types (grid)
                        const Text(
                          'Select Sling Types',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                ),
                            itemCount: slingTypes.length,
                            itemBuilder: (context, index) {
                              final slingType = slingTypes[index];
                              final isSelected = selectedTypeIndices.contains(
                                index,
                              );

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedTypeIndices.remove(index);
                                    } else {
                                      selectedTypeIndices.add(index);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? slingType['color'].withOpacity(
                                              0.3,
                                            )
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? slingType['color']
                                              : Colors.grey.shade400,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: isSelected ? 30 : 24,
                                        color: slingType['color'],
                                      ),
                                      const SizedBox(height: 4),
                                      Flexible(
                                        child: Text(
                                          slingType['name'],
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color: slingType['color'],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),
                        _buildField('Sling Length (m)', _slingLengthController),
                        _buildField(
                          'Sling Capacity (kg)',
                          _slingCapacityController,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Buttons
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
                          final slingData = {
                            'selectedConfigIndex': selectedConfigIndex,
                            'selectedTypeIndices': selectedTypeIndices.toList(),
                            'slingLength': _slingLengthController.text,
                            'slingCapacity': _slingCapacityController.text,
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TruckDetailsScreen(),
                            ),
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
