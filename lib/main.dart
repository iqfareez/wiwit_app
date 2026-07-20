import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'shared/constants.dart';
import 'shared/services/networking/chopper_instance.dart';
import 'views/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ChopperInstance.initializeChopperClient();

  // TODO: Temporary for testing, hardcoding the token to store to secure storage
  final storage = FlutterSecureStorage();
  await storage.write(
    key: kStoreApiBearerToken,
    value: '5|FxiNPkoMFMYJWCY6qtYuOt06bu602RKx53NwD3FO053b3ac9',
  );

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
      home: const LoginPage(),
    );
  }
}
