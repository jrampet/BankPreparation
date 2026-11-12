# PrepQuest

PrepQuest is an offline-first Flutter app for Indian banking and railway recruitment exam preparation.

## What is implemented

- Onboarding for IBPS PO, IBPS Clerk, IBPS RRB PO, IBPS RRB Clerk, RRB NTPC, RRB Group D, RRB ALP and RRB JE.
- Daily goal, preparation-level and strong/weak subject preferences.
- Home dashboard, exam-specific subject map, syllabus/notice guide, study-plan suggestions and target-date countdown.
- Offline concept lessons with formulas, worked examples and five explained practice questions per seeded topic.
- Quick, topic and timed mixed-practice sessions with question navigation, review flags, a timer, result history and incorrect-answer explanations.
- A mistake bank, staged 1/3/7/14/30-day revision scheduling, active learning-time tracking, streaks and repeat-safe XP.
- SQLite persistence for local progress and assessment history. Existing Phase 1 SharedPreferences progress is migrated on first database open.
- Subject-level analytics, a readiness estimate and achievement milestones.
- Light and dark themes.

The learning path is intentionally honest about its coverage: the bundled offline question bank is a small curated starter set, not a complete bank for all eight exams. The timed tests are practice sessions using that bank; they are not full-length official-pattern mock exams and do not apply official negative marking.

## Run and validate

```sh
flutter pub get
flutter run
flutter analyze
flutter test
```

## Official-source and syllabus policy

The guide in the app links to the recruiting authorities:

- IBPS recruitment hub: <https://www.ibps.in/index.php/recruitment/>
- IBPS Regional Rural Bank hub: <https://www.ibps.in/index.php/regional-rural-bank/>
- Ministry of Railways RRB CEN index: <https://rrb.indianrailways.gov.in/cencall/cen-list>
- RRB application portal: <https://www.rrbapply.gov.in/>

The Ministry of Railways CEN index was reachable and its current notice listing was checked on 9 November 2026. Individual, post-specific notice PDFs could not be retrieved in this environment. IBPS's official recruitment hub and active detailed notification also could not be retrieved reliably. Therefore the in-app guide explicitly identifies the section map as a high-level orientation guide and the topic chips as PrepQuest's curated practice map—not as an exhaustive or fully verified current-cycle official syllabus. The user must check the linked active notice for dates, subjects, stages, question counts, timing, eligibility and marking rules. Do not treat the sample questions as verified previous-year questions.

This distinction is important because recruiting authorities publish the current notice as the source of truth; topic-by-topic lists on exam-preparation sites are not a substitute. When the notice PDFs are accessible, record their exact cycle, publication date, URL and any corrigenda before marking a pattern as verified.

## Architecture

- `lib/presentation/`: onboarding, dashboard, syllabus/notice guide, lessons, timed practice, revision, analytics, plan and achievements.
- `lib/domain/`: exam/syllabus/question/progress models, progress controller, streak and XP logic.
- `lib/data/content/`: offline seed questions, syllabus subject-area guide and practice-topic taxonomy.
- `lib/data/local/`: SQLite repository, migration from the earlier SharedPreferences key and assessment-result storage.

`ProgressController` depends on `ProgressRepository`, so UI and domain code do not issue SQL directly. Seed content is bundled in Dart constants and remains usable without connectivity.

## Local database

SQLite schema version 1 currently has:

- `app_progress(id, document)`: the versioned local profile/progress state document.
- `assessment_results(id, exam_id, title, total_questions, correct_answers, wrong_answers, skipped_questions, score, max_score, duration_seconds, completed_at)`: one row per completed test, indexed by exam and date.

The progress document includes exam/profile preferences, target date, XP/streak, active study seconds, topic/question progress, revision due dates and stages, and question-attempt counters. This is device-local persistence, not a cloud-sync implementation. A future schema migration can normalize question and topic progress once the content bank is large enough to benefit from independently queryable content records.

## Gamification and practice

- The first correct response to each question can earn 2 XP; repeated correct responses do not farm question XP.
- First topic completion earns 10 lesson XP plus 50 topic XP; later completions do not repeat that topic reward.
- Extra-study bonus thresholds are 45/60/90/120 measured minutes, with cumulative daily awards capped at 150 XP.
- Study timing runs within lesson/test foreground sessions and pauses when the app is backgrounded.
- Incorrect responses enter the mistake bank with 1, 3, 7, 14 and 30-day review intervals; a correct response clears the current mistake.
- Test scoring currently reports correct answers without negative marking. Verify the active official notice before introducing an exam-specific scoring rule.

## Still to build before calling the product complete

- Retrieve, review and version the current detailed official notices for all eight exams, including corrigenda; expand and independently verify each syllabus and exam pattern against those documents.
- Commission and quality-check a complete, exam-specific question bank, solutions, tagged difficulty and verified previous-year items.
- Full-length exam-pattern mocks with section timers, question palette, review flags, auto-submit, official negative-marking rules and detailed reports.
- Topic/module/weekly assessments with the requested lengths and coverage.
- Normalized SQLite content tables and content-version/migration tooling.
- Reliable sync/outbox/conflict handling, downloadable content updates and optional current-affairs feeds.
- User-configurable local reminders, more achievements, and opt-in leaderboards/friends.

The current readiness number is a study-progress estimate, not a prediction of passing or selection.
