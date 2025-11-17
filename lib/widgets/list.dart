import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:libry/models/books_model.dart';
import 'package:libry/utilities/validation.dart';
import 'package:provider/provider.dart';
import '../provider/book_provider.dart';
import '../themes/styles.dart';
import 'package:libry/constants/app_colors.dart';
import '../widgets/buttons.dart';
import '../widgets/scaffold.dart';
import 'alert_dialogue.dart';
import 'fab.dart';

class ListScreen<T> extends StatelessWidget {
  final String title;
  final int totalCount;
  final int availableCount;
  final String searchHint;
  final List<T> items;
  final Widget Function(T item) tileBuilder;
  final void Function(T item)? onTap;
  final _formKey = GlobalKey<FormState>();

  ListScreen({
    super.key,
    required this.title,
    required this.totalCount,
    required this.availableCount,
    required this.searchHint,
    required this.items,
    required this.tileBuilder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text(title)),
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
      floatingActionButton: fab(method: () => _addBook(context)),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(MyColors.whiteBG),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset("assets/icons/search-line.svg"),
          ),
          hintText: searchHint,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total : ${context.watch<BookProvider>().books.length}",
                  style: BodyTextStyles.headingSmallStyle(MyColors.whiteBG),
                ),
                Text(
                  "Available : $availableCount",
                  style: BodyTextStyles.bodySmallStyle(MyColors.whiteBG),
                ),
              ],
            ),
            MyButton.filterButton(method: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    int count = context.read<BookProvider>().count;
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
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () => onTap?.call(item),
          child: tileBuilder(item),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 4),
    );
  }

  Widget _emptyField() {
    return Center(
      child: Text(
        "No Books Found",
        style: BodyTextStyles.bodySmallStyle(Colors.black),
      ),
    );
  }

  void _addBook(BuildContext context) {
    showPopUpScreen(
      title: "Add Book",
      context: context,
      child: _addBookForm(context),
    );
  }

  Widget _addBookForm(BuildContext context) {
    final List<TextEditingController> controllers = List.generate(
      9,
      (_) => TextEditingController(),
    );

    void cancel() {
      Navigator.pop(context);
    }

    void add(BuildContext context) {
      if (_formKey.currentState!.validate()) {
        final book = Books(
          title: controllers[0].text,
          author: controllers[1].text,
          language: controllers[2].text,
          year: controllers[3].text,
          publisher: controllers[4].text,
          pages: int.parse(controllers[5].text),
          genre: controllers[6].text,
          totalCopies: int.parse(controllers[7].text),
          copiesAvailable: int.parse(controllers[8].text),
        );
        context.read<BookProvider>().addBook(book);
        Navigator.pop(context);
      }
    }

    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controllers[0],
              decoration: InputDecoration(hintText: "Book title"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            TextFormField(
              controller: controllers[1],
              decoration: InputDecoration(hintText: "Author name"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            TextFormField(
              controller: controllers[2],
              decoration: InputDecoration(hintText: "Language"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            TextFormField(
              controller: controllers[3],
              decoration: InputDecoration(hintText: "Publish year"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            TextFormField(
              controller: controllers[4],
              decoration: InputDecoration(hintText: "Publisher"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            TextFormField(
              controller: controllers[5],
              decoration: InputDecoration(hintText: "Number of pages"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            TextFormField(
              controller: controllers[6],
              decoration: InputDecoration(hintText: "Genre"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            TextFormField(
              controller: controllers[7],
              decoration: InputDecoration(hintText: "No of copies available"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            TextFormField(
              controller: controllers[8],
              decoration: InputDecoration(hintText: "Book Shelf number"),
              validator: (value)=>Validator.emptyValidator(value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.secondaryButtonColor,
                    foregroundColor: MyColors.whiteBG,
                  ),
                  onPressed: cancel,
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryButtonColor,
                    foregroundColor: MyColors.whiteBG,
                  ),
                  onPressed: () => add(context),
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
