import 'package:candix/features/game/domain/entities/candy.dart';
import 'package:flutter/material.dart';
import 'package:candix/core/constants/app_constants.dart';

// For simplicity, CandyModel is identical to Candy entity.
// In a real app, this might include toJson/fromJson methods for persistence.
class CandyModel extends Candy {
  const CandyModel({
    required super.id,
    required super.type,
    required super.color,
  });

  factory CandyModel.fromType(CandyType type) {
    return CandyModel(
      id: 'candy_${type.name}_${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      color: AppConstants.candyColors[type.index],
    );
  }

  factory CandyModel.random() {
    final randomTypeIndex = DateTime.now().microsecondsSinceEpoch % AppConstants.maxCandyTypes;
    final type = CandyType.values[randomTypeIndex];
    return CandyModel.fromType(type);
  }

  // Example of how to convert to/from JSON if needed for persistence
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'colorValue': color.value,
      };

  factory CandyModel.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String;
    final type = CandyType.values.firstWhere((e) => e.name == typeName);
    final color = Color(json['colorValue'] as int);
    return CandyModel(
      id: json['id'] as String,
      type: type,
      color: color,
    );
  }
}
