import 'package:flutter/material.dart';
import 'package:libry/provider/issue_provider.dart';
import 'package:libry/provider/members_provider.dart';
import 'package:libry/screens/members_screens/edit_member.dart';
import 'package:libry/utilities/helpers.dart';
import 'package:libry/utilities/helpers/date_formater.dart';
import 'package:libry/widgets/layout_widgets.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/members_model.dart';
import '../../screens/members_screens/member_history.dart';

class MemberDetailsScreen extends StatefulWidget {
  final int memberId;

  const MemberDetailsScreen({super.key, required this.memberId});

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  final String dateFormatString = 'dd/MM/yyyy';
  // late final issue;
  @override
  Widget build(BuildContext context) {
    final memberDetail = context.watch<MembersProvider>().getMemberById(widget.memberId);
    final issue = context.watch<IssueProvider>().getMemberFine(widget.memberId);

    if (memberDetail == null) {
      return LayoutWidgets.customScaffold(
        appBar: LayoutWidgets.appBar(barTitle: "Member Details", context: context),
        body: Center(child: Text('Member not found')),
      );
    }

    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Member Details", context: context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Member Header Section
              _buildHeaderSection(memberDetail),
        
              // Member Information
              _buildInformationSection(memberDetail),
        
              // Statistics
              _buildStatisticsSection(memberDetail, issue),
        
              // Action Buttons
              _buildActionButtons(memberDetail),
        
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Members member) {
    final isActive = DateTime.now().isBefore(member.expiry);
    final daysUntilExpiry = member.expiry.difference(DateTime.now()).inDays;

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Member Initial Circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                member.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.background,
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Member Name
          Text(
            member.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          // Member ID
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ID: ${member.memberId}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Membership Status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.warning,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  isActive
                      ? daysUntilExpiry > 30
                      ? 'Active Membership'
                      : 'Expiring in $daysUntilExpiry days'
                      : 'Membership Expired',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection(Members member) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          _buildInfoRow(Icons.email, 'Email', member.email),
          _buildInfoRow(Icons.phone, 'Phone', member.phone),
          _buildInfoRow(Icons.location_on, 'Address', member.address),

          Divider(height: 32),

          Text(
            'Membership Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          _buildInfoRow(
            Icons.calendar_today,
            'Joined',
            dateFormat(date: member.joined, format: dateFormatString),
          ),
          _buildInfoRow(
            Icons.event_available,
            'Valid Until',
            dateFormat(date: member.expiry, format: dateFormatString),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(Members member, int issue) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Borrowing Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Borrowed',
                  member.totalBorrow.toString(),
                  Icons.library_books,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Currently',
                  '${member.currentlyBorrow}/5',
                  Icons.book_online,
                  member.currentlyBorrow >= 5 ? Colors.red : Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Fines',
                  '₹${issue.toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  member.fine > 0 ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Slots Left',
                  '${5 - member.currentlyBorrow}',
                  Icons.space_dashboard,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.background, size: 20),
          SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Members member) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemberHistoryScreen(memberId: widget.memberId),
                ),
              ),
              icon: Icon(Icons.history),
              label: Text('View Borrow History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryButton,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  transition(child: EditMembersScreen(member: member)),
                );
              },
              icon: Icon(Icons.edit),
              label: Text('Edit Member'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmDelete(member),
              icon: Icon(Icons.delete),
              label: Text('Delete Member'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Members member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Member'),
        content: Text('Are you sure you want to delete "${member.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MembersProvider>().removeMember(member.id!);
              Navigator.pop(context); // Go back after delete
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}