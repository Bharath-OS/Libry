// lib/provider/issue_provider.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../database/issue_records_db.dart';
import '../models/issue_records_model.dart';

class IssueProvider with ChangeNotifier {
  List<IssueRecords> _allIssues = [];
  List<IssueRecords> _filteredIssues = [];
  int fineAmount = 5;
  int get fineOwed {
    int fines = 0;
    _allIssues.map((issue) => fines += issue.fineAmount);
    return fines;
  }

  int get dueTodayCount {
    return _allIssues
        .where((issue) => DateUtils.isSameDay(issue.dueDate, DateTime.now()))
        .length;
  }

  static Box<IssueRecords>? _issueBox;
  String _filter = 'all'; // 'all', 'active', 'returned'

  List<IssueRecords> get issues => _filteredIssues;
  List<IssueRecords> get allIssues => _allIssues;
  int get totalCount => _allIssues.length;
  int get activeCount => _allIssues.where((i) => !i.isReturned).length;
  int get returnedCount => _allIssues.where((i) => i.isReturned).length;
  int get issuedTodayCount => _allIssues
      .where((i) => DateUtils.isSameDay(i.borrowDate, DateTime.now()))
      .length;
  int get overDueCount =>
      _allIssues.where((i) => i.dueDate.isAfter(DateTime.now())).length;

  // Initialize
  Future<void> init() async {
    await IssueDBHive.initIssueBox();
    await refresh();
  }

  // Refresh data
  Future<void> refresh() async {
    _allIssues = IssueDBHive.getAllIssues();
    _applyFilter();
    notifyListeners();
  }

  // ========== SIMPLE BUSINESS LOGIC ==========

  // Borrow a book (returns issue ID)
  Future<String> borrowBook({
    required int bookId,
    required int memberId,
    required DateTime dueDate,
  }) async {
    // Check if Hive is ready
    if (!IssueDBHive.isReady) {
      throw Exception('Database not ready. Please try again.');
    }

    final issueId = await IssueDBHive.addIssue(
      bookId: bookId,
      memberId: memberId,
      dueDate: dueDate,
    );

    await refresh();
    return issueId;
  }

  // Return a book
  Future<void> returnBook(String issueId) async {
    await IssueDBHive.returnIssue(issueId);
    await refresh();
  }

  // Delete issue (for corrections)
  Future<void> deleteIssue(String issueId) async {
    await IssueDBHive.deleteIssue(issueId);
    await refresh();
  }

  // Get issue by ID
  IssueRecords? getIssue(String issueId) {
    return IssueDBHive.getIssueById(issueId);
  }

  // Get active issues for member
  List<IssueRecords> getMemberActiveIssues(int memberId) {
    return IssueDBHive.getActiveIssuesByMember(memberId);
  }

  // Check if member can borrow (limit: 5 books)
  bool canMemberBorrow(int memberId) {
    final active = getMemberActiveIssues(memberId).length;
    return active < 5;
  }

  // Check if book is available
  bool isBookAvailable(int bookId) {
    return !IssueDBHive.isBookBorrowed(bookId);
  }

  // Calculate fine for overdue book
  int calculateFine(IssueRecords issue) {
    if (issue.isReturned) return issue.fineAmount;

    if (DateTime.now().isAfter(issue.dueDate)) {
      final daysLate = DateTime.now().difference(issue.dueDate).inDays;
      return daysLate * fineAmount; // ₹5 per day
    }

    return 0;
  }

  // ========== FILTERING ==========

  void setFilter(String filter) {
    _filter = filter;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    switch (_filter) {
      case 'active':
        _filteredIssues = _allIssues.where((i) => !i.isReturned).toList();
        break;
      case 'returned':
        _filteredIssues = _allIssues.where((i) => i.isReturned).toList();
        break;
      default: // 'all'
        _filteredIssues = _allIssues;
    }
  }

  // Get box instance with null check
  static Box<IssueRecords> get _box {
    if (_issueBox == null || !_issueBox!.isOpen) {
      throw Exception('Issue box not initialized. Call initIssueBox() first.');
    }
    return _issueBox!;
  }

  // Clear all (testing)
  Future<void> clearAll() async {
    await IssueDBHive.clearAll();
    await refresh();
  }
}
