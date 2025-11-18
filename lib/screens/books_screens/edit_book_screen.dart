import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/scaffold.dart';
import '../../constants/app_colors.dart';
import '../../models/books_model.dart';
import '../../provider/book_provider.dart';
import '../../utilities/validation.dart';
import '../../widgets/form.dart';

class EditBookScreen extends StatefulWidget {
  final Books book;
  const EditBookScreen({super.key, required this.book});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> controllers;
  late Books _book;
  @override
  initState() {
    super.initState();
    _book = widget.book;
    controllers = List.generate(9, (_) => TextEditingController());
    controllers[0].text = _book.title;
    controllers[1].text = _book.author;
    controllers[2].text = _book.language;
    controllers[3].text = _book.year;
    controllers[4].text = _book.publisher;
    controllers[5].text = _book.pages.toString();
    controllers[6].text = _book.genre;
    controllers[7].text = _book.totalCopies.toString();
    controllers[8].text = _book.copiesAvailable.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormContainer(
            title: "Edit Book",
            formWidget: _editBookForm(context),
          ),
        ),
      ),
    );
  }

  Widget _editBookForm(BuildContext context) {
    void back() {
      Navigator.pop(context);
    }

    void saveBook(BuildContext context) {
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
    final TextStyle textStyle = const TextStyle(
      color: Color(0xffC1DCFF),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              style: textStyle,
              controller: controllers[0],
              decoration: InputDecoration(hintText: "Book title"),
              validator: (value) => Validator.emptyValidator(value),
            ),
            TextFormField(
              style: textStyle,
              controller: controllers[1],
              decoration: InputDecoration(hintText: "Author name"),
              validator: (value) => Validator.emptyValidator(value),
            ),
            TextFormField(
              style: textStyle,
              controller: controllers[2],
              decoration: InputDecoration(hintText: "Language"),
              validator: (value) => Validator.emptyValidator(value),
            ),
            TextFormField(
              style: textStyle,
              controller: controllers[3],
              decoration: InputDecoration(hintText: "Publish year"),
              validator: (value) => Validator.emptyValidator(value),
            ),
            TextFormField(
              style: textStyle,
              controller: controllers[4],
              decoration: InputDecoration(hintText: "Publisher"),
              validator: (value) => Validator.emptyValidator(value),
            ),
            TextFormField(
              style: textStyle,
              controller: controllers[5],
              decoration: InputDecoration(hintText: "Number of pages"),
              validator: (value) => Validator.emptyValidator(value),
            ),
            TextFormField(
              style: textStyle,
              controller: controllers[6],
              decoration: InputDecoration(hintText: "Genre"),
              validator: (value) => Validator.emptyValidator(value),
            ),
            TextFormField(
              style: textStyle,
              controller: controllers[7],
              decoration: InputDecoration(hintText: "Total copies"),
              validator: (value) => Validator.emptyValidator(value),
            ),
            TextFormField(
              style: textStyle,
              controller: controllers[8],
              decoration: InputDecoration(hintText: "Available copies"),
              validator: (value) => Validator.emptyValidator(value),
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
                  onPressed: back,
                  child: Text("Back"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryButtonColor,
                    foregroundColor: MyColors.whiteBG,
                  ),
                  onPressed: () => saveBook(context),
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
