import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constants.dart';
import '../../shared/services/networking/chopper_instance.dart';
import '../../shared/utils/navigation_utils.dart';
import '../auth/login_page.dart';
import '../onboarding/server_set_page.dart';
import 'components/confirm_dialog.dart';
import 'components/settings_section_card.dart';
import 'components/settings_section_label.dart';
import 'components/settings_tile.dart';

/// Represents the settings page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _storage = FlutterSecureStorage();
  static final _prefs = SharedPreferencesAsync();

  String? _serverUrl;

  @override
  void initState() {
    super.initState();
    _loadServerUrl();
  }

  Future<void> _loadServerUrl() async {
    final serverUrl = await _prefs.getString(kStoreServerUrl);
    if (!mounted) return;

    setState(() => _serverUrl = serverUrl);
  }

  /// Asks for confirmation, then runs [action] while the dialog stays open so
  /// its confirm button can carry the progress indicator.
  Future<void> _confirmAndRun({
    required String title,
    required String message,
    required String confirmLabel,
    required Future<void> Function() action,
  }) {
    return showDialog<void>(
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
  }

  Future<void> _logout() {
    return _confirmAndRun(
      title: 'Log out?',
      message: "You'll need to sign in again to see your transactions.",
      confirmLabel: 'Log out',
      action: () async {
        // TODO: call the logout endpoint once the API implements it, so the
        // token is revoked server side and not just dropped locally.
        await _storage.delete(key: kStoreApiBearerToken);

        if (!mounted) return;

        context.replaceRootWith(const LoginPage());
      },
    );
  }

  Future<void> _changeServer() {
    return _confirmAndRun(
      title: 'Change server?',
      message:
          'This signs you out and takes you back to the server setup screen.',
      confirmLabel: 'Change server',
      action: () async {
        // TODO: call the logout endpoint once the API implements it, so the
        // token is revoked server side and not just dropped locally.
        await _storage.delete(key: kStoreApiBearerToken);
        await _prefs.remove(kStoreServerUrl);

        // Drop the client so nothing keeps talking to the old server.
        ChopperInstance.reset();

        if (!mounted) return;

        context.replaceRootWith(const ServerSetPage());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              const SettingsSectionLabel('Connection'),
              const Gap(8),
              SettingsSectionCard(
                child: SettingsTile(
                  icon: Icons.dns_outlined,
                  title: 'Change server',
                  subtitle: _serverUrl ?? 'Loading...',
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
                child: Text(
                  'Wiwit',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
