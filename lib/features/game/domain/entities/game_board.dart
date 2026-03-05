import 'package:candix/features/game/domain/entities/candy.dart';

class GameBoard {
  final List<Candy> candies;
  final int size;

  const GameBoard({
    required this.candies,
    required this.size,
  });

  GameBoard copyWith({
    List<Candy>? candies,
    int? size,
  }) {
    return GameBoard(
      candies: candies ?? this.candies,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameBoard &&
          runtimeType == other.runtimeType &&
          candies == other.candies &&
          size == other.size;

  @override
  int get hashCode => candies.hashCode ^ size.hashCode;

  @override
  String toString() => 'GameBoard(size: $size, candies: ${candies.length})';
}
