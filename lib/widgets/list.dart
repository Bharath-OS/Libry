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
  final Widget filters;

  const ListScreen({
    super.key,
    required this.title,
    required this.totalCount,
    required this.availableCount,
    required this.searchHint,
    required this.items,
    required this.tileBuilder,
    required this.fabMethod,
    required this.filters,
    this.onTap,
  });

  @override
  State<ListScreen<T>> createState() => _ListScreenState<T>();
}

class _ListScreenState<T> extends State<ListScreen<T>> {
  final TextEditingController _searchController = TextEditingController();
  late int count;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (widget.items is List<Books>) {
      context.read<BookProvider>().searchBooks(_searchController.text);
    } else {
      context.read<MembersProvider>().searchMembers(_searchController.text);
    }
  }
  //todo Implement the clearing the search text when the user switches the page
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total : ${widget.totalCount}",
                  style: BodyTextStyles.headingSmallStyle(MyColors.whiteBG),
                ),
                Text(
                  "Available : ${widget.availableCount}",
                  style: BodyTextStyles.bodySmallStyle(MyColors.whiteBG),
                ),
              ],
            ),
            SizedBox(
              child: Row(
                spacing: 10,
                children: [
                  widget.filters,
                  MyButton.deleteButton(method: () => _clearAllItems(context)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    count = widget.items.length;

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
              if (count == 0) {
                return _emptyField();
              } else {
                return _buildBookTile();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookTile() {
    return ListView.separated(
      itemCount: widget.items.length,
      itemBuilder: (ctx, i) {
        final item = widget.items[i];
        return GestureDetector(
          onTap: () => widget.onTap?.call(item),
          child: widget.tileBuilder(item),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 4),
    );
  }

  Widget _emptyField() {
    return Center(
      child: Text(
        // widget.items is List<Books> ? "No Books Found!" : "No Members Found!",
        "No ${widget.title.toLowerCase()} Found!",
        style: BodyTextStyles.bodySmallStyle(Colors.black),
      ),
    );
  }

  Future<void> _clearAllItems(BuildContext context) async {
    if (widget.items is List<Books>) {
      await context.read<BookProvider>().clearAllBooks();
      showSnackBar(text: "All Books cleared", context: context);
    } else if (widget.items is List<Members>) {
      await context.read<MembersProvider>().clearAllMembers();
      showSnackBar(text: "All Members cleared", context: context);
    }
  }
}
