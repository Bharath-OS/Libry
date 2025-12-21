import 'dart:core';

import 'package:flutter/material.dart';
import 'package:libry/models/members_model.dart';
import 'package:libry/provider/members_provider.dart';
import 'package:libry/utilities/helpers.dart';
import 'package:provider/provider.dart';
import '../models/books_model.dart';
import '../provider/book_provider.dart';
import '../themes/styles.dart';
import 'package:libry/constants/app_colors.dart';
import '../widgets/buttons.dart';
import '../widgets/layout_widgets.dart';

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
      if (filtered is List<Books>) {
        filtered = (filtered as List<Books>)
            .where((book) =>
        book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query) ||
            book.publisher.toLowerCase().contains(query))
            .toList() as List<T>;
      } else if (filtered is List<Members>) {
        filtered = (filtered as List<Members>)
            .where((member) =>
        member.name.toLowerCase().contains(query) ||
            member.email.toLowerCase().contains(query) ||
            member.phone.contains(query) ||
            (member.memberId?.toLowerCase().contains(query) ?? false))
            .toList() as List<T>;
      }
    }

    // Apply book-specific filters
    if (filtered is List<Books>) {
      // Genre filter
      if (_selectedGenre != null && _selectedGenre != 'All') {
        filtered = (filtered as List<Books>)
            .where((book) => book.genre == _selectedGenre)
            .toList() as List<T>;
      }

      // Language filter
      if (_selectedLanguage != null && _selectedLanguage != 'All') {
        filtered = (filtered as List<Books>)
            .where((book) => book.language == _selectedLanguage)
            .toList() as List<T>;
      }

      // Availability filter
      if (_availabilityFilter == 'available') {
        filtered = (filtered as List<Books>)
            .where((book) => book.copiesAvailable > 0)
            .toList() as List<T>;
      } else if (_availabilityFilter == 'unavailable') {
        filtered = (filtered as List<Books>)
            .where((book) => book.copiesAvailable == 0)
            .toList() as List<T>;
      }
    }

    // Apply member-specific filters
    if (filtered is List<Members>) {
      final now = DateTime.now();

      if (_membershipFilter == 'active') {
        filtered = (filtered as List<Members>)
            .where((member) => member.expiry.isAfter(now))
            .toList() as List<T>;
      } else if (_membershipFilter == 'expired') {
        filtered = (filtered as List<Members>)
            .where((member) => member.expiry.isBefore(now))
            .toList() as List<T>;
      } else if (_membershipFilter == 'expiring_soon') {
        final thirtyDaysFromNow = now.add(Duration(days: 30));
        filtered = (filtered as List<Members>)
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
      floatingActionButton: MyButton.fab(method: widget.fabMethod),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            style: TextFieldStyle.inputTextStyle,
            controller: _searchController,
            decoration: InputDecoration(
              hintText: widget.searchHint,
              prefixIcon: Icon(Icons.search, color: MyColors.bgColor),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: MyColors.bgColor),
                onPressed: () {
                  _searchController.clear();
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        // Filter Chips Row
        if (_filteredItems is List<Books> || _filteredItems is List<Members>)
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
                  style: BodyTextStyles.headingSmallStyle(MyColors.whiteBG),
                ),
                if (_filteredItems is List<Books>)
                  Text(
                    "Available: ${widget.availableCount}",
                    style: BodyTextStyles.bodySmallStyle(MyColors.whiteBG),
                  )
                else if (_filteredItems is List<Members>)
                  Text(
                    "Active: ${widget.availableCount}",
                    style: BodyTextStyles.bodySmallStyle(MyColors.whiteBG),
                  ),
              ],
            ),
            Row(
              children: [
                // Reset Filters Button
                if (_hasActiveFilters)
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: _resetFilters,
                      icon: Icon(Icons.filter_alt_off, color: Colors.orange),
                      tooltip: 'Reset Filters',
                      style: IconButton.styleFrom(
                        backgroundColor: MyColors.whiteBG,
                      ),
                    ),
                  ),

                // Filter Button
                IconButton(
                  onPressed: () => _showFilterDialog(context),
                  icon: Stack(
                    children: [
                      Icon(Icons.filter_list, color: MyColors.bgColor),
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
                    backgroundColor: MyColors.whiteBG,
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
          if (_filteredItems is List<Books>) ...[
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
          ] else if (_filteredItems is List<Members>) ...[
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

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap, {Color? color}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: MyColors.whiteBG.withOpacity(0.3),
      selectedColor: color ?? MyColors.bgColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : MyColors.whiteBG,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          color: MyColors.bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
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
                : "No ${widget.title.toLowerCase()} found!",
            style: BodyTextStyles.bodySmallStyle(Colors.black),
          ),
          if (_hasActiveFilters) ...[
            SizedBox(height: 8),
            TextButton(
              onPressed: _resetFilters,
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
        title: Row(
          children: [
            Icon(Icons.filter_list, color: MyColors.bgColor),
            SizedBox(width: 8),
            Text('Filter Options'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_filteredItems is List<Books>) ...[
                // Book Filters
                _buildDialogSection('Availability', [
                  _buildDialogRadio('All', _availabilityFilter == 'all', () {
                    setState(() => _availabilityFilter = 'all');
                    Navigator.pop(context);
                    _applyFilters();
                  }),
                  _buildDialogRadio('Available Only', _availabilityFilter == 'available', () {
                    setState(() => _availabilityFilter = 'available');
                    Navigator.pop(context);
                    _applyFilters();
                  }),
                  _buildDialogRadio('Unavailable Only', _availabilityFilter == 'unavailable', () {
                    setState(() => _availabilityFilter = 'unavailable');
                    Navigator.pop(context);
                    _applyFilters();
                  }),
                ]),

                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 16),

                _buildDialogSection('Genre', [
                  _buildGenreDropdown(),
                ]),

                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 16),

                _buildDialogSection('Language', [
                  _buildLanguageDropdown(),
                ]),
              ] else if (_filteredItems is List<Members>) ...[
                // Member Filters
                _buildDialogSection('Membership Status', [
                  _buildDialogRadio('All Members', _membershipFilter == 'all', () {
                    setState(() => _membershipFilter = 'all');
                    Navigator.pop(context);
                    _applyFilters();
                  }),
                  _buildDialogRadio('Active Only', _membershipFilter == 'active', () {
                    setState(() => _membershipFilter = 'active');
                    Navigator.pop(context);
                    _applyFilters();
                  }),
                  _buildDialogRadio('Expiring Soon (30 days)', _membershipFilter == 'expiring_soon', () {
                    setState(() => _membershipFilter = 'expiring_soon');
                    Navigator.pop(context);
                    _applyFilters();
                  }),
                  _buildDialogRadio('Expired', _membershipFilter == 'expired', () {
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
            child: Text('Reset All'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
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
            color: MyColors.bgColor,
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildDialogRadio(String label, bool isSelected, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      leading: Radio(
        value: true,
        groupValue: isSelected,
        onChanged: (_) => onTap(),
      ),
      onTap: onTap,
    );
  }

  Widget _buildGenreDropdown() {
    final bookProvider = context.watch<BookProvider>();
    final allBooks = widget.items as List<Books>;
    final genres = ['All', ...allBooks.map((b) => b.genre).toSet().toList()..sort()];

    return DropdownButtonFormField<String>(
      value: _selectedGenre ?? 'All',
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: genres.map((genre) {
        return DropdownMenuItem(
          value: genre,
          child: Text(genre),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedGenre = value);
        Navigator.pop(context);
        _applyFilters();
      },
    );
  }

  Widget _buildLanguageDropdown() {
    final allBooks = widget.items as List<Books>;
    final languages = ['All', ...allBooks.map((b) => b.language).toSet().toList()..sort()];

    return DropdownButtonFormField<String>(
      value: _selectedLanguage ?? 'All',
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: languages.map((language) {
        return DropdownMenuItem(
          value: language,
          child: Text(language),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedLanguage = value);
        Navigator.pop(context);
        _applyFilters();
      },
    );
  }

  Future<void> _clearAllItems(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All ${widget.title}'),
        content: Text(
          'Are you sure you want to delete all ${widget.title.toLowerCase()}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (widget.items is List<Books>) {
        await context.read<BookProvider>().clearAllBooks();
        showSnackBar(text: "All Books cleared", context: context);
      } else if (widget.items is List<Members>) {
        await context.read<MembersProvider>().clearAllMembers();
        showSnackBar(text: "All Members cleared", context: context);
      }
    }
  }
}