import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/books_model.dart';

class DataBaseServices {
  static Database? _db;
  final String _dbName = 'books.db';

  static final DataBaseServices instance = DataBaseServices._constructor();

  DataBaseServices._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    final database = openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ${BookKeys.title} TEXT NOT NULL,
  ${BookKeys.author} TEXT,
  ${BookKeys.language} TEXT,
  ${BookKeys.publishYear} INTEGER,
  ${BookKeys.publisherName} TEXT,
  ${BookKeys.pages} INTEGER,
  ${BookKeys.totalCopies} INTEGER,
  ${BookKeys.copiesAvailable} INTEGER,
  ${BookKeys.genre} TEXT,
  ${BookKeys.coverPicture} TEXT,
  created_at TEXT DEFAULT (datetime('now'))
)
        ''');
      },
    );
    return database;
  }

  Future<void> addBook(Books book) async {
    final db = await database;
    await db.insert(_dbName, {
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
    });
  }

  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete(_dbName, where: 'id = ?', whereArgs: [id]);
  }
}
