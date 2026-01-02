import 'package:flutter/material.dart';
import 'package:libry/features/settings/data/service/settings_service.dart';

class SettingsViewModel with ChangeNotifier {
  double _fineAmount = SettingsService.instance.fineAmount;
  int _issuePeriod = SettingsService.instance.issuePeriod;
  List<String> _genres = SettingsService.instance.getGenres();
  List<String> _languages = SettingsService.instance.getLanguages();
  double finePerDay = 1.0; // default value; expose load/save logic as needed

  void _syncData() {
    _fineAmount = SettingsService.instance.fineAmount;
    _issuePeriod = SettingsService.instance.issuePeriod;
    _genres = SettingsService.instance.getGenres();
    _languages = SettingsService.instance.getLanguages();
    notifyListeners();
  }

  double get fineAmount => _fineAmount;
  int get issuePeriod => _issuePeriod;
  List<String> get genres => _genres;
  List<String> get languages => _languages;

  String addGenre(String genre) {
    if (SettingsService.instance.addGenre(genre)) {
      _syncData();
      return "$genre successfully added";
    }
    return "Failed to add $genre";
  }

  String editGenre({required String oldGenre, required String newGenre}) {
    final index = genres.indexOf(oldGenre);
    if (SettingsService.instance.editGenre(index: index, newGenre: newGenre)) {
      _syncData();
      return "$newGenre successfully updated";
    }
    return "Failed to update $newGenre";
  }

  String addLanguage(String language) {
    if (SettingsService.instance.addLanguage(language)) {
      _syncData();
      return "$language successfully added";
    }
    return "Failed to add $language";
  }

  String editLanguage({
    required String oldLanguage,
    required String newLanguage,
  }) {
    final index = languages.indexOf(oldLanguage);
    if (SettingsService.instance.editLanguage(
      index: index,
      newLanguage: newLanguage,
    )) {
      _syncData();
      return "$newLanguage successfully updated";
    }
    return "Failed to update $newLanguage";
  }

  String deleteGenre(String genre) {
    if (SettingsService.instance.deleteGenre(genre)) {
      _syncData();
      debugPrint("$genre successfully deleted.");
      return "$genre successfully deleted.";
    }
    debugPrint("Failed to delete $genre");
    return "Failed to delete $genre";
  }

  String deleteLanguage(String language) {
    if (SettingsService.instance.deleteLanguage(language)) {
      _syncData();
      return "$language successfully deleted.";
    }
    return "Failed to delete $language";
  }

  String addFineAmount(double amount) {
    if (SettingsService.instance.setFineAmount(amount)) {
      _syncData();
      return "Amount updated";
    }
    return "Failed to update the amount";
  }

  String addIssuePeriod(int days) {
    if (SettingsService.instance.setIssuePeriod(days)) {
      _syncData();
      return "Borrow duration updated";
    }
    return "Failed to update the borrow period";
  }
}
