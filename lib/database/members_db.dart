import 'package:sqflite/sqflite.dart';

import '../models/members_model.dart';
import 'libry_db.dart';


// BookRepository - Handles only book operations
class BookRepository {
  static const String tableName = 'members';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${MembersKey.name} TEXT NOT NULL,
        ${MembersKey.memberId} TEXT,
        ${MembersKey.email} TEXT,
        ${MembersKey.phone} TEXT,
        ${MembersKey.address} TEXT,
        ${MembersKey.totalBorrow} INTEGER,
        ${MembersKey.currentlyBorrow} INTEGER,
        ${MembersKey.fine} INTEGER,
        ${MembersKey.joined} TEXT DEFAULT (datetime('now')),
        ${MembersKey.expiry} TEXT,
      )
    ''');
  }

  static Future<int> addMember(Members member) async {
    final db = await DatabaseServices.instance.database;
    return await db.insert(tableName, {

    });
  }

// ... other book methods
}

// MemberRepository - Handles only member operations
class MemberRepository {
  static const String tableName = 'members';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE
      )
    ''');
  }

  static Future<int> addMember(Member member) async {
    final db = await DatabaseServices.instance.database;
    return await db.insert(tableName, member.toMap());
  }

// ... other member methods
}