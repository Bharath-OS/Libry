import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class IssueHistoryWidgets {
  static Widget buildStatsCards({
    required int total,
    required int active,
    required int returned,
    required int overdue,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              total.toString(),
              Colors.white,
              Colors.blue,
              Icons.all_inclusive,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Active',
              active.toString(),
              Colors.white,
              Colors.orange,
              Icons.book_online,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Returned',
              returned.toString(),
              Colors.white,
              Colors.green,
              Icons.check_circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Overdue',
              overdue.toString(),
              Colors.white,
              Colors.red,
              Icons.warning,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStatCard(
      String label,
      String value,
      Color bgColor,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
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
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Filter Chips Section - Shows filter chips for different statuses
  static Widget buildFilterChips({
    required int total,
    required int active,
    required int returned,
    required int overdue,
    required String currentFilter,
    required Function(String) onFilterChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'All',
              value: 'all',
              count: total,
              isSelected: currentFilter == 'all',
              onTap: () => onFilterChanged('all'),
            ),
            SizedBox(width: 8),
            _buildFilterChip(
              label: 'Active',
              value: 'active',
              count: active,
              isSelected: currentFilter == 'active',
              onTap: () => onFilterChanged('active'),
            ),
            SizedBox(width: 8),
            _buildFilterChip(
              label: 'Returned',
              value: 'returned',
              count: returned,
              isSelected: currentFilter == 'returned',
              onTap: () => onFilterChanged('returned'),
            ),
            SizedBox(width: 8),
            _buildFilterChip(
              label: 'Overdue',
              value: 'overdue',
              count: overdue,
              isSelected: currentFilter == 'overdue',
              onTap: () => onFilterChanged('overdue'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFilterChip({
    required String label,
    required String value,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color chipColor;
    switch (value) {
      case 'all':
        chipColor = AppColors.primary;
        break;
      case 'active':
        chipColor = Colors.orange;
        break;
      case 'returned':
        chipColor = Colors.green;
        break;
      case 'overdue':
        chipColor = Colors.red;
        break;
      default:
        chipColor = AppColors.primary;
    }

    return FilterChip(
      label: Text(
        '$label ($count)',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey[200],
      selectedColor: chipColor,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? chipColor : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      elevation: isSelected ? 2 : 0,
    );
  }

  /// Empty State Widget
  static Widget buildEmptyState({
    required String message,
    bool showClearFilter = false,
    VoidCallback? onClearFilter,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: AppColors.white),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showClearFilter && onClearFilter != null) ...[
            SizedBox(height: 8),
            TextButton(
              onPressed: onClearFilter,
              child: Text(
                'Clear Filter',
                style: TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Info Item Widget - Reusable info row with icon
  static Widget buildInfoItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: AppColors.darkGrey),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Fine Warning Container
  static Widget buildFineWarning({
    required int fine,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.money_off, color: Colors.red[700], size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overdue Fine',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Rs $fine',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Deleted Item Warning
  static Widget buildDeletedWarning({
    required bool isBookDeleted,
    required bool isMemberDeleted,
  }) {
    if (!isBookDeleted && !isMemberDeleted) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, size: 18, color: Colors.orange[800]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              isBookDeleted && isMemberDeleted
                  ? 'Book and Member have been deleted'
                  : isBookDeleted
                  ? 'Book has been deleted'
                  : 'Member has been deleted',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[900],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Status Badge
  static Widget buildStatusBadge({
    required bool isReturned,
    required bool isOverdue,
  }) {
    Color statusColor;
    String statusText;

    if (isReturned) {
      statusColor = Colors.green;
      statusText = 'Returned';
    } else if (isOverdue) {
      statusColor = Colors.red;
      statusText = 'Overdue';
    } else {
      statusColor = Colors.orange;
      statusText = 'Active';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Date Formatter
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}