import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:candix/features/game/domain/entities/candy.dart';

class CandyTileWidget extends StatelessWidget {
  final Candy candy;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;
  final bool isMatched;

  const CandyTileWidget({
    super.key,
    required this.candy,
    required this.isSelected,
    required this.onTap,
    required this.size,
    this.isMatched = false,
  });

  @override
  Widget build(BuildContext context) {
    if (candy.type == CandyType.empty) {
      return SizedBox.square(dimension: size);
    }

    return GestureDetector(
      onTap: onTap,
      child: Animate(
        effects: isMatched
            ? [FadeEffect(duration: 300.ms), ScaleEffect(begin: 1.0, end: 0.0, duration: 300.ms)]
            : [],
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: candy.color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 4)
                : null,
            boxShadow: [if (isSelected) BoxShadow(color: candy.color, blurRadius: 8)],
          ),
          child: Center(
            child: Icon(
              _getIconForCandyType(candy.type),
              color: Colors.white,
              size: size * 0.6,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForCandyType(CandyType type) {
    switch (type) {
      case CandyType.red: return Icons.favorite;
      case CandyType.blue: return Icons.star;
      case CandyType.green: return Icons.grass;
      case CandyType.yellow: return Icons.sunny;
      case CandyType.purple: return Icons.diamond;
      case CandyType.orange: return Icons.circle;
      case CandyType.empty: return Icons.close;
    }
  }
}
