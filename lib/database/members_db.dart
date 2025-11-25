import 'package:sqflite/sqflite.dart';
import '../models/members_model.dart';
import 'libry_db.dart';

// BookRepository - Handles only book operations
class MembersDB {
  static const String _tableName = 'members';

  static Future<Database> _initDB() async {
    return await DatabaseServices.instance.database;
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${MembersKey.memberId} TEXT NOT NULL,
        ${MembersKey.name} TEXT NOT NULL,
        ${MembersKey.email} TEXT,
        ${MembersKey.phone} TEXT,
        ${MembersKey.address} TEXT,
        ${MembersKey.totalBorrow} INTEGER DEFAULT 0,
        ${MembersKey.currentlyBorrow} INTEGER DEFAULT 0,
        ${MembersKey.fine} REAL DEFAULT 0,
        ${MembersKey.joined} TEXT DEFAULT (datetime('now')),
        ${MembersKey.expiry} TEXT NOT NULL,
      )
    ''');
  }

  static Future<void> addMember(Members member,int count) async {
    final db = await _initDB();
    await db.insert(_tableName, {
      MembersKey.memberId: _generateMemberId(count),
      MembersKey.name: member.name,
      MembersKey.email: member.email,
      MembersKey.phone: member.phone,
      MembersKey.address: member.address,
      MembersKey.totalBorrow: member.totalBorrow,
      MembersKey.currentlyBorrow: member.currentlyBorrow,
      MembersKey.fine: member.currentlyBorrow,
      MembersKey.expiry: member.expiry,
    });
  }

  static String _generateMemberId(int sequentialId) {
    return 'M${sequentialId.toString().padLeft(3, '0')}';
  }

  static Future<void> removeMember(int memberId) async {
    final db = await _initDB();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [memberId]);
  }

  static Future<List<Members>> getMembers() async {
    final db = await _initDB();
    final data = await db.query(_tableName);

    List<Members> members = data
        .map(
          (member) => Members(
            name: member[MembersKey.name] as String,
            memberId: member[MembersKey.memberId] as String,
            email: member[MembersKey.email] as String,
            phone: member[MembersKey.phone] as String,
            address: member[MembersKey.address] as String,
            totalBorrow: member[MembersKey.totalBorrow] as int,
            currentlyBorrow: member[MembersKey.currentlyBorrow] as int,
            fine: member[MembersKey.fine] as double,
            joined: member[MembersKey.joined] as DateTime,
            expiry: member[MembersKey.expiry] as DateTime,
          ),
        )
        .toList();
    return members;
  }

  static Future<void> updateMember(Members member)async{
    final db = await _initDB();
    await db.update(_tableName, {
      MembersKey.memberId: member.memberId,
      MembersKey.name: member.name,
      MembersKey.email: member.email,
      MembersKey.phone: member.phone,
      MembersKey.address: member.address,
      MembersKey.totalBorrow: member.totalBorrow,
      MembersKey.currentlyBorrow: member.currentlyBorrow,
      MembersKey.fine: member.currentlyBorrow,
      MembersKey.expiry: member.expiry.toIso8601String(),
    },
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  static Future<void> clearAllMembers() async{
    final db = await _initDB();
    await db.delete(_tableName);
  }
}
