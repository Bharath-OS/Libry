import 'package:flutter/material.dart';
import '../models/members_model.dart';
import '../models/books_model.dart';
import '../themes/styles.dart';
import 'buttons.dart';

class Cards {
  static Widget bookCard({required Books bookDetails}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 84,
              height: 84,
              color: Colors.grey,
              child: Image.asset(bookDetails.coverPicture),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bookDetails.title, style: CardStyles.cardTitleStyle),
                  Text(bookDetails.author, style: CardStyles.cardSubTitleStyle),
                  Text(
                    "Copy Available : ${bookDetails.copiesAvailable}/${bookDetails.totalCopies}",
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(children: [MyButton.deleteButton(method: () {})]),
            ),
          ],
        ),
      ),
    );
  }

  static Widget memberCard({required Members memberDetails}) {
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
                    memberDetails.memberId,
                    style: CardStyles.cardSubTitleStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(children: [MyButton.deleteButton(method: () {})]),
            ),
          ],
        ),
      ),
    );
  }
}
