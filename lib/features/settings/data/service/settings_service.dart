import 'package:hive/hive.dart';

class SettingsService {
  static const String _fineKey = 'fine_per_day';
  static const String _daysKey = 'default_issue_days';
  static const String _maxBorrow = 'max_book_borrow_per_member';
  late final Box _appSettingsBox;
  late final Box<String> _genreBox;
  late final Box<String> _languageBox;

  SettingsService._internal();

  static late final SettingsService _instance = SettingsService._internal();

  factory SettingsService() => _instance;

  static SettingsService get instance => _instance;

  Future<void> init() async {
    _genreBox = await Hive.openBox<String>('genre');
    _languageBox = await Hive.openBox<String>('language');
    _appSettingsBox = await Hive.openBox('app_settings');
  }

  List<String> getGenres() => _genreBox.values.toList();
  List<String> getLanguages() => _languageBox.values.toList();

  bool addGenre(String genre) {
    try {
      _genreBox.add(genre);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool editGenre({required int index, required String newGenre}){
    try{
      _genreBox.putAt(index, newGenre);
      return true;
    }catch(_){
      return false;
    }
  }

  bool addLanguage(String language) {
    try {
      _languageBox.add(language);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool editLanguage({required int index, required String newLanguage}){
    try{
      _languageBox.putAt(index, newLanguage);
      return true;
    }catch(_){
      return false;
    }
  }

  bool deleteGenre(String genre) {
    final index = _genreBox.values.toList().indexOf(genre);
    if (index != -1) {
      _genreBox.deleteAt(index);
      return true;
    } else {
      return false;
    }
  }

  bool deleteLanguage(String language) {
    final index = _languageBox.values.toList().indexOf(language);
    if (index != -1) {
      _languageBox.deleteAt(index);
      return true;
    } else {
      return false;
    }
  }

  double get fineAmount => _appSettingsBox.get(_fineKey, defaultValue: 3.0);
  bool setFineAmount(double amount) {
    try {
      _appSettingsBox.put(_fineKey, amount);
      return true;
    } catch (_) {
      return false;
    }
  }

  int get issuePeriod => _appSettingsBox.get(_daysKey, defaultValue: 15);
  bool setIssuePeriod(int period) {
    try {
      _appSettingsBox.put(_daysKey, period);
      return true;
    } catch (_) {
      return false;
    }
  }

  int get borrowLimit => _appSettingsBox.get(_maxBorrow, defaultValue: 5);
  bool setBorrowLimit(int count){
    try{
      _appSettingsBox.put(_maxBorrow, count);
      return true;
    }catch(_){
      return false;
    }
  }
}
