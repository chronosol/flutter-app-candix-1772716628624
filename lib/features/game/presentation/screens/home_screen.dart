import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:candix/core/routing/app_router.dart';
import 'package:candix/features/game/presentation/controllers/game_controller.dart';
import 'package:candix/features/game/presentation/widgets/game_over_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<bool>(isGameOverProvider, (previous, next) {
      if (next == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return GameOverDialog(
              score: ref.read(gameScoreProvider),
              onPlayAgain: () {
                context.pop(); // Close dialog
                ref.read(gameControllerProvider.notifier).startGame();
              },
              onGoHome: () {
                context.pop(); // Close dialog
                context.go(AppRoute.home.path);
              },
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Candix',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(AppRoute.settings.path),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Candix!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(gameControllerProvider.notifier).startGame();
                context.go(AppRoute.game.path);
              },
              icon: const Icon(Icons.play_arrow),
              label: Text(
                'Start Game',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.go(AppRoute.settings.path),
              icon: const Icon(Icons.settings),
              label: Text(
                'Settings',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
