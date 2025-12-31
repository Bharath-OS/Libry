import 'dart:io';
import 'package:flutter/material.dart';
import '../../features/issues/data/model/issue_records_model.dart';
import '../../features/members/data/model/members_model.dart';
import '../../features/books/data/model/books_model.dart';
import '../constants/app_colors.dart';
import '../themes/styles.dart';
import '../utilities/helpers.dart';
import 'buttons.dart';

class Cards {
  static Widget bookCard({required BookModel bookDetails, required VoidCallback onDelete}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(bookDetails.coverPicture),
                width: 70,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70, height: 90, color: Colors.grey[300],
                  child: const Icon(Icons.book, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bookDetails.title, style: CardStyles.cardTitleStyle),
                  Text(bookDetails.author, style: CardStyles.cardSubTitleStyle),
                  const SizedBox(height: 4),
                  Text("Available: ${bookDetails.copiesAvailable}/${bookDetails.totalCopies}",
                      style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                ],
              ),
            ),
            MyButton.deleteButton(method: onDelete),
          ],
        ),
      ),
    );
  }

  static Widget memberCard({required MemberModel memberDetails, required VoidCallback onDelete}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(memberDetails.name, style: CardStyles.cardTitleStyle),
                  Text(
                    memberDetails.memberId!,
                    style: CardStyles.cardSubTitleStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(children: [MyButton.deleteButton(method: onDelete)]),
            ),
          ],
        ),
      ),
    );
  }

  static Widget detailsCard({required int count, required String parameter}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "$count\n",
            style: const TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Livvic", fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: parameter, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget historyCard({
    required IssueRecords issue,
    required BuildContext context,
    bool showMemberName = true,
    bool showBookName = true,
    VoidCallback? onReturn,
  }) {
    final isReturned = issue.returnDate != null;
    final daysLeft = issue.dueDate.difference(DateTime.now()).inDays;
    final isOverdue = !isReturned && daysLeft < 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                // Status Indicator
                CircleAvatar(
                  radius: 6,
                  backgroundColor: isReturned
                      ? Colors.green
                      : (isOverdue ? Colors.red : Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showBookName)
                        Text(
                          issue.bookName??"Book is deleted", // Fallback logic implemented here
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      if (showMemberName)
                        Text(
                          "Member: ${issue.memberName ?? "Member is deleted"}", // Fallback logic
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                    ],
                  ),
                ),
                if (!isReturned)
                  IconButton(
                    icon: const Icon(Icons.keyboard_return, color: Colors.blue),
                    onPressed: onReturn,
                    tooltip: 'Return Book',
                  ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dateInfo("Issued", issue.borrowDate),
                _dateInfo("Due", issue.dueDate),
                if (isReturned) _dateInfo("Returned", issue.returnDate!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _dateInfo(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text("${date.day}/${date.month}/${date.year}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

