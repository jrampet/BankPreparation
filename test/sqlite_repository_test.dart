import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:prepquest/data/local/progress_repository.dart';
import 'package:prepquest/domain/study_models.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'persists profile, topic, question and assessment data in SQLite',
    () async {
      final repository = await SqliteProgressRepository.openAt(
        inMemoryDatabasePath,
      );
      final result = AssessmentResult(
        id: 'attempt-1',
        examId: 'ibps_po',
        title: '5-question challenge',
        totalQuestions: 5,
        correctAnswers: 3,
        wrongAnswers: 1,
        skippedQuestions: 1,
        score: 3,
        maxScore: 5,
        durationSeconds: 240,
        completedAt: '2026-11-09T12:00:00.000',
      );
      final progress = Progress(
        examId: 'ibps_po',
        targetExamDate: '2027-02-01',
        preparationLevel: 'Building confidence',
        xp: 62,
        streak: 3,
        lastStudyDate: '2026-11-09',
        studySeconds: 3600,
        todayStudySeconds: 300,
        questionsAnsweredCount: 6,
        questionsCorrectCount: 4,
        completedTopicIds: const {'percentages'},
        answeredQuestionIds: const {'pct_1', 'pct_2'},
        correctQuestionIds: const {'pct_1'},
        rewardedQuestionIds: const {'pct_1'},
        incorrectQuestionIds: const {'pct_2'},
        revisionDueDates: const {'pct_2': '2026-11-10'},
        assessmentResults: [result],
      );

      await repository.save(progress);
      final loaded = await repository.load();

      expect(loaded.examId, progress.examId);
      expect(loaded.targetExamDate, progress.targetExamDate);
      expect(loaded.preparationLevel, progress.preparationLevel);
      expect(loaded.completedTopicIds, progress.completedTopicIds);
      expect(loaded.answeredQuestionIds, progress.answeredQuestionIds);
      expect(loaded.correctQuestionIds, progress.correctQuestionIds);
      expect(loaded.incorrectQuestionIds, progress.incorrectQuestionIds);
      expect(loaded.revisionDueDates, progress.revisionDueDates);
      expect(loaded.revisionStages, progress.revisionStages);
      expect(loaded.questionsAnsweredCount, 6);
      expect(loaded.questionsCorrectCount, 4);
      expect(loaded.assessmentResults.single.id, result.id);
      expect(loaded.assessmentResults.single.score, result.score);
      await repository.database.close();
    },
  );

  test('migrates existing shared-preferences progress into SQLite', () async {
    SharedPreferences.setMockInitialValues({
      'prepquest.progress.v1':
          '{"examId":"rrb_ntpc","xp":123,"completedTopicIds":["percentages"]}',
    });
    final preferences = await SharedPreferences.getInstance();
    final repository = await SqliteProgressRepository.openAt(
      inMemoryDatabasePath,
    );

    final migrated = await repository.load();
    expect(migrated.examId, 'rrb_ntpc');
    expect(migrated.xp, 123);
    expect(migrated.completedTopicIds, contains('percentages'));
    expect(preferences.getString('prepquest.progress.v1'), isNull);
    await repository.database.close();
  });
}
