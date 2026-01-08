import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../model/members_model.dart';

// BookRepository - Handles only book operations
class MembersDB {
  static const String _boxName = 'members';
  
  static Box<MemberModel>? _memberBox;
  
  static Future<Box<MemberModel>> get _box async => _memberBox ?? await Hive.openBox<MemberModel>(_boxName);

  static Future<bool> addMember(MemberModel member) async{
    try{
      final box = await _box;
      member.id = const Uuid().v4();
      await box.put(member.id, member);
      return true;
    }catch(_){
      return false;
    }
  }

  static Future<bool> removeMember(String memberId)async{
    try{
      final box = await _box;
      await box.delete(memberId);
      return true;
    }catch(_){
      return false;
    }
  }

  static String _generateMemberId(int sequentialId) {
    return 'M${sequentialId.toString().padLeft(3, '0')}';
  }

  static Future<List<MemberModel>?> getMembers() async {
    try{
      final box = await _box;
      return box.values.toList();
    } catch(_){
      return null;
    }
  }

  static Future<bool> updateMember(MemberModel member)async{
    final box = await _box;
    try{
      await box.put(member.id, member);
      return true;
    }catch(_){
      return false;
    }
  }

  static Future<MemberModel?> getMemberById(String memberId) async{
    try{
      final box = await _box;
      return box.get(memberId);
    }catch(_){
      return null;
    }
  }

  static Future<void> incrementMemberFine(String memberId, double fineAmount) async {
    final db = await _box;
    final member = await getMemberById(memberId);
    if(member != null){
    final currentFine = member.fine;
    final newFine = currentFine + fineAmount;
    member.fine = newFine;
    await db.put(memberId, member);
    }
  }

  static Future<void> clearAllMembers() async{
    final db = await _box;
    await db.clear();
  }
}
