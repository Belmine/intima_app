import 'package:uuid/uuid.dart';

/// Modèle de profil utilisateur
class UserProfile {
  final String id;
  final String ageRange;
  final bool hasFirstPeriod;
  final bool hasMenopause;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    String? id,
    required this.ageRange,
    required this.hasFirstPeriod,
    required this.hasMenopause,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Convertir en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age_range': ageRange,
      'has_first_period': hasFirstPeriod ? 1 : 0,
      'has_menopause': hasMenopause ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Créer depuis Map (SQLite)
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      ageRange: map['age_range'] as String,
      hasFirstPeriod: (map['has_first_period'] as int) == 1,
      hasMenopause: (map['has_menopause'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Copier avec modifications
  UserProfile copyWith({
    String? id,
    String? ageRange,
    bool? hasFirstPeriod,
    bool? hasMenopause,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      ageRange: ageRange ?? this.ageRange,
      hasFirstPeriod: hasFirstPeriod ?? this.hasFirstPeriod,
      hasMenopause: hasMenopause ?? this.hasMenopause,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, ageRange: $ageRange, hasFirstPeriod: $hasFirstPeriod, hasMenopause: $hasMenopause)';
  }
}