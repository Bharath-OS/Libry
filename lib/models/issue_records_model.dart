// lib/models/issue_records_model.dart
import 'package:hive/hive.dart';

part 'issue_records_model.g.dart';

@HiveType(typeId: 3)
class IssueRecords {
  @HiveField(0)
  final String issueId; // I001, I002, etc.

  @HiveField(1)
  final int bookId;

  @HiveField(2)
  final int memberId;

  @HiveField(3)
  final DateTime borrowDate;

  @HiveField(4)
  final DateTime dueDate;

  @HiveField(5)
  DateTime? returnDate;

  @HiveField(6)
  bool isReturned;

  @HiveField(7)
  int fineAmount;

  @HiveField(8)
  String? bookName;

  @HiveField(9)
  String? memberName;

  IssueRecords({
    required this.issueId,
    required this.bookId,
    this.bookName,
    required this.memberId,
    this.memberName,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.isReturned = false,
    this.fineAmount = 0,
  });

  // Simple copyWith for updates
  IssueRecords copyWith({
    bool? isReturned,
    DateTime? returnDate,
    int? fineAmount,
    String? booksName,
    String? membersName
  }) {
    return IssueRecords(
      issueId: issueId,
      bookId: bookId,
      memberId: memberId,
      borrowDate: borrowDate,
      dueDate: dueDate,
      memberName: membersName ?? this.memberName,
      bookName: booksName ?? this.bookName,
      returnDate: returnDate ?? this.returnDate,
      isReturned: isReturned ?? this.isReturned,
      fineAmount: fineAmount ?? this.fineAmount,
    );
  }
}