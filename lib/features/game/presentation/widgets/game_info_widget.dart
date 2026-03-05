import 'package:flutter/material.dart';
import 'package:candix/features/game/domain/entities/game_state.dart';

class GameInfoWidget extends StatelessWidget {
  final GameState gameState;

  const GameInfoWidget({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn(
              context,
              label: 'Score',
              value: gameState.score.toString(),
              icon: Icons.emoji_events,
              color: colorScheme.primary,
            ),
            _buildInfoColumn(
              context,
              label: 'Moves',
              value: gameState.movesLeft.toString(),
              icon: Icons.swap_horiz,
              color: colorScheme.secondary,
            ),
            _buildInfoColumn(
              context,
              label: 'Level',
              value: gameState.level.toString(),
              icon: Icons.star,
              color: colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    {required String label, required String value, required IconData icon, required Color color}
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(label, style: textTheme.labelMedium),
        Text(value, style: textTheme.titleLarge?.copyWith(color: color)),
      ],
    );
  }
}
