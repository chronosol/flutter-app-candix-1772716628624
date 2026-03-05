import 'package:flutter/material.dart';

class AppConstants {
  static const int boardSize = 8; // 8x8 board
  static const int minMatchLength = 3;
  static const int maxCandyTypes = 6;

  static const List<Color> candyColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  static const int initialMoves = 30;
  static const int initialScore = 0;
  static const int scorePerMatch = 10;
  static const int scorePerBonusCandy = 20;

  static const Duration swapAnimationDuration = Duration(milliseconds: 150);
  static const Duration fallAnimationDuration = Duration(milliseconds: 200);
  static const Duration matchAnimationDuration = Duration(milliseconds: 300);
}
