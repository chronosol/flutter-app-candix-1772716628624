import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/features/game/presentation/controllers/game_controller.dart';
import 'package:candix/features/game/presentation/widgets/candy_tile_widget.dart';

class GameBoardWidget extends ConsumerWidget {
  final double tileSize;

  const GameBoardWidget({super.key, this.tileSize = 60.0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateAsync = ref.watch(gameControllerProvider);

    return gameStateAsync.when(
      data: (gameState) {
        final board = gameState.board;
        if (board.candies.isEmpty) {
          return const Center(child: Text('Board is empty. Start a new game!'));
        }

        final int rows = board.candies.length;
        final int cols = board.candies[0].length;

        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest, // Fixed: surfaceVariant to surfaceContainerHighest
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: rows * cols,
            itemBuilder: (context, index) {
              final int row = index ~/ cols;
              (final int col = index % cols).toInt();
              final candy = board.candies[row][col];
              return CandyTileWidget(
                candy: candy,
                row: row,
                col: col,
                size: tileSize,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Error loading game: $error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(gameControllerProvider.notifier).startGame(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
