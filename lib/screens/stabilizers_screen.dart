import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/lift_plan_screen.dart';
import 'package:operatorsafe/screens/lifting_plan_builder_screen.dart';
import 'package:operatorsafe/utils/formatters.dart';

class StabilizersScreen extends StatefulWidget {
  const StabilizersScreen({super.key});

  @override
  State<StabilizersScreen> createState() => _StabilizersScreenState();
}

// will need refactoring, best to demonstrate functionality.
class _StabilizersScreenState extends State<StabilizersScreen> {
  late Map<StabilizerLegEnum, Stabilizer> stabilizers = {};

  @override
  void initState() {
    super.initState();

    stabilizers = {
      StabilizerLegEnum.frontFront: Stabilizer(
        stabilizerLegName: StabilizerLegEnum.frontFront,
        stabilizerPosition: 0.0,
        isStabilizerActive: true,
        rotationOrientation: -1,
      ),
      StabilizerLegEnum.frontLeft: Stabilizer(
        stabilizerLegName: StabilizerLegEnum.frontLeft,
        stabilizerPosition: 1.0,
        isStabilizerActive: true,
        rotationOrientation: 2,
      ),
      StabilizerLegEnum.rearLeft: Stabilizer(
        stabilizerLegName: StabilizerLegEnum.rearLeft,
        stabilizerPosition: 1.0,
        isStabilizerActive: true,
        rotationOrientation: 2,
      ),
      StabilizerLegEnum.frontRight: Stabilizer(
        stabilizerLegName: StabilizerLegEnum.frontRight,
        stabilizerPosition: 1.0,
        isStabilizerActive: true,
        rotationOrientation: -1,
      ),
      StabilizerLegEnum.rearRight: Stabilizer(
        stabilizerLegName: StabilizerLegEnum.rearRight,
        stabilizerPosition: 1.0,
        isStabilizerActive: true,
        rotationOrientation: -1,
      ),
      StabilizerLegEnum.rearRear: Stabilizer(
        stabilizerLegName: StabilizerLegEnum.rearRear,
        stabilizerPosition: 0.0,
        isStabilizerActive: true,
        rotationOrientation: 1,
      ),
    };
  }

  double _frontFront = 0.0;
  double _leftFront = 1.0;
  double _rightFront = 1.0;
  double _leftRear = 1.0;
  double _rightRear = 1.0;
  double _rearRear = 0.0;

  bool _frontFrontActive = true;
  bool _leftFrontActive = true;
  bool _rightFrontActive = true;
  bool _leftRearActive = true;
  bool _rightRearActive = true;
  bool _rearRearActive = true;

