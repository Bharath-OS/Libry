import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/books/viewmodel/book_provider.dart';
import '../../features/issues/data/model/issue_records_model.dart';
import '../../features/members/data/model/members_model.dart';
import '../../features/books/data/model/books_model.dart';
import '../../features/members/viewmodel/members_provider.dart';
import '../constants/app_colors.dart';
import 'buttons.dart';

class Cards {
  static Widget bookCard({required String id, required VoidCallback onDelete, required BuildContext context}) {
    final bookDetails = context.watch<BookViewModel>().getBookById(id);
    final bool isAvailable = bookDetails!.copiesAvailable > 0;
    final Color statusColor = isAvailable ? Colors.green : Colors.red;
    final String statusText = isAvailable ? 'Available' : 'Unavailable';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Book Cover Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).toInt()),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  bookDetails.coverPictureData as Uint8List,
                  width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.book_outlined,
                        size: 36,
                        color: AppColors.primary.withAlpha((0.7 * 255).toInt()),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookDetails.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    bookDetails.author,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      // Availability Status
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor.withAlpha((0.3 * 255).toInt())),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Genre Tag
                  if (bookDetails.genre.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        bookDetails.genre,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Delete Button
            SizedBox(
              width: 40,
              height: 40,
              child: MyButton.deleteButton(method: onDelete),
            ),
          ],
        ),
      ),
    );
  }

  static Widget memberCard({required String memberId, required VoidCallback onDelete, required BuildContext context}) {
    final memberDetails = context.watch<MembersViewModel>().getMemberById(memberId);
    if(memberDetails == null) return Container();
    final bool isActive = memberDetails.expiry.isAfter(DateTime.now());
    final Color statusColor = isActive ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Member Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                border: Border.all(
                  color: AppColors.primary.withAlpha((0.3 * 255).toInt()),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.person_outline,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Member Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memberDetails.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    memberDetails.memberId ?? 'No ID',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      // Membership Status
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor.withAlpha((0.3 * 255).toInt())),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              isActive ? 'Active' : 'Expired',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Delete Button
            SizedBox(
              width: 40,
              height: 40,
              child: MyButton.deleteButton(method: onDelete),
            ),
          ],
        ),
      ),
    );
  }

  static Widget detailsCard({required int count, required String parameter, Color? color}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$count",
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontFamily: "Livvic",
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            parameter,
            style: TextStyle(
              color: Colors.white.withAlpha((0.9 * 255).toInt()),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  static Widget historyCard({
    required IssueRecords issue,
    required BuildContext context,
    bool showMemberName = true,
    bool showBookName = true,
    VoidCallback? onReturn,
    BookModel? bookDetails,
    MemberModel? memberDetails,
  }) {
    final isReturned = issue.returnDate != null;
    final daysLeft = issue.dueDate.difference(DateTime.now()).inDays;
    final isOverdue = !isReturned && daysLeft < 0;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isReturned) {
      statusColor = Colors.green;
      statusText = 'Returned';
      statusIcon = Icons.check_circle;
    } else if (isOverdue) {
      statusColor = Colors.red;
      statusText = 'Overdue';
      statusIcon = Icons.warning;
    } else {
      statusColor = Colors.orange;
      statusText = 'Active';
      statusIcon = Icons.pending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isOverdue ? Colors.red.withAlpha((0.3 * 255).toInt()) : Colors.grey.shade200,
          width: isOverdue ? 2 : 1,
        ),
      ),
      elevation: isOverdue ? 3 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha((0.1 * 255).toInt()),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(statusIcon, size: 18, color: statusColor),
                    ),
                    SizedBox(width: 12),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),

                if (!isReturned && onReturn != null)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.keyboard_return, size: 18, color: AppColors.primary),
                      onPressed: onReturn,
                      tooltip: 'Return Book',
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),

            SizedBox(height: 12),

            // Book and Member Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBookName)
                  Text(
                    issue.bookName ?? bookDetails?.title ?? 'Book is deleted',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                if (showMemberName && showBookName) SizedBox(height: 6),

                if (showMemberName)
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Member: ${issue.memberName ?? memberDetails?.name ?? 'Member is deleted'}",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            SizedBox(height: 16),

            // Dates Section
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dateInfo("Issued", issue.borrowDate, Icons.calendar_today),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  _dateInfo("Due", issue.dueDate, Icons.event),
                  if (isReturned) ...[
                    Container(
                      height: 24,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                    _dateInfo("Returned", issue.returnDate!, Icons.check_circle),
                  ],
                ],
              ),
            ),

            // Days Left / Overdue Days
            if (!isReturned)
              Container(
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isOverdue ? Colors.red[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isOverdue ? Colors.red[100]! : Colors.orange[100]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isOverdue ? Icons.warning_amber : Icons.access_time,
                      size: 16,
                      color: isOverdue ? Colors.red : Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Text(
                      isOverdue
                          ? 'Overdue by ${daysLeft.abs()} days'
                          : '$daysLeft days left',
                      style: TextStyle(
                        color: isOverdue ? Colors.red[800] : Colors.orange[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _dateInfo(String label, DateTime date, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          "${date.day}/${date.month}/${date.year}",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}