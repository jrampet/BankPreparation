import 'package:flutter/material.dart';

import '../../domain/progress_controller.dart';
import '../../domain/study_models.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    required this.topic,
    required this.controller,
    super.key,
  });

  final StudyTopic topic;
  final ProgressController controller;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with WidgetsBindingObserver {
  final Stopwatch _activeTime = Stopwatch();
  bool _started = false;
  bool _saving = false;
  bool _answered = false;
  int? _selectedIndex;
  int _questionIndex = 0;
  int _correctCount = 0;

  StudyQuestion get _question => widget.topic.questions[_questionIndex];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _activeTime.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_started || _saving) return;
    if (state == AppLifecycleState.resumed) {
      _activeTime.start();
    } else {
      _activeTime.stop();
    }
  }

  Future<void> _submitAnswer(int index) async {
    if (_answered || _saving) return;
    final isCorrect = index == _question.answerIndex;
    try {
      setState(() {
        _saving = true;
        _selectedIndex = index;
      });
      await widget.controller.recordAnswer(_question, isCorrect);
      if (!mounted) return;
      setState(() {
        _answered = true;
        _saving = false;
        if (isCorrect) _correctCount++;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save your answer: $error')),
      );
    }
  }

  void _continue() {
    if (_questionIndex == widget.topic.questions.length - 1) {
      _finishLesson();
      return;
    }
    setState(() {
      _questionIndex++;
      _selectedIndex = null;
      _answered = false;
    });
  }

  Future<void> _finishLesson() async {
    if (_saving) return;
    _activeTime.stop();
    setState(() => _saving = true);
    try {
      await widget.controller.completeLesson(
        widget.topic,
        activeSeconds: _activeTime.elapsed.inSeconds.clamp(1, 86400),
      );
      if (!mounted) return;
      setState(() => _saving = false);
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.celebration_rounded,
            color: Color(0xFF5C58E8),
            size: 38,
          ),
          title: const Text('Nice work!'),
          content: Text(
            'You got $_correctCount of ${widget.topic.questions.length} questions right. '
            'Your learning streak and progress are saved on this device.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
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
        SnackBar(content: Text('Could not save lesson progress: $error')),
      );
    }
  }

  void _startPractice() {
    setState(() {
      _started = true;
      _activeTime.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Exit lesson',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(widget.topic.title),
        actions: [
          if (_started)
            Padding(
              padding: const EdgeInsets.only(right: 17),
              child: Center(
                child: Text(
                  '${_questionIndex + 1}/${widget.topic.questions.length}',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _started ? _buildQuestion(colors) : _buildConcept(colors),
          ),
        ),
      ),
    );
  }

  Widget _buildConcept(ColorScheme colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(21, 12, 21, 28),
      children: [
        Row(
          children: [
            _LargeTopicIcon(topic: widget.topic),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.topic.subject.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      letterSpacing: .9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.topic.durationMinutes} min lesson',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.wifi_off_rounded,
              color: Color(0xFF39876D),
              size: 19,
            ),
            const SizedBox(width: 5),
            const Text(
              'Offline ready',
              style: TextStyle(
                color: Color(0xFF39876D),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 23),
        Text(
          'The idea',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          widget.topic.concept,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55),
        ),
        const SizedBox(height: 17),
        _LessonNote(
          icon: Icons.functions_rounded,
          label: 'Formula / shortcut',
          content: widget.topic.formula,
          color: const Color(0xFF5C58E8),
        ),
        const SizedBox(height: 12),
        _LessonNote(
          icon: Icons.lightbulb_outline_rounded,
          label: 'Worked example',
          content: widget.topic.example,
          color: const Color(0xFFE18A23),
        ),
        const SizedBox(height: 19),
        Text(
          'Now make it stick',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 5),
        Text(
          'Try ${widget.topic.questions.length} questions. You’ll get an explanation after every answer.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: _startPractice,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Start practice'),
        ),
      ],
    );
  }

  Widget _buildQuestion(ColorScheme colors) {
    final answeredCorrectly = _selectedIndex == _question.answerIndex;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 8),
          child: LinearProgressIndicator(
            value:
                (_questionIndex + (_answered ? 1 : 0)) /
                widget.topic.questions.length,
            minHeight: 7,
            borderRadius: BorderRadius.circular(7),
            color: colors.primary,
            backgroundColor: colors.primary.withValues(alpha: .12),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(21, 20, 21, 12),
            children: [
              Text(
                'QUESTION ${_questionIndex + 1}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.primary,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _question.prompt,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w900, height: 1.2),
              ),
              const SizedBox(height: 23),
              for (var index = 0; index < _question.options.length; index++)
                _AnswerOption(
                  label: _question.options[index],
                  letter: String.fromCharCode(65 + index),
                  selected: _selectedIndex == index,
                  correct: _answered && index == _question.answerIndex,
                  incorrect:
                      _answered &&
                      _selectedIndex == index &&
                      !answeredCorrectly,
                  enabled: !_answered && !_saving,
                  onTap: () => _submitAnswer(index),
                ),
              if (_answered) ...[
                const SizedBox(height: 11),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: answeredCorrectly
                        ? const Color(0xFFDEF4E9)
                        : const Color(0xFFFFE8E5),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        answeredCorrectly
                            ? Icons.check_circle_rounded
                            : Icons.menu_book_rounded,
                        color: answeredCorrectly
                            ? const Color(0xFF23865F)
                            : const Color(0xFFB4493E),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              answeredCorrectly
                                  ? 'That’s right!'
                                  : 'Let’s learn from it',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: answeredCorrectly
                                    ? const Color(0xFF176B4B)
                                    : const Color(0xFF96382F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _question.explanation,
                              style: const TextStyle(height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(21, 8, 21, 15),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _answered ? _continue : null,
              child: _saving
                  ? const SizedBox(
                      height: 19,
                      width: 19,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _questionIndex == widget.topic.questions.length - 1
                          ? 'Finish lesson'
                          : 'Continue',
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LessonNote extends StatelessWidget {
  const _LessonNote({
    required this.icon,
    required this.label,
    required this.content,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.letter,
    required this.selected,
    required this.correct,
    required this.incorrect,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final String letter;
  final bool selected;
  final bool correct;
  final bool incorrect;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderColor = correct
        ? const Color(0xFF2D9970)
        : incorrect
        ? const Color(0xFFD05B4E)
        : selected
        ? colors.primary
        : colors.outlineVariant;
    final background = correct
        ? const Color(0xFFDEF4E9)
        : incorrect
        ? const Color(0xFFFFE8E5)
        : selected
        ? colors.primary.withValues(alpha: .08)
        : colors.surface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints: const BoxConstraints(minHeight: 57),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: selected || correct ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: borderColor.withValues(alpha: .12),
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (correct)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF2D9970),
                  )
                else if (incorrect)
                  const Icon(Icons.cancel_rounded, color: Color(0xFFD05B4E)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LargeTopicIcon extends StatelessWidget {
  const _LargeTopicIcon({required this.topic});

  final StudyTopic topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        topic.icon,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w900,
          fontSize: 27,
        ),
      ),
    );
  }
}
