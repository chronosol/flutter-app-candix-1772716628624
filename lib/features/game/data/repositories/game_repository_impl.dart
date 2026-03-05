import 'dart:math';
import 'package:flutter/material.dart';
import 'package:candix/features/game/domain/entities/candy.dart';
import 'package:candix/features/game/domain/entities/game_board.dart';
import 'package:candix/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final Random _random = Random();

  // Helper to generate a random candy type
  CandyType _generateRandomCandyType() {
    return CandyType.values[_random.nextInt(CandyType.values.length)];
  }

  // Helper to generate a random candy color
  Color _generateRandomCandyColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  Future<GameBoard> initializeBoard({int rows = 8, int cols = 8}) async {
    final List<List<Candy?>> candies = List.generate(
      rows,
      (r) => List.generate(
        cols,
        (c) => null, // Initialize with nulls, then fill
      ),
    );

    // Fill the board, ensuring no initial matches
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        Candy? newCandy;
        do {
          newCandy = Candy(
            id: '${r}_${c}_${_random.nextDouble()}',
            type: _generateRandomCandyType(),
            color: _generateRandomCandyColor(),
          );
          candies[r][c] = newCandy;
        } while (_hasMatchAt(candies, r, c)); // Regenerate if it creates an immediate match
      }
    }
    return GameBoard(candies: candies);
  }

  bool _hasMatchAt(List<List<Candy?>> board, int r, int c) {
    final candy = board[r][c];
    if (candy == null) return false;

    // Check horizontal matches
    int horizontalCount = 1;
    for (int i = c - 1; i >= 0 && board[r][i]?.color == candy.color; i--) {
      horizontalCount++;
    }
    for (int i = c + 1; i < board[r].length && board[r][i]?.color == candy.color; i++) {
      horizontalCount++;
    }
    if (horizontalCount >= 3) return true;

    // Check vertical matches
    int verticalCount = 1;
    for (int i = r - 1; i >= 0 && board[i][c]?.color == candy.color; i--) {
      verticalCount++;
    }
    for (int i = r + 1; i < board.length && board[i][c]?.color == candy.color; i++) {
      verticalCount++;
    }
    if (verticalCount >= 3) return true;

    return false;
  }

  @override
  List<Set<(int, int)>> findMatches(GameBoard board) {
    final List<Set<(int, int)>> allMatches = [];
    final int rows = board.candies.length;
    final int cols = board.candies[0].length;

    // Check horizontal matches
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols - 2; c++) {
        final candy1 = board.candies[r][c];
        final candy2 = board.candies[r][c + 1];
        final candy3 = board.candies[r][c + 2];

        if (candy1 != null && candy2 != null && candy3 != null &&
            candy1.color == candy2.color && candy2.color == candy3.color) {
          final match = <(int, int)>{(r, c), (r, c + 1), (r, c + 2)};
          // Extend match to include more if available
          for (int i = c + 3; i < cols && board.candies[r][i]?.color == candy1.color; i++) {
            match.add((r, i));
          }
          allMatches.add(match);
          c += match.length - 1; // Skip already matched candies
        }
      }
    }

    // Check vertical matches
    for (int c = 0; c < cols; c++) {
      for (int r = 0; r < rows - 2; r++) {
        final candy1 = board.candies[r][c];
        final candy2 = board.candies[r + 1][c];
        final candy3 = board.candies[r + 2][c];

        if (candy1 != null && candy2 != null && candy3 != null &&
            candy1.color == candy2.color && candy2.color == candy3.color) {
          final match = <(int, int)>{(r, c), (r + 1, c), (r + 2, c)};
          // Extend match to include more if available
          for (int i = r + 3; i < rows && board.candies[i][c]?.color == candy1.color; i++) {
            match.add((i, c));
          }
          allMatches.add(match);
          r += match.length - 1; // Skip already matched candies
        }
      }
    }

    // Merge overlapping matches
    final mergedMatches = <Set<(int, int)>>{};
    for (final match in allMatches) {
      bool merged = false;
      for (final existingMatch in mergedMatches) {
        if (existingMatch.intersection(match).isNotEmpty) {
          existingMatch.addAll(match);
          merged = true;
          break;
        }
      }
      if (!merged) {
        mergedMatches.add(match);
      }
    }

    return mergedMatches.toList();
  }

  @override
  (GameBoard, int) removeMatches(GameBoard board, List<Set<(int, int)>> matches) {
    final newCandies = List<List<Candy?>>.from(board.candies.map((row) => List<Candy?>.from(row)));
    int scoreIncrease = 0;

    for (final match in matches) {
      for (final (r, c) in match) {
        if (newCandies[r][c] != null) {
          newCandies[r][c] = null; // Remove candy
          scoreIncrease += 10; // Example score for each removed candy
        }
      }
    }
    return (GameBoard(candies: newCandies), scoreIncrease);
  }

  @override
  GameBoard dropCandies(GameBoard board) {
    final newCandies = List<List<Candy?>>.from(board.candies.map((row) => List<Candy?>.from(row)));
    final int rows = newCandies.length;
    final int cols = newCandies[0].length;

    for (int c = 0; c < cols; c++) {
      int writeRow = rows - 1;
      for (int r = rows - 1; r >= 0; r--) {
        if (newCandies[r][c] != null) {
          if (writeRow != r) {
            newCandies[writeRow][c] = newCandies[r][c];
            newCandies[r][c] = null; // Set the old position to null
          }
          writeRow--;
        }
      }
    }
    return GameBoard(candies: newCandies);
  }

  @override
  GameBoard fillEmptySpaces(
    GameBoard board,
    CandyType Function() generateRandomCandyType,
    Color Function() generateRandomCandyColor,
  ) {
    final newCandies = List<List<Candy?>>.from(board.candies.map((row) => List<Candy?>.from(row)));
    final int rows = newCandies.length;
    final int cols = newCandies[0].length;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (newCandies[r][c] == null) {
          newCandies[r][c] = Candy(
            id: '${r}_${c}_${_random.nextDouble()}',
            type: generateRandomCandyType(),
            color: generateRandomCandyColor(),
          );
        }
      }
    }
    return GameBoard(candies: newCandies);
  }
}
