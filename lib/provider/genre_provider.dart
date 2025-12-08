import '../database/genre_db.dart';
import 'package:flutter/material.dart';

class GenreProvider extends ChangeNotifier {
  List<String> _genres = [];

  List<String> get getGenre => List.from(_genres);

  GenreProvider() {
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    _genres = await GenreDB.getGenre();
    notifyListeners();
  }

  Future<void> addGenre(String genre) async {
    GenreDB.addGenre(genre);
    await _loadGenres();
  }

  Future<void> deleteGenre(String genre) async {
    GenreDB.deleteGenre(genre);
    await _loadGenres();
  }

  Future<void> editGenre(String oldGenre, String newGenre) async {
    GenreDB.editGenre(oldGenre, newGenre);
    await _loadGenres();
  }
}