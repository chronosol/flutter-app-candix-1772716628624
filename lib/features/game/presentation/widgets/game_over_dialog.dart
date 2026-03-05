import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Game Over!',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Score: $score',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onPlayAgain,
            icon: const Icon(Icons.refresh),
            label: Text(
              'Play Again',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onGoHome,
            icon: const Icon(Icons.home),
            label: Text(
              'Go Home',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
