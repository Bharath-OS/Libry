import 'package:flutter/material.dart';

import '../Models/books.dart';
import '../Themes/styles.dart';
import 'buttons.dart';

class Cards {
  static Widget bookCard ({required Books bookDetails}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(width: 84, height: 84, color: Colors.grey),
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
}
