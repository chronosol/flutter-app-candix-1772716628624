import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            // Example setting: Toggle dark mode
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (bool value) {
                // This would typically involve a provider to change themeMode
                // For simplicity, we'll just show the toggle.
                // A full implementation would use a StateNotifierProvider for theme.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dark mode toggle: $value (requires app restart or theme provider)'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text(
                'Go Back',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
