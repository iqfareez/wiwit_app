import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/theme_mode_provider.dart';
import '../../../shared/utils/theme_mode_utils.dart';

/// Lets the user pick which theme the app follows.
class ThemeModeDialog extends ConsumerWidget {
  const ThemeModeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(themeModeProvider).value;

    return SimpleDialog(
      title: const Text('Appearance'),
      children: [
        RadioGroup<ThemeMode>(
          groupValue: selected,
          onChanged: (picked) {
            if (picked == null) return;

            ref.read(themeModeProvider.notifier).setMode(picked);
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode in ThemeMode.values)
                RadioListTile<ThemeMode>(
                  value: mode,
                  title: Text(mode.label),
                  secondary: Icon(mode.icon),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
