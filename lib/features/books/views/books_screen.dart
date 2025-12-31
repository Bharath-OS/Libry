import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libry/features/books/data/model/books_model.dart';
import '../../../core/utilities/helpers.dart';
import '../../../core/widgets/cards.dart';
import '../../../core/widgets/list.dart';
import '../viewmodel/book_provider.dart';
import 'add_book_screen.dart';
import 'books_details.dart';

class BookListScreenView extends StatelessWidget {
  const BookListScreenView({super.key});

  @override
  Widget build(BuildContext context) {

    return ListScreen<BookModel>(
      title: "BookModel",
      totalCount: context.watch<BookViewModel>().totalBooks,
      availableCount: context.watch<BookViewModel>().availableBooks,
      searchHint: "Search BookModel...",
      items: context.watch<BookViewModel>().books,
      tileBuilder: (book) => Cards.bookCard(bookDetails: book, onDelete: ()=>deleteBook(context: context,bookDetails: book,inDetailsScreen: false)),
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
