import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ComiConvertApp());
}

class ComiConvertApp extends StatelessWidget {
  const ComiConvertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComiConvert',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
