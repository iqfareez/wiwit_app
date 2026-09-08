import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../shared/providers/server_url_provider.dart';
import '../../shared/services/networking/server_probe.dart';
import 'components/server_input_sheet.dart';

/// Onboarding page to setup server instance URL.
class ServerSetPage extends ConsumerStatefulWidget {
  const ServerSetPage({super.key});

  @override
  ConsumerState<ServerSetPage> createState() => _ServerSetPageState();
}

class _ServerSetPageState extends ConsumerState<ServerSetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final lastUrl = ref.read(lastServerUrlProvider);
    if (lastUrl != null) _urlController.text = lastUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final result = await resolveServerUrl(_urlController.text);
      if (!mounted) return;

      if (!result.isSuccess) {
        final message = switch (result.error!) {
          ServerProbeError.notWiwitInstance =>
            "That server doesn't look like a Wiwit instance.",
          ServerProbeError.unreachable =>
            "Couldn't reach that server. Check the URL.",
        };
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        return;
      }

      await ref.read(serverUrlProvider.notifier).set(result.url!);
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
