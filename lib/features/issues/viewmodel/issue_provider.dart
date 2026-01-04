import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:libry/features/members/data/service/members_db.dart';
import '../../settings/data/service/settings_service.dart';
import '../data/service/issue_records_db.dart';
import '../data/model/issue_records_model.dart';

class IssueViewModel with ChangeNotifier {
  List<IssueRecords> _allIssues = [];
  List<IssueRecords> _filteredIssues = [];
  String _filter = 'all';

  // Getters
  List<IssueRecords> get issues => _filteredIssues;
  List<IssueRecords> get allIssues => _allIssues;
  double get currentFineRate => SettingsService.instance.fineAmount;

  // Stats Getters
  int get totalCount => _allIssues.length;
  int get returnedCount => _allIssues.where((i) => i.isReturned).length;
  int get activeCount => _allIssues.where((i) => !i.isReturned).length;
  int get overDueCount => _allIssues.where((i) => !i.isReturned && DateTime.now().isAfter(i.dueDate)).length;
  int get issuedTodayCount => _allIssues
      .where((i) => DateUtils.isSameDay(i.borrowDate, DateTime.now()))
      .length;

  double getMemberFine(int memberId){
    final issues = IssueDBHive.getIssuesByMember(memberId);
    return issues
        .where((issue) => !issue.isReturned)
        .fold(0.0, (sum, issue) => sum + calculateFine(issue));

  }

  int get dueTodayCount {
    return _allIssues
        .where((i) => !i.isReturned && DateUtils.isSameDay(i.dueDate, DateTime.now()))
        .length;
  }

  int get returnTodayCount {
    return _allIssues
        .where((i) => i.isReturned && i.returnDate != null && DateUtils.isSameDay(i.returnDate!, DateTime.now()))
        .length;
  }

  double get totalPendingFines {
    return _allIssues
        .where((issue) => !issue.isReturned)
        .fold(0.0, (double sum, issue) => sum + calculateFine(issue));
  }
  // Initialize
  Future<void> init() async {
    await IssueDBHive.initIssueBox();
    await refresh();
  }

  Future<void> refresh() async {
    if (IssueDBHive.isReady) {
      _allIssues = IssueDBHive.getAllIssues();
      await _updateFines(); // Syncs Hive fines with Member SQLite fines
      _applyFilter();
      notifyListeners();
    }
  }

  // Borrow a book (Restored name)
  Future<String> borrowBook({
    required int bookId,
    required int memberId,
    required DateTime dueDate,
    required String memberName,
    required String bookName,
  }) async {
    if (!IssueDBHive.isReady) {
      throw Exception('Database not ready. Please try again.');
    }

    final issueId = await IssueDBHive.addIssue(
      bookId: bookId,
      memberId: memberId,
      dueDate: dueDate,
      memberName: memberName,
      bookName: bookName,
    );

    await refresh();
    return issueId;
  }

  // ========== CORE BUSINESS LOGIC ==========

  // 1. Update fines progressively (The "Taxi Meter" logic)
  Future<void> _updateFines() async {
    bool hasChanges = false;
    final now = DateTime.now();

    for (var issue in _allIssues.where((i) => !i.isReturned && now.isAfter(i.dueDate))) {
      DateTime lastUpdate = issue.lastFineUpdateDate ?? issue.dueDate;

      if (!DateUtils.isSameDay(lastUpdate, now)) {
        int daysPassed = _calculateFullDaysPassed(lastUpdate, now);

        if (daysPassed > 0) {
          double additionalFine = daysPassed * currentFineRate;

          // Update Hive
          final updatedIssue = issue.copyWith(
            fineAmount: issue.fineAmount + additionalFine,
            lastFineUpdateDate: DateTime(now.year, now.month, now.day),
          );
          await IssueDBHive.box.put(issue.issueId, updatedIssue);

          // Update SQLite Member Balance
          await MembersDB.incrementMemberFine(issue.memberId, additionalFine);
          hasChanges = true;
        }
      }
    }
    if (hasChanges) _allIssues = IssueDBHive.getAllIssues();
  }

  // 2. Mark fine as paid (Called from your Dialog)
  Future<void> markFinePaid(String issueId, double amountPaid) async {
    final issue = IssueDBHive.getIssueById(issueId);
    if (issue == null) return;

    await MembersDB.incrementMemberFine(issue.memberId, amountPaid);

    final updatedIssue = issue.copyWith(
      fineAmount: 0.0,
      lastFineUpdateDate: null,
      isFinePaid: true
    );
    await IssueDBHive.box.put(issueId, updatedIssue);
    await refresh();
  }

  // 3. Return Book
  Future<void> returnBook(String issueId) async {
    await IssueDBHive.returnIssue(issueId);
    // Note: We don't reset fine to 0 here because markFinePaid
    // should have been called first per your UI logic.
    await refresh();
  }

  // 4. Calculate for Display (Includes today's unsaved fine)
  double calculateFine(IssueRecords issue) {
    if (issue.isReturned) return 0.0;
    final now = DateTime.now();
    if (!now.isAfter(issue.dueDate)) return 0.0;

    double totalFine = issue.fineAmount;
    DateTime lastUpdate = issue.lastFineUpdateDate ?? issue.dueDate;

    if (!DateUtils.isSameDay(lastUpdate, now)) {
      totalFine += currentFineRate;
    }
    return totalFine;
  }

  // ========== HELPERS ==========

  int _calculateFullDaysPassed(DateTime from, DateTime to) {
    final fromMidnight = DateTime(from.year, from.month, from.day);
    final toMidnight = DateTime(to.year, to.month, to.day);
    return toMidnight.difference(fromMidnight).inDays;
  }

  void setFilter(String filter) {
    _filter = filter;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_filter == 'active') {
      _filteredIssues = _allIssues.where((i) => !i.isReturned).toList();
    } else if (_filter == 'returned') {
      _filteredIssues = _allIssues.where((i) => i.isReturned).toList();
    } else {
      _filteredIssues = _allIssues;
    }
  }
}