import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants.dart';
import 'storage_provider.dart';

part 'theme_mode_provider.g.dart';

/// Owns the theme the user picked and persists it so the choice survives
/// restarts.
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async {
    final stored = await ref
        .watch(preferencesProvider)
        .getString(kStoreThemeMode);

    // Follow the OS until the user picks a theme themselves. Storing the enum
    // name keeps the stored value readable and free of magic strings.
    return ThemeMode.values.asNameMap()[stored] ?? ThemeMode.system;
  }

  /// Applies [mode] immediately, then persists it.
  Future<void> setMode(ThemeMode mode) async {
    if (state.value == mode) return;

    state = AsyncData(mode);

    await ref.read(preferencesProvider).setString(kStoreThemeMode, mode.name);
  }
}
