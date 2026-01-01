import 'package:flutter/widgets.dart';
import 'package:libry/features/members/data/service/members_db.dart';
import 'package:libry/features/members/data/model/members_model.dart';

import '../../../core/utilities/helpers/date_formater.dart';

class MembersViewModel extends ChangeNotifier {
  MembersViewModel() {
    fetchMembers();
  }

  List<MemberModel> _members = [];
  List<MemberModel> _filteredMembers = [];
  // String searchText = '';

  List<MemberModel> get members => _filteredMembers;
  int get count => _members.length;
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

  List<MemberModel>? checkMatch(String searchText) {
    final matchedMembers = _members
        .where((member) => member.name.toLowerCase().contains(searchText))
        .toList();
    return matchedMembers.isNotEmpty ? matchedMembers : null;
  }

  Future<String> renewMembership(int memberId) async {
    try {
      final member = getMemberById(memberId);
      if (member == null) {
        return 'Member with ID $memberId not found';
      }

      final baseDate = member.expiry.isAfter(DateTime.now())
          ? member.expiry
          : DateTime.now();

      final newExpiryDate = baseDate.add(Duration(days: 365));

      // Create updated member
      final updatedMember = member.copyWith(expiry: newExpiryDate);

      await updateMember(updatedMember);
      return'Membership extended until ${dateFormat(date: newExpiryDate,format: 'MMM dd yyyy')}';
    } catch (e) {
      return 'Exception renewing membership: $e';
    }
  }

  Future<void> fetchMembers() async {
    _members = await MembersDB.getMembers();
    _filteredMembers = _members;
    notifyListeners();
  }

  Future<void> addMember(MemberModel member) async {
    await MembersDB.addMember(member, count + 1);
    await fetchMembers();
  }

  //
  Future<void> removeMember(int memberId) async {
    await MembersDB.removeMember(memberId);
    await fetchMembers();
  }

  Future<void> updateMember(MemberModel member) async {
    await MembersDB.updateMember(member);
    await fetchMembers();
  }

  // Helper method to get member by ID
  MemberModel? getMemberById(int id) {
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
