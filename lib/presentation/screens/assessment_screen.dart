import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/content/study_content.dart';
import '../../domain/progress_controller.dart';
import '../../domain/study_models.dart';

class AssessmentHub extends StatelessWidget {
  const AssessmentHub({
    required this.controller,
    required this.onOpenGuide,
    super.key,
  });

  final ProgressController controller;
  final VoidCallback onOpenGuide;

  @override
  Widget build(BuildContext context) {
    final exam = exams.firstWhere(
      (item) => item.id == controller.progress.examId,
    );
    final results = controller.progress.assessmentResults
        .where((result) => result.examId == exam.id)
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(19, 10, 19, 28),
      children: [
        Text(
          'Practice that shows what to work on.',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 5),
        Text(
          'Choose a short quiz or a longer timed practice. Your score and review notes stay on this device.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 17),
        _AssessmentModeCard(
          icon: Icons.bolt_rounded,
          color: const Color(0xFFE59B3F),
          title: 'Quick challenge',
          description: '5 questions · about 5 minutes',
          badge: 'A quick reset',
          onTap: () => _start(context, 5, 5, '5-question challenge'),
        ),
        _AssessmentModeCard(
          icon: Icons.topic_outlined,
          color: const Color(0xFF5C58E8),
          title: 'Topic practice',
          description: '10 questions · 10 minutes',
          badge: 'Build accuracy',
          onTap: () => _start(context, 10, 10, '10-question topic practice'),
        ),
        _AssessmentModeCard(
          icon: Icons.timer_outlined,
          color: const Color(0xFF319574),
          title: 'Timed mixed practice',
          description: '20 questions · 20 minutes',
          badge: 'Work under time',
          onTap: () => _start(context, 20, 20, '20-question mixed practice'),
        ),
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer
              .withValues(alpha: .48),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded),
                    SizedBox(width: 8),
                    Text(
                      'About these practice tests',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                const Text(
                  'Tests use the offline practice bank currently in this app. They are not complete official-pattern mock exams. Check the latest exam notice for section timing, question counts and marking rules.',
                  style: TextStyle(height: 1.4),
                ),
                const SizedBox(height: 7),
                TextButton.icon(
                  onPressed: onOpenGuide,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Review official exam guide'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Recent attempts',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        if (results.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Your practice results will appear here after your first test.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          for (final result in results.take(5))
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary
                      .withValues(alpha: .1),
                  child: Text('${result.accuracyPercent}%'),
                ),
                title: Text(result.title),
                subtitle: Text(
                  '${result.correctAnswers} right · ${result.wrongAnswers} wrong · ${result.skippedQuestions} skipped',
                ),
                trailing: Text(
                  '${result.score.toStringAsFixed(result.score % 1 == 0 ? 0 : 1)}/${result.maxScore.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
      ],
    );
  }

  void _start(
    BuildContext context,
    int requestedQuestions,
    int durationMinutes,
    String title,
  ) {
    final topics = topicsForExam(controller.progress.examId!);
    final questionPool = topics.expand((topic) => topic.questions).toList()
      ..shuffle(Random(DateTime.now().microsecondsSinceEpoch));
    final selectedQuestions = questionPool.take(requestedQuestions).toList();
    if (selectedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There are no questions available yet.')),
      );
      return;
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => AssessmentScreen(
          controller: controller,
          questions: selectedQuestions,
          title: title,
          duration: Duration(minutes: durationMinutes),
        ),
      ),
    );
  }
}

