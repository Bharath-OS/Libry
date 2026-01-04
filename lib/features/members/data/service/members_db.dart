import 'package:sqflite/sqflite.dart';
import '../model/members_model.dart';
import '../../../../database/libry_db.dart';

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
        ${MembersKey.joined} TEXT NOT NULL,
        ${MembersKey.expiry} TEXT NOT NULL
      )
    ''');
  }

  static Future<int?> addMember(MemberModel member,int count) async {
    final db = await _initDB();
    final id = await db.insert(_tableName, {
      MembersKey.memberId: _generateMemberId(count),
      MembersKey.name: member.name,
      MembersKey.email: member.email,
      MembersKey.phone: member.phone,
      MembersKey.address: member.address,
      MembersKey.fine: member.fine,
      MembersKey.totalBorrow: member.totalBorrow,
      MembersKey.currentlyBorrow: member.currentlyBorrow,
      MembersKey.joined: member.joined.toIso8601String(),
      MembersKey.expiry: member.expiry.toIso8601String(),
    });
    return id;
  }

  static String _generateMemberId(int sequentialId) {
    return 'M${sequentialId.toString().padLeft(3, '0')}';
  }

  static Future<void> removeMember(int memberId) async {
    final db = await _initDB();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [memberId]);
  }

  static Future<List<MemberModel>> getMembers() async {
    final db = await _initDB();
    final data = await db.query(_tableName);

    List<MemberModel> members = data
        .map(
          (member) => MemberModel(
            id: member['id'] as int,
            name: member[MembersKey.name] as String,
            memberId: member[MembersKey.memberId] as String,
            email: member[MembersKey.email] as String? ?? '',
            phone: member[MembersKey.phone] as String? ?? '',
            address: member[MembersKey.address] as String? ?? '',
            totalBorrow: member[MembersKey.totalBorrow] as int? ?? 0,
            currentlyBorrow: member[MembersKey.currentlyBorrow] as int? ?? 0,
            fine: (member[MembersKey.fine] as num?)?.toDouble() ?? 0.0,
            joined: DateTime.parse(member[MembersKey.joined] as String),
            expiry: DateTime.parse(member[MembersKey.expiry] as String),
          ),
        )
        .toList();
    return members;
  }

  static Future<void> updateMember(MemberModel member)async{
    final db = await _initDB();
    await db.update(_tableName, {
      MembersKey.memberId: member.memberId,
      MembersKey.name: member.name,
      MembersKey.email: member.email,
      MembersKey.phone: member.phone,
      MembersKey.address: member.address,
      MembersKey.fine: member.fine,
      MembersKey.totalBorrow: member.totalBorrow,
      MembersKey.currentlyBorrow: member.currentlyBorrow,
      MembersKey.expiry: member.expiry.toIso8601String(),
    },
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  static Future<void> incrementMemberFine(int memberId, double fineAmount) async {
    final db = await _initDB();
    // We use whereArgs [fineAmount, memberId] to safely pass values into the ? placeholders
    await db.rawUpdate(
      "UPDATE $_tableName SET ${MembersKey.fine} = ${MembersKey.fine} + ? WHERE id = ?",
      [fineAmount, memberId],
    );
  }

  static Future<void> clearAllMembers() async{
    final db = await _initDB();
    await db.delete(_tableName);
  }
}
