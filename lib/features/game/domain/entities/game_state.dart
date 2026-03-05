import 'package:candix/features/game/domain/entities/game_board.dart';

enum GameStatus {
  playing,
  gameOver,
  levelComplete,
}

class GameState {
  final GameBoard board;
  final int score;
  final int movesLeft;
  final int level;
  final GameStatus status;
  final int? selectedCandyIndex;

  const GameState({
    required this.board,
    required this.score,
    required this.movesLeft,
    required this.level,
    required this.status,
    this.selectedCandyIndex,
  });

  GameState copyWith({
    GameBoard? board,
    int? score,
    int? movesLeft,
    int? level,
    GameStatus? status,
    int? selectedCandyIndex,
  }) {
    return GameState(
      board: board ?? this.board,
      score: score ?? this.score,
      movesLeft: movesLeft ?? this.movesLeft,
      level: level ?? this.level,
      status: status ?? this.status,
      selectedCandyIndex: selectedCandyIndex,
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
          level == other.level &&
          status == other.status &&
          selectedCandyIndex == other.selectedCandyIndex;

  @override
  int get hashCode =>
      board.hashCode ^
      score.hashCode ^
      movesLeft.hashCode ^
      level.hashCode ^
      status.hashCode ^
      selectedCandyIndex.hashCode;

  @override
  String toString() =>
      'GameState(score: $score, moves: $movesLeft, status: $status)';
}
