import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../shared/components/confirm_dialog.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/server_url_provider.dart';
import '../../shared/providers/theme_mode_provider.dart';
import '../../shared/utils/theme_mode_utils.dart';
import 'components/settings_section_card.dart';
import 'components/settings_section_label.dart';
import 'components/settings_tile.dart';
import 'components/theme_mode_dialog.dart';

/// Represents the settings page
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late Future<PackageInfo> futurePackageInfo;

  @override
  void initState() {
    super.initState();
    futurePackageInfo = PackageInfo.fromPlatform();
  }

  /// Asks for confirmation, then runs [action] while the dialog stays open so
  /// its confirm button can carry the progress indicator.
  ///
  /// Returns whether the user went through with it.
  Future<bool> _confirmAndRun({
    required String title,
    required String message,
    required String confirmLabel,
    required Future<void> Function() action,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      // The dialog runs the action, so it decides when it closes.
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        action: action,
      ),
    );

    return confirmed ?? false;
  }

  /// Both destructive actions leave the user somewhere else entirely, and the
  /// root view has already swapped to that screen underneath us. All that is
  /// left is to get this page out of the way.
  Future<void> _closeAfter(Future<bool> confirmation) async {
    final confirmed = await confirmation;

    if (!confirmed || !mounted) return;

    Navigator.of(context).pop();
  }

  Future<void> _logout() {
    return _closeAfter(
      _confirmAndRun(
        title: 'Log out?',
        message: "You'll need to sign in again to see your transactions.",
        confirmLabel: 'Log out',
        action: ref.read(authTokenProvider.notifier).clear,
      ),
    );
  }

  Future<void> _changeServer() {
    return _closeAfter(
      _confirmAndRun(
        title: 'Change server?',
        message:
            'This signs you out and takes you back to the server setup screen.',
        confirmLabel: 'Change server',
        action: () async {
          await ref.read(authTokenProvider.notifier).clear();

          // Forgetting the URL disposes the Chopper client derived from it, so
          // nothing keeps talking to the old server.
          await ref.read(serverUrlProvider.notifier).clear();
        },
      ),
    );
  }

  void _showThemeModeDialog() {
    showDialog<void>(context: context, builder: (_) => const ThemeModeDialog());
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    final serverUrl = ref.watch(serverUrlProvider).value;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back',
                  ),
                  const Gap(4),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              const SettingsSectionLabel('Appearance'),
              const Gap(8),
              SettingsSectionCard(
                child: SettingsTile(
                  icon: themeMode.icon,
                  title: 'Theme',
                  subtitle: themeMode.label,
                  onTap: _showThemeModeDialog,
                ),
              ),
              const Gap(24),
              const SettingsSectionLabel('Connection'),
              const Gap(8),
              SettingsSectionCard(
                child: SettingsTile(
                  icon: Icons.dns_outlined,
                  title: 'Change server',
                  subtitle: serverUrl ?? 'Loading...',
                  onTap: _changeServer,
                ),
              ),
              const Gap(24),
              const SettingsSectionLabel('Account'),
              const Gap(8),
              SettingsSectionCard(
                child: SettingsTile(
                  icon: Icons.logout,
                  title: 'Log out',
                  subtitle: 'Sign out of this device',
                  isDestructive: true,
                  onTap: _logout,
                ),
              ),
              const Gap(32),
              Center(
                child: FutureBuilder(
                  future: futurePackageInfo,
                  builder: (context, asyncSnapshot) {
                    var textStyle = Theme.of(context).textTheme.bodySmall
                        ?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        );
                    if (!asyncSnapshot.hasData) {
                      return Text('Wiwit', style: textStyle);
                    }
                    var appVersion = asyncSnapshot.data?.version;
                    var appName = asyncSnapshot.data?.appName;
                    return Text('$appName v$appVersion', style: textStyle);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
