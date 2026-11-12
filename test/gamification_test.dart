import 'package:flutter_test/flutter_test.dart';

import 'package:prepquest/data/content/study_content.dart';
import 'package:prepquest/data/local/progress_repository.dart';
import 'package:prepquest/domain/gamification.dart';
import 'package:prepquest/domain/progress_controller.dart';
import 'package:prepquest/domain/study_models.dart';

class _MemoryProgressRepository implements ProgressRepository {
  Progress stored = const Progress();

  @override
  Future<Progress> load() async => stored;

  @override
  Future<void> save(Progress progress) async {
    stored = progress;
  }
}

void main() {
  group('Gamification', () {
    test('streak continues only on consecutive active days', () {
      final today = DateTime(2026, 11, 9);
      expect(
        Gamification.updatedStreak(
          currentStreak: 4,
          lastStudyDate: '2026-11-08',
          today: today,
        ),
        5,
      );
      expect(
        Gamification.updatedStreak(
          currentStreak: 4,
          lastStudyDate: '2026-11-06',
          today: today,
        ),
        1,
      );
    });

    test('extra-learning bonus is capped at the 120-minute tier', () {
      expect(Gamification.bonusXpForDailyMinutes(44), 0);
      expect(Gamification.bonusXpForDailyMinutes(45), 25);
      expect(Gamification.bonusXpForDailyMinutes(60), 50);
      expect(Gamification.bonusXpForDailyMinutes(90), 100);
      expect(Gamification.bonusXpForDailyMinutes(120), 150);
      expect(Gamification.bonusXpForDailyMinutes(180), 150);
    });
  });

  group('ProgressController', () {
    test(
      'awards XP on the first correct answer and removes mastered mistakes',
      () async {
        final repository = _MemoryProgressRepository();
        final controller = ProgressController(
          repository: repository,
          clock: () => DateTime(2026, 11, 9),
        );
        final question = topics.first.questions.first;

        expect(await controller.recordAnswer(question, false), isFalse);
        expect(controller.progress.incorrectQuestionIds, contains(question.id));
        expect(controller.progress.revisionDueDates[question.id], '2026-11-10');
        expect(await controller.recordAnswer(question, true), isTrue);
        expect(
          controller.progress.incorrectQuestionIds,
          isNot(contains(question.id)),
        );
        expect(controller.progress.correctQuestionIds, contains(question.id));
        expect(controller.progress.xp, 2);
        expect(controller.progress.questionsAnsweredCount, 2);
        expect(controller.progress.questionsCorrectCount, 1);
        expect(await controller.recordAnswer(question, true), isFalse);
        expect(controller.progress.xp, 2);
      },
    );

    test(
      'records measured study time and rewards a completed topic once',
      () async {
        var now = DateTime(2026, 11, 9, 12);
        final controller = ProgressController(
          repository: _MemoryProgressRepository(),
          clock: () => now,
        );
        await controller.completeLesson(topics.first, activeSeconds: 300);
        expect(controller.progress.studySeconds, 300);
        expect(controller.progress.todayStudySeconds, 300);
        expect(controller.progress.streak, 1);
        expect(controller.progress.xp, 60);

        now = now.add(const Duration(days: 1));
        await controller.completeLesson(topics.first, activeSeconds: 180);
        expect(controller.progress.streak, 2);
        expect(controller.progress.studySeconds, 480);
        expect(controller.progress.xp, 60);
      },
    );

    test(
      'adds extra-study bonus once the measured daily threshold is reached',
      () async {
        final controller = ProgressController(
          repository: _MemoryProgressRepository(),
          clock: () => DateTime(2026, 11, 9, 12),
        );
        await controller.completeLesson(topics.first, activeSeconds: 44 * 60);
        expect(controller.progress.xp, 60);
        await controller.completeLesson(topics[1], activeSeconds: 60);
        expect(controller.progress.todayStudySeconds, 45 * 60);
        expect(controller.progress.xp, 145);
      },
    );
  });
}
