import 'package:candix/features/game/domain/entities/game_board.dart';

class GameState {
  final GameBoard board;
  final int score;
  final int movesLeft;
  final bool isGameOver;
  final (int, int)? selectedCandy; // (row, col) of selected candy

  const GameState({
    required this.board,
    required this.score,
    required this.movesLeft,
    required this.isGameOver,
    this.selectedCandy,
  });

  GameState copyWith({
    GameBoard? board,
    int? score,
    int? movesLeft,
    bool? isGameOver,
    (int, int)? selectedCandy,
  }) {
    return GameState(
      board: board ?? this.board,
      score: score ?? this.score,
      movesLeft: movesLeft ?? this.movesLeft,
      isGameOver: isGameOver ?? this.isGameOver,
      selectedCandy: selectedCandy ?? this.selectedCandy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          board == other.board &&
          score == other.score &&
          movesLeft == other.movesLeft &&
          isGameOver == other.isGameOver &&
          selectedCandy == other.selectedCandy;

  @override
  int get hashCode =>
      board.hashCode ^
      score.hashCode ^
      movesLeft.hashCode ^
      isGameOver.hashCode ^
      (selectedCandy?.hashCode ?? 0);

  @override
  String toString() =>
      'GameState(score: $score, movesLeft: $movesLeft, isGameOver: $isGameOver, selectedCandy: $selectedCandy)';
}
