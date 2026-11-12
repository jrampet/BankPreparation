class Exam {
  const Exam({
    required this.id,
    required this.name,
    required this.shortName,
    required this.category,
  });

  final String id;
  final String name;
  final String shortName;
  final String category;
}

class ExamSection {
  const ExamSection({
    required this.name,
    required this.subjects,
    required this.description,
  });

  final String name;
  final List<String> subjects;
  final String description;
}

class ExamSyllabus {
  const ExamSyllabus({
    required this.examId,
    required this.sections,
    required this.sourceLabel,
    required this.sourceUrl,
    required this.sourceCheckedOn,
    required this.noticeCycle,
    required this.verificationNote,
  });

  final String examId;
  final List<ExamSection> sections;
  final String sourceLabel;
  final String sourceUrl;
  final String sourceCheckedOn;
  final String noticeCycle;
  final String verificationNote;

  List<String> get subjects =>
      sections.expand((section) => section.subjects).toSet().toList();
}

class StudyQuestion {
  const StudyQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int answerIndex;
  final String explanation;
}

class StudyTopic {
  const StudyTopic({
    required this.id,
    required this.title,
    required this.subject,
    required this.icon,
    required this.durationMinutes,
    required this.concept,
    required this.formula,
    required this.example,
    required this.questions,
  });

  final String id;
  final String title;
  final String subject;
  final String icon;
  final int durationMinutes;
  final String concept;
  final String formula;
  final String example;
  final List<StudyQuestion> questions;
}

class AssessmentResult {
  const AssessmentResult({
    required this.id,
    required this.examId,
    required this.title,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedQuestions,
    required this.score,
    required this.maxScore,
    required this.durationSeconds,
    required this.completedAt,
  });

  final String id;
  final String examId;
  final String title;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedQuestions;
  final double score;
  final double maxScore;
  final int durationSeconds;
  final String completedAt;

  int get accuracyPercent =>
      totalQuestions == 0 ? 0 : (100 * correctAnswers / totalQuestions).round();

  Map<String, Object?> toJson() => {
    'id': id,
    'examId': examId,
    'title': title,
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'wrongAnswers': wrongAnswers,
    'skippedQuestions': skippedQuestions,
    'score': score,
    'maxScore': maxScore,
    'durationSeconds': durationSeconds,
    'completedAt': completedAt,
  };

  factory AssessmentResult.fromJson(Map<String, dynamic> json) =>
      AssessmentResult(
        id: json['id'] as String,
        examId: json['examId'] as String,
        title: json['title'] as String,
        totalQuestions: json['totalQuestions'] as int,
        correctAnswers: json['correctAnswers'] as int,
        wrongAnswers: json['wrongAnswers'] as int,
        skippedQuestions: json['skippedQuestions'] as int,
        score: (json['score'] as num).toDouble(),
        maxScore: (json['maxScore'] as num).toDouble(),
        durationSeconds: json['durationSeconds'] as int,
        completedAt: json['completedAt'] as String,
      );
}

class Progress {
  const Progress({
    this.examId,
    this.targetExamDate,
    this.preparationLevel = 'Starting out',
    this.strongSubjects = const {},
    this.weakSubjects = const {},
    this.xp = 0,
    this.streak = 0,
    this.lastStudyDate,
    this.studySeconds = 0,
    this.todayStudySeconds = 0,
    this.dailyGoalMinutes = 30,
    this.questionsAnsweredCount = 0,
    this.questionsCorrectCount = 0,
    this.completedTopicIds = const {},
    this.answeredQuestionIds = const {},
    this.correctQuestionIds = const {},
    this.rewardedQuestionIds = const {},
    this.incorrectQuestionIds = const {},
    this.revisionDueDates = const {},
    this.revisionStages = const {},
    this.assessmentResults = const [],
  });

  final String? examId;
  final String? targetExamDate;
  final String preparationLevel;
  final Set<String> strongSubjects;
  final Set<String> weakSubjects;
  final int xp;
  final int streak;
  final String? lastStudyDate;
  final int studySeconds;
  final int todayStudySeconds;
  int get studyMinutes => studySeconds ~/ 60;
  int get todayStudyMinutes => todayStudySeconds ~/ 60;
  final int dailyGoalMinutes;
  final int questionsAnsweredCount;
  final int questionsCorrectCount;
  final Set<String> completedTopicIds;
  final Set<String> answeredQuestionIds;
  final Set<String> correctQuestionIds;
  final Set<String> rewardedQuestionIds;
  final Set<String> incorrectQuestionIds;
  final Map<String, String> revisionDueDates;
  final Map<String, int> revisionStages;
  final List<AssessmentResult> assessmentResults;

  int get level => (xp ~/ 250).clamp(0, 6).toInt();

  String get levelName => const [
    'Beginner',
    'Apprentice',
    'Dedicated Learner',
    'Knowledge Seeker',
    'Exam Warrior',
    'Master',
    'Exam Champion',
  ][level];

