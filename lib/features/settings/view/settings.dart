import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libry/features/settings/view/widgets/reusable_widgets.dart';
import 'package:libry/features/settings/viewmodel/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/layout_widgets.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsView> {
  final iconColor = AppColors.primary;
  late double finePerDay;
  late int defaultIssueDays;
  late int maxBorrowLimit;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final genres = context.watch<SettingsViewModel>().genres;
    final languages = context.watch<SettingsViewModel>().languages;
    finePerDay = context.watch<SettingsViewModel>().fineAmount;
    defaultIssueDays = context.watch<SettingsViewModel>().issuePeriod;
    maxBorrowLimit = context.watch<SettingsViewModel>().borrowLimit;

    return LayoutWidgets.customScaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Library Settings Section
              _buildSectionTitle('Library Settings'),
              SizedBox(height: 12),
              _buildSettingsContainer(),
              SizedBox(height: 24),
              _buildSectionTitle('Content Management'),
              SizedBox(height: 12),
              // Genres
              buildManagementCard(
                title: 'Book Genres',
                icon: Icons.category,
                items: genres,
                emptyMessage: 'No genres added yet',
                onAdd: () => showSettingsEditDialog(
                  context: context,
                  title: 'Add Genre',
                  label: 'Genre Name',
                  validator: (genre) => Validator.genreValidator(
                    genre,
                    genres,
                  ),
                  onSave: (val) =>
                      context.read<SettingsViewModel>().addGenre(val),
                ),
                onEdit: (genre) => showSettingsEditDialog(
                  context: context,
                  title: 'Edit Genre',
                  initialValue: genre,
                  label: 'Genre Name',
                  validator: (genre) => Validator.genreValidator(genre, genres),
                  onSave: (val) => context.read<SettingsViewModel>().editGenre(
                    oldGenre: genre,
                    newGenre: val,
                  ),
                ),
                onDelete: (genre) => showDeleteConfirmDialog(
                  context: context,
                  itemName: genre,
                  category: 'Genre',
                  onConfirm: () =>
                      context.read<SettingsViewModel>().deleteGenre(genre),
                ),
              ),

              SizedBox(height: 16),

              // Languages
              buildManagementCard(
                title: 'Languages',
                icon: Icons.language,
                items: languages,
                emptyMessage: 'No languages added yet',
                onAdd: () => showSettingsEditDialog(
                  context: context,
                  title: 'Add Language',
                  label: 'Language Name',
                  validator: (language) =>
                      Validator.languageValidator(language, languages),
                  onSave: (val) =>
                      context.read<SettingsViewModel>().addLanguage(val),
                ),
                onEdit: (lang) => showSettingsEditDialog(
                  context: context,
                  title: 'Edit Language',
                  initialValue: lang,
                  label: 'Language Name',
                  validator: (language) =>
                      Validator.languageValidator(language, languages),
                  onSave: (val) => context
                      .read<SettingsViewModel>()
                      .editLanguage(oldLanguage: lang, newLanguage: val),
                ),
                onDelete: (lang) => showDeleteConfirmDialog(
                  context: context,
                  itemName: lang,
                  category: 'Language',
                  onConfirm: () =>
                      context.read<SettingsViewModel>().deleteLanguage(lang),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingsContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          buildSettingTile(
            icon: Icons.attach_money,
            title: 'Fine Per Day',
            subtitle: '₹$finePerDay per day for overdue books',
            trailing: IconButton(
              icon: Icon(Icons.edit, color: iconColor),
              onPressed: () => showSettingsEditDialog(
                context: context,
                title: 'Set Fine Amount',
                label: 'Fine per day (₹)',
                initialValue: finePerDay.toString(),
                validator: (fineAmount) => Validator.numberValidator(
                  value: fineAmount,
                  isDouble: true,
                ),
                onSave: (fineAmount) {
                  context.read<SettingsViewModel>().addFineAmount(
                    double.parse(fineAmount),
                  );
                },
              ),
            ),
          ),
          Divider(height: 1),
          buildSettingTile(
            icon: Icons.calendar_month,
            title: 'Default Issue Period',
            subtitle: '$defaultIssueDays days',
            trailing: IconButton(
              icon: Icon(Icons.edit, color: iconColor),
              onPressed: () => showSettingsEditDialog(
                context: context,
                title: 'Set Default Issue Period',
                label: 'Number of days',
                initialValue: defaultIssueDays.toString(),
                validator: (days) => Validator.numberValidator(value: days),
                onSave: (value) {
                  context.read<SettingsViewModel>().addIssuePeriod(
                    int.parse(value),
                  );
                },
              ),
            ),
          ),
          Divider(height: 1),
          buildSettingTile(
            icon: Icons.book_online,
            title: 'Max BookModel Per Member',
            subtitle: '$maxBorrowLimit books at a time',
            trailing: IconButton(
              icon: Icon(Icons.edit, color: iconColor),
              onPressed: () => showSettingsEditDialog(
                context: context,
                title: 'Set Default Issue Period',
                label: 'Number of days',
                initialValue: maxBorrowLimit.toString(),
                validator: (days) => Validator.numberValidator(value: days),
                onSave: (value) {
                  context.read<SettingsViewModel>().addBorrowLimit(
                    int.parse(value),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
