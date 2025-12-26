import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:libry/features/settings/view/widgets/reusable_widgets.dart';
import 'package:libry/provider/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/styles.dart';
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import '../../../database/genre_db.dart';
import '../../../database/issue_records_db.dart';
import '../../../database/language_db.dart';
import '../../../models/issue_records_model.dart';
import '../../../provider/genre_provider.dart';
import '../../../provider/issue_provider.dart';
import '../../../provider/members_provider.dart';
import '../../auth/data/model/user_model.dart';
import '../../books/viewmodel/book_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(IssueRecordsAdapter());

  genreBox = await Hive.openBox<String>('genre');
  languageBox = await Hive.openBox<String>('language');
  userDataBoxNew = await Hive.openBox<UserModel>('users');
  statusBox = await Hive.openBox("status");

  await IssueDBHive.initIssueBox();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<BookViewModel>(create: (_) => BookViewModel()),
          ChangeNotifierProvider<GenreProvider>(create: (_) => GenreProvider()),
          ChangeNotifierProvider<LanguageProvider>(
            create: (_) => LanguageProvider(),
          ),
          ChangeNotifierProvider<IssueProvider>(
            create: (_) => IssueProvider()..init(),
          ),
          ChangeNotifierProvider<MembersProvider>(
            create: (context) => MembersProvider(),
          ),
        ],
        child: MaterialApp(home: SettingsView()),
      ),
    );
  });
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsView> {
  static const String FINE_PER_DAY_KEY = 'fine_per_day';
  static const String DEFAULT_ISSUE_DAYS_KEY = 'default_issue_days';
  final iconColor = AppColors.primary;

  double finePerDay = 5.0;
  int defaultIssueDays = 14;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      finePerDay = prefs.getDouble(FINE_PER_DAY_KEY) ?? 5.0;
      defaultIssueDays = prefs.getInt(DEFAULT_ISSUE_DAYS_KEY) ?? 14;
    });
  }

  Future<void> _saveFinePerDay(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(FINE_PER_DAY_KEY, value);
    setState(() => finePerDay = value);
  }

  Future<void> _saveDefaultIssueDays(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(DEFAULT_ISSUE_DAYS_KEY, value);
    setState(() => defaultIssueDays = value);
  }

  @override
  Widget build(BuildContext context) {
    final genres = context.watch<GenreProvider>().getGenre;
    final languages = context.watch<LanguageProvider>().getLanguages;

    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Settings", context: context),
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

              // Content Management Section
              _buildSectionTitle('Content Management'),
              SizedBox(height: 12),

              // Genres
              _buildManagementCard(
                title: 'Book Genres',
                icon: Icons.category,
                items: genres,
                emptyMessage: 'No genres added yet',
                onAdd: () => _showAddGenreDialog(genres),
                onEdit: (genre) => _showEditGenreDialog(genre),
                onDelete: (genre) => _showDeleteGenreDialog(genre),
              ),

              SizedBox(height: 16),

              // Languages
              _buildManagementCard(
                title: 'Languages',
                icon: Icons.language,
                items: languages,
                emptyMessage: 'No languages added yet',
                onAdd: () => _showAddLanguageDialog(languages),
                onEdit: (language) => _showEditLanguageDialog(language),
                onDelete: (language) => _showDeleteLanguageDialog(language),
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
              onPressed: () => _showFineDialog(),
            ),
          ),
          Divider(height: 1),
          buildSettingTile(
            icon: Icons.calendar_month,
            title: 'Default Issue Period',
            subtitle: '$defaultIssueDays days',
            trailing: IconButton(
              icon: Icon(Icons.edit, color: iconColor),
              onPressed: () => _showIssuePeriodDialog(),
            ),
          ),
          Divider(height: 1),
          buildSettingTile(
            icon: Icons.book_online,
            title: 'Max Books Per Member',
            subtitle: '5 books at a time',
            trailing: Icon(Icons.info_outline, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard({
    required String title,
    required IconData icon,
    required List<String> items,
    required String emptyMessage,
    required VoidCallback onAdd,
    required Function(String) onEdit,
    required Function(String) onDelete,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.background),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length}',
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          if (items.isEmpty)
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  emptyMessage,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    title: Text(items[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_outlined, size: 20),
                          color: AppColors.primary,
                          onPressed: () => onEdit(items[index]),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 20),
                          color: Colors.red,
                          onPressed: () => onDelete(items[index]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add),
              label: Text('Add $title'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog methods
  //todo Create a reusable pop up widget from this.
  void _showFineDialog() {
    final controller = TextEditingController(text: finePerDay.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primary,
        title: Text(
          'Set Fine Amount',
          style: BodyTextStyles.headingSmallStyle(AppColors.background),
        ),
        content: TextField(
          style: TextFieldStyle.inputTextStyle,
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelStyle: TextFieldStyle.inputTextStyle,
            labelText: 'Fine per day (₹)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextFieldStyle.inputTextStyle),
          ),
          MyButton.primaryButton(
            method: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                _saveFinePerDay(value);
                Navigator.pop(context);
              }
            },
            text: 'Save',
          ),
        ],
      ),
    );
  }

  void _showIssuePeriodDialog() {
    final controller = TextEditingController(text: defaultIssueDays.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Default Issue Period'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of days',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                _saveDefaultIssueDays(value);
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddGenreDialog(List<String> genres) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Genre'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Genre name',
              border: OutlineInputBorder(),
            ),
            validator: (value) => Validator.genreValidator(value, genres),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<GenreProvider>().addGenre(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditGenreDialog(String genre) {
    final controller = TextEditingController(text: genre);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Genre'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Genre name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<GenreProvider>().editGenre(
                  genre,
                  controller.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteGenreDialog(String genre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Genre'),
        content: Text('Are you sure you want to delete "$genre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GenreProvider>().deleteGenre(genre);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddLanguageDialog(List<String> languages) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Language'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Language name',
              border: OutlineInputBorder(),
            ),
            validator: (value) => Validator.genreValidator(value, languages),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<LanguageProvider>().addLanguage(
                  controller.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditLanguageDialog(String language) {
    final controller = TextEditingController(text: language);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Language'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Language name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<LanguageProvider>().editLanguage(
                  language,
                  controller.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteLanguageDialog(String language) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Language'),
        content: Text('Are you sure you want to delete "$language"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LanguageProvider>().deleteLanguage(language);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
