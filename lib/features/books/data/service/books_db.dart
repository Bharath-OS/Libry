import 'package:libry/database/libry_db.dart';
import 'package:sqflite/sqflite.dart';

import '../model/books_model.dart';

class BooksDB {
  static const String _tableName = "books";

  static Future<void> createTable(Database db) async {
    await db.execute('''
          CREATE TABLE $_tableName (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ${BookKeys.title} TEXT NOT NULL,
  ${BookKeys.author} TEXT,
  ${BookKeys.language} TEXT,
  ${BookKeys.publishYear} TEXT,
  ${BookKeys.publisherName} TEXT,
  ${BookKeys.pages} INTEGER,
  ${BookKeys.totalCopies} INTEGER,
  ${BookKeys.copiesAvailable} INTEGER,
  ${BookKeys.genre} TEXT,
  ${BookKeys.coverPicture} TEXT,
  created_at TEXT DEFAULT (datetime('now'))
)
''');
  }

  static Future<Database> _initDB() async{
    return DatabaseServices.instance.database;
  }


  static Future<void> addBook(BookModel book) async {
    final db = await _initDB();
    await db.insert(_tableName, {
      BookKeys.title: book.title,
      BookKeys.author: book.author,
      BookKeys.language: book.language,
      BookKeys.publishYear: book.year,
      BookKeys.publisherName: book.publisher,
      BookKeys.pages: book.pages,
      BookKeys.totalCopies: book.totalCopies,
      BookKeys.copiesAvailable: book.copiesAvailable,
      BookKeys.genre: book.genre,
      BookKeys.coverPicture: book.coverPicture,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteBook(int bookId) async {
    final db = await _initDB();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [bookId]);
  }

  static Future<List<BookModel>> getBooks() async {
    final db = await _initDB();
    final data = await db.query(_tableName);

    List<BookModel> books = data
        .map(
          (book) => BookModel(
            id: book['id'] as int,
            title: book[BookKeys.title] as String,
            author: book[BookKeys.author] as String,
            year: book[BookKeys.publishYear] as String,
            language: book[BookKeys.language] as String,
            publisher: book[BookKeys.publisherName] as String,
            genre: book[BookKeys.genre] as String,
            pages: book[BookKeys.pages] as int,
            totalCopies: book[BookKeys.totalCopies] as int,
            copiesAvailable: book[BookKeys.copiesAvailable] as int,
            coverPicture: book[BookKeys.coverPicture] as String,
          ),
        )
        .toList();
    return books;
  }

  static Future<void> updateBook(BookModel book) async {
    final db = await _initDB();
    await db.update(
      _tableName,
      {
        BookKeys.title: book.title,
        BookKeys.author: book.author,
        BookKeys.language: book.language,
        BookKeys.publishYear: book.year,
        BookKeys.publisherName: book.publisher,
        BookKeys.pages: book.pages,
        BookKeys.totalCopies: book.totalCopies,
        BookKeys.copiesAvailable: book.copiesAvailable,
        BookKeys.genre: book.genre,
        BookKeys.coverPicture: book.coverPicture,
      },
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  static Future<void> clearAllBooks() async {
    final db = await _initDB();
    await db.delete(_tableName);
  }
}
