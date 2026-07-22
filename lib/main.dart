import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'shared/constants.dart';
import 'shared/services/networking/chopper_instance.dart';
import 'views/auth/login_page.dart';
import 'views/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ChopperInstance.initializeChopperClient();

  final token = await const FlutterSecureStorage().read(
    key: kStoreApiBearerToken,
  );

  runApp(MainApp(isAuthenticated: token?.isNotEmpty ?? false));
}

class MainApp extends StatelessWidget {
  const MainApp({required this.isAuthenticated, super.key});

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF7CCF00));
    return MaterialApp(
      title: 'Wiwit',
      theme: ThemeData(
        fontFamily: 'DMSans',
        colorScheme: colorScheme,
        cardTheme: CardThemeData(color: Colors.white),
      ),
      home: isAuthenticated ? const Home() : const LoginPage(),
    );
  }
}
