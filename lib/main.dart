import 'package:flutter/material.dart';
import 'package:operatorsafe/screens/Job_list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:operatorsafe/screens/delivery_api_screen.dart';
import 'package:operatorsafe/screens/sling_configuration_screen.dart';
import 'package:operatorsafe/screens/location_details_screen.dart';
import 'package:operatorsafe/screens/weather_condition_screen.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: 'assets/.env');


  // Start the app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeLift',
      home: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Lift Logic'),
                // backgroundColor: const Color(0xFFF5C400),
              ),
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeliveryAddressScreen(),
                      ),
                    );
                  },
                  child: const Text("Start Unloading"),
                ),
              ),
            ),
      ),
    );
  }
}
