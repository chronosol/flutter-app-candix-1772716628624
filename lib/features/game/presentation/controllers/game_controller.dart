import 'dart:math';

import 'package:flutter/material.dart'; // Keep for Color
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/features/game/domain/entities/candy.dart';
import 'package:candix/features/game/domain/entities/game_board.dart';
import 'package:candix/features/game/domain/entities/game_state.dart';
import 'package:candix/features/game/domain/repositories/game_repository.dart';

class GameController extends AsyncNotifier<GameState> {
  final Random _random = Random();

  @override
  Future<GameState> build() async {
    final repository = ref.read(gameRepositoryProvider);
    final initialBoard = await repository.initializeBoard();
    return GameState(
      board: initialBoard,
      score: 0,
      movesLeft: 30, // Example initial moves
      isGameOver: false,
      selectedCandy: null,
    );
  }

  // Helper to generate a random candy type
  CandyType _generateRandomCandyType() {
    return CandyType.values[_random.nextInt(CandyType.values.length)];
  }

  // Helper to generate a random candy color
  Color _generateRandomCandyColor() {
    final colors = [
      Colors.red, // Example colors
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  // Initialize or reset the game
  Future<void> startGame() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(gameRepositoryProvider);
      final initialBoard = await repository.initializeBoard();
      return GameState(
        board: initialBoard,
        score: 0,
        movesLeft: 30,
        isGameOver: false,
        selectedCandy: null,
      );
    });
  }

  // Select a candy
  void selectCandy(int row, int col) {
    state.whenData((gameState) {
      if (gameState.isGameOver) return;

      if (gameState.selectedCandy == null) {
        // No candy selected, select this one
        state = AsyncValue.data(gameState.copyWith(
          selectedCandy: (row, col),
        ));
      } else {
        // A candy is already selected, try to swap
        final (selectedRow, selectedCol) = gameState.selectedCandy!;
        if ((selectedRow == row && (selectedCol - col).abs() == 1) ||
            (selectedCol == col && (selectedRow - row).abs() == 1)) {
          // Valid adjacent swap
          _performSwap(selectedRow, selectedCol, row, col);
        } else {
          // Invalid swap, or re-selecting the same candy, or selecting a non-adjacent candy
          state = AsyncValue.data(gameState.copyWith(selectedCandy: null));
        }
      }
    });
  }

  Future<void> _performSwap(int r1, int c1, int r2, int c2) async {
    state = await AsyncValue.guard(() async {
      final currentGameState = state.requireValue;
      if (currentGameState.movesLeft <= 0) {
        return currentGameState.copyWith(isGameOver: true);
      }

      final repository = ref.read(gameRepositoryProvider);
      final newBoardCandies = List<List<Candy?>>.from(currentGameState.board.candies.map((row) => List<Candy?>.from(row)));

      // Perform the swap in the board
      final temp = newBoardCandies[r1][c1];
      newBoardCandies[r1][c1] = newBoardCandies[r2][c2];
      newBoardCandies[r2][c2] = temp;

      final swappedBoard = GameBoard(candies: newBoardCandies);

      // Check for matches after swap
      final matches = repository.findMatches(swappedBoard);

      if (matches.isEmpty) {
        // No matches, swap back and decrement moves
        final tempBack = newBoardCandies[r1][c1];
        newBoardCandies[r1][c1] = newBoardCandies[r2][c2];
        newBoardCandies[r2][c2] = tempBack;
        return currentGameState.copyWith(
          board: GameBoard(candies: newBoardCandies),
          selectedCandy: null,
          movesLeft: currentGameState.movesLeft - 1,
        );
      } else {
        // Matches found, process them
        int currentScore = currentGameState.score;
        int movesRemaining = currentGameState.movesLeft - 1;

        // Loop until no more matches can be made
        GameBoard boardAfterMatches = swappedBoard;
        List<Set<(int, int)>> allMatches;
        do {
          allMatches = repository.findMatches(boardAfterMatches);
          if (allMatches.isNotEmpty) {
            // Remove matched candies and update score
            final (updatedBoard, scoreIncrease) = repository.removeMatches(boardAfterMatches, allMatches);
            currentScore += scoreIncrease;
            boardAfterMatches = updatedBoard;

            // Drop candies
            final boardAfterDrop = repository.dropCandies(boardAfterMatches);
            boardAfterMatches = boardAfterDrop;

            // Fill empty spaces with new candies
            final filledBoard = repository.fillEmptySpaces(boardAfterMatches, _generateRandomCandyType, _generateRandomCandyColor);
            boardAfterMatches = filledBoard;
          }
        } while (allMatches.isNotEmpty); // Continue as long as new matches are found

        return currentGameState.copyWith(
          board: boardAfterMatches,
          score: currentScore,
          movesLeft: movesRemaining,
          isGameOver: movesRemaining <= 0,
          selectedCandy: null,
        );
      }
    });
  }

  // Other game logic methods (e.g., check for game over, handle special candies)
  void checkGameOver() {
    state.whenData((gameState) {
      if (gameState.movesLeft <= 0 && !gameState.isGameOver) {
        state = AsyncValue.data(gameState.copyWith(isGameOver: true));
      }
    });
  }
}

final gameControllerProvider =
    AsyncNotifierProvider<GameController, GameState>(GameController.new);

final gameBoardProvider = Provider<GameBoard>((ref) {
  return ref.watch(gameControllerProvider.select((state) => state.value?.board ?? GameBoard(candies: [])));
});

final gameScoreProvider = Provider<int>((ref) {
  return ref.watch(gameControllerProvider.select((state) => state.value?.score ?? 0));
});

final gameMovesLeftProvider = Provider<int>((ref) {
  return ref.watch(gameControllerProvider.select((state) => state.value?.movesLeft ?? 0));
});

final isGameOverProvider = Provider<bool>((ref) {
  return ref.watch(gameControllerProvider.select((state) => state.value?.isGameOver ?? false));
});

final selectedCandyProvider = Provider<(int, int)?>((ref) {
  return ref.watch(gameControllerProvider.select((state) => state.value?.selectedCandy));
});
