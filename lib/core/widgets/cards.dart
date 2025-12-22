import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/members_model.dart';
import '../../models/books_model.dart';
import '../constants/app_colors.dart';
import '../themes/styles.dart';
import '../utilities/helpers.dart';
import 'buttons.dart';

class Cards {
  static Widget bookCard({
    required Books bookDetails,
    required BuildContext context,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 84,
              height: 84,
              color: Colors.grey,
              child: Image.file(File(bookDetails.coverPicture),fit: BoxFit.cover,),
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
              child: Column(
                children: [
                  MyButton.deleteButton(
                    method: () => deleteBook(
                      context: context,
                      bookDetails: bookDetails,
                      inDetailsScreen: false,
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
                    memberDetails.memberId!,
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

  static Widget detailsCard({required int count, required String parameter}) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.whiteBG,
        borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "$count\n",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: "Livvic",
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: parameter,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Livvic",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
