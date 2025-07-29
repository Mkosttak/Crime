// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detective.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Detective _$DetectiveFromJson(Map<String, dynamic> json) => Detective(
  id: json['id'] as String,
  name: json['name'] as String,
  level: (json['level'] as num?)?.toInt() ?? 1,
  experience: (json['experience'] as num?)?.toInt() ?? 0,
  focusPoints: (json['focusPoints'] as num?)?.toInt() ?? 100,
  maxFocusPoints: (json['maxFocusPoints'] as num?)?.toInt() ?? 100,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
  stats: json['stats'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$DetectiveToJson(Detective instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'level': instance.level,
  'experience': instance.experience,
  'focusPoints': instance.focusPoints,
  'maxFocusPoints': instance.maxFocusPoints,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastLoginAt': instance.lastLoginAt.toIso8601String(),
  'stats': instance.stats,
};
