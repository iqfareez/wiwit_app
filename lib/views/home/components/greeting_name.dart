import 'package:flutter/material.dart';

class GreetingName extends StatelessWidget {
  const GreetingName({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .stretch,
      children: [
        Text("Good Morning", style: TextStyle(fontSize: 14)),
        Text(name, style: TextStyle(fontSize: 24, fontWeight: .bold)),
      ],
    );
  }
}
