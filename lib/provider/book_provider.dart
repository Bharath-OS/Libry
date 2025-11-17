import 'package:flutter/material.dart';
import 'package:libry/database/libry_db.dart';

import '../models/books_model.dart';

class BookProvider extends ChangeNotifier {

  BookProvider(){
    fetchBooks();
  }
  final _db = DatabaseServices.instance;
  List<Books> _books = [];
  List<Books> get books => _books;
  int get count => _books.length;


  Future<void> fetchBooks()async{
    _books=await _db.getBooks();
    notifyListeners();
  }

  Future<void> addBook(Books book) async{
    await _db.addBook(book);
    await fetchBooks();
  }

  Future<void> removeBook(int index)async{
    await _db.deleteBook(index);
    await fetchBooks();
  }
}
