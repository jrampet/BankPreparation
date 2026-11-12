import 'package:flutter/material.dart';

import '../../data/content/study_content.dart';
import '../../domain/gamification.dart';
import '../../domain/progress_controller.dart';
import '../../domain/study_models.dart';
import 'achievements_screen.dart';
import 'assessment_screen.dart';
import 'exam_guide_screen.dart';
import 'lesson_screen.dart';
import 'study_plan_screen.dart';

class PrepShell extends StatefulWidget {
  const PrepShell({
    required this.controller,
    required this.isDark,
    required this.onThemeToggle,
    super.key,
  });

  final ProgressController controller;
  final bool isDark;
  final VoidCallback onThemeToggle;

  @override
  State<PrepShell> createState() => _PrepShellState();
}

class _PrepShellState extends State<PrepShell> {
  int _tab = 0;

  StudyTopic get _nextTopic {
    final list = topicsForExam(widget.controller.progress.examId!);
    return list.firstWhere(
      (topic) =>
          !widget.controller.progress.completedTopicIds.contains(topic.id),
      orElse: () => list.first,
    );
  }

  Future<void> _openTopic(StudyTopic topic) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            LessonScreen(topic: topic, controller: widget.controller),
      ),
    );
  }

  void _openExamGuide() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            ExamGuideScreen(examId: widget.controller.progress.examId!),
      ),
    );
  }

  void _openStudyPlan() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => StudyPlanScreen(controller: widget.controller),
      ),
    );
  }

  void _openAchievements() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => AchievementsScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(
        controller: widget.controller,
        nextTopic: _nextTopic,
        onStart: () => _openTopic(_nextTopic),
        onLearn: () => setState(() => _tab = 1),
        onRevision: () => setState(() => _tab = 3),
        onTests: () => setState(() => _tab = 2),
        onPlan: _openStudyPlan,
        onGuide: _openExamGuide,
      ),
      _LearnTab(
        controller: widget.controller,
        onTopicTap: _openTopic,
        onOpenGuide: _openExamGuide,
      ),
      AssessmentHub(controller: widget.controller, onOpenGuide: _openExamGuide),
      _RevisionTab(controller: widget.controller, onTopicTap: _openTopic),
      _ProgressTab(
        controller: widget.controller,
        onOpenPlan: _openStudyPlan,
        onOpenAchievements: _openAchievements,
      ),
    ];
    return Scaffold(
      appBar: _tab == 0
          ? AppBar(
              title: const _BrandMark(),
              actions: [
                _StreakChip(streak: widget.controller.progress.streak),
                IconButton(
                  tooltip: 'Official syllabus & exam guide',
                  onPressed: _openExamGuide,
                  icon: const Icon(Icons.menu_book_outlined),
                ),
                IconButton(
                  tooltip: widget.isDark
                      ? 'Switch to light theme'
                      : 'Switch to dark theme',
                  onPressed: widget.onThemeToggle,
                  icon: Icon(
                    widget.isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_outlined,
                  ),
                ),
                const SizedBox(width: 14),
              ],
            )
          : AppBar(
              title: Text(
                const [
                  'Home',
                  'Your learning path',
                  'Practice tests',
                  'Mistake bank',
                  'Your progress',
                ][_tab],
              ),
              actions: [
                IconButton(
                  tooltip: 'Official syllabus & exam guide',
                  onPressed: _openExamGuide,
                  icon: const Icon(Icons.menu_book_outlined),
                ),
                IconButton(
                  tooltip: widget.isDark
                      ? 'Switch to light theme'
                      : 'Switch to dark theme',
                  onPressed: widget.onThemeToggle,
                  icon: Icon(
                    widget.isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_outlined,
                  ),
                ),
              ],
            ),
      body: SafeArea(
        top: false,
        child: IndexedStack(index: _tab, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route_rounded),
            label: 'Syllabus',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz_rounded),
            label: 'Tests',
          ),
          NavigationDestination(
            icon: Icon(Icons.refresh_rounded),
            selectedIcon: Icon(Icons.autorenew_rounded),
            label: 'Revision',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.controller,
    required this.nextTopic,
    required this.onStart,
    required this.onLearn,
    required this.onRevision,
    required this.onTests,
    required this.onPlan,
    required this.onGuide,
  });

  final ProgressController controller;
  final StudyTopic nextTopic;
  final VoidCallback onStart;
  final VoidCallback onLearn;
  final VoidCallback onRevision;
  final VoidCallback onTests;
  final VoidCallback onPlan;
  final VoidCallback onGuide;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;
    final exam = exams.firstWhere((item) => item.id == progress.examId);
    final syllabus = topicsForExam(exam.id);
    final completion = syllabus.isEmpty
        ? 0.0
        : progress.completedTopicIds
                  .where((id) => syllabus.any((topic) => topic.id == id))
                  .length /
              syllabus.length;
    final dailyFraction =
        (progress.todayStudyMinutes / progress.dailyGoalMinutes).clamp(
          0.0,
          1.0,
        );
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text(
          'A little progress adds up.',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -.7),
        ),
        const SizedBox(height: 4),
        Text(
          'Your ${exam.shortName} preparation, one focused session at a time.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 18),
        _DailyGoalCard(
          minutes: progress.todayStudyMinutes,
          goal: progress.dailyGoalMinutes,
          progress: dailyFraction,
          xp: progress.xp,
          level: progress.levelName,
        ),
        const SizedBox(height: 15),
        FilledButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow_rounded, size: 23),
          label: const Text('Start a 5-minute challenge'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(58),
            backgroundColor: const Color(0xFF5C58E8),
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onTests,
                icon: const Icon(Icons.quiz_outlined),
                label: const Text('Practice tests'),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPlan,
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('Study plan'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: const Color(0xFFF19B36),
                value: '${progress.streak}',
                label: 'day streak',
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _MiniStatCard(
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFF5C58E8),
                value: '${progress.xp}',
                label: 'total XP',
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _MiniStatCard(
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF3B9C78),
                value: '${(completion * 100).round()}%',
                label: 'syllabus',
              ),
            ),
          ],
        ),
        const SizedBox(height: 23),
        _SectionHeading(
          title: 'Pick up where you left off',
          trailing: TextButton(
            onPressed: onLearn,
            child: const Text('See path'),
          ),
        ),
        Card(
          child: InkWell(
            onTap: onStart,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Row(
                children: [
                  _TopicIcon(topic: nextTopic),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nextTopic.subject.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colors.primary,
                                letterSpacing: .7,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nextTopic.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${nextTopic.durationMinutes} min · lesson + ${nextTopic.questions.length} questions',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: colors.primary),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeading(
          title: 'Today’s revision',
          trailing: TextButton(
            onPressed: onRevision,
            child: const Text('Review mistakes'),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0DC),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFFE18A23),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    progress.incorrectQuestionIds.isEmpty
                        ? 'No mistakes yet. Your missed questions will show up here for review.'
                        : '${progress.incorrectQuestionIds.length} question${progress.incorrectQuestionIds.length == 1 ? '' : 's'} in your mistake bank. A quick retry can help it stick.',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeading(title: 'Your learning journey'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.map_outlined, color: Color(0xFF5C58E8)),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        '${progress.completedTopicIds.where((id) => syllabus.any((topic) => topic.id == id)).length} of ${syllabus.length} topics explored',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      '${(completion * 100).round()}%',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: completion,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: colors.primary,
                  backgroundColor: colors.primary.withValues(alpha: .12),
                ),
                const SizedBox(height: 12),
                Text(
                  'A steady routine builds knowledge. This progress is a guide, not a promise of exam results.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant, height: 1.35),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 11),
        Card(
          child: ListTile(
            onTap: onGuide,
            leading: const Icon(
              Icons.verified_outlined,
              color: Color(0xFF5C58E8),
            ),
            title: const Text(
              'Official syllabus & exam pattern',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: const Text(
              'Check the recruiting authority’s current notice',
            ),
            trailing: const Icon(Icons.open_in_new_rounded),
          ),
        ),
      ],
    );
  }
}

