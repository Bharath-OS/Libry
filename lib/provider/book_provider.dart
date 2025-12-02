import 'package:flutter/material.dart';
import 'package:libry/database/books_db.dart';
import 'package:libry/database/libry_db.dart';

import '../models/books_model.dart';

class BookProvider extends ChangeNotifier {
  BookProvider() {
    fetchBooks();
  }
  List<Books> _books = [];
  List<Books> _filteredBooks = [];
  String _searchQuery = '';

  List<Books> get books =>
      _filteredBooks.isEmpty ? _books : _filteredBooks;
  int get count => _books.length;

  //Searching implementation
  void searchBooks(String query) {
    _searchQuery = query;

    if (_searchQuery.isNotEmpty) {
      _filteredBooks = _books.where((book) {
        return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    } else {
      _filteredBooks = _books;
    }

    notifyListeners();
  }

  Future<void> fetchBooks() async {
    _books = await BooksDB.getBooks();
    _filteredBooks = _books;
    notifyListeners();
  }

  Future<void> addBook(Books book) async {
    await BooksDB.addBook(book);
    await fetchBooks();
  }

  Future<void> removeBook(int bookId) async {
    await BooksDB.deleteBook(bookId);
    await fetchBooks();
  }

  Future<void> updateBook(Books book) async {
    await BooksDB.updateBook(book);
    await fetchBooks();
  }

  // Helper method to get book by ID
  Books? getBookById(int id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllBooks() async {
    await BooksDB.clearAllBooks();
    await fetchBooks();
    notifyListeners();
  }
}
