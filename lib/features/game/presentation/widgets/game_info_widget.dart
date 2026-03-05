import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/features/game/presentation/controllers/game_controller.dart';

class GameInfoWidget extends ConsumerWidget {
  const GameInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(gameScoreProvider);
    final movesLeft = ref.watch(gameMovesLeftProvider);
    final textTheme = Theme.of(context).textTheme; // textTheme is now used

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Score',
                  style: textTheme.titleMedium, // Using textTheme
                ),
                Text(
                  '$score',
                  style: textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Moves Left',
                  style: textTheme.titleMedium, // Using textTheme
                ),
                Text(
                  '$movesLeft',
                  style: textTheme.headlineSmall?.copyWith(
                    color: movesLeft <= 5 ? Colors.red : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
