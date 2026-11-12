import 'package:flutter/material.dart';

import '../../data/content/study_content.dart';
import '../../domain/progress_controller.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({required this.controller, super.key});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;
    final examTopics = topicsForExam(progress.examId!);
    final questionCount = progress.questionsAnsweredCount;
    final accuracy = questionCount == 0
        ? 0
        : (100 * progress.questionsCorrectCount / questionCount).round();
    final hours = progress.studySeconds / 3600;
    final allComplete = examTopics.every(
      (topic) => progress.completedTopicIds.contains(topic.id),
    );
    final items = [
      _Achievement(
        title: 'First lesson',
        description: 'Complete your first learning topic.',
        icon: Icons.menu_book_rounded,
        unlocked: progress.completedTopicIds.isNotEmpty,
      ),
      _Achievement(
        title: '7-day streak',
        description: 'Keep a learning streak for seven days.',
        icon: Icons.local_fire_department_rounded,
        unlocked: progress.streak >= 7,
      ),
      _Achievement(
        title: '100 questions',
        description: 'Attempt 100 practice questions.',
        icon: Icons.quiz_outlined,
        unlocked: questionCount >= 100,
      ),
      _Achievement(
        title: 'Accuracy master',
        description: 'Reach 80% accuracy after at least 10 answers.',
        icon: Icons.gps_fixed_rounded,
        unlocked: questionCount >= 10 && accuracy >= 80,
      ),
      _Achievement(
        title: '10 hours of learning',
        description: 'Record 600 minutes of active learning.',
        icon: Icons.schedule_rounded,
        unlocked: hours >= 10,
      ),
      _Achievement(
        title: 'Perfect practice',
        description: 'Get every answered question right in a practice test.',
        icon: Icons.stars_rounded,
        unlocked: progress.assessmentResults.any(
          (result) =>
              result.totalQuestions > 0 &&
              result.correctAnswers == result.totalQuestions,
        ),
      ),
      _Achievement(
        title: 'Full learning path',
        description: 'Complete all topics currently in your offline path.',
        icon: Icons.flag_rounded,
        unlocked: allComplete,
      ),
    ];
    final unlocked = items.where((item) => item.unlocked).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(19, 10, 19, 28),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .08),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 31,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$unlocked of ${items.length} achievements unlocked',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.unlocked
                      ? const Color(0xFFFFF0DC)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    item.unlocked ? item.icon : Icons.lock_outline_rounded,
                    color: item.unlocked
                        ? const Color(0xFFE18A23)
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: item.unlocked
                        ? null
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                subtitle: Text(item.description),
                trailing: item.unlocked
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF319574),
                      )
                    : null,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'Achievements reward learning progress, not time spent idling in the app.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Achievement {
  const _Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
}
