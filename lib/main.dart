import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/Job_list_screen.dart';
// import 'package:operatorsafe/screens/delivery_details_screen.dart';
// import 'package:operatorsafe/screens/login_screen.dart';
// import 'package:operatorsafe/screens/lifting_tools_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Text('SafeLift'),
                backgroundColor: Color(0xFFF5C400),
              ),
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobListScreen(),
                      ),
                    );
                  },
                  child: Text("Start Unloading"),
                ),
              ),
            ),
      ),
    );
  }
}
