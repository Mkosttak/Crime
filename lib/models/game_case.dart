import 'package:json_annotation/json_annotation.dart';

part 'game_case.g.dart';

@JsonSerializable()
class DialogOption {
  final String id;
  final String text;
  final String response;
  final bool isUnlocked;

  const DialogOption({
    required this.id,
    required this.text,
    required this.response,
    this.isUnlocked = true,
  });

  factory DialogOption.fromJson(Map<String, dynamic> json) => _$DialogOptionFromJson(json);
  Map<String, dynamic> toJson() => _$DialogOptionToJson(this);
}

enum CaseStatus {
  available,
  accepted,
  crimeSceneReviewed,
  autopsyReviewed,
  evidenceReviewed,
  witnessInterviewed,
  suspectsInterrogated,
  inProgress,
  readyToSolve,
  completed,
  failed
}

enum CaseDifficulty {
  easy,
  medium,
  hard,
  expert
}

@JsonSerializable()
class GameCase {
  final String id;
  final String title;
  final String description;
  final String summary;
  final CaseDifficulty difficulty;
  final CaseStatus status;
  final DateTime dateCreated;
  final String location;
  final String victimName;
  final List<Evidence> evidence;
  final List<Witness> witnesses;
  final List<Suspect> suspects;
  final CrimeSceneReport? crimeSceneReport;
  final AutopsyReport? autopsyReport;
  final String? solution;
  final List<String> unlockedClues;
  final Map<String, dynamic> gameData;
  final int rewardExperience;
  final int requiredFocusPoints;

  const GameCase({
    required this.id,
    required this.title,
    required this.description,
    required this.summary,
    this.difficulty = CaseDifficulty.easy,
    this.status = CaseStatus.available,
    required this.dateCreated,
    required this.location,
    required this.victimName,
    this.evidence = const [],
    this.witnesses = const [],
    this.suspects = const [],
    this.crimeSceneReport,
    this.autopsyReport,
    this.solution,
    this.unlockedClues = const [],
    this.gameData = const {},
    this.rewardExperience = 50,
    this.requiredFocusPoints = 10,
  });

  factory GameCase.fromJson(Map<String, dynamic> json) => _$GameCaseFromJson(json);
  Map<String, dynamic> toJson() => _$GameCaseToJson(this);

  GameCase copyWith({
    String? id,
    String? title,
    String? description,
    String? summary,
    CaseDifficulty? difficulty,
    CaseStatus? status,
    DateTime? dateCreated,
    String? location,
    String? victimName,
    List<Evidence>? evidence,
    List<Witness>? witnesses,
    List<Suspect>? suspects,
    CrimeSceneReport? crimeSceneReport,
    AutopsyReport? autopsyReport,
    String? solution,
    List<String>? unlockedClues,
    Map<String, dynamic>? gameData,
    int? rewardExperience,
    int? requiredFocusPoints,
  }) {
    return GameCase(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      summary: summary ?? this.summary,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      dateCreated: dateCreated ?? this.dateCreated,
      location: location ?? this.location,
      victimName: victimName ?? this.victimName,
      evidence: evidence ?? this.evidence,
      witnesses: witnesses ?? this.witnesses,
      suspects: suspects ?? this.suspects,
      crimeSceneReport: crimeSceneReport ?? this.crimeSceneReport,
      autopsyReport: autopsyReport ?? this.autopsyReport,
      solution: solution ?? this.solution,
      unlockedClues: unlockedClues ?? this.unlockedClues,
      gameData: gameData ?? this.gameData,
      rewardExperience: rewardExperience ?? this.rewardExperience,
      requiredFocusPoints: requiredFocusPoints ?? this.requiredFocusPoints,
    );
  }

  // İlerleme hesaplaması
  double get progressPercentage {
    const totalSteps = 6;
    int completedSteps = 0;
    
    if (status.index >= CaseStatus.crimeSceneReviewed.index) completedSteps++;
    if (status.index >= CaseStatus.autopsyReviewed.index) completedSteps++;
    if (status.index >= CaseStatus.evidenceReviewed.index) completedSteps++;
    if (status.index >= CaseStatus.witnessInterviewed.index) completedSteps++;
    if (status.index >= CaseStatus.suspectsInterrogated.index) completedSteps++;
    if (status.index >= CaseStatus.completed.index) completedSteps++;
    
    return completedSteps / totalSteps;
  }

  bool get isCompleted => status == CaseStatus.completed;
  bool get isActive => status != CaseStatus.available && status != CaseStatus.completed && status != CaseStatus.failed;
}

