import 'package:Libry/core/utilities/fine_calculator.dart';
import 'package:Libry/features/issues/data/model/issue_records_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FineCalculator - calculateFullDaysPassed Tests', () {
    test('Same day different hours should return 0 days', () {
      final from = DateTime(2026, 5, 20, 10, 0);
      final to = DateTime(2026, 5, 20, 23, 30);
      expect(FineCalculator.calculateFullDaysPassed(from, to), equals(0));
    });

    test('Overnight (23:00 to 01:00 next day) should return 1 day', () {
      final from = DateTime(2026, 5, 20, 23, 0);
      final to = DateTime(2026, 5, 21, 1, 0);
      expect(FineCalculator.calculateFullDaysPassed(from, to), equals(1));
    });

    test('Exactly 24 hours apart should return 1 day', () {
      final from = DateTime(2026, 5, 20, 10, 0);
      final to = DateTime(2026, 5, 21, 10, 0);
      expect(FineCalculator.calculateFullDaysPassed(from, to), equals(1));
    });

    test('Multiple days apart should return the correct count', () {
      final from = DateTime(2026, 5, 20, 15, 0);
      final to = DateTime(2026, 5, 25, 10, 0); // 5 days difference
      expect(FineCalculator.calculateFullDaysPassed(from, to), equals(5));
    });
  });

  group('FineCalculator - calculate (Display Fine) Tests', () {
    final tBorrowDate = DateTime(2026, 5, 10);
    final tDueDate = DateTime(2026, 5, 15); // Overdue starting May 16th
    const tFineRate = 3.0; // ₹3.0 per day

    test('Returned issues should have a fine of 0.0', () {
      final issue = IssueRecords(
        issueId: 'I001',
        bookId: 'B001',
        memberId: 'M001',
        borrowDate: tBorrowDate,
        dueDate: tDueDate,
        isReturned: true,
        fineAmount: 15.0,
      );

      final now = DateTime(2026, 5, 20); // 5 days past due date
      final fine = FineCalculator.calculate(
        issue: issue,
        now: now,
        fineRatePerDay: tFineRate,
      );

      expect(fine, equals(0.0));
    });

    test('Issues with fine marked as paid should have a fine of 0.0', () {
      final issue = IssueRecords(
        issueId: 'I001',
        bookId: 'B001',
        memberId: 'M001',
        borrowDate: tBorrowDate,
        dueDate: tDueDate,
        isReturned: false,
        fineAmount: 15.0,
        isFinePaid: true,
      );

      final now = DateTime(2026, 5, 20);
      final fine = FineCalculator.calculate(
        issue: issue,
        now: now,
        fineRatePerDay: tFineRate,
      );

      expect(fine, equals(0.0));
    });

    test('Issues that are not overdue yet should have a fine of 0.0', () {
      final issue = IssueRecords(
        issueId: 'I001',
        bookId: 'B001',
        memberId: 'M001',
        borrowDate: tBorrowDate,
        dueDate: tDueDate,
        isReturned: false,
        fineAmount: 0.0,
      );

      // Current time is exactly on the due date
      final nowOnDueDate = DateTime(2026, 5, 15, 23, 59);
      final fineOnDueDate = FineCalculator.calculate(
        issue: issue,
        now: nowOnDueDate,
        fineRatePerDay: tFineRate,
      );

      // Current time is before the due date
      final nowBeforeDueDate = DateTime(2026, 5, 14, 12, 0);
      final fineBeforeDueDate = FineCalculator.calculate(
        issue: issue,
        now: nowBeforeDueDate,
        fineRatePerDay: tFineRate,
      );

      expect(fineOnDueDate, equals(0.0));
      expect(fineBeforeDueDate, equals(0.0));
    });

    test(
      'Overdue issue already updated today should return current saved fineAmount',
      () {
        final now = DateTime(2026, 5, 20, 14, 0);
        final issue = IssueRecords(
          issueId: 'I001',
          bookId: 'B001',
          memberId: 'M001',
          borrowDate: tBorrowDate,
          dueDate: tDueDate,
          isReturned: false,
          fineAmount: 12.0, // Stored fine
          lastFineUpdateDate: DateTime(
            2026,
            5,
            20,
            9,
            0,
          ), // Updated earlier today
        );

        final fine = FineCalculator.calculate(
          issue: issue,
          now: now,
          fineRatePerDay: tFineRate,
        );

        // Since lastFineUpdateDate is today, no progressive display fine should be added today
        expect(fine, equals(12.0));
      },
    );

    test(
      'Overdue issue NOT updated today should add one day of currentFineRate for display',
      () {
        final now = DateTime(2026, 5, 20, 14, 0);

        // Scenario A: lastFineUpdateDate is yesterday
        final issueA = IssueRecords(
          issueId: 'I001',
          bookId: 'B001',
          memberId: 'M001',
          borrowDate: tBorrowDate,
          dueDate: tDueDate,
          isReturned: false,
          fineAmount: 12.0,
          lastFineUpdateDate: DateTime(
            2026,
            5,
            19,
            10,
            0,
          ), // Last updated yesterday
        );

        // Scenario B: lastFineUpdateDate is null (never updated since due date)
        final issueB = IssueRecords(
          issueId: 'I002',
          bookId: 'B002',
          memberId: 'M002',
          borrowDate: tBorrowDate,
          dueDate: tDueDate, // May 15
          isReturned: false,
          fineAmount: 0.0,
          lastFineUpdateDate: null, // Never updated
        );

        final fineA = FineCalculator.calculate(
          issue: issueA,
          now: now,
          fineRatePerDay: tFineRate,
        );

        final fineB = FineCalculator.calculate(
          issue: issueB,
          now: now,
          fineRatePerDay: tFineRate,
        );

        // Fine A: should be saved fine (12.0) + today's rate (3.0) = 15.0
        expect(fineA, equals(15.0));

        // Fine B: since lastFineUpdateDate is null, it defaults to dueDate (May 15).
        // Since now (May 20) is a new day compared to dueDate, it adds today's rate (3.0).
        expect(fineB, equals(3.0));
      },
    );
  });
}
