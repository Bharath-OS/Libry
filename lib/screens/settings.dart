import 'package:flutter/material.dart';
import 'package:libry/Themes/styles.dart';
import 'package:libry/Widgets/buttons.dart';
import 'package:libry/provider/language_provider.dart';
import 'package:libry/widgets/dialogs.dart';
import 'package:libry/widgets/layout_widgets.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../provider/genre_provider.dart';
import '../utilities/validation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genres = context.watch<GenreProvider>().getGenre;
    final languages = context.watch<LanguageProvider>().getLanguages;
    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Settings", context: context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(30),
                padding: EdgeInsets.all(30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColors.whiteBG,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    children: [
                      createWidgets(
                        items: genres,
                        context: context,
                        title: "Genre",
                        onAdd: (ctx, genre) =>
                            addGenre(context: ctx, items: genres),
                        onEdit: (ctx, genre) => editGenre(ctx, genre),
                        onDelete: (ctx, genre) => deleteGenre(ctx, genre),
                      ),

                      createWidgets(
                        context: context,
                        title: "Language",
                        items: languages,
                        onEdit: (ctx, language) => editLanguage(ctx, language),
                        onDelete: (ctx, language) => deleteLanguage(ctx, language),
                        onAdd: (ctx,language) => addLanguage(context: ctx, items: language),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> addLanguage({
  required BuildContext context,
  required List<String> items,
}) async {
  final languageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add new language", style: CardStyles.cardTitleStyle),
            TextFormField(
              controller: languageController,
              decoration: InputDecoration(labelText: "Enter new language"),
              validator: (value) => Validator.genreValidator(value, items),
            ),
          ],
        ),
      ),
      actions: [
        MyButton.secondaryButton(
          method: () => Navigator.pop(context),
          text: "Cancel",
          fontSize: 12,
        ),
        MyButton.primaryButton(
          method: () {
            try {
              context.read<LanguageProvider>().addLanguage(languageController.text);
            } catch (_) {
              AppDialogs.showSnackBar(message: "Error adding language", context: context);
            } finally {
              Navigator.pop(context);
            }
          },
          text: "Add",
          fontSize: 12,
        ),
      ],
    ),
  );
}

Future<void> addGenre({
  required BuildContext context,
  required List<String> items,
}) async {
  final genreController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add new genre", style: CardStyles.cardTitleStyle),
            TextFormField(
              controller: genreController,
              decoration: InputDecoration(labelText: "Enter new genre"),
              validator: (value) => Validator.genreValidator(value, items),
            ),
          ],
        ),
      ),
      actions: [
        MyButton.secondaryButton(
          method: () => Navigator.pop(context),
          text: "Cancel",
          fontSize: 12,
        ),
        MyButton.primaryButton(
          method: () {
            try {
              context.read<GenreProvider>().addGenre(genreController.text);
            } catch (_) {
              AppDialogs.showSnackBar(message: "Error adding genre", context: context);
            } finally {
              Navigator.pop(context);
            }
          },
          text: "Add",
          fontSize: 12,
        ),
      ],
    ),
  );
}

Future<void> editLanguage(BuildContext context, String language) async {
  final languageController = TextEditingController();
  languageController.text = language;
  final formKey = GlobalKey<FormState>();
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit Language", style: CardStyles.cardTitleStyle),
            TextFormField(
              controller: languageController,
              decoration: InputDecoration(labelText: "Enter new language"),
              validator: (value) => Validator.emptyValidator(value),
            ),
          ],
        ),
      ),
      actions: [
        MyButton.secondaryButton(
          method: () => Navigator.pop(context),
          text: "Cancel",
          fontSize: 12,
        ),
        MyButton.primaryButton(
          method: () {
            try {
              context.read<LanguageProvider>().editLanguage(
                language,
                languageController.text.trim(),
              );
            } catch (e) {
              AppDialogs.showSnackBar(
                message: "Error editing language",
                context: context,
              );
            } finally {
              Navigator.pop(context);
            }
          },
          text: "Edit",
          fontSize: 12,
        ),
      ],
    ),
  );
}

Future<void> editGenre(BuildContext context, String genre) async {
  final genreController = TextEditingController();
  genreController.text = genre;
  final formKey = GlobalKey<FormState>();
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit genre", style: CardStyles.cardTitleStyle),
            TextFormField(
              controller: genreController,
              decoration: InputDecoration(labelText: "Enter new genre"),
              validator: (value) => Validator.emptyValidator(value),
            ),
          ],
        ),
      ),
      actions: [
        MyButton.secondaryButton(
          method: () => Navigator.pop(context),
          text: "Cancel",
          fontSize: 12,
        ),
        MyButton.primaryButton(
          method: () {
            try {
              context.read<GenreProvider>().editGenre(
                genre,
                genreController.text.trim(),
              );
            } catch (e) {
              AppDialogs.showSnackBar(
                message: "Error editing genre",
                context: context,
              );
            } finally {
              Navigator.pop(context);
            }
          },
          text: "Edit",
          fontSize: 12,
        ),
      ],
    ),
  );
}

Future<void> deleteLanguage(BuildContext context, String language) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete language"),
      content: Text("Do you really want to delete this language?"),
      actions: [
        MyButton.secondaryButton(
          method: () => Navigator.pop(context),
          text: "No",
          fontSize: 12,
        ),
        MyButton.primaryButton(
          method: () {
            try {
              context.read<LanguageProvider>().deleteLanguage(language);
            } catch (e) {
              AppDialogs.showSnackBar(
                message: "Error deleting language",
                context: context,
              );
            } finally {
              Navigator.pop(context);
            }
          },
          text: "Yes",
          fontSize: 12,
        ),
      ],
    ),
  );
}

Future<void> deleteGenre(BuildContext context, String genre) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete Genre"),
      content: Text("Do you really want to delete this genre?"),
      actions: [
        MyButton.secondaryButton(
          method: () => Navigator.pop(context),
          text: "No",
          fontSize: 12,
        ),
        MyButton.primaryButton(
          method: () {
            try {
              context.read<GenreProvider>().deleteGenre(genre);
            } catch (e) {
              AppDialogs.showSnackBar(
                message: "Error deleting genre",
                context: context,
              );
            } finally {
              Navigator.pop(context);
            }
          },
          text: "Yes",
          fontSize: 12,
        ),
      ],
    ),
  );
}

Widget createWidgets({
  required List<String> items,
  required BuildContext context,
  required String title,
  required Future<void> Function(BuildContext, String) onEdit,
  required Future<void> Function(BuildContext, String) onDelete,
  required Future<void> Function(BuildContext, List<String>) onAdd,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 10,
    children: [
      Text(title, style: CardStyles.cardTitleStyle),
      Container(
        height: 150,
        decoration: BoxDecoration(
          color: MyColors.bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: MyColors.lightGrey),
        ),
        child: items.isEmpty
            ? Center(
                child: Text(
                  "No $title found",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  color: MyColors.whiteBG,
                  child: ListTile(
                    title: Text(items[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => onEdit(context, items[index]),
                          child: Icon(
                            Icons.create_outlined,
                            color: MyColors.primaryColor,
                          ),
                        ),
                        MyButton.deleteButton(
                          method: () => onDelete(context, items[index]),
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: items.length,
              ),
      ),
      MyButton.primaryButton(
        method: () => onAdd(context, items),
        text: "Add $title",
        fontSize: 15,
      ),
    ],
  );
}
