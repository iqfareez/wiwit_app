import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Persistent bottom sheet for [ServerSetPage].
class ServerInputSheet extends StatelessWidget {
  const ServerInputSheet({
    required this.formKey,
    required this.controller,
    required this.isLoading,
    required this.onConnect,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Server URL',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Gap(12),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.url,
              autocorrect: false,
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (_) => onConnect(),
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
                filled: true,
                hintText: 'https://your-server.com',
                prefixIcon: const Icon(Icons.dns_outlined),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your server URL';
                }
                return null;
              },
            ),
            const Gap(16),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : onConnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'Connect',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            Gap(16),
          ],
        ),
      ),
    );
  }
}
