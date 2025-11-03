import 'package:flutter/material.dart';
import 'package:libry/Widgets/appbar.dart';
import 'package:libry/Widgets/buttons.dart';
import '../../Models/books.dart';
import '../../Themes/styles.dart';
import '../../Utilities/constants.dart';
import '../../Widgets/scaffold.dart';

class BookDetailScreen extends StatefulWidget {
  final Books bookDetails;

  BookDetailScreen({super.key, required this.bookDetails});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  String selectedStatus = 'Available';

  final List<String> statusOptions = ['Available', 'Not Available'];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: LibryAppBar.appBar(barTitle: "Books Details"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 3,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 100,
                      bottom: 40,
                      left: 30,
                      right: 30,
                    ),
                    width: double.infinity,
                    // height: 650,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: MyColors.whiteBG,
                    ),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: widget.bookDetails.title,
                                  style: BodyTextStyles.mainHeadingStyle
                                      .copyWith(height: 1.5),
                                  children: [
                                    TextSpan(
                                      text: "\nBy ${widget.bookDetails.author}\n",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Livvic",
                                        color: MyColors.darkGrey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.bookDetails.year,
                                      style: TextStyle(
                                        fontFamily: "Livvic",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Language : ${widget.bookDetails.language}",
                            style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.8,
                            ),

                            children: [
                              TextSpan(
                                text: "\nPublisher : ${widget.bookDetails.publisher}",
                              ),
                              TextSpan(text: "\nGenre : ${widget.bookDetails.genre}"),
                              TextSpan(
                                text:
                                    "\nPages : ${widget.bookDetails.pages.toString()}",
                              ),
                              TextSpan(
                                text:
                                    "\nTotal copies : ${widget.bookDetails.totalCopies.toString()}",
                              ),
                              TextSpan(
                                text:
                                    "\nTotal copies available : ${widget.bookDetails.copiesAvailable.toString()}",
                              ),
                            ],
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: MyColors.whiteBG,
                          value: selectedStatus,
                          items: statusOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue!;
                            });
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyButton.secondaryButton(
                                method: () {},
                                text: "View History",
                              ),
                              MyButton.primaryButton(
                                method: () {},
                                text: "Edit Book",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -90,
                    left: 100,
                    child: Container(
                      width: 170,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 7),
                            blurRadius: 10,
                            color: MyColors.lightGrey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: MyButton.deleteButton(method: () {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
