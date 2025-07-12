import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/lift_plan_screen.dart';

class StabilizerDetailsScreen extends StatefulWidget {
  const StabilizerDetailsScreen({super.key});

  @override
  State<StabilizerDetailsScreen> createState() =>
      _StabilizerDetailsScreenState();
}

class _StabilizerDetailsScreenState extends State<StabilizerDetailsScreen> {
  final List<double> _stabilizerValues = [100, 100, 100, 100];

  static const List<String> stabilizerShortLabels = ['FL', 'FR', 'RL', 'RR'];
  static const List<String> stabilizerLabels = [
    'Front Left',
    'Front Right',
    'Rear Left',
    'Rear Right',
  ];

  Widget _buildHorizontalBar(double value, String shortLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(shortLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
            Container(
              width: value, // scaled 0-100 px
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.horizontal(
                  left: const Radius.circular(8),
                  right: Radius.circular(value >= 100 ? 8 : 0),
                ),
              ),
            ),
            Positioned(
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupedBars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left group: FL and RL stacked vertically
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHorizontalBar(_stabilizerValues[0], stabilizerShortLabels[0]),
            const SizedBox(height: 20),
            _buildHorizontalBar(_stabilizerValues[2], stabilizerShortLabels[2]),
          ],
        ),

        // Truck icon center with fixed smaller size
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Icon(
            Icons.local_shipping,
            size: 48,
            color: Colors.grey.shade700,
          ),
        ),

        // Right group: FR and RR stacked vertically
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHorizontalBar(_stabilizerValues[1], stabilizerShortLabels[1]),
            const SizedBox(height: 20),
            _buildHorizontalBar(_stabilizerValues[3], stabilizerShortLabels[3]),
          ],
        ),
      ],
    );
  }

  Widget _buildSlider(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stabilizerLabels[index],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _stabilizerValues[index],
            min: 0,
            max: 100,
            divisions: 100,
            label: '${_stabilizerValues[index].toInt()}%',
            onChanged: (val) {
              setState(() {
                _stabilizerValues[index] = val;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stabilizer Details')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Adjust Stabilizer Legs',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildGroupedBars(),
                          const SizedBox(height: 24),
                          // Sliders inside card to avoid extra scrolling
                          ...List.generate(4, _buildSlider),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Buttons outside card
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LiftPlanScreen(),
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
      ),
    );
  }
}
