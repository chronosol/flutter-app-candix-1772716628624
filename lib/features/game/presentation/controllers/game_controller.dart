import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candix/core/constants/app_constants.dart';
import 'package:candix/features/game/data/models/candy_model.dart';
import 'package:candix/features/game/domain/entities/candy.dart';
import 'package:candix/features/game/domain/entities/game_board.dart';
import 'package:candix/features/game/domain/entities/game_state.dart';
import 'package:candix/features/game/domain/repositories/game_repository.dart';
import 'package:candix/features/game/data/repositories/game_repository_impl.dart';

class GameController extends AsyncNotifier<GameState> {
  late GameRepository _gameRepository;
  final Random _random = Random();

  @override
  Future<GameState> build() async {
    _gameRepository = ref.watch(gameRepositoryProvider);
    return _initializeNewGame();
  }

  GameState _initializeNewGame() {
    final candies = List<Candy>.generate(
      AppConstants.boardSize * AppConstants.boardSize,
      (index) => CandyModel.random(),
    );
    final initialBoard = GameBoard(candies: candies, size: AppConstants.boardSize);

    // Ensure no initial matches
    GameBoard boardWithoutMatches = _removeInitialMatches(initialBoard);

    return GameState(
      board: boardWithoutMatches,
      score: AppConstants.initialScore,
      movesLeft: AppConstants.initialMoves,
      level: 1,
      status: GameStatus.playing,
      selectedCandyIndex: null,
    );
  }

  GameBoard _removeInitialMatches(GameBoard board) {
    List<Candy> newCandies = List.from(board.candies);
    bool hasMatches;
    do {
      hasMatches = false;
      final matches = _findMatches(GameBoard(candies: newCandies, size: board.size));
      if (matches.isNotEmpty) {
        hasMatches = true;
        for (final index in matches) {
          newCandies[index] = CandyModel.random(); // Replace with a new random candy
        }
      }
    } while (hasMatches);
    return board.copyWith(candies: newCandies);
  }

  void selectCandy(int index) {
    if (state.value!.status != GameStatus.playing) return;

    final currentSelected = state.value!.selectedCandyIndex;
    if (currentSelected == null) {
      state = AsyncValue.data(state.value!.copyWith(selectedCandyIndex: index));
    } else if (currentSelected == index) {
      state = AsyncValue.data(state.value!.copyWith(selectedCandyIndex: null));
    } else {
      _trySwap(currentSelected, index);
    }
  }

  void _trySwap(int index1, int index2) async {
    final currentState = state.value!;
    final board = currentState.board;
    final size = board.size;

    final row1 = index1 ~/ size;
    final col1 = index1 % size;
    final row2 = index2 ~/ size;
    final col2 = index2 % size;

    // Check if candies are adjacent
    final isAdjacent = (row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1);

    if (!isAdjacent) {
      state = AsyncValue.data(currentState.copyWith(selectedCandyIndex: null));
      return;
    }

    // Perform the swap visually first
    List<Candy> newCandies = List.from(board.candies);
    final temp = newCandies[index1];
    newCandies[index1] = newCandies[index2];
    newCandies[index2] = temp;

    state = AsyncValue.data(currentState.copyWith(
      board: board.copyWith(candies: newCandies),
      selectedCandyIndex: null,
    ));

    // Wait for a short duration for the swap animation to play
    await Future.delayed(AppConstants.swapAnimationDuration);

    // Check for matches after swap
    final matches = _findMatches(GameBoard(candies: newCandies, size: size));

    if (matches.isNotEmpty) {
      _processMatches(matches);
    } else {
      // No matches, revert the swap
      List<Candy> revertedCandies = List.from(board.candies);
      state = AsyncValue.data(currentState.copyWith(
        board: board.copyWith(candies: revertedCandies),
      ));
    }
  }

