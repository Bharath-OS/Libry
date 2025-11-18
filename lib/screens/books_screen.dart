import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/book_provider.dart';
import '../widgets/list.dart';
import '../widgets/cards.dart';
import 'books_screens/books_details.dart';
import 'package:libry/models/books_model.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final books = List.generate(
      context.watch<BookProvider>().count,
          (i) => Books(
        title: "Book $i",
        author: "Author $i",
        year: "1999",
        language: "English",
        publisher: "Publisher",
        genre: "Fantasy",
        pages: 200 + i,
        totalCopies: 6,
        copiesAvailable: 3,
        coverPicture:"image/path/default.png"
      ),
    );

    return ListScreen<Books>(
      title: "All Books",
      totalCount: context.watch<BookProvider>().count,
      availableCount: 22,
      searchHint: "Search Book",
      items: context.watch<BookProvider>().books,
      tileBuilder: (book) => Cards.bookCard(bookDetails: book),
      onTap: (book) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookDetailScreen(bookDetails: book),
        ),
      ),
    );
  }
}