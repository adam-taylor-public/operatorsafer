import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/pdf_screen.dart';

class LiftPlanScreen extends StatefulWidget {
  const LiftPlanScreen({super.key});

  @override
  State<LiftPlanScreen> createState() => _LiftPlanScreenState();
}

class _LiftPlanScreenState extends State<LiftPlanScreen> {
  bool _showOptions = false;

  final List<Map<String, dynamic>> _options = [
    {'label': 'House', 'icon': Icons.home},
    {'label': 'Driveway', 'icon': Icons.drive_eta},
    {'label': 'Car', 'icon': Icons.directions_car},
    {'label': 'Powerlines', 'icon': Icons.power},
    {'label': 'Underground Services', 'icon': Icons.electrical_services},
    {'label': 'Trees', 'icon': Icons.park},
    {'label': 'Fences', 'icon': Icons.share},

    {'label': 'Pedestrian Path', 'icon': Icons.directions_walk},
    {'label': 'Overhead Structure', 'icon': Icons.account_tree_outlined},
    {'label': 'Uneven Ground', 'icon': Icons.landscape},
    {'label': 'Scaffolding', 'icon': Icons.foundation},
    {'label': 'Water Body', 'icon': Icons.water},
    {'label': 'Other Machinery', 'icon': Icons.precision_manufacturing},
    {'label': 'Fuel Tanks', 'icon': Icons.local_gas_station},
    {'label': 'Traffic Area', 'icon': Icons.traffic},
    {'label': 'Slope/Incline', 'icon': Icons.swap_vert},
    {'label': 'Crane Setup Zone', 'icon': Icons.construction},
    {'label': 'Public Access Area', 'icon': Icons.people},
    {'label': 'Lighting Pole', 'icon': Icons.lightbulb_outline},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lift Plan')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                // Main Card
                Expanded(
                  child: Card(
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
                            'Lift Plan Overview',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Canvas with toggle button inside
                          Expanded(
                            child: Stack(
                              children: [
                                // InteractiveViewer with panning and zoom, restricted boundaries
                                InteractiveViewer(
                                  panEnabled: true,
                                  scaleEnabled: true,
                                  minScale: 0.2,
                                  maxScale: 4.0,
                                  boundaryMargin: EdgeInsets.zero,
                                  constrained: false,
                                  child: const CanvasGrid(),
                                ),

                                // Options list - fixed size, scrollable, no scaling
                                if (_showOptions)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.white.withOpacity(0.95),
                                      child: _buildOptionsList(),
                                    ),
                                  ),

                                // Floating + button bottom right, fixed position
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: FloatingActionButton(
                                      mini: true,
                                      onPressed: () {
                                        setState(
                                          () => _showOptions = !_showOptions,
                                        );
                                      },
                                      child: Icon(
                                        _showOptions ? Icons.close : Icons.add,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Save/Cancel Buttons
                const SizedBox(height: 12),
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
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PdfEditorWidget(),
                              ),
                            ),
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

  Widget _buildOptionsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _options.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, idx) {
        final option = _options[idx];
        return ListTile(
          leading: Icon(option['icon'], size: 28),
          title: Text(option['label']),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added: ${option['label']}')),
            );
            setState(() => _showOptions = false);
          },
        );
      },
    );
  }
}

class CanvasGrid extends StatelessWidget {
  final double cellSize; // pixels per cell
  final int gridDimension; // 60 x 60 cells
  final Color lineColor;

  const CanvasGrid({
    super.key,
    this.cellSize = 40.0,
    this.gridDimension = 60,
    this.lineColor = const Color(0x11000000), // very light
  });

  @override
  Widget build(BuildContext context) {
    final totalSize = gridDimension * cellSize;
    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: CustomPaint(
        painter: _GridPainter(
          cellSize: cellSize,
          lineColor: lineColor,
          gridDimension: gridDimension,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double cellSize;
  final Color lineColor;
  final int gridDimension;

  _GridPainter({
    required this.cellSize,
    required this.lineColor,
    required this.gridDimension,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 0.5;

    // Draw vertical lines
    for (int i = 0; i <= gridDimension; i++) {
      final x = i * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (int j = 0; j <= gridDimension; j++) {
      final y = j * cellSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
