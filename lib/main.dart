import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF7CCF00));
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'DMSans',
        colorScheme: colorScheme,
        cardTheme: CardThemeData(color: Colors.white),
      ),
      home: const Home(),
    );
  }
}
