import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/features/game/domain/entities/candy.dart';
import 'package:candix/features/game/domain/entities/game_board.dart';
import 'package:candix/features/game/data/repositories/game_repository_impl.dart';

abstract class GameRepository {
  Future<GameBoard> initializeBoard({int rows = 8, int cols = 8});
  List<Set<(int, int)>> findMatches(GameBoard board);
  (GameBoard, int) removeMatches(GameBoard board, List<Set<(int, int)>> matches);
  GameBoard dropCandies(GameBoard board);
  GameBoard fillEmptySpaces(
    GameBoard board,
    CandyType Function() generateRandomCandyType,
    Color Function() generateRandomCandyColor,
  );
  // Future<void> saveGameState(GameState state);
  // Future<GameState?> loadGameState();
}

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepositoryImpl();
});