  void _processMatches(Set<int> matches) async {
    final currentState = state.value!;
    int currentScore = currentState.score;
    int currentMoves = currentState.movesLeft;

    // Calculate score
    currentScore += matches.length * AppConstants.scorePerMatch;

    // Mark candies for removal (e.g., replace with empty)
    List<Candy> candiesAfterMatch = List.from(currentState.board.candies);
    for (final index in matches) {
      candiesAfterMatch[index] = Candy.empty();
    }

    state = AsyncValue.data(currentState.copyWith(
      board: currentState.board.copyWith(candies: candiesAfterMatch),
      score: currentScore,
      movesLeft: currentMoves - 1,
    ));

    await Future.delayed(AppConstants.matchAnimationDuration); // Wait for match animation

    // Apply gravity and refill
    _applyGravityAndRefill();
  }

  void _applyGravityAndRefill() async {
    final currentState = state.value!;
    final board = currentState.board;
    final size = board.size;
    List<Candy> newCandies = List.from(board.candies);

    // Apply gravity
    for (int col = 0; col < size; col++) {
      List<Candy> columnCandies = [];
      for (int row = size - 1; row >= 0; row--) {
        final index = row * size + col;
        if (newCandies[index].type != CandyType.empty) {
          columnCandies.add(newCandies[index]);
        }
      }
      // Fill empty spaces at the top
      while (columnCandies.length < size) {
        columnCandies.insert(0, CandyModel.random());
      }
      // Update the board with the new column
      for (int row = 0; row < size; row++) {
        final index = row * size + col;
        newCandies[index] = columnCandies[size - 1 - row];
      }
    }

    state = AsyncValue.data(currentState.copyWith(
      board: board.copyWith(candies: newCandies),
    ));

    await Future.delayed(AppConstants.fallAnimationDuration); // Wait for fall animation

    // Check for cascading matches
    final newMatches = _findMatches(GameBoard(candies: newCandies, size: size));
    if (newMatches.isNotEmpty) {
      _processMatches(newMatches); // Recursive call for cascades
    } else {
      // No more matches, check game over conditions
      _checkGameOver();
    }
  }

  Set<int> _findMatches(GameBoard board) {
    final matches = <int>{};
    final size = board.size;
    final candies = board.candies;

    // Check horizontal matches
    for (int row = 0; row < size; row++) {
      for (int col = 0; col <= size - AppConstants.minMatchLength; col++) {
        final firstCandy = candies[row * size + col];
        if (firstCandy.type == CandyType.empty) continue;

        int matchCount = 1;
        for (int k = 1; k < AppConstants.minMatchLength; k++) {
          if (candies[row * size + col + k].type == firstCandy.type) {
            matchCount++;
          } else {
            break;
          }
        }
        if (matchCount >= AppConstants.minMatchLength) {
          for (int k = 0; k < matchCount; k++) {
            matches.add(row * size + col + k);
          }
        }
      }
    }

    // Check vertical matches
    for (int col = 0; col < size; col++) {
      for (int row = 0; row <= size - AppConstants.minMatchLength; row++) {
        final firstCandy = candies[row * size + col];
        if (firstCandy.type == CandyType.empty) continue;

        int matchCount = 1;
        for (int k = 1; k < AppConstants.minMatchLength; k++) {
          if (candies[(row + k) * size + col].type == firstCandy.type) {
            matchCount++;
          } else {
            break;
          }
        }
        if (matchCount >= AppConstants.minMatchLength) {
          for (int k = 0; k < matchCount; k++) {
            matches.add((row + k) * size + col);
          }
        }
      }
    }
    return matches;
  }

  void _checkGameOver() async {
    final currentState = state.value!;
    if (currentState.movesLeft <= 0) {
      await _gameRepository.saveHighScore(currentState.score);
      state = AsyncValue.data(currentState.copyWith(status: GameStatus.gameOver));
    } else {
      // TODO: Implement check for no more possible moves
      // For now, just continue if moves are left
    }
  }

  void resetGame() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => _initializeNewGame());
  }
}

final gameControllerProvider = AsyncNotifierProvider<GameController, GameState>(
  GameController.new,
);
