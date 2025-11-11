import 'package:flutter/material.dart';

import '../Widgets/list.dart';
import '../models/books.dart';
import '../widgets/cards.dart';
import 'books_screens/books_details.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final books = List.generate(
      25,
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
      ),
    );

    return ListScreen<Books>(
      title: "All Books",
      totalCount: 223,
      availableCount: 22,
      searchHint: "Search Book",
      items: books,
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