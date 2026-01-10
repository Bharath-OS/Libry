import 'package:flutter/material.dart';
import 'package:libry/features/books/data/service/books_db.dart';

import '../data/model/books_model.dart';

class BookViewModel extends ChangeNotifier {
  BookViewModel() {
    fetchBooks();
  }
  List<BookModel> _books = [];
  List<BookModel> _filteredBooks = [];
  String _searchQuery = '';

  List<BookModel> get books => _filteredBooks;
  int get count => _filteredBooks.length;
  int get totalBooks => _books.length;
  int get availableBooks => _books.where((book)=>book.copiesAvailable > 0).length;

  //Searching implementation
  void searchBooks(String query) {
    _searchQuery = query;

    if (_searchQuery.isNotEmpty) {
      List<BookModel>? matchedBooks = matchSearch(query);
      _filteredBooks = matchedBooks ?? [];
    } else {
      _filteredBooks = _books;
    }

    notifyListeners();
  }

  List<BookModel>? matchSearch(String query){
    final filteredBooks = _books.where((book) {
      return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    return filteredBooks.isNotEmpty ? filteredBooks : null;
  }

  Future<void> fetchBooks() async {
    final books = await BooksDBHive.getBooks();
    _books = books ?? []; // Safely handle the null case
    _filteredBooks = _books;
    notifyListeners();
  }

  Future<void> addBook(BookModel book) async {
    await BooksDBHive.addBook(book);
    await fetchBooks();
  }

  Future<void> removeBook(String bookId) async {
    await BooksDBHive.deleteBook(bookId);
    await fetchBooks();
  }

  Future<void> updateBook(BookModel book) async {
    await BooksDBHive.updateBook(book);
    await fetchBooks();
  }

  // Helper method to get book by ID
  BookModel? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllBooks() async {
    await BooksDBHive.clearAllBooks();
    await fetchBooks();
  }

  Future<void> adjustBookCopies(String bookId, int delta) async {
    final index = _books.indexWhere((b) => b.id == bookId);
    if (index == -1) return;
    final book = _books[index];
    book.adjustCopies(delta);
    await updateBook(book);
  }
}
