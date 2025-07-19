import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:operatorsafe/screens/delivery_date_screen.dart';

/// Entry point of the SafeLift application.
///
/// - Initializes Flutter bindings
/// - Loads environment variables from the `.env` file
/// - Runs the app starting with [MainApp] widget
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (API keys, config values, etc)
  await dotenv.load(fileName: 'assets/.env');

  runApp(const MainApp());
}

/// Root widget of the application.
///
/// This widget sets up:
/// - The MaterialApp with app-wide properties like title
/// - The initial home screen with a simple Scaffold
///
/// Expand this class to:
/// - Add global state management (Provider, Riverpod, etc)
/// - Setup routing/navigation
/// - Define themes and localization
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lift Logic',

      home: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Lift Logic'),
                // backgroundColor: const Color(0xFFF5C400), // Customize if needed
              ),

              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeliveryDateScreen(),
                      ),
                    );
                  },
                  child: const Text('Start Unloading'),
                ),
              ),
            ),
      ),
    );
  }
}
