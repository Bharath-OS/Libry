import '../Models/members.dart';
import '../Widgets/list.dart';
import 'package:flutter/material.dart';
import 'MembersScreens/memberdetails.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final members = List.generate(
      25,
      (i) => Members(
        name: "Member $i",
        memberId: "MID${1000 + i}",
        email: "member$i@example.com",
        dob: "1990-01-${(i % 28) + 1}".padLeft(10, '0'),
        address: "Address $i, City ${(i % 5) + 1}",
        totalBorrow: (i % 10) + 1,
        currentlyBorrow: (i % 3),
        fine: (i % 5) * 10,
        joined: "2023-01-${(i % 28) + 1}".padLeft(10, '0'),
        expiry: "2026-01-${(i % 28) + 1}".padLeft(10, '0'),
        phone: '9999999999',
      ),
    );

    return ListScreen<Members>(
      title: "All Member",
      totalCount: 290,
      availableCount: 20,
      searchHint: "Search Member",
      items: members,
      tileBuilder: (member) => MemberTile(memberDetails: member),
      onTap: (member) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MemberDetailsScreen(memberDetails: member),
        ),
      ),
    );
  }
}
