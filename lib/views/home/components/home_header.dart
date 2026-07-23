import 'package:flutter/material.dart';

import '../../profile/settings_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.greeting, required this.name});

  final String greeting;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .stretch,
            children: [
              Text(greeting, style: TextStyle(fontSize: 14)),
              Text(name, style: TextStyle(fontSize: 24, fontWeight: .bold)),
            ],
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: .end,
            // crossAxisAlignment: .end,
            children: [
              IconButton(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
                tooltip: 'Settings',
                icon: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text("F", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
