import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pdfrxFlutterInitialize();
  runApp(const HawkABuildApp());
}

class HawkABuildApp extends StatelessWidget {
  const HawkABuildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HawkABuild',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.cyan,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
      ),
      // Intentional empty app shell: the sample test dashboard is not the
      // product UI. Add the original screens and route them from here.
      home: const Scaffold(),
    );
  }
}
