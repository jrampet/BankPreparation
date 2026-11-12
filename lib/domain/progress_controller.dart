import 'package:flutter/foundation.dart';

import '../data/local/progress_repository.dart';
import 'gamification.dart';
import 'study_models.dart';

class ProgressController extends ChangeNotifier {
  ProgressController({required this.repository, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final ProgressRepository repository;
  final DateTime Function() _clock;
  Progress _progress = const Progress();

  Progress get progress => _progress;

  Future<void> load() async {
    _progress = await repository.load();
    notifyListeners();
  }

  Future<void> selectExam(
    String examId, {
    int? dailyGoalMinutes,
    String? preparationLevel,
    Set<String>? strongSubjects,
    Set<String>? weakSubjects,
  }) async {
    _progress = _progress.copyWith(
      examId: examId,
      dailyGoalMinutes: dailyGoalMinutes,
      preparationLevel: preparationLevel,
      strongSubjects: strongSubjects,
      weakSubjects: weakSubjects,
    );
    await _save();
  }

  Future<void> setTargetExamDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    _progress = _progress.copyWith(
      targetExamDate: Gamification.dateKey(normalized),
    );
    await _save();
  }

  Future<bool> recordAnswer(StudyQuestion question, bool isCorrect) async {
    final answered = {..._progress.answeredQuestionIds, question.id};
    final correct = {..._progress.correctQuestionIds};
    final rewarded = {..._progress.rewardedQuestionIds};
    final incorrect = {..._progress.incorrectQuestionIds};
    final dueDates = {..._progress.revisionDueDates};
    final revisionStages = {..._progress.revisionStages};
    final earnsQuestionXp = isCorrect && !rewarded.contains(question.id);
    if (isCorrect) {
      correct.add(question.id);
      rewarded.add(question.id);
      incorrect.remove(question.id);
      dueDates.remove(question.id);
      revisionStages.remove(question.id);
    } else {
      correct.remove(question.id);
      incorrect.add(question.id);
      const intervals = [1, 3, 7, 14, 30];
      final stage = (revisionStages[question.id] ?? 0)
          .clamp(0, intervals.length - 1)
          .toInt();
      dueDates[question.id] = Gamification.dateKey(
        _clock().add(Duration(days: intervals[stage])),
      );
      revisionStages[question.id] = (stage + 1)
          .clamp(0, intervals.length - 1)
          .toInt();
    }
    final next = _progress.copyWith(
      answeredQuestionIds: answered,
      correctQuestionIds: correct,
      rewardedQuestionIds: rewarded,
      incorrectQuestionIds: incorrect,
      revisionDueDates: dueDates,
      revisionStages: revisionStages,
      questionsAnsweredCount: _progress.questionsAnsweredCount + 1,
      questionsCorrectCount:
          _progress.questionsCorrectCount + (isCorrect ? 1 : 0),
      xp: _progress.xp + (earnsQuestionXp ? Gamification.correctAnswerXp : 0),
    );
    _progress = next;
    await _save();
    return earnsQuestionXp;
  }

  Future<void> completeLesson(
    StudyTopic topic, {
    required int activeSeconds,
  }) async {
    final today = _clock();
    final todayKey = Gamification.dateKey(today);
    final alreadyCompleted = _progress.completedTopicIds.contains(topic.id);
    final previousDailyMinutes = _progress.lastStudyDate == todayKey
        ? _progress.todayStudySeconds ~/ 60
        : 0;
    final nextDailySeconds =
        (_progress.lastStudyDate == todayKey
            ? _progress.todayStudySeconds
            : 0) +
        activeSeconds;
    final nextDailyMinutes = nextDailySeconds ~/ 60;
    final crossedBonus =
        Gamification.bonusXpForDailyMinutes(nextDailyMinutes) -
        Gamification.bonusXpForDailyMinutes(previousDailyMinutes);
    final completed = {..._progress.completedTopicIds, topic.id};
    final dueDates = {..._progress.revisionDueDates};
    for (final question in topic.questions.where(
      (question) => _progress.incorrectQuestionIds.contains(question.id),
    )) {
      dueDates.putIfAbsent(
        question.id,
        () => Gamification.dateKey(today.add(const Duration(days: 1))),
      );
    }
    _progress = _progress.copyWith(
      completedTopicIds: completed,
      revisionDueDates: dueDates,
      streak: Gamification.updatedStreak(
        currentStreak: _progress.streak,
        lastStudyDate: _progress.lastStudyDate,
        today: today,
      ),
      lastStudyDate: todayKey,
      xp:
          _progress.xp +
          (alreadyCompleted
              ? 0
              : Gamification.lessonXp + Gamification.topicCompletionXp) +
          crossedBonus,
      todayStudySeconds: nextDailySeconds,
      studySeconds: _progress.studySeconds + activeSeconds,
    );
    await _save();
  }

  Future<void> saveAssessmentResult(AssessmentResult result) async {
    if (_progress.assessmentResults.any((item) => item.id == result.id)) {
      throw StateError('This assessment result has already been saved.');
    }
    _progress = _progress.copyWith(
      assessmentResults: [result, ..._progress.assessmentResults],
    );
    await _save();
  }

  Future<void> _save() async {
    await repository.save(_progress);
    notifyListeners();
  }
}
