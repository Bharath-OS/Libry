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
    int totalMembers = context.watch<MembersViewModel>().totalCount;
    int availableCount = context.watch<MembersViewModel>().activeMembers;
    return ListScreen<MemberModel>(
      title: "All Members",
      totalCount: totalMembers,
      availableCount: availableCount,
      searchHint: "Search MemberModel...",
      items: context.watch<MembersViewModel>().members,
      tileBuilder: (member) => Cards.memberCard(
        memberId: member.id!,
        context: context,
        onDelete: () =>
            deleteMember(context: context, memberDetails: member,inDetailsScreen: false)
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
