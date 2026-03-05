import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:candix/core/constants/app_constants.dart';
import 'package:candix/features/game/domain/entities/game_state.dart';
import 'package:candix/features/game/presentation/controllers/game_controller.dart';
import 'package:candix/features/game/presentation/widgets/game_board_widget.dart';
import 'package:candix/features/game/presentation/widgets/game_info_widget.dart';
import 'package:candix/features/game/presentation/widgets/game_over_dialog.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateAsync = ref.watch(gameControllerProvider);

    ref.listen<AsyncValue<GameState>>(
      gameControllerProvider,
      (previous, next) {
        if (next.hasValue && next.value!.status == GameStatus.gameOver) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => GameOverDialog(
              score: next.value!.score,
              onPlayAgain: () {
                context.pop(); // Close dialog
                ref.read(gameControllerProvider.notifier).resetGame();
              },
              onGoHome: () {
                context.pop(); // Close dialog
                context.go('/');
              },
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Candix Game'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: gameStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (gameState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.boardSize * 2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameInfoWidget(gameState: gameState),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GameBoardWidget(gameState: gameState),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (gameState.status != GameStatus.playing)
                    ElevatedButton(
                      onPressed: () => ref.read(gameControllerProvider.notifier).resetGame(),
                      child: const Text('Play Again'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
