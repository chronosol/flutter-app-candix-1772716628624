import 'package:candix/features/game/domain/entities/candy.dart';

class GameBoard {
  final List<List<Candy?>> candies; // Nullable for empty spots

  const GameBoard({required this.candies});

  GameBoard copyWith({
    List<List<Candy?>>? candies,
  }) {
    return GameBoard(
      candies: candies ?? this.candies,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameBoard &&
          runtimeType == other.runtimeType &&
          _listEquals(candies, other.candies);

  @override
  int get hashCode => _listHashCode(candies);

  bool _listEquals(List<List<Candy?>> a, List<List<Candy?>> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (int j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }
    return true;
  }

  int _listHashCode(List<List<Candy?>> list) {
    int hash = 0;
    for (final row in list) {
      for (final item in row) {
        hash = hash ^ (item?.hashCode ?? 0);
      }
    }
    return hash;
  }

  @override
  String toString() => 'GameBoard(rows: ${candies.length}, cols: ${candies.isNotEmpty ? candies[0].length : 0})';
}
