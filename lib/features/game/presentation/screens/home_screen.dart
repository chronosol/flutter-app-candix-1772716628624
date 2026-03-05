import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:candix/features/game/data/repositories/game_repository_impl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScoreAsync = ref.watch(gameRepositoryProvider.selectAsync((repo) => repo.getHighScore()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Candix'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Candix!',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              highScoreAsync.when(
                data: (highScore) => Text(
                  'High Score: $highScore',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error loading high score: $err'),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () => context.go('/game'),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Game'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go('/settings'),
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
