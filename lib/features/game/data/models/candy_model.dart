import 'package:flutter/material.dart';
import 'package:candix/features/game/domain/entities/candy.dart';

class CandyModel extends Candy {
  const CandyModel({
    required super.id,
    required super.type,
    required super.color,
  });

  factory CandyModel.fromJson(Map<String, dynamic> json) {
    return CandyModel(
      id: json['id'] as String,
      type: CandyType.values.firstWhere(
        (e) => e.toString() == 'CandyType.${json['type']}',
        orElse: () => CandyType.normal,
      ),
      color: Color(json['color'] as int), // Assuming color is stored as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'color': color.toARGB(), // Fixed: Use toARGB() instead of .value
    };
  }

  CandyModel copyWith({
    String? id,
    CandyType? type,
    Color? color,
  }) {
    return CandyModel(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }
}
