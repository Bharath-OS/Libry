import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utilities/helpers.dart';
import '../../core/widgets/cards.dart';
import '../../provider/book_provider.dart';
import '../../core/widgets/list.dart';
import 'add_book_screen.dart';
import 'package:libry/models/books_model.dart';

import 'books_details.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ListScreen<Books>(
      title: "Books",
      totalCount: context.watch<BookProvider>().totalBooks,
      availableCount: context.watch<BookProvider>().availableBooks,
      searchHint: "Search Books...",
      items: context.watch<BookProvider>().books,
      tileBuilder: (book) => Cards.bookCard(bookDetails: book,context: context),
      onTap: (book) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>BookDetailScreen(bookId: book.id!))
      ),
      fabMethod: () {
        Navigator.push(context, transition(child: AddBookScreen()));
      },
    );
  }
}
