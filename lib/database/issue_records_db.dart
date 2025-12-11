// lib/database/issue_db_hive.dart
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/issue_records_model.dart';

class IssueDBHive {
  static const String _boxName = 'issue_records';
  static Box<IssueRecords>? _issueBox;
  static int _nextId = 1;

  // Initialize Hive
  static Future<void> initIssueBox() async {
    try {
      // Just open the box, Hive is already initialized in main.dart
      _issueBox = await Hive.openBox<IssueRecords>(_boxName);

      // Find highest issue ID to continue sequence
      final allIssues = getAllIssues();
      if (allIssues.isNotEmpty) {
        final ids = allIssues.map((i) {
          final idStr = i.issueId.substring(1); // Remove 'I'
          return int.tryParse(idStr) ?? 0;
        }).toList();
        _nextId = (ids.reduce((a, b) => a > b ? a : b)) + 1;
      }
    } catch (e) {
      print('Error opening issue box: $e');
      rethrow;
    }
  }

  // Check if box is ready
  static bool get isReady => _issueBox != null && _issueBox!.isOpen;

  // Generate issue ID: I001, I002, etc.
  static String _generateIssueId() {
    final id = _nextId.toString().padLeft(3, '0');
    _nextId++;
    return 'I$id';
  }

  // Get box instance
  static Box<IssueRecords> get _box {
    if (_issueBox == null) {
      throw Exception('Hive not initialized. Call initHive() first.');
    }
    return _issueBox!;
  }

  // ========== SIMPLE CRUD OPERATIONS ==========

  // 1. Add new issue
  static Future<String> addIssue({
    required int bookId,
    required int memberId,
    required DateTime dueDate,
  }) async {
    final issueId = _generateIssueId();

    final record = IssueRecords(
      issueId: issueId,
      bookId: bookId,
      memberId: memberId,
      borrowDate: DateTime.now(),
      dueDate: dueDate,
    );

    await _box.put(issueId, record);
    return issueId;
  }

  // 2. Get all issues
  static List<IssueRecords> getAllIssues() {
    return _box.values.toList();
  }

  // 3. Get issue by ID
  static IssueRecords? getIssueById(String issueId) {
    return _box.get(issueId);
  }

  // 4. Get active issues (not returned)
  static List<IssueRecords> getActiveIssues() {
    return _box.values.where((issue) => !issue.isReturned).toList();
  }

  // 5. Return a book
  static Future<void> returnIssue(String issueId) async {
    final issue = getIssueById(issueId);
    if (issue == null) return;

    final updated = issue.copyWith(
      isReturned: true,
      returnDate: DateTime.now(),
    );

    await _box.put(issueId, updated);
  }

  // 6. Delete issue (for corrections)
  static Future<void> deleteIssue(String issueId) async {
    await _box.delete(issueId);
  }

  // 7. Get issues by member
  static List<IssueRecords> getIssuesByMember(int memberId) {
    return _box.values.where((issue) => issue.memberId == memberId).toList();
  }

  // 8. Get active issues by member
  static List<IssueRecords> getActiveIssuesByMember(int memberId) {
    return _box.values.where((issue) =>
    issue.memberId == memberId && !issue.isReturned
    ).toList();
  }

  // 9. Get issues by book
  static List<IssueRecords> getIssuesByBook(int bookId) {
    return _box.values.where((issue) => issue.bookId == bookId).toList();
  }

  // 10. Check if book is borrowed
  static bool isBookBorrowed(int bookId) {
    return _box.values.any((issue) =>
    issue.bookId == bookId && !issue.isReturned
    );
  }

  // 11. Clear all (for testing)
  static Future<void> clearAll() async {
    await _box.clear();
    _nextId = 1;
  }
}