// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialogOption _$DialogOptionFromJson(Map<String, dynamic> json) => DialogOption(
  id: json['id'] as String,
  text: json['text'] as String,
  response: json['response'] as String,
  isUnlocked: json['isUnlocked'] as bool? ?? true,
);

Map<String, dynamic> _$DialogOptionToJson(DialogOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'response': instance.response,
      'isUnlocked': instance.isUnlocked,
    };

GameCase _$GameCaseFromJson(Map<String, dynamic> json) => GameCase(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  summary: json['summary'] as String,
  difficulty:
      $enumDecodeNullable(_$CaseDifficultyEnumMap, json['difficulty']) ??
      CaseDifficulty.easy,
  status:
      $enumDecodeNullable(_$CaseStatusEnumMap, json['status']) ??
      CaseStatus.available,
  dateCreated: DateTime.parse(json['dateCreated'] as String),
  location: json['location'] as String,
  victimName: json['victimName'] as String,
  evidence:
      (json['evidence'] as List<dynamic>?)
          ?.map((e) => Evidence.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  witnesses:
      (json['witnesses'] as List<dynamic>?)
          ?.map((e) => Witness.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  suspects:
      (json['suspects'] as List<dynamic>?)
          ?.map((e) => Suspect.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  crimeSceneReport: json['crimeSceneReport'] == null
      ? null
      : CrimeSceneReport.fromJson(
          json['crimeSceneReport'] as Map<String, dynamic>,
        ),
  autopsyReport: json['autopsyReport'] == null
      ? null
      : AutopsyReport.fromJson(json['autopsyReport'] as Map<String, dynamic>),
  solution: json['solution'] as String?,
  unlockedClues:
      (json['unlockedClues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  gameData: json['gameData'] as Map<String, dynamic>? ?? const {},
  rewardExperience: (json['rewardExperience'] as num?)?.toInt() ?? 50,
  requiredFocusPoints: (json['requiredFocusPoints'] as num?)?.toInt() ?? 10,
);

Map<String, dynamic> _$GameCaseToJson(GameCase instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'summary': instance.summary,
  'difficulty': _$CaseDifficultyEnumMap[instance.difficulty]!,
  'status': _$CaseStatusEnumMap[instance.status]!,
  'dateCreated': instance.dateCreated.toIso8601String(),
  'location': instance.location,
  'victimName': instance.victimName,
  'evidence': instance.evidence,
  'witnesses': instance.witnesses,
  'suspects': instance.suspects,
  'crimeSceneReport': instance.crimeSceneReport,
  'autopsyReport': instance.autopsyReport,
  'solution': instance.solution,
  'unlockedClues': instance.unlockedClues,
  'gameData': instance.gameData,
  'rewardExperience': instance.rewardExperience,
  'requiredFocusPoints': instance.requiredFocusPoints,
};

const _$CaseDifficultyEnumMap = {
  CaseDifficulty.easy: 'easy',
  CaseDifficulty.medium: 'medium',
  CaseDifficulty.hard: 'hard',
  CaseDifficulty.expert: 'expert',
};

const _$CaseStatusEnumMap = {
  CaseStatus.available: 'available',
  CaseStatus.accepted: 'accepted',
  CaseStatus.crimeSceneReviewed: 'crimeSceneReviewed',
  CaseStatus.autopsyReviewed: 'autopsyReviewed',
  CaseStatus.evidenceReviewed: 'evidenceReviewed',
  CaseStatus.witnessInterviewed: 'witnessInterviewed',
  CaseStatus.suspectsInterrogated: 'suspectsInterrogated',
  CaseStatus.inProgress: 'inProgress',
  CaseStatus.readyToSolve: 'readyToSolve',
  CaseStatus.completed: 'completed',
  CaseStatus.failed: 'failed',
};

Evidence _$EvidenceFromJson(Map<String, dynamic> json) => Evidence(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: json['type'] as String,
  location: json['location'] as String,
  isAnalyzed: json['isAnalyzed'] as bool? ?? false,
  analysisResult: json['analysisResult'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$EvidenceToJson(Evidence instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'type': instance.type,
  'location': instance.location,
  'isAnalyzed': instance.isAnalyzed,
  'analysisResult': instance.analysisResult,
  'imageUrl': instance.imageUrl,
};

Witness _$WitnessFromJson(Map<String, dynamic> json) => Witness(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  statement: json['statement'] as String,
  isInterviewed: json['isInterviewed'] as bool? ?? false,
  questions:
      (json['questions'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  answers:
      (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  imageUrl: json['imageUrl'] as String?,
  dialogOptions:
      (json['dialogOptions'] as List<dynamic>?)
          ?.map((e) => DialogOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  dialogResponses:
      (json['dialogResponses'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$WitnessToJson(Witness instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'statement': instance.statement,
  'isInterviewed': instance.isInterviewed,
  'questions': instance.questions,
  'answers': instance.answers,
  'imageUrl': instance.imageUrl,
  'dialogOptions': instance.dialogOptions,
  'dialogResponses': instance.dialogResponses,
};

Suspect _$SuspectFromJson(Map<String, dynamic> json) => Suspect(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  alibi: json['alibi'] as String,
  relationship: json['relationship'] as String,
  motive: json['motive'] as String,
  isInterrogated: json['isInterrogated'] as bool? ?? false,
  questions:
      (json['questions'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  answers:
      (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  imageUrl: json['imageUrl'] as String?,
  suspicionLevel: (json['suspicionLevel'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SuspectToJson(Suspect instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'alibi': instance.alibi,
  'relationship': instance.relationship,
  'motive': instance.motive,
  'isInterrogated': instance.isInterrogated,
  'questions': instance.questions,
  'answers': instance.answers,
  'imageUrl': instance.imageUrl,
  'suspicionLevel': instance.suspicionLevel,
};

CrimeSceneReport _$CrimeSceneReportFromJson(Map<String, dynamic> json) =>
    CrimeSceneReport(
      id: json['id'] as String,
      description: json['description'] as String,
      timeOfCrime: json['timeOfCrime'] as String,
      weatherConditions: json['weatherConditions'] as String,
      observations: json['observations'] as String,
      foundItems:
          (json['foundItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      photographs:
          (json['photographs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      details: json['details'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$CrimeSceneReportToJson(CrimeSceneReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'timeOfCrime': instance.timeOfCrime,
      'weatherConditions': instance.weatherConditions,
      'observations': instance.observations,
      'foundItems': instance.foundItems,
      'photographs': instance.photographs,
      'details': instance.details,
    };

AutopsyReport _$AutopsyReportFromJson(Map<String, dynamic> json) =>
    AutopsyReport(
      id: json['id'] as String,
      victimName: json['victimName'] as String,
      causeOfDeath: json['causeOfDeath'] as String,
      timeOfDeath: json['timeOfDeath'] as String,
      bodyCondition: json['bodyCondition'] as String,
      findings:
          (json['findings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      toxicologyResults:
          (json['toxicologyResults'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      details: json['details'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$AutopsyReportToJson(AutopsyReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'victimName': instance.victimName,
      'causeOfDeath': instance.causeOfDeath,
      'timeOfDeath': instance.timeOfDeath,
      'bodyCondition': instance.bodyCondition,
      'findings': instance.findings,
      'toxicologyResults': instance.toxicologyResults,
      'details': instance.details,
    };
