import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../../books/data/model/books_model.dart';
import '../../../books/data/service/books_db.dart';
import '../../../members/data/model/members_model.dart';
import '../../../members/data/service/members_db.dart';
import '../model/issue_records_model.dart';

class IssueDBHive {
  static const String boxName = 'issue_records';
  static Box<IssueRecords>? _issueBox;
  static int _nextId = 1;

  static Box<IssueRecords> get box {
    if (_issueBox == null) {
      throw Exception('Hive not initialized. Call initHive() first.');
    }
    return _issueBox!;
  }

  static Future<void> initIssueBox() async {
    try {
      _issueBox = await Hive.openBox<IssueRecords>(boxName);
      final allIssues = getAllIssues();
      if (allIssues.isNotEmpty) {
        final ids = allIssues.map((i) {
          final idStr = i.issueId.substring(1);
          return int.tryParse(idStr) ?? 0;
        }).toList();
        _nextId = (ids.reduce((a, b) => a > b ? a : b)) + 1;
      }

    } catch (e) {
      debugPrint('Error opening issue box: $e');
      rethrow;
    }
  }

  static bool get isReady => _issueBox != null && _issueBox!.isOpen;

  static String _generateIssueId() {
    final id = _nextId.toString().padLeft(3, '0');
    _nextId++;
    return 'I$id';
  }

  static Future<String> addIssue({
    required String bookId,
    required String memberId,
    required DateTime dueDate,
    required String memberName,
    required String bookName,
  }) async {
    final issueId = _generateIssueId();

    final record = IssueRecords(
      issueId: issueId,
      bookId: bookId,
      memberId: memberId,
      borrowDate: DateTime.now(),
      dueDate: dueDate,
      bookName: bookName,
      memberName: memberName,
      isFinePaid: null,
    );

    await box.put(issueId, record);
    return issueId;
  }

  static List<IssueRecords> getAllIssues() {
    return box.values.toList();
  }

  static IssueRecords? getIssueById(String issueId) {
    return box.get(issueId);
  }

  static List<IssueRecords> getActiveIssues() {
    return box.values.where((issue) => !issue.isReturned).toList();
  }

  // Claude changed: Simplified return - only marks as returned, doesn't reset fine
  static Future<void> returnIssue(String issueId) async {
    final issue = getIssueById(issueId);
    if (issue == null) return;

    final updated = issue.copyWith(
      isReturned: true,
      returnDate: DateTime.now(),
      // Claude changed: Keep fine amount and payment status as is
    );

    await box.put(issueId, updated);
  }

  static Future<void> deleteIssue(String issueId) async {
    await box.delete(issueId);
  }

  static List<IssueRecords> getIssuesByMember(String memberId) {
    return box.values.where((issue) => issue.memberId == memberId).toList();
  }

  static List<IssueRecords> getActiveIssuesByMember(String memberId) {
    return box.values
        .where((issue) => issue.memberId == memberId && !issue.isReturned)
        .toList();
  }

  static List<IssueRecords> getIssuesByBook(int bookId) {
    return box.values.where((issue) => issue.bookId == bookId).toList();
  }

  static bool isBookBorrowed(int bookId) {
    return box.values.any(
      (issue) => issue.bookId == bookId && !issue.isReturned,
    );
  }

  static Future<void> clearAll() async {
    final List<BookModel>? books = await BooksDBHive.getBooks();
    final List<MemberModel>? members = await MembersDB.getMembers();

    if(books != null) {
      for (var book in books) {
        final updatedBook = book.copyWith(copiesAvailable: book.totalCopies);
        BooksDBHive.updateBook(updatedBook);
      }
    }

    if(members != null){
      for (var member in members) {
        final updatedMember = member.copyWith(currentlyBorrow: 0);
        MembersDB.updateMember(updatedMember);
      }
    }
    await box.clear();
    _nextId = 1;
  }
}
