import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prepquest/data/content/study_content.dart';
import 'package:prepquest/data/local/progress_repository.dart';
import 'package:prepquest/domain/progress_controller.dart';
import 'package:prepquest/domain/study_models.dart';
import 'package:prepquest/presentation/screens/assessment_screen.dart';

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
  testWidgets(
    'timed assessment saves score and reveals wrong-answer feedback',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = ProgressController(
        repository: _MemoryProgressRepository(),
      );
      await controller.selectExam('ibps_po');
      final questions = topics.first.questions.take(2).toList();
      await tester.pumpWidget(
        MaterialApp(
          home: AssessmentScreen(
            controller: controller,
            questions: questions,
            title: 'Test practice',
            duration: const Duration(minutes: 5),
          ),
        ),
      );

      await tester.tap(
        find.text(questions[0].options[questions[0].answerIndex]),
      );
      await tester.pump();
      await tester.tap(find.text('Next question'));
      await tester.pump();
      final wrongIndex =
          (questions[1].answerIndex + 1) % questions[1].options.length;
      await tester.tap(find.text(questions[1].options[wrongIndex]));
      await tester.pump();
      await tester.tap(find.text('Submit test'));
      await tester.pumpAndSettle();

      expect(find.text('Practice complete'), findsOneWidget);
      expect(find.textContaining('Correct answer:'), findsOneWidget);
      expect(controller.progress.questionsAnsweredCount, 2);
      expect(controller.progress.questionsCorrectCount, 1);
      expect(
        controller.progress.incorrectQuestionIds,
        contains(questions[1].id),
      );
      expect(controller.progress.assessmentResults.single.correctAnswers, 1);
      expect(controller.progress.assessmentResults.single.wrongAnswers, 1);
      expect(controller.progress.assessmentResults.single.score, 1);
    },
  );
}
