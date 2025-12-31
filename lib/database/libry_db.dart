import 'package:libry/features/books/data/service/books_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../features/books/data/model/books_model.dart';
import '../features/members/data/service/members_db.dart';

class DatabaseServices {
  static Database? _db;
  static final String _dbName = 'library.db';
  final int _version = 1;

  static final DatabaseServices _instance = DatabaseServices._constructor();
  static DatabaseServices get instance => _instance;

  DatabaseServices._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabases();
    return _db!;
  }

  Future<Database> _initDatabases() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _version,
      onCreate: _createDatabases,
    );
  }

  Future<void> _createDatabases(Database db, int _) async{
    await BooksDB.createTable(db);
    await MembersDB.createTable(db);
  }
}
