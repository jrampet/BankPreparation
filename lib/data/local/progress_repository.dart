import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/study_models.dart';

abstract interface class ProgressRepository {
  Future<Progress> load();
  Future<void> save(Progress progress);
}

class SqliteProgressRepository implements ProgressRepository {
  SqliteProgressRepository(this.database);

  static const schemaVersion = 1;
  final Database database;

  static Future<SqliteProgressRepository> open() async {
    final databasesPath = await getDatabasesPath();
    return openAt(path.join(databasesPath, 'prepquest.db'));
  }

  static Future<SqliteProgressRepository> openAt(String databasePath) async {
    final database = await openDatabase(
      databasePath,
      version: schemaVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE app_progress (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            document TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE assessment_results (
            id TEXT PRIMARY KEY,
            exam_id TEXT NOT NULL,
            title TEXT NOT NULL,
            total_questions INTEGER NOT NULL,
            correct_answers INTEGER NOT NULL,
            wrong_answers INTEGER NOT NULL,
            skipped_questions INTEGER NOT NULL,
            score REAL NOT NULL,
            max_score REAL NOT NULL,
            duration_seconds INTEGER NOT NULL,
            completed_at TEXT NOT NULL
          )
        ''');
        await db.execute(
          'CREATE INDEX assessment_results_exam_date '
          'ON assessment_results(exam_id, completed_at)',
        );
      },
    );
    final repository = SqliteProgressRepository(database);
    await repository._migrateSharedPreferences();
    return repository;
  }

  @override
  Future<Progress> load() async {
    final rows = await database.query(
      'app_progress',
      columns: ['document'],
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return const Progress();

    final decoded = jsonDecode(rows.single['document']! as String);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Saved learning progress has an invalid shape.',
      );
    }

    final attempts = await database.query(
      'assessment_results',
      orderBy: 'completed_at DESC',
    );
    return Progress.fromJson({
      ...decoded,
      'assessmentResults': attempts
          .map(
            (row) => {
              'id': row['id'],
              'examId': row['exam_id'],
              'title': row['title'],
              'totalQuestions': row['total_questions'],
              'correctAnswers': row['correct_answers'],
              'wrongAnswers': row['wrong_answers'],
              'skippedQuestions': row['skipped_questions'],
              'score': row['score'],
              'maxScore': row['max_score'],
              'durationSeconds': row['duration_seconds'],
              'completedAt': row['completed_at'],
            },
          )
          .toList(),
    });
  }

  @override
  Future<void> save(Progress progress) async {
    final document = Map<String, Object?>.from(progress.toJson())
      ..remove('assessmentResults');
    await database.transaction((txn) async {
      await txn.insert('app_progress', {
        'id': 1,
        'document': jsonEncode(document),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      await txn.delete('assessment_results');
      for (final result in progress.assessmentResults) {
        await txn.insert('assessment_results', {
          'id': result.id,
          'exam_id': result.examId,
          'title': result.title,
          'total_questions': result.totalQuestions,
          'correct_answers': result.correctAnswers,
          'wrong_answers': result.wrongAnswers,
          'skipped_questions': result.skippedQuestions,
          'score': result.score,
          'max_score': result.maxScore,
          'duration_seconds': result.durationSeconds,
          'completed_at': result.completedAt,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> _migrateSharedPreferences() async {
    final rows = await database.query(
      'app_progress',
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isNotEmpty) return;

    const oldStorageKey = 'prepquest.progress.v1';
    final preferences = await SharedPreferences.getInstance();
    final stored = preferences.getString(oldStorageKey);
    if (stored == null) return;

    final decoded = jsonDecode(stored);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'The previous saved progress cannot be migrated because its data is invalid.',
      );
    }
    await save(Progress.fromJson(decoded));
    final removed = await preferences.remove(oldStorageKey);
    if (!removed) {
      throw StateError(
        'Migrated progress, but could not clear the old local copy.',
      );
    }
  }
}
