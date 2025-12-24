import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libry/models/books_model.dart';
import '../../../core/utilities/helpers.dart';
import '../../../core/widgets/cards.dart';
import '../../../core/widgets/list.dart';
import '../../../provider/book_provider.dart';
import 'add_book_screen.dart';
import 'books_details.dart';

class BookListScreenView extends StatelessWidget {
  const BookListScreenView({super.key});

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
          MaterialPageRoute(builder: (context)=>BookInfoScreenView(bookId: book.id!))
      ),
      fabMethod: () {
        Navigator.push(context, transition(child: AddBookScreenView()));
      },
    );
  }
}
