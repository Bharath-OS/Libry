import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:libry/features/settings/data/service/settings_service.dart';
import 'package:libry/features/settings/view/widgets/reusable_widgets.dart';
import 'package:libry/features/settings/viewmodel/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../issues/data/service/issue_records_db.dart';
import '../../issues/data/model/issue_records_model.dart';
import '../../issues/viewmodel/issue_provider.dart';
import '../../members/viewmodel/members_provider.dart';
import '../../auth/data/model/user_model.dart';
import '../../books/viewmodel/book_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(IssueRecordsAdapter());

  userDataBoxNew = await Hive.openBox<UserModel>('users');
  statusBox = await Hive.openBox("status");

  await IssueDBHive.initIssueBox();
  await SettingsService.instance.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<BookViewModel>(create: (_) => BookViewModel()),
          ChangeNotifierProvider<SettingsViewModel>(
            create: (_) => SettingsViewModel(),
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
  final iconColor = AppColors.primary;
  final fineController = TextEditingController();
  final issuePeriodController = TextEditingController();
  late double finePerDay;
  late int defaultIssueDays;

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
              buildManagementCard(
                title: 'Book Genres',
                icon: Icons.category,
                items: genres,
                emptyMessage: 'No genres added yet',
                onAdd: () => showManagerDialog(
                  context: context,
                  title: 'Add Genre',
                  label: 'Genre Name',
                  existingItems: genres,
                  onSave: (val) => context.read<SettingsViewModel>().addGenre(val),
                ),
                onEdit: (genre) => showManagerDialog(
                  context: context,
                  title: 'Edit Genre',
                  initialValue: genre,
                  label: 'Genre Name',
                  existingItems: genres,
                  onSave: (val) => context.read<SettingsViewModel>().editGenre(oldGenre: genre, newGenre: val),
                ),
                onDelete: (genre) => showDeleteConfirmDialog(
                  context: context,
                  itemName: genre,
                  category: 'Genre',
                  onConfirm: () => context.read<SettingsViewModel>().deleteGenre(genre),
                ),
              ),

              SizedBox(height: 16),

              // Languages
              buildManagementCard(
                title: 'Languages',
                icon: Icons.language,
                items: languages,
                emptyMessage: 'No languages added yet',
                onAdd: () => showManagerDialog(
                  context: context,
                  title: 'Add Language',
                  label: 'Language Name',
                  existingItems: languages,
                  onSave: (val) => context.read<SettingsViewModel>().addLanguage(val),
                ),
                onEdit: (lang) => showManagerDialog(
                  context: context,
                  title: 'Edit Language',
                  initialValue: lang,
                  label: 'Language Name',
                  existingItems: languages,
                  onSave: (val) => context.read<SettingsViewModel>().editLanguage(oldLanguage: lang, newLanguage: val),
                ),
                onDelete: (lang) => showDeleteConfirmDialog(
                  context: context,
                  itemName: lang,
                  category: 'Language',
                  onConfirm: () => context.read<SettingsViewModel>().deleteLanguage(lang),
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
              onPressed: () => buildDialogBox(
                controller: fineController,
                context: context,
                title: 'Set Fine Amount',
                label: 'Fine per day (₹)',
                saveMethod: () {
                  context.read<SettingsViewModel>().addFineAmount(double.parse(fineController.text.trim()));
                  Navigator.pop(context);
                },
                isDouble: true
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
              onPressed: () => buildDialogBox(
                controller: issuePeriodController,
                context: context,
                title: 'Set Default Issue Period',
                label: 'Number of days',
                saveMethod: (){
                  context.read<SettingsViewModel>().addIssuePeriod(int.parse(issuePeriodController.text));
                  Navigator.pop(context);
                },
              ),
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
}
