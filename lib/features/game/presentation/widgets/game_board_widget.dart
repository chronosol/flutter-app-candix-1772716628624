import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/core/constants/app_constants.dart';
import 'package:candix/features/game/domain/entities/game_state.dart';
import 'package:candix/features/game/presentation/controllers/game_controller.dart';
import 'package:candix/features/game/presentation/widgets/candy_tile_widget.dart';

class GameBoardWidget extends ConsumerWidget {
  final GameState gameState;

  const GameBoardWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = gameState.board;
    final size = board.size;
    final selectedIndex = gameState.selectedCandyIndex;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(4),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size,
          childAspectRatio: 1,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: board.candies.length,
        itemBuilder: (context, index) {
          final candy = board.candies[index];
          final isSelected = selectedIndex == index;

          return CandyTileWidget(
            candy: candy,
            isSelected: isSelected,
            onTap: () => ref.read(gameControllerProvider.notifier).selectCandy(index),
            size: (MediaQuery.of(context).size.width / size) - 10, // Approximate size
          );
        },
      ),
    );
  }
}
