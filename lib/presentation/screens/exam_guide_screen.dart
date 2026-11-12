import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/content/exam_syllabi.dart';
import '../../data/content/study_content.dart';

class ExamGuideScreen extends StatelessWidget {
  const ExamGuideScreen({required this.examId, super.key});

  final String examId;

  Future<void> _openOfficialSource(BuildContext context, String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the official website.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final exam = exams.firstWhere((item) => item.id == examId);
    final syllabus = examSyllabi[examId]!;
    return Scaffold(
      appBar: AppBar(title: Text('${exam.shortName} guide')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(19, 8, 19, 28),
        children: [
          Card(
            color: colors.primaryContainer.withValues(alpha: .45),
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_outlined, color: colors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Check the official notice first',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${syllabus.noticeCycle}. This guide was checked on ${syllabus.sourceCheckedOn}.',
                    style: const TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        _openOfficialSource(context, syllabus.sourceUrl),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open official notice hub'),
                  ),
                  if (exam.category == 'Railways')
                    TextButton.icon(
                      onPressed: () => _openOfficialSource(
                        context,
                        officialRrbApplicationUrl,
                      ),
                      icon: const Icon(Icons.assignment_outlined),
                      label: const Text('RRB application & CEN portal'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Exam subject areas',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 9),
          for (final section in syllabus.sections)
            Card(
              margin: const EdgeInsets.only(bottom: 11),
              child: ExpansionTile(
                initiallyExpanded: syllabus.sections.length == 1,
                title: Text(
                  section.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text('${section.subjects.length} subject areas'),
                childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      section.description,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final subject in section.subjects)
                    _SubjectTopics(subject: subject),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'About the topic map',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                syllabus.verificationNote,
                style: const TextStyle(height: 1.45),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Official source: ${syllabus.sourceLabel}\n${syllabus.sourceUrl}',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colors.onSurfaceVariant, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _SubjectTopics extends StatelessWidget {
  const _SubjectTopics({required this.subject});

  final String subject;

  @override
  Widget build(BuildContext context) {
    final topics = practiceTopicsBySubject[subject] ?? const <String>[];
    if (topics.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 6,
            runSpacing: 0,
            children: topics
                .map(
                  (topic) => Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(topic),
                    labelStyle: const TextStyle(fontSize: 11),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
