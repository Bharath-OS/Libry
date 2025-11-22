

import 'package:flutter/widgets.dart';
import 'package:libry/database/libry_db.dart';
import 'package:libry/models/members_model.dart';

class MembersProvider extends ChangeNotifier{
  MembersProvider(){
    fetchMembers();
  }

  final _db = DatabaseServices.instance;
  List<Members> _members = [];
  List<Members> get members => _members;
  int get count => _members.length;

  Future<void> fetchMembers() async{
    _members = await _db.getBooks();
    notifyListeners();
  }

  Future<void> addMember(Members member) async{
    await _db.addBook(member);
    await fetchMembers();
  }

  Future<void> removeMember(int memberId) async{
    await _db.deleteBook(memberId);
    await fetchMembers();
  }

  Future<void> updateMember(Members member) async {
    await _db.updateBook(member);
    await fetchMembers();
  }

  // Helper method to get book by ID
  Members? getMemberById(int id) {
    try {
      return _members.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllMembers() async {
    await _db.clearAllBooks();
    await fetchMembers();
  }

}