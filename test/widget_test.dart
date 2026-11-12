import 'package:flutter/material.dart';
import 'package:prepquest/data/content/study_content.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prepquest/data/local/progress_repository.dart';
import 'package:prepquest/domain/progress_controller.dart';
import 'package:prepquest/domain/study_models.dart';
import 'package:prepquest/presentation/prepquest_app.dart';

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
  testWidgets('onboarding saves an exam and opens the learning dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _MemoryProgressRepository();
    final controller = ProgressController(repository: repository);
    await controller.load();
    await tester.pumpWidget(PrepQuestApp(controller: controller));

    expect(find.textContaining('Your next big goal,'), findsOneWidget);
    for (
      var attempt = 0;
      attempt < 4 && find.text('Build my study path').evaluate().isEmpty;
      attempt++
    ) {
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Build my study path'));
    await tester.pumpAndSettle();

    expect(repository.stored.examId, 'ibps_po');
    expect(find.text('A little progress adds up.'), findsOneWidget);
    expect(find.text('Start a 5-minute challenge'), findsOneWidget);

    await tester.tap(find.text('Start a 5-minute challenge'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Start practice'));
    await tester.tap(find.text('Start practice'));
    await tester.pumpAndSettle();

    final topic = topics.first;
    for (var index = 0; index < topic.questions.length; index++) {
      final question = topic.questions[index];
      final answer = find.text(question.options[question.answerIndex]).first;
      await tester.ensureVisible(answer);
      await tester.tap(answer);
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(
          index == topic.questions.length - 1 ? 'Finish lesson' : 'Continue',
        ),
      );
      await tester.pumpAndSettle();
    }

    expect(find.text('Nice work!'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(repository.stored.completedTopicIds, contains(topic.id));
    expect(repository.stored.xp, 70);
  });
}
