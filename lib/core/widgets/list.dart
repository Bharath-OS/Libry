import 'dart:core';

import 'package:flutter/material.dart';

import 'package:libry/features/members/data/model/members_model.dart';
import 'package:libry/features/members/viewmodel/members_provider.dart';
import 'package:provider/provider.dart';

import '../../features/books/data/model/books_model.dart';
import '../../features/books/viewmodel/book_provider.dart';
import '../constants/app_colors.dart';
import '../themes/styles.dart';
import '../utilities/helpers.dart';
import '../utilities/helpers/pdf_export_services.dart';
import 'buttons.dart';
import 'layout_widgets.dart';

class ListScreen<T> extends StatefulWidget {
  final String title;
  final int totalCount;
  final int availableCount;
  final String searchHint;
  final List<T> items;
  final Widget Function(T item) tileBuilder;
  final void Function(T item)? onTap;
  final VoidCallback fabMethod;

  const ListScreen({
    super.key,
    required this.title,
    required this.totalCount,
    required this.availableCount,
    required this.searchHint,
    required this.items,
    required this.tileBuilder,
    required this.fabMethod,
    this.onTap,
  });

  @override
  State<ListScreen<T>> createState() => _ListScreenState<T>();
}

class _ListScreenState<T> extends State<ListScreen<T>> {
  final TextEditingController _searchController = TextEditingController();