class _LearnTab extends StatelessWidget {
  const _LearnTab({
    required this.controller,
    required this.onTopicTap,
    required this.onOpenGuide,
  });

  final ProgressController controller;
  final ValueChanged<StudyTopic> onTopicTap;
  final VoidCallback onOpenGuide;

  @override
  Widget build(BuildContext context) {
    final examId = controller.progress.examId!;
    final syllabus = topicsForExam(examId);
    final subjects = syllabus.map((topic) => topic.subject).toSet();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Text(
          'Every expert starts somewhere.',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 5),
        Text(
          'Complete a topic to unlock the next step in its subject.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 11),
        OutlinedButton.icon(
          onPressed: onOpenGuide,
          icon: const Icon(Icons.verified_outlined),
          label: const Text('View official exam syllabus'),
        ),
        const SizedBox(height: 20),
        for (final subject in subjects)
          _SubjectPath(
            subject: subject,
            topics: syllabus
                .where((topic) => topic.subject == subject)
                .toList(),
            completedIds: controller.progress.completedTopicIds,
            onTopicTap: onTopicTap,
          ),
      ],
    );
  }
}

class _SubjectPath extends StatelessWidget {
  const _SubjectPath({
    required this.subject,
    required this.topics,
    required this.completedIds,
    required this.onTopicTap,
  });

