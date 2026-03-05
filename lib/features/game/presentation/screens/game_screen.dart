import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/features/game/presentation/controllers/game_controller.dart';
import 'package:candix/features/game/presentation/widgets/game_board_widget.dart';
import 'package:candix/features/game/presentation/widgets/game_info_widget.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateAsync = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Candix Game',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: gameStateAsync.when(
        data: (gameState) {
          return Column(
            children: [
              const GameInfoWidget(),
              Expanded(
                child: Center(
                  child: GameBoardWidget(
                    tileSize: MediaQuery.of(context).size.width / (gameState.board.candies.isNotEmpty ? gameState.board.candies[0].length : 8) - 16, // Dynamic tile size
                  ),
                ),
              ),
              if (gameState.isGameOver)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Game Over!',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: $error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(gameControllerProvider.notifier).startGame(),
                child: const Text('Restart Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
