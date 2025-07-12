import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/lifting_conditions_screen.dart';
import 'package:operatorsafe/screens/weather_api_screen.dart';
import 'package:operatorsafe/screens/weather_condition_screen.dart';

class LocationDetailsScreen extends StatefulWidget {
  const LocationDetailsScreen({super.key});

  @override
  State<LocationDetailsScreen> createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  final _numberController = TextEditingController(text: '45');
  final _streetController = TextEditingController(text: 'Queen Street');
  final _suburbController = TextEditingController(text: 'Auckland Central');
  final _cityController = TextEditingController(text: 'Auckland');
  final _countryController = TextEditingController(text: 'New Zealand');

  @override
  void dispose() {
    _streetController.dispose();
    _numberController.dispose();
    _suburbController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Scaffold(
      appBar: AppBar(
        // title: const Text('Lift Logic logo here'),
        // No backgroundColor added as requested
      ),
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
                    padding: const EdgeInsets.all(
                      16,
                    ), // consistent padding around whole card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Location title centered inside card, no background color
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Location',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Map placeholder with same side padding (wrap in ClipRRect for radius)
                        ClipRRect(
                          borderRadius: borderRadius,
                          child: Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text(
                                'Map Placeholder',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Fields
                        _buildField('Number', _numberController),
                        _buildField('Street', _streetController),
                        _buildField('Suburb', _suburbController),
                        _buildField('City', _cityController),
                        _buildField('Country', _countryController),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
                          final updated = {
                            'number': _numberController.text,
                            'street': _streetController.text,
                            'suburb': _suburbController.text,
                            'city': _cityController.text,
                            'country': _countryController.text,
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WeatherScreen(),
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
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
