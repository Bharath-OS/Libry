import 'package:flutter/material.dart';
import 'package:libry/utilities/helpers.dart';
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
    return ListScreen<Books>(
      title: "All Books",
      totalCount: context.watch<BookProvider>().count,
      availableCount: context
          .watch<BookProvider>()
          .books
          .where((book) => book.copiesAvailable > 0)
          .length,
      searchHint: "Search Book",
      items: context.watch<BookProvider>().books,
      tileBuilder: (book) => Cards.bookCard(bookDetails: book,context: context),
      onTap: (book) => Navigator.push(
        context,
        transition(child: BookDetailScreen(bookId: book.id!,))
      ),
    );
  }
}
