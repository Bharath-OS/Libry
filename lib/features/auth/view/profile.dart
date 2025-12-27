import 'package:flutter/material.dart';
import 'package:libry/features/auth/data/services/userdata.dart';
import 'package:libry/features/books/views/add_book_screen.dart';
import 'package:libry/core/themes/styles.dart';
import 'package:libry/features/issues/viewmodel/issue_provider.dart';
import 'package:libry/features/auth/view/login.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/helpers.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../issues/issue.dart';
import '../data/model/user_model.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color color = AppColors.primary;
  late UserModel? user;

  @override
  void initState() {
    super.initState();
    // if (mounted) {
    // }
    _loadUserData();
  }

  void _loadUserData() {
    user = UserModelService.getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Account", context: context),
      body: SafeArea(child: SingleChildScrollView(child: _buildProfile())),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),
            _buildKeyStats(color),
            _quickActionButtons(color),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String profileLetters = '';
    user!.name.split(' ').forEach((word)=>profileLetters += word[0]);
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primaryButton,
          child: Text(
             profileLetters,
            style: BodyTextStyles.mainHeadingStyle.copyWith(
              fontSize: 40,
              color: AppColors.white,
            ),
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${user!.name}\n",
            style: TextStyle(
              color: AppColors.white,
              fontFamily: "Lobster",
              fontSize: 42,
              fontWeight: FontWeight.w800,
            ),
            children: [
              TextSpan(
                text: "Librarian\n",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Livvic",
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade400,
                ),
              ),
              TextSpan(
                text: user!.email,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Livvic",
                  fontWeight: FontWeight.normal,

                )
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyStats(Color color) {
    final activeMembersCount = context.watch<IssueProvider>().activeCount;
    final issuedTodayCount = context.watch<IssueProvider>().issuedTodayCount;
    final fineOwes = context.watch<IssueProvider>().fineOwed;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            icon: Icons.book_rounded,
            stat: issuedTodayCount,
            label: "Issued Today",
            color: color,
          ),
          verticalDivider(),
          _buildStatCard(
            icon: Icons.people_rounded,
            stat: activeMembersCount,
            label: "Active Members",
            color: color,
          ),
          verticalDivider(),
          _buildStatCard(
            icon: Icons.currency_rupee_rounded,
            stat: fineOwes,
            label: "Fine Owes",
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _quickActionButtons(Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          actionButton(
            iconColor: color,
            textColor: color,
            icon: Icons.add_rounded,
            text: "Add Book",
            method: ()=>Navigator.push(context, transition(child: AddBookScreenView()))
          ),
          Divider(),
          actionButton(
            iconColor: color,
            textColor: color,
            icon: Icons.arrow_upward_rounded,
            text: "Issue Book",
            method: () =>
                Navigator.push(context, transition(child: IssueBookScreen())),
          ),
          Divider(),
          actionButton(
            icon: Icons.create_outlined,
            iconColor: color,
            text: "Edit Profile",
            textColor: color,
            method: () async{
              await Navigator.push(context, transition(child: EditProfileScreen()));
              _loadUserData();
            }
          ),
          Divider(),
          actionButton(icon: Icons.file_copy_outlined, iconColor: color,text: "Download",textColor: color, method: (){}),
          Divider(),
          actionButton(
              icon: Icons.exit_to_app,
              iconColor: AppColors.error,
              text: "Logout",
              textColor: AppColors.error,
              method: () async{
                UserModelService.setLogValue(false);
                await Navigator.push(context, transition(child: LoginView()));
                _loadUserData();
              }
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required int stat,
    required String label,
    Color color = Colors.black,
  }) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color, fontWeight: FontWeight.bold),
            Text(
              stat.toString(),
              style: BodyTextStyles.headingMediumStyle(color),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: BodyTextStyles.bodySmallStyle(
                color,
              ).copyWith(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalDivider() {
    return Container(height: 100, width: 1.5, color: Colors.black12);
  }

  Widget actionButton({
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color textColor,
    required VoidCallback method,
  }) {
    return GestureDetector(
      onTap: method,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(icon, color: iconColor, size: 40),
              Text(text, style: CardStyles.cardSubTitleStyle.copyWith(color: textColor)),
            ],
          ),
          Icon(Icons.arrow_forward_ios_rounded,color: iconColor,),
        ],
      ),
    );
  }

}

