import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../model/books_model.dart';

class BooksDBHive {
  static const String _boxName = "books";

  static Future<Box<BookModel>> _openBox() async {
    return Hive.openBox<BookModel>(_boxName);
  }

  static Future<void> addBook(BookModel book) async {
    final box = await _openBox();
    book.id = const Uuid().v4(); // Generate a unique ID
    await box.put(book.id, book);
  }

  static Future<void> deleteBook(String bookId) async {
    final box = await _openBox();
    await box.delete(bookId);
  }

  static Future<List<BookModel>?> getBooks() async {
    try {
      final box = await _openBox();
      return box.values.toList();
    } catch (_) {
      return null;
    }
  }

  static Future<void> updateBook(BookModel book) async {
    final box = await _openBox();
    await box.put(book.id, book);
  }

  static Future<void> clearAllBooks() async {
    final box = await _openBox();
    await box.clear();
  }
}
