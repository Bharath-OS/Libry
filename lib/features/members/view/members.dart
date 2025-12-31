import 'package:libry/features/members/viewmodel/members_provider.dart';
import 'package:libry/features/members/view/add_members.dart';
import 'package:provider/provider.dart';

import '../../../core/utilities/helpers.dart';
import '../../../core/widgets/cards.dart';
import '../../../core/widgets/list.dart';
import '../data/model/members_model.dart';
import 'package:flutter/material.dart';
import 'member_details.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int totalMembers = context.watch<MembersProvider>().totalCount;
    int availableCount = context.watch<MembersProvider>().activeMembers;
    return ListScreen<MemberModel>(
      title: "MemberModel",
      totalCount: totalMembers,
      availableCount: availableCount,
      searchHint: "Search MemberModel...",
      items: context.watch<MembersProvider>().members,
      tileBuilder: (member) => Cards.memberCard(
        memberDetails: member,
        onDelete: () =>
            context.read<MembersProvider>().removeMember(member.id!),
      ),
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
