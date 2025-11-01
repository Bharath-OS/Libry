import 'package:flutter/material.dart';
import 'package:libry/Screens/register.dart';
import '../Database/userdata.dart';
import '../Utilities/constants.dart';
import '../Widgets/buttons.dart';

class BooksScreen extends StatefulWidget {
  BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: Column(
                  children: [
                    SearchBar(
                      leading: Icon(
                        Icons.search_outlined
                      ),
                      hintText: "Search Book",
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text("Total books : 221"),
                            Text("Available books : 32"),
                          ],
                        ),
                        MyButton.primaryButton(method: (){},text: "Filter")
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.separated(
                    itemBuilder: (i, ctx) => bookTile(
                      bookName: "Book $i",
                      author: "Author $i",
                      publishYear: "20$i",
                    ),
                    separatorBuilder: (_, ctx) => SizedBox(height: 16),
                    itemCount: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookTile({
    required String bookName,
    required String author,
    required String publishYear,
  }) {
    return ListTile(
      title: Text(bookName),
      subtitle: Text(author),
      leading: Icon(Icons.delete_outline, color: MyColors.warningColor),
    );
  }
}