  final String subject;
  final List<StudyTopic> topics;
  final Set<String> completedIds;
  final ValueChanged<StudyTopic> onTopicTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var index = 0; index < topics.length; index++)
                  _PathTopicRow(
                    topic: topics[index],
                    complete: completedIds.contains(topics[index].id),
                    locked:
                        index > 0 &&
                        !completedIds.contains(topics[index - 1].id),
                    isLast: index == topics.length - 1,
                    onTap: onTopicTap,
                  ),
              ],
            ),
          ),
          if (subject == 'General Awareness')
            Padding(
              padding: const EdgeInsets.only(top: 7, left: 3),
              child: Text(
                'Exam syllabus varies by notification. Verify the current official notification.',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}

class _PathTopicRow extends StatelessWidget {
  const _PathTopicRow({
    required this.topic,
    required this.complete,
    required this.locked,
    required this.isLast,
    required this.onTap,
  });

  final StudyTopic topic;
  final bool complete;
  final bool locked;
  final bool isLast;
  final ValueChanged<StudyTopic> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final iconColor = complete
        ? const Color(0xFF319574)
        : locked
        ? colors.outline
        : colors.primary;
    return InkWell(
      onTap: locked ? null : () => onTap(topic),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        child: Row(
          children: [
            SizedBox(
              width: 31,
              height: 31,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!isLast)
                    Positioned(
                      top: 24,
                      bottom: -34,
                      child: Container(width: 2, color: colors.outlineVariant),
                    ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: iconColor.withValues(alpha: .12),
                    child: Icon(
                      complete
                          ? Icons.check_rounded
                          : locked
                          ? Icons.lock_outline_rounded
                          : Icons.play_arrow_rounded,
                      size: 18,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: locked
                          ? colors.onSurfaceVariant
                          : colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${topic.durationMinutes} min · ${topic.questions.length} practice questions',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.outline),
          ],
        ),
      ),
    );
  }
}

class _RevisionTab extends StatelessWidget {
  const _RevisionTab({required this.controller, required this.onTopicTap});

  final ProgressController controller;
  final ValueChanged<StudyTopic> onTopicTap;

  @override
  Widget build(BuildContext context) {
    final today = Gamification.dateKey(DateTime.now());
    final allTopics = topicsForExam(controller.progress.examId!);
    final mistakes = <StudyTopic, List<StudyQuestion>>{};
    for (final topic in allTopics) {
      final missed = topic.questions.where(
        (question) =>
            controller.progress.incorrectQuestionIds.contains(question.id),
      );
      if (missed.isNotEmpty) mistakes[topic] = missed.toList();
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .08),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 27,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Mistakes are useful clues. Try again after a break to help new ideas stick.',
                    style: TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (mistakes.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Icon(
                    Icons.self_improvement_rounded,
                    size: 42,
                    color: Color(0xFF5C58E8),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your mistake bank is clear',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Missed questions will be saved here so you can revisit them.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          for (final entry in mistakes.entries)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 8,
                ),
                leading: _TopicIcon(topic: entry.key),
                title: Text(
                  entry.key.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  '${entry.value.length} missed · ${entry.value.any((question) => (controller.progress.revisionDueDates[question.id] ?? '').compareTo(today) <= 0) ? 'ready to revisit' : 'review coming up'}',
                ),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () => onTopicTap(entry.key),
              ),
            ),
        const SizedBox(height: 8),
        Text(
          'Questions answered correctly are removed from your mistake bank. Each repeat helps strengthen recall.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _ProgressTab extends StatelessWidget {
  const _ProgressTab({
    required this.controller,
    required this.onOpenPlan,
    required this.onOpenAchievements,
  });

  final ProgressController controller;
  final VoidCallback onOpenPlan;
  final VoidCallback onOpenAchievements;

  @override
  Widget build(BuildContext context) {
    final progress = controller.progress;
    final examId = progress.examId!;
    final syllabus = topicsForExam(examId);
    final correct = progress.questionsCorrectCount;
    final attempted = progress.questionsAnsweredCount;
    final accuracy = attempted == 0 ? 0 : (100 * correct / attempted).round();
    final completedCount = progress.completedTopicIds
        .where((id) => syllabus.any((topic) => topic.id == id))
        .length;
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  height: 84,
                  width: 84,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress.level == 6
                            ? 1
                            : (progress.xp % 250) / 250,
                        strokeWidth: 8,
                        backgroundColor: colors.primary.withValues(alpha: .12),
                        strokeCap: StrokeCap.round,
                      ),
                      const Icon(Icons.bolt_rounded, size: 31),
                    ],
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.levelName,
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 3),
                      Text('${progress.xp} XP earned'),
                      const SizedBox(height: 6),
                      Text(
                        progress.level == 6
                            ? 'Top level reached'
                            : '${250 - progress.xp % 250} XP to next level',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onOpenPlan,
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('Study plan'),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onOpenAchievements,
                icon: const Icon(Icons.emoji_events_outlined),
                label: const Text('Achievements'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                value: '${progress.studyMinutes}',
                label: 'study minutes',
                icon: Icons.schedule_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                value: '$attempted',
                label: 'questions tried',
                icon: Icons.quiz_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                value: '$accuracy%',
                label: 'accuracy',
                icon: Icons.track_changes_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                value: '$completedCount/${syllabus.length}',
                label: 'topics complete',
                icon: Icons.flag_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          'By subject',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        for (final subject in syllabus.map((topic) => topic.subject).toSet())
          _SubjectProgress(
            subject: subject,
            topics: syllabus
                .where((topic) => topic.subject == subject)
                .toList(),
            completedIds: progress.completedTopicIds,
            answeredIds: progress.answeredQuestionIds,
            correctIds: progress.correctQuestionIds,
          ),
        const SizedBox(height: 10),
        Card(
          color: colors.secondaryContainer.withValues(alpha: .55),
          child: const Padding(
            padding: EdgeInsets.all(17),
            child: Text(
              'Readiness is a guide, not a guarantee. Keep revising, practise under timed conditions, and check the latest official exam notification.',
              style: TextStyle(height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubjectProgress extends StatelessWidget {
  const _SubjectProgress({
    required this.subject,
    required this.topics,
    required this.completedIds,
    required this.answeredIds,
    required this.correctIds,
  });

  final String subject;
  final List<StudyTopic> topics;
  final Set<String> completedIds;
  final Set<String> answeredIds;
  final Set<String> correctIds;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final done = topics
        .where((topic) => completedIds.contains(topic.id))
        .length;
    final questions = topics.expand((topic) => topic.questions);
    final solved = questions
        .where((question) => correctIds.contains(question.id))
        .length;
    final attempted = questions
        .where((question) => answeredIds.contains(question.id))
        .length;
    final subjectAccuracy = attempted == 0
        ? '—'
        : '${(100 * solved / attempted).round()}%';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    subject,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Text('$done/${topics.length} topics'),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: topics.isEmpty ? 0 : done / topics.length,
              borderRadius: BorderRadius.circular(8),
              minHeight: 7,
              color: colors.primary,
            ),
            const SizedBox(height: 7),
            Text(
              'Practice accuracy: $subjectAccuracy',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({
    required this.minutes,
    required this.goal,
    required this.progress,
    required this.xp,
    required this.level,
  });

  final int minutes;
  final int goal;
  final double progress;
  final int xp;
  final String level;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: const Color(0xFF252345),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'TODAY’S FOCUS',
                    style: TextStyle(
                      color: Color(0xFFB7B6D0),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const Icon(
                  Icons.bolt_rounded,
                  color: Color(0xFFFFD66B),
                  size: 18,
                ),
                const SizedBox(width: 3),
                Text(
                  '$xp XP',
                  style: const TextStyle(
                    color: Color(0xFFFFD66B),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 5,
                    children: [
                      Text(
                        '$minutes',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          height: 1,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: Text(
                          'min studied',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$goal min goal',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 9,
                backgroundColor: Colors.white.withValues(alpha: .15),
                color: const Color(0xFF92E2C2),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFF92E2C2),
                  size: 17,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '$level · ${progress >= 1 ? 'Daily goal reached — nice work!' : '${(goal - minutes).clamp(0, goal)} minutes to your goal'}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .88),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.favorite_rounded, color: colors.error, size: 15),
                const SizedBox(width: 3),
                const Text(
                  'Healthy pace',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 19, color: iconColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: colors.primary),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicIcon extends StatelessWidget {
  const _TopicIcon({required this.topic});

  final StudyTopic topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      width: 47,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        topic.icon,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w900,
          fontSize: topic.icon.length > 1 ? 18 : 25,
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0DE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Color(0xFFEF8D27),
            size: 19,
          ),
          const SizedBox(width: 3),
          Text(
            '$streak',
            style: const TextStyle(
              color: Color(0xFF9C5C16),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 9),
        const Flexible(
          child: Text(
            'PrepQuest',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
