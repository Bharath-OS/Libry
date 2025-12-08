import 'package:flutter/material.dart';
import '../database/language_db.dart';

class LanguageProvider extends ChangeNotifier {
  List<String> _languages = [];

  List<String> get getLanguages => List.from(_languages);

  LanguageProvider() {
    _loadLanguages();
  }

  void _loadLanguages() async {
    _languages = LanguageDB.getLanguage();
    notifyListeners();
  }

  void addLanguage(String genre) async {
    LanguageDB.addLanguage(genre);
     _loadLanguages();
  }

  void deleteLanguage(String genre)  {
    LanguageDB.deleteLanguage(genre);
     _loadLanguages();
  }

  void editLanguage(String oldLanguage, String newLanguage)  {
    LanguageDB.editLanguage(oldLanguage, newLanguage);
     _loadLanguages();
  }
}