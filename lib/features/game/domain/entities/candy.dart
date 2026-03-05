import 'package:flutter/material.dart';

enum CandyType {
  normal,
  striped,
  wrapped,
  bomb,
  jelly, // Example special candy
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
          type == other.type &&
          color == other.color;

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ color.hashCode;

  @override
  String toString() => 'Candy(id: $id, type: $type, color: $color)';
}
