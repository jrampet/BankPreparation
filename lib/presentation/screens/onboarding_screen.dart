import 'package:flutter/material.dart';

import '../../data/content/exam_syllabi.dart';
import '../../data/content/study_content.dart';
import '../../domain/progress_controller.dart';
import '../../domain/study_models.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.controller, super.key});

  final ProgressController controller;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _selectedExam = 'ibps_po';
  int _dailyGoal = 30;
  String _preparationLevel = 'Starting out';
  final Set<String> _strongSubjects = {};
  final Set<String> _weakSubjects = {};
  bool _saving = false;

  Future<void> _start() async {
    setState(() => _saving = true);
    try {
      await widget.controller.selectExam(
        _selectedExam,
        dailyGoalMinutes: _dailyGoal,
        preparationLevel: _preparationLevel,
        strongSubjects: _strongSubjects,
        weakSubjects: _weakSubjects,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save your setup: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final subjects = examSyllabi[_selectedExam]!.subjects;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Text(
                      'PrepQuest',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.5,
                      ),
                    ),
                    const _OfflineBadge(),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'Your next big goal,\none small win at a time.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.08,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Build a study habit that fits real life. Start with a five-minute lesson and keep your progress, even offline.',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: colors.onSurfaceVariant, height: 1.45),
                ),
                const SizedBox(height: 28),
                Text(
                  'CHOOSE YOUR EXAM',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                for (final exam in exams)
                  _ExamChoice(
                    exam: exam,
                    selected: _selectedExam == exam.id,
                    onTap: () => setState(() => _selectedExam = exam.id),
                  ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A daily goal that works for you',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You can change this any time. Small and steady counts.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 9,
                          children: [15, 30, 45].map((minutes) {
                            return ChoiceChip(
                              label: Text('$minutes min'),
                              selected: _dailyGoal == minutes,
                              onSelected: (_) =>
                                  setState(() => _dailyGoal = minutes),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Where are you in your preparation?',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 9),
                        DropdownButtonFormField<String>(
                          initialValue: _preparationLevel,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Current preparation level',
                          ),
                          items:
                              const [
                                    'Starting out',
                                    'Building confidence',
                                    'Regular practice',
                                    'Revision and mock tests',
                                  ]
                                  .map(
                                    (level) => DropdownMenuItem(
                                      value: level,
                                      child: Text(level),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (level) {
                            if (level != null) {
                              setState(() => _preparationLevel = level);
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Subjects that feel strong (optional)',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: subjects.map((subject) {
                            return ChoiceChip(
                              label: Text(subject),
                              selected: _strongSubjects.contains(subject),
                              onSelected: (selected) => setState(() {
                                if (selected) {
                                  _strongSubjects.add(subject);
                                  _weakSubjects.remove(subject);
                                } else {
                                  _strongSubjects.remove(subject);
                                }
                              }),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Subjects to focus on (optional)',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: subjects.map((subject) {
                            return ChoiceChip(
                              label: Text(subject),
                              selected: _weakSubjects.contains(subject),
                              onSelected: (selected) => setState(() {
                                if (selected) {
                                  _weakSubjects.add(subject);
                                  _strongSubjects.remove(subject);
                                } else {
                                  _weakSubjects.remove(subject);
                                }
                              }),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving ? null : _start,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Build my study path'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Practice builds readiness; it cannot guarantee exam selection.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExamChoice extends StatelessWidget {
  const _ExamChoice({
    required this.exam,
    required this.selected,
    required this.onTap,
  });

  final Exam exam;
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
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: selected ? colors.primary : colors.outlineVariant,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.primary.withValues(alpha: .12)
                        : colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    exam.category == 'Banking'
                        ? Icons.account_balance_rounded
                        : Icons.train_rounded,
                    color: selected ? colors.primary : colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.shortName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        exam.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected ? colors.primary : colors.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OfflineBadge extends StatelessWidget {
  const _OfflineBadge();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.cloud_off_rounded, size: 15, color: Color(0xFF39876D)),
        SizedBox(width: 4),
        Text(
          'Works offline',
          style: TextStyle(
            color: Color(0xFF39876D),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
