import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

late Box languageBox;

class LanguageDB{
  static List<String> getLanguage(){
    return languageBox.values.toList().cast<String>();
  }

  static void addLanguage(String newLanguage) {
    languageBox.add(newLanguage);
  }

  static int? getIndex(String searchKey){
    int index = 0;
    List<String> languages = languageBox.values.toList().cast<String>();
    index = languages.indexOf(searchKey);
    return index != -1? languages.indexOf(searchKey) : null;
  }

  static void deleteLanguage(String language){
    int? index = getIndex(language);
    if(index != null){
      languageBox.deleteAt(index);
    }
    else{
      throw Exception("Language $language is not found");
    }
  }

  static void editLanguage(String oldLanguage, String newLanguage){
    int? index = getIndex(oldLanguage);
    if(index != null){
      languageBox.putAt(index, newLanguage);
    }
    else{
      throw Exception("Language $oldLanguage not found");
    }
  }
}