@JsonSerializable()
class Evidence {
  final String id;
  final String name;
  final String description;
  final String type;
  final String location;
  final bool isAnalyzed;
  final String? analysisResult;
  final String? imageUrl;

  const Evidence({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.location,
    this.isAnalyzed = false,
    this.analysisResult,
    this.imageUrl,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) => _$EvidenceFromJson(json);
  Map<String, dynamic> toJson() => _$EvidenceToJson(this);

  Evidence copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? location,
    bool? isAnalyzed,
    String? analysisResult,
    String? imageUrl,
  }) {
    return Evidence(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      location: location ?? this.location,
      isAnalyzed: isAnalyzed ?? this.isAnalyzed,
      analysisResult: analysisResult ?? this.analysisResult,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

@JsonSerializable()
class Witness {
  final String id;
  final String name;
  final String description;
  final String statement;
  final bool isInterviewed;
  final List<String> questions;
  final List<String> answers;
  final String? imageUrl;
  final List<DialogOption> dialogOptions;
  final Map<String, String> dialogResponses;

  const Witness({
    required this.id,
    required this.name,
    required this.description,
    required this.statement,
    this.isInterviewed = false,
    this.questions = const [],
    this.answers = const [],
    this.imageUrl,
    this.dialogOptions = const [],
    this.dialogResponses = const {},
  });

  factory Witness.fromJson(Map<String, dynamic> json) => _$WitnessFromJson(json);
  Map<String, dynamic> toJson() => _$WitnessToJson(this);

  Witness copyWith({
    String? id,
    String? name,
    String? description,
    String? statement,
    bool? isInterviewed,
    List<String>? questions,
    List<String>? answers,
    String? imageUrl,
  }) {
    return Witness(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      statement: statement ?? this.statement,
      isInterviewed: isInterviewed ?? this.isInterviewed,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

@JsonSerializable()
class Suspect {
  final String id;
  final String name;
  final String description;
  final String alibi;
  final String relationship;
  final String motive;
  final bool isInterrogated;
  final List<String> questions;
  final List<String> answers;
  final String? imageUrl;
  final int suspicionLevel;

  const Suspect({
    required this.id,
    required this.name,
    required this.description,
    required this.alibi,
    required this.relationship,
    required this.motive,
    this.isInterrogated = false,
    this.questions = const [],
    this.answers = const [],
    this.imageUrl,
    this.suspicionLevel = 0,
  });

  factory Suspect.fromJson(Map<String, dynamic> json) => _$SuspectFromJson(json);
  Map<String, dynamic> toJson() => _$SuspectToJson(this);

  Suspect copyWith({
    String? id,
    String? name,
    String? description,
    String? alibi,
    String? relationship,
    String? motive,
    bool? isInterrogated,
    List<String>? questions,
    List<String>? answers,
    String? imageUrl,
    int? suspicionLevel,
  }) {
    return Suspect(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      alibi: alibi ?? this.alibi,
      relationship: relationship ?? this.relationship,
      motive: motive ?? this.motive,
      isInterrogated: isInterrogated ?? this.isInterrogated,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      imageUrl: imageUrl ?? this.imageUrl,
      suspicionLevel: suspicionLevel ?? this.suspicionLevel,
    );
  }
}

@JsonSerializable()
class CrimeSceneReport {
  final String id;
  final String description;
  final String timeOfCrime;
  final String weatherConditions;
  final String observations; // Changed from List<String> to String
  final List<String> foundItems; // Added foundItems
  final List<String> photographs;
  final Map<String, dynamic> details;

  const CrimeSceneReport({
    required this.id,
    required this.description,
    required this.timeOfCrime,
    required this.weatherConditions,
    required this.observations,
    this.foundItems = const [],
    this.photographs = const [],
    this.details = const {},
  });

  factory CrimeSceneReport.fromJson(Map<String, dynamic> json) => _$CrimeSceneReportFromJson(json);
  Map<String, dynamic> toJson() => _$CrimeSceneReportToJson(this);
}

@JsonSerializable()
class AutopsyReport {
  final String id;
  final String victimName;
  final String causeOfDeath;
  final String timeOfDeath;
  final String bodyCondition;
  final List<String> findings;
  final List<String> toxicologyResults;
  final Map<String, dynamic> details;

  const AutopsyReport({
    required this.id,
    required this.victimName,
    required this.causeOfDeath,
    required this.timeOfDeath,
    required this.bodyCondition,
    this.findings = const [],
    this.toxicologyResults = const [],
    this.details = const {},
  });

  factory AutopsyReport.fromJson(Map<String, dynamic> json) => _$AutopsyReportFromJson(json);
  Map<String, dynamic> toJson() => _$AutopsyReportToJson(this);
}
