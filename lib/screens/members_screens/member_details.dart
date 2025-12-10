import 'package:flutter/material.dart';
import 'package:libry/utilities/helpers.dart';
import 'package:libry/widgets/layout_widgets.dart';
import '../../models/members_model.dart';
import '../../widgets/buttons.dart';

class MemberDetailsScreen extends StatelessWidget {
  final Members memberDetails;

  const MemberDetailsScreen({super.key, required this.memberDetails});
  final String dateFormatString = 'd/m/y';

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Member detail",context: context),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(memberDetails),
                const SizedBox(height: 10),
                _buildMetadata(memberDetails),
                const SizedBox(height: 20),
                _buildActions(),
              ],
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
            text: "Joined at ${formatDate(member.joined)}",
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
          TextSpan(text: "\nValidity : Till ${formatDate(member.expiry)}"),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyButton.secondaryButton(method: () {}, text: "View History"),
        const SizedBox(height: 10),
        MyButton.primaryButton(method: (){}, text: "Edit Member"),
      ],
    );
  }
}