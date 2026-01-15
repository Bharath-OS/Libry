import 'package:flutter/widgets.dart';
import '../../members/data/service/members_db.dart';
import '../../../core/utilities/helpers/date_formater.dart';
import '../data/model/members_model.dart';

class MembersViewModel extends ChangeNotifier {
  MembersViewModel() {
    fetchMembers();
  }

  final List<MemberModel> _members = []; // existing backing store
  List<MemberModel> _filteredMembers = [];
  // String searchText = '';

  List<MemberModel> get members => _filteredMembers.reversed.toList();
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

  Future<String> renewMembership(String memberId) async {
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
      return 'Membership extended until ${dateFormat(date: newExpiryDate, format: 'MMM dd yyyy')}';
    } catch (e) {
      return 'Exception renewing membership: $e';
    }
  }

  Future<void> fetchMembers() async {
    final members = await MembersDB.getMembers();
    _members
      ..clear()
      ..addAll(members!);
    _filteredMembers = List.from(members);
    notifyListeners();
  }

  String generateId(int count){
    return "M${count.toString().padLeft(2,"0")}";
  }

  Future<bool> addMember(MemberModel member) async {
    late String? success;
    final id = generateId(totalCount+1);
    final memberWithId = member.copyWith(memberId: id, id: id);
    try {
      success = await MembersDB.addMember(memberWithId);
      if (success == null) {
        await fetchMembers();
        return true;
      }
      else{
        debugPrint(success);
        return false;
      }
    } catch (e) {
      debugPrint('Error adding member: $e');
      return false;
    }
  }

  //
  Future<void> removeMember(String memberId) async {
    await MembersDB.removeMember(memberId);
    await fetchMembers();
  }

  Future<void> updateMember(MemberModel member) async {
    await MembersDB.updateMember(member);
    await fetchMembers();
  }

  // Helper method to get member by ID
  MemberModel? getMemberById(String id) {
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

  // Adjust member fine by amount (positive to add owed fine, negative when paying)
  Future<void> adjustMemberFine(String memberId, double amount) async {
    final index = _members.indexWhere((m) => m.memberId == memberId);
    if (index == -1) return;
    _members[index].adjustFine(amount);
    // persist to DB if you have a DB layer; keep simple:
    notifyListeners();
    // Optionally call your DB update here
  }

  // Helper to set exact fine (used if needed)
  Future<void> setMemberFine(String memberId, double newAmount) async {
    final index = _members.indexWhere((m) => m.memberId == memberId);
    if (index == -1) return;
    _members[index].fineBalance = newAmount;
    notifyListeners();
    // persist to DB if you have a DB layer
  }
}