  void lockSlider() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stabilizers'),
        // backgroundColor: const Color(0xFFF5C400),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            padding: EdgeInsets.all(10),
            color: Colors.white30,
            child: Column(
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    // Top Row
                    TableRow(
                      children: [
                        SizedBox(), // Top-left empty
                        Column(
                          children: [
                            Text('FF ${toPercentage(_frontFront)}%'),
                            SizedBox(
                              height: 125,
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Slider(
                                  value: _frontFront,
                                  inactiveColor: Colors.black26,
                                  activeColor: Colors.redAccent,
                                  onChanged:
                                      _frontFrontActive
                                          ? (newValue) {
                                            setState(
                                              () => _frontFront = newValue,
                                            );
                                          }
                                          : null,
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _frontFrontActive = !_frontFrontActive;
                                  _frontFrontActive
                                      ? _frontFront = 1.0
                                      : _frontFront = 0.0;
                                });
                              },
                              icon: Icon(
                                _frontFrontActive
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outlined,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(), // Top-right empty
                      ],
                    ),

                    // Middle Row
                    TableRow(
                      children: [
                        // Left-side sliders
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('LF ${toPercentage(_leftFront)}%'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _leftFrontActive = !_leftFrontActive;
                                  _leftFrontActive
                                      ? _leftFront = 1.0
                                      : _leftFront = 0.0;
                                });
                              },
                              icon: Icon(
                                _leftFrontActive
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outlined,
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 2,
                              child: Slider(
                                value: _leftFront,
                                activeColor: Colors.redAccent,
                                onChanged:
                                    _leftFrontActive
                                        ? (newValue) {
                                          setState(() => _leftFront = newValue);
                                        }
                                        : null,
                              ),
                            ),

                            // left rear
                            Text('LR ${toPercentage(_leftRear)}%'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _leftRearActive = !_leftRearActive;
                                  _leftRearActive
                                      ? _leftRear = 1.0
                                      : _leftRear = 0.0;
                                });
                              },
                              icon: Icon(
                                _leftRearActive
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outlined,
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 2,
                              child: Slider(
                                value: _leftRear,
                                activeColor: Colors.redAccent,
                                label: 'left rear',
                                onChanged:
                                    _leftRearActive
                                        ? (newValue) {
                                          setState(() => _leftRear = newValue);
                                        }
                                        : null,
                              ),
                            ),
                          ],
                        ),

                        // Crane image in center
                        Center(
                          child: Image.asset(
                            'assets/images/crane_truck_topview.png',
                            height: 150,
                            width: 75,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Right-side sliders
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('RF ${toPercentage(_rightFront)}%'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _leftRearActive = !_leftRearActive;
                                  _leftRear = 0.0;
                                });
                              },
                              icon: Icon(
                                _leftRearActive
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outlined,
                              ),
                            ),
                            Slider(
                              value: _rightFront,
                              activeColor: Colors.redAccent,
                              onChanged: (newValue) {
                                setState(() => _rightFront = newValue);
                              },
                            ),
                            Text('RR ${toPercentage(_rightRear)}%'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _leftRearActive = !_leftRearActive;
                                  _leftRear = 0.0;
                                });
                              },
                              icon: Icon(
                                _leftRearActive
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outlined,
                              ),
                            ),
                            // quarterTurns: -1,
                            Slider(
                              value: _rightRear,
                              activeColor: Colors.redAccent,
                              onChanged: (newValue) {
                                setState(() => _rightRear = newValue);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Bottom Row
                    TableRow(
                      children: [
                        SizedBox(), // Bottom-left empty
                        Column(
                          children: [
                            Text('BR ${toPercentage(_rearRear)}%'),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _leftRearActive = !_leftRearActive;
                                  _leftRear = 0.0;
                                });
                              },
                              icon: Icon(
                                _leftRearActive
                                    ? Icons.block_outlined
                                    : Icons.check_circle_outlined,
                              ),
                            ),
                            SizedBox(
                              height: 125,
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: Slider(
                                  value: _rearRear,
                                  activeColor: Colors.redAccent,
                                  inactiveColor: Colors.black26,
                                  onChanged: (newValue) {
                                    setState(() => _rearRear = newValue);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(), // Bottom-right empty
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiftPlanScreen(),
                      ),
                    );
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// stabilizersNames
enum StabilizerLegEnum {
  frontFront,
  frontRight,
  frontLeft,
  rearRight,
  rearLeft,
  rearRear,
}

// stabilizer sliders
class Stabilizer {
  final StabilizerLegEnum _stabilizerLegName;
  double _stabilizerPosition;
  bool _isStabilizerActive;
  final int _rotationOrientation;

  Stabilizer({
    required StabilizerLegEnum stabilizerLegName,
    double stabilizerPosition = 1.0,
    bool isStabilizerActive = true,
    int rotationOrientation = 0,
  }) : _stabilizerLegName = stabilizerLegName,
       _stabilizerPosition = stabilizerPosition,
       _isStabilizerActive = isStabilizerActive,
       _rotationOrientation = rotationOrientation;

  // Getters
  StabilizerLegEnum get leg => _stabilizerLegName;
  double get position => _stabilizerPosition;
  bool get isActive => _isStabilizerActive;
  int get rotation => _rotationOrientation;

  int get positionPercentage => (_stabilizerPosition * 100).round();

  // Setters
  set position(double value) {
    _stabilizerPosition = value.clamp(0.0, 1.0);
  }

  set isActive(bool value) {
    _isStabilizerActive = value;
  }
}
