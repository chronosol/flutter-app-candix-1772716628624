import 'package:flutter/material.dart';

enum CandyType {
  red,
  blue,
  green,
  yellow,
  purple,
  orange,
  empty, // Represents an empty slot after a match
}

class Candy {
  final String id;
  final CandyType type;
  final Color color;

  const Candy({
    required this.id,
    required this.type,
    required this.color,
  });

  Candy copyWith({
    String? id,
    CandyType? type,
    Color? color,
  }) {
    return Candy(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Candy &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;

  @override
  String toString() => 'Candy(id: $id, type: $type)';

  static Candy empty() => Candy(
        id: 'empty_${DateTime.now().microsecondsSinceEpoch}',
        type: CandyType.empty,
        color: Colors.transparent,
      );
}
