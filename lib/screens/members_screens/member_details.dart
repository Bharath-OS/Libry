import 'package:flutter/material.dart';
import 'package:libry/provider/members_provider.dart';
import 'package:libry/screens/members_screens/edit_member.dart';
import 'package:libry/utilities/helpers.dart';
import 'package:libry/utilities/helpers/date_formater.dart';
import 'package:libry/widgets/layout_widgets.dart';
import 'package:provider/provider.dart';
import '../../models/members_model.dart';
import '../../widgets/buttons.dart';
import 'member_history.dart';

class MemberDetailsScreen extends StatefulWidget {
  final int memberId;

  const MemberDetailsScreen({super.key, required this.memberId});

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  late Members memberDetail;
  final String dateFormatString = 'dd/MM/yyyy';

  @override
  Widget build(BuildContext context) {
    memberDetail = context.watch<MembersProvider>().getMemberById(widget.memberId)!;
    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Member detail", context: context),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(memberDetail),
                  const SizedBox(height: 10),
                  _buildMetadata(memberDetail),
                  const SizedBox(height: 20),
                  _buildActions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Members member) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "${member.name}\n",
        style: const TextStyle(
          fontSize: 32,
          fontFamily: "Livvic",
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: "Joined at ${dateFormat(date: member.joined,format: dateFormatString)}",
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Livvic",
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata(Members member) {
    return RichText(
      text: TextSpan(
        text: "Email : ${member.email}",
        style: const TextStyle(
          fontFamily: "Livvic",
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.8,
        ),
        children: [
          TextSpan(text: "\nPhone : ${member.phone}"),
          TextSpan(text: "\nAddress : ${member.address}"),
          TextSpan(text: "\nTotal borrowed : ${member.totalBorrow}"),
          TextSpan(text: "\nCurrently borrowed : ${member.currentlyBorrow}/5"),
          TextSpan(text: "\nFines owed : ${member.fine}\$"),
          TextSpan(text: "\nValidity till : ${dateFormat(date: member.expiry,format: dateFormatString)}"),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyButton.secondaryButton(
          method: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberHistoryScreen(memberId: widget.memberId),
            ),
          ),
          text: "View History",
        ),
        const SizedBox(height: 10),
        MyButton.primaryButton(
          method: () {
            Navigator.push(context, transition(child: EditMembersScreen(member: memberDetail)));
          },
          text: "Edit Member",
        ),
      ],
    );
  }
}