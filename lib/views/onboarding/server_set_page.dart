import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constants.dart';
import '../../shared/services/networking/chopper_instance.dart';
import '../auth/login_page.dart';
import 'components/server_input_sheet.dart';

/// Onboarding page to setup server instance URL.
class ServerSetPage extends StatefulWidget {
  const ServerSetPage({super.key});

  @override
  State<ServerSetPage> createState() => _ServerSetPageState();
}

class _ServerSetPageState extends State<ServerSetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  /// Prepends `https://` when no scheme is present and drops trailing slashes.
  String _normalizeUrl(String raw) {
    var url = raw.trim();
    if (!url.startsWith(RegExp(r'https?://'))) {
      url = 'https://$url';
    }
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  Future<void> _connect() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final serverUrl = _normalizeUrl(_urlController.text);

      final reachable = await ChopperInstance.isServerReachable(serverUrl);
      if (!mounted) return;

      if (!reachable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Couldn't reach that server. Check the URL."),
          ),
        );
        return;
      }

      // Persist and wire up the client against the chosen server.
      await SharedPreferencesAsync().setString(kStoreServerUrl, serverUrl);
      ChopperInstance.initializeChopperClient(serverUrl);

      if (!mounted) return;

      // Morph into the login screen with a fade + subtle scale.
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 550),
          pageBuilder: (_, _, _) => const LoginPage(),
          transitionsBuilder: (_, animation, _, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      bottomSheet: ServerInputSheet(
        formKey: _formKey,
        controller: _urlController,
        isLoading: _isLoading,
        onConnect: _connect,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'appLogo',
                    child: Image.asset(
                      'assets/logos/icon-light-84.png',
                      height: 72,
                    ),
                  ),
                  const Gap(24),
                  Text(
                    'Wiwit',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    'Track your money, your way.\nConnect to your Wiwit server to get started.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
