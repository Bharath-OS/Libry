import 'package:flutter/widgets.dart';
import 'package:libry/database/members_db.dart';
import 'package:libry/features/members/data/model/members_model.dart';

class MembersProvider extends ChangeNotifier {
  MembersProvider() {
    fetchMembers();
  }

  List<Members> _members = [];
  List<Members> _filteredMembers = [];
  // String searchText = '';

  List<Members> get members => _filteredMembers;
  int get count => _filteredMembers.length;
  int get totalCount => _members.length;
  int get activeMembers => _members
      .where(
        (member) =>
            member.expiry.isAfter(DateTime.now()) ||
            member.expiry.isAtSameMomentAs(DateTime.now()),
      )
      .length;

  void searchMembers(String query) {
    if (query.isNotEmpty) {
      String searchText = query.toLowerCase();
      final matchedMembers = checkMatch(searchText);

      _filteredMembers = matchedMembers ?? [];
    } else {
      _filteredMembers = _members;
    }
    notifyListeners();
  }

  List<Members>? checkMatch(String searchText) {
    final matchedMembers = _members
        .where((member) => member.name.toLowerCase().contains(searchText))
        .toList();
    return matchedMembers.isNotEmpty ? matchedMembers : null;
  }

  Future<void> fetchMembers() async {
    _members = await MembersDB.getMembers();
    _filteredMembers = _members;
    notifyListeners();
  }

  Future<void> addMember(Members member) async {
    await MembersDB.addMember(member, count + 1);
    await fetchMembers();
  }

  //
  Future<void> removeMember(int memberId) async {
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
