import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/features/game/domain/entities/candy.dart';
import 'package:candix/features/game/presentation/controllers/game_controller.dart';

class CandyTileWidget extends ConsumerWidget {
  final Candy? candy;
  final int row;
  final int col;
  final double size;

  const CandyTileWidget({
    super.key,
    required this.candy,
    required this.row,
    required this.col,
    this.size = 60.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCandy = ref.watch(selectedCandyProvider);
    final isSelected = selectedCandy != null && selectedCandy.$1 == row && selectedCandy.$2 == col;

    return GestureDetector(
      onTap: () {
        ref.read(gameControllerProvider.notifier).selectCandy(row, col);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: candy?.color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary, width: 4)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Center(
          child: candy == null
              ? null
              : Icon(
                  _getCandyIcon(candy!.type),
                  color: candy!.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  size: size * 0.6,
                ),
        ),
      ).animate(
        // Example animation for new candies or movement
        key: ValueKey('${candy?.id ?? 'empty'}-$row-$col'), // Unique key for animation
      ).scale(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        begin: const Offset(0.8, 0.8), // Fixed: Offset expects dx, dy
        end: const Offset(1.0, 1.0),   // Fixed: Offset expects dx, dy
      ).fadeIn(
        duration: const Duration(milliseconds: 150),
      ),
    );
  }

  IconData _getCandyIcon(CandyType type) {
    switch (type) {
      case CandyType.normal:
        return Icons.circle;
      case CandyType.striped:
        return Icons.linear_scale;
      case CandyType.wrapped:
        return Icons.square;
      case CandyType.bomb:
        return Icons.flare;
      case CandyType.jelly:
        return Icons.bubble_chart;
    }
  }
}
