import 'package:json_annotation/json_annotation.dart';

part 'detective.g.dart';

@JsonSerializable()
class Detective {
  final String id;
  final String name;
  final int level;
  final int experience;
  final int focusPoints;
  final int maxFocusPoints;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final Map<String, dynamic> stats;
  
  const Detective({
    required this.id,
    required this.name,
    this.level = 1,
    this.experience = 0,
    this.focusPoints = 100,
    this.maxFocusPoints = 100,
    required this.createdAt,
    required this.lastLoginAt,
    this.stats = const {},
  });

  factory Detective.fromJson(Map<String, dynamic> json) => _$DetectiveFromJson(json);
  Map<String, dynamic> toJson() => _$DetectiveToJson(this);

  Detective copyWith({
    String? id,
    String? name,
    int? level,
    int? experience,
    int? focusPoints,
    int? maxFocusPoints,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? stats,
  }) {
    return Detective(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      focusPoints: focusPoints ?? this.focusPoints,
      maxFocusPoints: maxFocusPoints ?? this.maxFocusPoints,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      stats: stats ?? this.stats,
    );
  }

  // Seviye hesaplama
  int get experienceToNextLevel {
    return (level * 100) - experience;
  }

  // Fokus puanı yenilenme süresini hesapla
  int get minutesToFullFocus {
    final missing = maxFocusPoints - focusPoints;
    return missing * 5; // Her 5 dakikada 1 puan
  }

  // İstatistikler
  int get casesCompleted => stats['cases_completed'] ?? 0;
  int get correctDeductions => stats['correct_deductions'] ?? 0;
  int get totalDeductions => stats['total_deductions'] ?? 0;
  double get accuracy => totalDeductions > 0 ? correctDeductions / totalDeductions : 0.0;
}
