import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:libry/Models/books.dart';
import 'package:libry/Screens/BooksScreens/bookdetails.dart';
import 'package:libry/Widgets/appbar.dart';
import '../Themes/styles.dart';
import '../Utilities/constants.dart';
import '../Widgets/buttons.dart';
import '../Widgets/scaffold.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  int totalBooks = 223;
  int availableBooks = 22;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text("All Books")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Header section
              Column(
                children: [
                  SearchBar(
                    elevation: WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(MyColors.whiteBG),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset("assets/icons/search-line.svg"),
                    ),
                    hintText: "Search Book",
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total books : $totalBooks",
                            style: BodyTextStyles.headingSmallStyle(
                              MyColors.whiteBG,
                            ),
                          ),
                          Text(
                            "Available books : $availableBooks",
                            style: BodyTextStyles.bodySmallStyle(
                              MyColors.whiteBG,
                            ),
                          ),
                        ],
                      ),
                      MyButton.filterButton(method: () {}),
                    ],
                  ),
                  SizedBox(height: 14),
                ],
              ),

              // Scrollable book list
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: MyColors.bgColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: ListView.separated(
                      itemBuilder: (ctx, i) {
                        Books bookDetails = Books(
                          title: "Book $i",
                          author: "Author $i",
                          year: "1999",
                          language: "English",
                          publisher: "Publisher",
                          genre: "Fantasy",
                          pages: 200 + i,
                          totalCopies: 5,
                          copiesAvailable: 3,
                        );
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailScreen(bookDetails: bookDetails),
                            ),
                          ),
                          child: bookTile(bookDetails: bookDetails),
                        );
                      },
                      separatorBuilder: (_, _) => SizedBox(height: 4),
                      itemCount: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bookTile({required Books bookDetails}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(color: Colors.grey),
            ),
            SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bookDetails.title, style: CardStyles.cardTitleStyle),
                  Text(bookDetails.author, style: CardStyles.cardSubTitleStyle),
                  Text("Copy Available : 3/6"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [MyButton.deleteButton(method: () {})],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
