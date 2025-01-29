import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CoastalTourismApp());
}

class CoastalTourismApp extends StatelessWidget {
  const CoastalTourismApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coastal Tourism',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077BE),
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
