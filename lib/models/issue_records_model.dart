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
  double fineAmount;

  IssueRecords({
    required this.issueId,
    required this.bookId,
    required this.memberId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.isReturned = false,
    this.fineAmount = 0.0,
  });

  // Simple copyWith for updates
  IssueRecords copyWith({
    bool? isReturned,
    DateTime? returnDate,
    double? fineAmount,
  }) {
    return IssueRecords(
      issueId: issueId,
      bookId: bookId,
      memberId: memberId,
      borrowDate: borrowDate,
      dueDate: dueDate,
      returnDate: returnDate ?? this.returnDate,
      isReturned: isReturned ?? this.isReturned,
      fineAmount: fineAmount ?? this.fineAmount,
    );
  }
}