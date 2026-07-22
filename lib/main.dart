import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared/constants.dart';
import 'shared/services/networking/chopper_instance.dart';
import 'views/auth/login_page.dart';
import 'views/home/home.dart';
import 'views/onboarding/server_set_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final serverUrl = await SharedPreferencesAsync().getString(kStoreServerUrl);
  final hasServer = serverUrl != null && serverUrl.isNotEmpty;

  if (hasServer) {
    ChopperInstance.initializeChopperClient(serverUrl);
  }

  final token = await const FlutterSecureStorage().read(
    key: kStoreApiBearerToken,
  );

  runApp(
    MainApp(hasServer: hasServer, isAuthenticated: token?.isNotEmpty ?? false),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    required this.hasServer,
    required this.isAuthenticated,
    super.key,
  });

  final bool hasServer;
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
      home: Builder(
        builder: (context) {
          // Onboarding when no server is set, otherwise home or login
          // depending on whether a token exists.
          if (!hasServer) {
            return const ServerSetPage();
          }
          if (!isAuthenticated) {
            return const LoginPage();
          }
          return const Home();
        },
      ),
    );
  }
}
