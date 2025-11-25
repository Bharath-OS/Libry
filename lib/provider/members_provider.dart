

import 'package:flutter/widgets.dart';
import 'package:libry/database/libry_db.dart';
import 'package:libry/database/members_db.dart';
import 'package:libry/models/members_model.dart';

class MembersProvider extends ChangeNotifier{
  MembersProvider(){
    fetchMembers();
  }

  List<Members> _members = [];
  List<Members> get members => _members;
  int get count => _members.length;

  Future<void> fetchMembers() async{
    _members = await MembersDB.getMembers();
    notifyListeners();
  }

  Future<void> addMember(Members member) async{
    await MembersDB.addMember(member, count+1);
    await fetchMembers();
  }
  //
  Future<void> removeMember(int memberId) async{
    await MembersDB.removeMember(memberId);
    await fetchMembers();
  }

  Future<void> updateMember(Members member) async {
    await MembersDB.updateMember(member);
    await fetchMembers();
  }

  // Helper method to get member by ID
  Members? getMemberById(int id) {
    try {
      return _members.firstWhere((member) => member.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllMembers() async {
    await MembersDB.clearAllMembers();
    await fetchMembers();
  }

}