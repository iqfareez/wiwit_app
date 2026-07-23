import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/providers/auth_provider.dart';
import 'shared/providers/server_url_provider.dart';
import 'shared/providers/theme_mode_provider.dart';
import 'views/root_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Warm the providers the first frame depends on.
  final container = ProviderContainer();
  await (
    container.read(themeModeProvider.future),
    container.read(serverUrlProvider.future),
    container.read(authTokenProvider.future),
  ).wait;

  runApp(
    UncontrolledProviderScope(container: container, child: const MainApp()),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  static const _seedColor = Color(0xFF7CCF00);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Already resolved in main(), so the fallback only covers a failed read.
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;

    final colorScheme = ColorScheme.fromSeed(seedColor: _seedColor);
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: .dark,
    );

    return MaterialApp(
      title: 'Wiwit',
      theme: ThemeData(
        fontFamily: 'DMSans',
        colorScheme: colorScheme,
        cardTheme: CardThemeData(color: Colors.white),
      ),
      darkTheme: ThemeData(
        brightness: .dark,
        colorScheme: darkColorScheme,
        cardTheme: CardThemeData(color: Colors.black),
      ),
      themeMode: themeMode,
      home: const RootView(),
    );
  }
}