  Progress copyWith({
    String? examId,
    String? targetExamDate,
    String? preparationLevel,
    Set<String>? strongSubjects,
    Set<String>? weakSubjects,
    int? xp,
    int? streak,
    String? lastStudyDate,
    int? studySeconds,
    int? todayStudySeconds,
    int? dailyGoalMinutes,
    int? questionsAnsweredCount,
    int? questionsCorrectCount,
    Set<String>? completedTopicIds,
    Set<String>? answeredQuestionIds,
    Set<String>? correctQuestionIds,
    Set<String>? rewardedQuestionIds,
    Set<String>? incorrectQuestionIds,
    Map<String, String>? revisionDueDates,
    Map<String, int>? revisionStages,
    List<AssessmentResult>? assessmentResults,
  }) {
    return Progress(
      examId: examId ?? this.examId,
      targetExamDate: targetExamDate ?? this.targetExamDate,
      preparationLevel: preparationLevel ?? this.preparationLevel,
      strongSubjects: strongSubjects ?? this.strongSubjects,
      weakSubjects: weakSubjects ?? this.weakSubjects,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      studySeconds: studySeconds ?? this.studySeconds,
      todayStudySeconds: todayStudySeconds ?? this.todayStudySeconds,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      questionsAnsweredCount:
          questionsAnsweredCount ?? this.questionsAnsweredCount,
      questionsCorrectCount:
          questionsCorrectCount ?? this.questionsCorrectCount,
      completedTopicIds: completedTopicIds ?? this.completedTopicIds,
      answeredQuestionIds: answeredQuestionIds ?? this.answeredQuestionIds,
      correctQuestionIds: correctQuestionIds ?? this.correctQuestionIds,
      rewardedQuestionIds: rewardedQuestionIds ?? this.rewardedQuestionIds,
      incorrectQuestionIds: incorrectQuestionIds ?? this.incorrectQuestionIds,
      revisionDueDates: revisionDueDates ?? this.revisionDueDates,
      revisionStages: revisionStages ?? this.revisionStages,
      assessmentResults: assessmentResults ?? this.assessmentResults,
    );
  }

  Map<String, Object?> toJson() => {
    'examId': examId,
    'targetExamDate': targetExamDate,
    'preparationLevel': preparationLevel,
    'strongSubjects': strongSubjects.toList(),
    'weakSubjects': weakSubjects.toList(),
    'xp': xp,
    'streak': streak,
    'lastStudyDate': lastStudyDate,
    'studySeconds': studySeconds,
    'todayStudySeconds': todayStudySeconds,
    'dailyGoalMinutes': dailyGoalMinutes,
    'questionsAnsweredCount': questionsAnsweredCount,
    'questionsCorrectCount': questionsCorrectCount,
    'completedTopicIds': completedTopicIds.toList(),
    'answeredQuestionIds': answeredQuestionIds.toList(),
    'correctQuestionIds': correctQuestionIds.toList(),
    'rewardedQuestionIds': rewardedQuestionIds.toList(),
    'incorrectQuestionIds': incorrectQuestionIds.toList(),
    'revisionDueDates': revisionDueDates,
    'revisionStages': revisionStages,
    'assessmentResults': assessmentResults
        .map((result) => result.toJson())
        .toList(),
  };

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    examId: json['examId'] as String?,
    targetExamDate: json['targetExamDate'] as String?,
    preparationLevel: json['preparationLevel'] as String? ?? 'Starting out',
    strongSubjects: Set<String>.from(
      json['strongSubjects'] as List? ?? const [],
    ),
    weakSubjects: Set<String>.from(json['weakSubjects'] as List? ?? const []),
    xp: json['xp'] as int? ?? 0,
    streak: json['streak'] as int? ?? 0,
    lastStudyDate: json['lastStudyDate'] as String?,
    studySeconds: json['studySeconds'] as int? ?? 0,
    todayStudySeconds: json['todayStudySeconds'] as int? ?? 0,
    dailyGoalMinutes: json['dailyGoalMinutes'] as int? ?? 30,
    questionsAnsweredCount: json['questionsAnsweredCount'] as int? ?? 0,
    questionsCorrectCount: json['questionsCorrectCount'] as int? ?? 0,
    completedTopicIds: Set<String>.from(
      json['completedTopicIds'] as List? ?? const [],
    ),
    answeredQuestionIds: Set<String>.from(
      json['answeredQuestionIds'] as List? ?? const [],
    ),
    correctQuestionIds: Set<String>.from(
      json['correctQuestionIds'] as List? ?? const [],
    ),
    rewardedQuestionIds: Set<String>.from(
      json['rewardedQuestionIds'] as List? ?? const [],
    ),
    incorrectQuestionIds: Set<String>.from(
      json['incorrectQuestionIds'] as List? ?? const [],
    ),
    revisionDueDates: Map<String, String>.from(
      json['revisionDueDates'] as Map? ?? const {},
    ),
    revisionStages: Map<String, int>.from(
      json['revisionStages'] as Map? ?? const {},
    ),
    assessmentResults: (json['assessmentResults'] as List? ?? const [])
        .map(
          (result) => AssessmentResult.fromJson(result as Map<String, dynamic>),
        )
        .toList(),
  );
}
