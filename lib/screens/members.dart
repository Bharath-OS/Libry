import 'package:libry/provider/members_provider.dart';
import 'package:libry/screens/members_screens/add_members.dart';
import 'package:libry/utilities/helpers.dart';
import 'package:provider/provider.dart';

import '../models/members_model.dart';
import '../widgets/cards.dart';
import '../widgets/list.dart';
import 'package:flutter/material.dart';
import 'members_screens/member_details.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int totalMembers = context.watch<MembersProvider>().totalCount;
    int availableCount = context.watch<MembersProvider>().activeMembers;
    return ListScreen<Members>(
      title: "Members",
      totalCount: totalMembers,
      availableCount: availableCount,
      searchHint: "Search Members...",
      items: context.watch<MembersProvider>().members,
      tileBuilder: (member) => Cards.memberCard(memberDetails: member),
      onTap: (member) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MemberDetailsScreen(memberId: member.id!),
        ),
      ),
      fabMethod: () {
        Navigator.push(context, transition(child: AddMembersScreen()));
      },
    );
  }
}
