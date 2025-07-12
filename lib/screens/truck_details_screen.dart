import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/stabilizer_details_screen.dart';

class TruckDetailsScreen extends StatefulWidget {
  const TruckDetailsScreen({super.key});

  @override
  State<TruckDetailsScreen> createState() => _TruckDetailsScreenState();
}

class _TruckDetailsScreenState extends State<TruckDetailsScreen> {
  final _plateController = TextEditingController();

  // Sample crane types, models, and variants
  final List<String> craneTypes = ['Hiab', 'Palfinger', 'Fassi'];

  final Map<String, List<String>> craneModels = {
    'Hiab': ['144', '166', '220'],
    'Palfinger': ['PK34002', 'PK20000', 'PK15500'],
    'Fassi': ['F50', 'F65', 'F90'],
  };

  final Map<String, List<String>> craneVariants = {
    // Variants keyed by model
    '144': ['Hipro-5', 'Hipro-6'],
    '166': ['Pro-7', 'Pro-8'],
    '220': ['Max-10', 'Max-12'],
    'PK34002': ['XL', 'Standard'],
    'PK20000': ['Heavy Duty', 'Lightweight'],
    'PK15500': ['Compact', 'Extended'],
    'F50': ['Variant A', 'Variant B'],
    'F65': ['Variant C', 'Variant D'],
    'F90': ['Variant E', 'Variant F'],
  };

  String? selectedCraneType;
  String? selectedCraneModel;
  String? selectedCraneVariant;

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Widget _buildCraneChartPreview() {
    // Placeholder box for crane lifting chart image
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: Text(
          selectedCraneVariant == null
              ? (selectedCraneModel == null
                  ? (selectedCraneType == null
                      ? 'Crane Lifting Chart Preview'
                      : 'Chart: $selectedCraneType')
                  : 'Chart: $selectedCraneType $selectedCraneModel')
              : 'Chart: $selectedCraneType $selectedCraneModel $selectedCraneVariant',
          style: const TextStyle(color: Colors.grey, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isDense: true,
            isExpanded: true,
            items:
                items
                    .map(
                      (e) => DropdownMenuItem<T>(
                        value: e,
                        child: Text(e.toString()),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cast lists explicitly
    final List<String> availableModels =
        selectedCraneType != null
            ? (craneModels[selectedCraneType!] ?? []).cast<String>()
            : <String>[];

    final List<String> availableVariants =
        selectedCraneModel != null
            ? (craneVariants[selectedCraneModel!] ?? []).cast<String>()
            : <String>[];

    // Reset dependent selections if no longer valid
    if (selectedCraneModel != null &&
        !availableModels.contains(selectedCraneModel)) {
      selectedCraneModel = null;
      selectedCraneVariant = null;
    }

    if (selectedCraneVariant != null &&
        !availableVariants.contains(selectedCraneVariant)) {
      selectedCraneVariant = null;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Truck Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Truck & Crane Info',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Crane chart placeholder box
                        _buildCraneChartPreview(),

                        // Truck plate input
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            controller: _plateController,
                            decoration: const InputDecoration(
                              labelText: 'Truck Plate Number',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),

                        // Crane type dropdown
                        _buildDropdown<String>(
                          label: 'Crane Type',
                          value: selectedCraneType,
                          items: craneTypes,
                          onChanged:
                              (val) => setState(() {
                                selectedCraneType = val;
                                selectedCraneModel =
                                    null; // reset dependent dropdowns
                                selectedCraneVariant = null;
                              }),
                        ),

                        // Crane model dropdown (depends on type)
                        _buildDropdown<String>(
                          label: 'Crane Model',
                          value: selectedCraneModel,
                          items: availableModels,
                          onChanged:
                              (val) => setState(() {
                                selectedCraneModel = val;
                                selectedCraneVariant =
                                    null; // reset variant on model change
                              }),
                        ),

                        // Crane variant dropdown (depends on model)
                        _buildDropdown<String>(
                          label: 'Crane Variant',
                          value: selectedCraneVariant,
                          items: availableVariants,
                          onChanged:
                              (val) => setState(() {
                                selectedCraneVariant = val;
                              }),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons row
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
                          final truckDetails = {
                            'truckPlate': _plateController.text,
                            'craneType': selectedCraneType ?? '',
                            'craneModel': selectedCraneModel ?? '',
                            'craneVariant': selectedCraneVariant ?? '',
                          };
                          Navigator.push(context, MaterialPageRoute(builder: (_) => StabilizerDetailsScreen()));
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
}
