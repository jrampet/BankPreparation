class Gamification {
  static const lessonXp = 10;
  static const correctAnswerXp = 2;
  static const topicCompletionXp = 50;

  static int bonusXpForDailyMinutes(int minutes) {
    if (minutes < 45) return 0;
    if (minutes < 60) return 25;
    if (minutes < 90) return 50;
    if (minutes < 120) return 100;
    return 150;
  }

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static int updatedStreak({
    required int currentStreak,
    required String? lastStudyDate,
    required DateTime today,
  }) {
    final todayKey = dateKey(today);
    if (lastStudyDate == todayKey) return currentStreak;
    final yesterdayKey = dateKey(today.subtract(const Duration(days: 1)));
    return lastStudyDate == yesterdayKey ? currentStreak + 1 : 1;
  }
}
