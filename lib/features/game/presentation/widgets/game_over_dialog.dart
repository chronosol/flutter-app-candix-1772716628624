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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colorScheme.surface,
      title: Text(
        'Game Over!',
        style: textTheme.headlineMedium?.copyWith(color: colorScheme.error),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Your Score: $score',
            style: textTheme.displaySmall?.copyWith(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onPlayAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Play Again'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onGoHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.primary),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Go Home'),
          ),
        ],
      ),
    );
  }
}
