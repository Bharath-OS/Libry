import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/books_model.dart';

class DatabaseServices {
  static Database? _db;
  final String _dbName = 'books.db';
  final String _tableName = "Books";

  static final DatabaseServices instance = DatabaseServices._constructor();

  DatabaseServices._constructor();

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
      },
    );
    return database;
  }

  Future<void> addBook(Books book) async {
    final db = await database;
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

  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete(_dbName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Books>> getBooks() async {
    final db = await database;
    final data = await db.query(_tableName);

    List<Books> books = data
        .map(
          (book) => Books(
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
}