class _AssessmentModeCard extends StatelessWidget {
  const _AssessmentModeCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.badge,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(description),
                    const SizedBox(height: 5),
                    Text(
                      badge,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({
    required this.controller,
    required this.questions,
    required this.title,
    required this.duration,
    super.key,
  });

  final ProgressController controller;
  final List<StudyQuestion> questions;
  final String title;
  final Duration duration;

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with WidgetsBindingObserver {
  final Stopwatch _stopwatch = Stopwatch();
  final Map<int, int> _answers = {};
  final Set<int> _markedForReview = {};
  Timer? _timer;
  int _current = 0;
  int _remainingSeconds = 0;
  bool _saving = false;
  bool _submitted = false;

  StudyQuestion get _question => widget.questions[_current];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingSeconds = widget.duration.inSeconds;
    _startTimer();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_submitted || _saving) return;
    if (state == AppLifecycleState.resumed) {
      _stopwatch.start();
      _startTimer();
    } else {
      _stopwatch.stop();
      _timer?.cancel();
      _timer = null;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _submitted || _saving) return;
      if (_remainingSeconds <= 1) {
        setState(() => _remainingSeconds = 0);
        _submit();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  Future<void> _submit() async {
    if (_saving || _submitted) return;
    setState(() => _saving = true);
    _timer?.cancel();
    _stopwatch.stop();
    try {
      final examId = widget.controller.progress.examId!;
      var correct = 0;
      var wrong = 0;
      for (var index = 0; index < widget.questions.length; index++) {
        final selected = _answers[index];
        if (selected == null) continue;
        final isCorrect = selected == widget.questions[index].answerIndex;
        if (isCorrect) {
          correct++;
        } else {
          wrong++;
        }
        await widget.controller.recordAnswer(
          widget.questions[index],
          isCorrect,
        );
      }
      final result = AssessmentResult(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        examId: examId,
        title: widget.title,
        totalQuestions: widget.questions.length,
        correctAnswers: correct,
        wrongAnswers: wrong,
        skippedQuestions: widget.questions.length - correct - wrong,
        score: correct.toDouble(),
        maxScore: widget.questions.length.toDouble(),
        durationSeconds: _stopwatch.elapsed.inSeconds,
        completedAt: DateTime.now().toIso8601String(),
      );
      await widget.controller.saveAssessmentResult(result);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _submitted = true;
      });
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          icon: const Icon(
            Icons.analytics_outlined,
            size: 38,
            color: Color(0xFF5C58E8),
          ),
          title: const Text('Practice complete'),
          content: SizedBox(
            width: 360,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${result.correctAnswers} correct · ${result.wrongAnswers} incorrect · ${result.skippedQuestions} skipped',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${result.score.toStringAsFixed(0)} / ${result.maxScore.toStringAsFixed(0)} correct · ${result.accuracyPercent}% accuracy',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Practice scoring has no negative marking. Review each missed answer:',
                    style: TextStyle(height: 1.35),
                  ),
                  for (var index = 0; index < widget.questions.length; index++)
                    if (_answers.containsKey(index) &&
                        _answers[index] != widget.questions[index].answerIndex)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.questions[index].prompt,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Correct answer: ${widget.questions[index].options[widget.questions[index].answerIndex]}',
                              style: const TextStyle(
                                color: Color(0xFF23865F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(widget.questions[index].explanation),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save your test result: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final question = _question;
    final selected = _answers[_current];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Exit test',
          onPressed: () => _confirmExit(context),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _remainingSeconds < 60
                      ? colors.errorContainer
                      : colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontFeatures: const [],
                    fontWeight: FontWeight.w800,
                    color: _remainingSeconds < 60
                        ? colors.error
                        : colors.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 3, 19, 6),
              child: LinearProgressIndicator(
                value: (_current + 1) / widget.questions.length,
                minHeight: 6,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(19, 14, 19, 10),
                children: [
                  Row(
                    children: [
                      Text(
                        'QUESTION ${_current + 1} OF ${widget.questions.length}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .7,
                            ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => setState(() {
                          if (!_markedForReview.add(_current)) {
                            _markedForReview.remove(_current);
                          }
                        }),
                        icon: Icon(
                          _markedForReview.contains(_current)
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                        ),
                        label: Text(
                          _markedForReview.contains(_current)
                              ? 'Marked'
                              : 'Review',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.prompt,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900, height: 1.3),
                  ),
                  const SizedBox(height: 18),
                  for (var index = 0; index < question.options.length; index++)
                    _AssessmentOption(
                      text: question.options[index],
                      letter: String.fromCharCode(65 + index),
                      selected: selected == index,
                      onTap: () => setState(() => _answers[_current] = index),
                    ),
                  const SizedBox(height: 17),
                  Text(
                    'QUESTION PALETTE',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      letterSpacing: .8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(widget.questions.length, (index) {
                      final isCurrent = index == _current;
                      final answered = _answers.containsKey(index);
                      final marked = _markedForReview.contains(index);
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => _current = index),
                        child: Container(
                          height: 39,
                          width: 42,
                          decoration: BoxDecoration(
                            color: marked
                                ? const Color(0xFFFFE9C9)
                                : isCurrent
                                ? colors.primary
                                : answered
                                ? const Color(0xFFDDF2E8)
                                : colors.surface,
                            border: Border.all(
                              color: isCurrent
                                  ? colors.primary
                                  : colors.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: isCurrent
                                  ? Colors.white
                                  : colors.onSurface,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 7, 17, 13),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _current == 0
                        ? null
                        : () => setState(() => _current--),
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving
                          ? null
                          : _current == widget.questions.length - 1
                          ? _submit
                          : () => setState(() => _current++),
                      child: _saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _current == widget.questions.length - 1
                                  ? 'Submit test'
                                  : 'Next question',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave this practice?'),
        content: const Text(
          'Your answers will not be scored or saved as a test result.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep practising'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (shouldExit == true && context.mounted) Navigator.of(context).pop();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }
}

class _AssessmentOption extends StatelessWidget {
  const _AssessmentOption({
    required this.text,
    required this.letter,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final String letter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: selected
            ? colors.primary.withValues(alpha: .09)
            : colors.surface,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            constraints: const BoxConstraints(minHeight: 54),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? colors.primary : colors.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: selected
                      ? colors.primary
                      : colors.surfaceContainerHighest,
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: selected ? Colors.white : colors.onSurface,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: colors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
