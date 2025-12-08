import 'package:flutter/material.dart';
import 'package:libry/Themes/styles.dart';
import 'package:libry/Widgets/buttons.dart';
import 'package:libry/widgets/alert_dialogue.dart';
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
  late List<String> genres;
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = context.read<GenreProvider>().getGenre[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    genres = context.watch<GenreProvider>().getGenre;
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
                        field: "Genre",
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

Future<void> addGenre(BuildContext context) async {
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
              context.read<GenreProvider>().addGenre(genreController.text);
            } catch (_) {
              showAlertMessage(message: "Error adding genre", context: context);
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
              showAlertMessage(
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
              showAlertMessage(
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
  required String field,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 10,
    children: [
      Text(field, style: CardStyles.cardTitleStyle),
      Container(
        height: 150,
        decoration: BoxDecoration(
          color: MyColors.bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: MyColors.lightGrey),
        ),
        child: ListView.builder(
          itemBuilder: (ctx, index) => Card(
            color: MyColors.whiteBG,
            child: ListTile(
              title: Text(items[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => editGenre(context, items[index]),
                    child: Icon(
                      Icons.create_outlined,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  MyButton.deleteButton(
                    method: () => deleteGenre(context, items[index]),
                  ),
                ],
              ),
            ),
          ),
          itemCount: items.length,
        ),
      ),
      MyButton.primaryButton(
        method: () => addGenre(context),
        text: "Add $field",
        fontSize: 15,
      ),
    ],
  );
}
