import 'package:flutter/material.dart';

import '../../data/content/exam_syllabi.dart';
import '../../data/content/study_content.dart';
import '../../domain/progress_controller.dart';
import '../../domain/study_models.dart';
import 'lesson_screen.dart';

class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({required this.controller, super.key});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;
    final exam = exams.firstWhere((item) => item.id == progress.examId);
    final syllabus = topicsForExam(exam.id);
    final incomplete =
        syllabus
            .where((topic) => !progress.completedTopicIds.contains(topic.id))
            .toList()
          ..sort((first, second) {
            final firstRank = progress.weakSubjects.contains(first.subject)
                ? 0
                : 1;
            final secondRank = progress.weakSubjects.contains(second.subject)
                ? 0
                : 1;
            return firstRank.compareTo(secondRank);
          });
    final revisionTopics =
        syllabus
            .where(
              (topic) => topic.questions.any(
                (question) =>
                    progress.incorrectQuestionIds.contains(question.id),
              ),
            )
            .toList()
          ..sort((first, second) {
            final firstRank = progress.weakSubjects.contains(first.subject)
                ? 0
                : 1;
            final secondRank = progress.weakSubjects.contains(second.subject)
                ? 0
                : 1;
            return firstRank.compareTo(secondRank);
          });
    final tasks = <StudyTopic>[
      ...revisionTopics,
      ...incomplete.where((topic) => !revisionTopics.contains(topic)),
    ].take(3).toList();
    final examDate = DateTime.tryParse(progress.targetExamDate ?? '');
    final daysRemaining = examDate?.difference(DateTime.now()).inDays;
    final dateText = switch (daysRemaining) {
      null => 'No exam date set',
      < 0 => 'Date has passed — update it when you know your next target.',
      final days => '$days days to your target date',
    };
    final readiness = _readiness(progress, syllabus);
    return Scaffold(
      appBar: AppBar(title: const Text('Your study plan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(19, 8, 19, 28),
        children: [
          Card(
            color: const Color(0xFF252345),
            child: Padding(
              padding: const EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.shortName.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFC9C6FF),
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    dateText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 13),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 1460),
                        ),
                        initialDate:
                            examDate != null && examDate.isAfter(DateTime.now())
                            ? examDate
                            : DateTime.now().add(const Duration(days: 90)),
                      );
                      if (selected == null) return;
                      await controller.setTargetExamDate(selected);
                    },
                    icon: const Icon(Icons.event_outlined),
                    label: Text(
                      examDate == null ? 'Set target date' : 'Change date',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Readiness estimate',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text(
                        '$readiness%',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  LinearProgressIndicator(
                    value: readiness / 100,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'A planning signal based on syllabus completion, answer accuracy and practice-test results—not a prediction of selection.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 17),
          Text(
            'Today’s suggested focus',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            'A balanced plan: revisit mistakes first, then make progress through new material.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          if (tasks.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(17),
                child: Text(
                  'You have finished the topics currently in this offline study path. Check the official syllabus guide for the full exam requirements.',
                ),
              ),
            )
          else
            for (var index = 0; index < tasks.length; index++)
              _PlanTask(
                number: index + 1,
                topic: tasks[index],
                isRevision: revisionTopics.contains(tasks[index]),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) => LessonScreen(
                      topic: tasks[index],
                      controller: controller,
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 17),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Study pace',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Your daily goal is ${progress.dailyGoalMinutes} minutes. Use the short lessons when time is tight and take breaks between longer sessions.',
                    style: const TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    examSyllabi[exam.id]!.verificationNote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _readiness(Progress progress, List<StudyTopic> syllabus) {
    final completion = syllabus.isEmpty
        ? 0.0
        : progress.completedTopicIds
                  .where(
                    (topicId) => syllabus.any((topic) => topic.id == topicId),
                  )
                  .length /
              syllabus.length;
    final examQuestions = syllabus.expand((topic) => topic.questions).toList();
    final attempts = progress.questionsAnsweredCount;
    final accuracy = attempts == 0
        ? 0.0
        : progress.questionsCorrectCount / attempts;
    final examResults = progress.assessmentResults
        .where((result) => result.examId == progress.examId)
        .toList();
    final testAccuracy = examResults.isEmpty
        ? 0.0
        : examResults
                  .map((result) => result.accuracyPercent)
                  .reduce((a, b) => a + b) /
              examResults.length /
              100;
    final revision = examQuestions.isEmpty
        ? 1.0
        : 1 -
              progress.incorrectQuestionIds
                      .where(
                        (questionId) => examQuestions.any(
                          (question) => question.id == questionId,
                        ),
                      )
                      .length /
                  examQuestions.length;
    final availableWeight =
        .35 +
        (attempts == 0 ? 0 : .3) +
        (examResults.isEmpty ? 0 : .2) +
        (attempts == 0 ? 0 : .15);
    final weightedReadiness =
        completion * .35 +
        (attempts == 0 ? 0 : accuracy * .3) +
        (examResults.isEmpty ? 0 : testAccuracy * .2) +
        (attempts == 0 ? 0 : revision * .15);
    return (weightedReadiness / availableWeight * 100)
        .round()
        .clamp(0, 100)
        .toInt();
  }
}

class _PlanTask extends StatelessWidget {
  const _PlanTask({
    required this.number,
    required this.topic,
    required this.isRevision,
    required this.onTap,
  });

  final int number;
  final StudyTopic topic;
  final bool isRevision;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isRevision
              ? const Color(0xFFFFF0DC)
              : Theme.of(context).colorScheme.primary.withValues(alpha: .1),
          child: Text(
            '$number',
            style: TextStyle(
              color: isRevision
                  ? const Color(0xFFE18A23)
                  : Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${isRevision ? 'Revision' : topic.subject} · ${topic.durationMinutes} min',
        ),
        trailing: const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }
}