  // Filter states
  String? _selectedGenre;
  String? _selectedLanguage;
  String _availabilityFilter = 'all'; // all, available, unavailable
  String _membershipFilter = 'all'; // all, active, expired, expiring_soon

  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    List<T> filtered = widget.items;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      if (filtered is List<BookModel>) {
        filtered = (filtered as List<BookModel>)
            .where((book) =>
        book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query) ||
            book.publisher.toLowerCase().contains(query))
            .toList() as List<T>;
      } else if (filtered is List<MemberModel>) {
        filtered = (filtered as List<MemberModel>)
            .where((member) =>
        member.name.toLowerCase().contains(query) ||
            member.email.toLowerCase().contains(query) ||
            member.phone.contains(query) ||
            (member.memberId?.toLowerCase().contains(query) ?? false))
            .toList() as List<T>;
      }
    }

    // Apply book-specific filters
    if (filtered is List<BookModel>) {
      // Genre filter
      if (_selectedGenre != null && _selectedGenre != 'All') {
        filtered = (filtered as List<BookModel>)
            .where((book) => book.genre == _selectedGenre)
            .toList() as List<T>;
      }

      // Language filter
      if (_selectedLanguage != null && _selectedLanguage != 'All') {
        filtered = (filtered as List<BookModel>)
            .where((book) => book.language == _selectedLanguage)
            .toList() as List<T>;
      }

      // Availability filter
      if (_availabilityFilter == 'available') {
        filtered = (filtered as List<BookModel>)
            .where((book) => book.copiesAvailable > 0)
            .toList() as List<T>;
      } else if (_availabilityFilter == 'unavailable') {
        filtered = (filtered as List<BookModel>)
            .where((book) => book.copiesAvailable == 0)
            .toList() as List<T>;
      }
    }

    // Apply member-specific filters
    if (filtered is List<MemberModel>) {
      final now = DateTime.now();

      if (_membershipFilter == 'active') {
        filtered = (filtered as List<MemberModel>)
            .where((member) => member.expiry.isAfter(now))
            .toList() as List<T>;
      } else if (_membershipFilter == 'expired') {
        filtered = (filtered as List<MemberModel>)
            .where((member) => member.expiry.isBefore(now))
            .toList() as List<T>;
      } else if (_membershipFilter == 'expiring_soon') {
        final thirtyDaysFromNow = now.add(Duration(days: 30));
        filtered = (filtered as List<MemberModel>)
            .where((member) =>
        member.expiry.isAfter(now) &&
            member.expiry.isBefore(thirtyDaysFromNow))
            .toList() as List<T>;
      }
    }

    setState(() {
      _filteredItems = filtered;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedGenre = null;
      _selectedLanguage = null;
      _availabilityFilter = 'all';
      _membershipFilter = 'all';
      _filteredItems = widget.items;
    });
  }

  bool get _hasActiveFilters {
    return _searchController.text.isNotEmpty ||
        (_selectedGenre != null && _selectedGenre != 'All') ||
        (_selectedLanguage != null && _selectedLanguage != 'All') ||
        _availabilityFilter != 'all' ||
        _membershipFilter != 'all';
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reapply filters when widget rebuilds with new items
    if (widget.items.length != _filteredItems.length && !_hasActiveFilters) {
      _filteredItems = widget.items;
    }

    return LayoutWidgets.customScaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 14),
              _buildList(context),
            ],
          ),
        ),
      ),
      floatingActionButton: MyButton.fab(onPressed: widget.fabMethod,label: "Add ${widget.items is List<BookModel> ? "Book" : "Member"}"),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            style: TextFieldStyle.inputTextStyle.copyWith(color: Colors.black),
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              hintText: widget.searchHint,
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: AppColors.primary),
                onPressed: () {
                  _searchController.clear();
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2.0),
              ),
            ),
          ),
        ),

        // Filter Chips Row
        if (_filteredItems is List<BookModel> || _filteredItems is List<MemberModel>)
          _buildFilterChips(),

        const SizedBox(height: 12),

        // Stats and Actions Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Showing: ${_filteredItems.length} of ${widget.totalCount}",
                  style: BodyTextStyles.headingSmallStyle(AppColors.white),
                ),
                if (_filteredItems is List<BookModel>)
                  Text(
                    "Available: ${widget.availableCount}",
                    style: BodyTextStyles.bodySmallStyle(AppColors.white),
                  )
                else if (_filteredItems is List<MemberModel>)
                  Text(
                    "Active: ${widget.availableCount}",
                    style: BodyTextStyles.bodySmallStyle(AppColors.white),
                  ),
              ],
            ),
            Row(
              children: [
                // Export Button
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () => _exportToPdf(context),
                    icon: Icon(Icons.download, color: Colors.white),
                    tooltip: 'Export to PDF',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                // Filter Button
                IconButton(
                  onPressed: () => _showFilterDialog(context),
                  icon: Stack(
                    children: [
                      Icon(Icons.filter_list, color: Colors.white),
                      if (_hasActiveFilters)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                MyButton.deleteButton(method: () => _clearAllItems(context)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (_filteredItems is List<BookModel>) ...[
            // Availability chips
            _buildChip(
              'All',
              _availabilityFilter == 'all',
                  () => setState(() {
                _availabilityFilter = 'all';
                _applyFilters();
              }),
            ),
            SizedBox(width: 8),
            _buildChip(
              'Available',
              _availabilityFilter == 'available',
                  () => setState(() {
                _availabilityFilter = 'available';
                _applyFilters();
              }),
              color: Colors.green,
            ),
            SizedBox(width: 8),
            _buildChip(
              'Unavailable',
              _availabilityFilter == 'unavailable',
                  () => setState(() {
                _availabilityFilter = 'unavailable';
                _applyFilters();
              }),
              color: Colors.red,
            ),
          ] else if (_filteredItems is List<MemberModel>) ...[
            // Membership status chips
            _buildChip(
              'All',
              _membershipFilter == 'all',
                  () => setState(() {
                _membershipFilter = 'all';
                _applyFilters();
              }),
            ),
            SizedBox(width: 8),
            _buildChip(
              'Active',
              _membershipFilter == 'active',
                  () => setState(() {
                _membershipFilter = 'active';
                _applyFilters();
              }),
              color: Colors.green,
            ),
            SizedBox(width: 8),
            _buildChip(
              'Expiring Soon',
              _membershipFilter == 'expiring_soon',
                  () => setState(() {
                _membershipFilter = 'expiring_soon';
                _applyFilters();
              }),
              color: Colors.orange,
            ),
            SizedBox(width: 8),
            _buildChip(
              'Expired',
              _membershipFilter == 'expired',
                  () => setState(() {
                _membershipFilter = 'expired';
                _applyFilters();
              }),
              color: Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap,
      {Color? color}) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: AppColors.white,
      selectedColor: color ?? AppColors.primary,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: AppColors.background,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Builder(
            builder: (context) {
              if (_filteredItems.isEmpty) {
                return _emptyField();
              } else {
                return _buildItemList();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return ListView.separated(
      itemCount: _filteredItems.length,
      itemBuilder: (ctx, i) {
        final item = _filteredItems[i];
        return GestureDetector(
          onTap: () => widget.onTap?.call(item),
          child: widget.tileBuilder(item),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 4),
    );
  }

  Widget _emptyField() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _hasActiveFilters ? Icons.search_off : Icons.inbox,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            _hasActiveFilters
                ? "No results found"
                : "No ${widget.items is List<BookModel> ? "book":"member"} found!",
            style: BodyTextStyles.bodySmallStyle(Colors.black),
          ),
          if (_hasActiveFilters) ...[
            SizedBox(height: 8),
            TextButton(
              onPressed: _resetFilters,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              child: Text('Clear filters'),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            Icon(Icons.filter_list, color: AppColors.primary),
            SizedBox(width: 12),
            Text(
              'Filter Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_filteredItems is List<BookModel>) ...[
                // Book Filters
                _buildDialogSection('Availability', [
                  _buildDialogRadio('All', _availabilityFilter == 'all', () {
                    setState(() => _availabilityFilter = 'all');
                    Navigator.pop(context);
                    _applyFilters();
                  }),
                  _buildDialogRadio('Available Only',
                      _availabilityFilter == 'available', () {
                        setState(() => _availabilityFilter = 'available');
                        Navigator.pop(context);
                        _applyFilters();
                      }),
                  _buildDialogRadio('Unavailable Only',
                      _availabilityFilter == 'unavailable', () {
                        setState(() => _availabilityFilter = 'unavailable');
                        Navigator.pop(context);
                        _applyFilters();
                      }),
                ]),
                SizedBox(height: 16),
                Divider(color: Colors.grey[300]),
                SizedBox(height: 16),
                _buildDialogSection('Genre', [
                  _buildGenreDropdown(),
                ]),
                SizedBox(height: 16),
                Divider(color: Colors.grey[300]),
                SizedBox(height: 16),
                _buildDialogSection('Language', [
                  _buildLanguageDropdown(),
                ]),
              ] else if (_filteredItems is List<MemberModel>) ...[
                // Member Filters
                _buildDialogSection('Membership Status', [
                  _buildDialogRadio('All Member', _membershipFilter == 'all',
                          () {
                        setState(() => _membershipFilter = 'all');
                        Navigator.pop(context);
                        _applyFilters();
                      }),
                  _buildDialogRadio('Active Only',
                      _membershipFilter == 'active', () {
                        setState(() => _membershipFilter = 'active');
                        Navigator.pop(context);
                        _applyFilters();
                      }),
                  _buildDialogRadio('Expiring Soon (30 days)',
                      _membershipFilter == 'expiring_soon', () {
                        setState(() => _membershipFilter = 'expiring_soon');
                        Navigator.pop(context);
                        _applyFilters();
                      }),
                  _buildDialogRadio('Expired', _membershipFilter == 'expired',
                          () {
                        setState(() => _membershipFilter = 'expired');
                        Navigator.pop(context);
                        _applyFilters();
                      }),
                ]),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetFilters();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Reset All',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDialogRadio(String label, bool isSelected, VoidCallback onTap) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey[300]!,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      color: isSelected ? AppColors.primary.withAlpha((0.1*255).toInt()) : Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        leading: Radio(
          value: true,
          groupValue: isSelected,
          onChanged: (_) => onTap(),
          activeColor: AppColors.primary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildGenreDropdown() {
    final allBooks = widget.items as List<BookModel>;
    final genres = [
      'All',
      ...allBooks.map((b) => b.genre).toSet().toList()..sort()
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGenre ?? 'All',
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        dropdownColor: AppColors.white,
        style: TextStyle(color: Colors.black),
        items: genres.map((genre) {
          return DropdownMenuItem(
            value: genre,
            child: Text(
              genre,
              style: TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedGenre = value);
          Navigator.pop(context);
          _applyFilters();
        },
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    final allBooks = widget.items as List<BookModel>;
    final languages = [
      'All',
      ...allBooks.map((b) => b.language).toSet().toList()..sort()
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedLanguage ?? 'All',
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        dropdownColor: AppColors.white,
        style: TextStyle(color: Colors.black),
        items: languages.map((language) {
          return DropdownMenuItem(
            value: language,
            child: Text(
              language,
              style: TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedLanguage = value);
          Navigator.pop(context);
          _applyFilters();
        },
      ),
    );
  }

  Future<void> _clearAllItems(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Clear All ${widget.title}',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete all ${widget.title.toLowerCase()}? This action cannot be undone.',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (widget.items is List<BookModel>) {
        await context.read<BookViewModel>().clearAllBooks();
        showSnackBar(text: "All Book cleared", context: context);
      } else if (widget.items is List<MemberModel>) {
        await context.read<MembersViewModel>().clearAllMembers();
        showSnackBar(text: "All Member cleared", context: context);
      }
    }
  }

  Future<void> _exportToPdf(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text(
                    'Generating PDF...',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Export based on type
      if (_filteredItems.isEmpty) {
        Navigator.pop(context);
        showSnackBar(
          text: "No data to export",
          context: context,
        );
        return;
      }

      if (_filteredItems is List<BookModel>) {
        await PdfExportService.exportBooksToPdf(_filteredItems);
      } else if (_filteredItems is List<MemberModel>) {
        await PdfExportService.exportMembersToPdf(_filteredItems);
      }

      // Close loading dialog
      Navigator.pop(context);

      // Show success message
      showSnackBar(
        text: "PDF exported successfully!",
        context: context,
      );
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      showSnackBar(
        text: "Error exporting PDF: ${e.toString()}",
        context: context,
      );
    }
  }
}