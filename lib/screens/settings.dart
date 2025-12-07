import 'package:flutter/material.dart';
import 'package:libry/Themes/styles.dart';
import 'package:libry/Widgets/buttons.dart';
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
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    genres = context.watch<GenreProvider>().getGenre;
    final items = genres
        .map(
          (genre) => DropdownMenuItem(
            value: genre,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(genre),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => editGenre(context,genre),
                      icon: Icon(Icons.create_outlined),
                    ),
                    IconButton(
                      onPressed: () => print("delete $genre"),
                      icon: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .toList();
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
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Genre", style: CardStyles.cardTitleStyle),
                    DropdownButton(
                      items: items,
                      value: currentValue,
                      onChanged: (value) {
                        setState(() {
                          currentValue = value!;
                        });
                      },
                    ),
                    // Text("Add Genre", style:CardStyles.cardSubTitleStyle),
                    MyButton.primaryButton(
                      method: () => addGenre(context),
                      text: "Add Genre",
                      fontSize: 15,
                    ),
                  ],
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
  final _genreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add new genre", style: CardStyles.cardTitleStyle),
            TextFormField(
              controller: _genreController,
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
            context.read<GenreProvider>().addGenre(_genreController.text);
            Navigator.pop(context);
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
            context.read<GenreProvider>().editGenre(genre,genreController.text.trim());
            Navigator.pop(context);
          },
          text: "Edit",
          fontSize: 12,
        ),
      ],
    ),
  );
}
