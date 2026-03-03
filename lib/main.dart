import 'package:app/src/feature/onboarding/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FinzaApp());
}

class FinzaApp extends StatelessWidget {
  const FinzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splashpage(),
    );
  }
}
