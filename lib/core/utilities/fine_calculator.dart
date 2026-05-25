import '../../features/issues/data/model/issue_records_model.dart';

class FineCalculator {
  /// Calculates the fine for a given [issue] based on the current [now] time and [fineRatePerDay].
  /// This includes today's unsaved fine if the background sync has not run yet.
  static double calculate({
    required IssueRecords issue,
    required DateTime now,
    required double fineRatePerDay,
  }) {
    if (issue.isReturned) return 0.0;
    if (issue.isFinePaid == true) return 0.0;
    if (!now.isAfter(issue.dueDate)) return 0.0;

    double totalFine = issue.fineAmount;
    DateTime lastUpdate = issue.lastFineUpdateDate ?? issue.dueDate;

    // Compare only the dates (year, month, day) to check if we're on a new day
    final lastUpdateMidnight = DateTime(lastUpdate.year, lastUpdate.month, lastUpdate.day);
    final nowMidnight = DateTime(now.year, now.month, now.day);

    if (lastUpdateMidnight != nowMidnight) {
      totalFine += fineRatePerDay;
    }
    return totalFine;
  }

  /// Calculates full days passed between two dates (midnight to midnight)
  static int calculateFullDaysPassed(DateTime from, DateTime to) {
    final fromMidnight = DateTime(from.year, from.month, from.day);
    final toMidnight = DateTime(to.year, to.month, to.day);
    return toMidnight.difference(fromMidnight).inDays;
  }
}
