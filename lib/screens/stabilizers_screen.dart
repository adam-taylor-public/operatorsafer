import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/lifting_plan_builder_screen.dart';

class StabilizersScreen extends StatefulWidget {
  const StabilizersScreen({super.key});

  @override
  State<StabilizersScreen> createState() => _StabilizersScreenState();
}

class _StabilizersScreenState extends State<StabilizersScreen> {
  @override
  double _frontFront = 0.0;
  double _leftFront = 1.0;
  double _rightFront = 1.0;
  double _leftRear = 1.0;
  double _rightRear = 1.0;
  double _rearRear = 0.0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stabilizers'),
        backgroundColor: const Color(0xFFF5C400),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            color: Colors.white30,
            //decoration: BoxDecoration(border: Border.all() ,borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                // Column for 
                // GridView.count(
                //   crossAxisCount: 3,

                // ),
                Row(
                  children: [
                    Text('Front Front'),
                    RotatedBox(
                      quarterTurns: -1,
                      child: Slider(
                        value: _frontFront,
                        onChanged:
                            (newValue) => {
                              setState(() {
                                _frontFront = newValue;
                              }),
                            },
                      ),
                    ),
                  ],
                ),

                // column to put left sliders, truck image, right sliders
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Front Left'),
                        Slider(
                          value: _leftFront,
                          onChanged:
                              (newValue) => {
                                setState(() {
                                  _leftFront = newValue;
                                }),
                              },
                        ),
                        Text('Rear Left'),
                        Slider(
                          value: _rightFront,
                          onChanged:
                              (newValue) => {
                                setState(() {
                                  _rightFront = newValue;
                                }),
                              },
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/crane_truck_topview.png',
                      width: 100,
                      height: 300,
                    ),
                    Column(
                      children: [
                        Text('Front Right'),
                        Slider(
                          value: _leftRear,
                          onChanged:
                              (newValue) => {
                                setState(() {
                                  _leftRear = newValue;
                                }),
                              },
                        ),
                        Text('Rear Right'),
                        Slider(
                          value: _rightRear,
                          onChanged:
                              (newValue) => {
                                setState(() {
                                  _rightRear = newValue;
                                }),
                              },
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Rear Rear'),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Slider(
                        value: _rearRear,
                        onChanged:
                            (newValue) => {
                              setState(() {
                                _rearRear = newValue;
                              }),
                            },
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiftingPlanBuilderScreen(),
                      ),
                    );
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
