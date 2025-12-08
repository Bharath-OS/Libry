import '../database/genre_db.dart';
import 'package:flutter/material.dart';

class GenreProvider extends ChangeNotifier {
  List<String> _genres = [];

  List<String> get getGenre => List.from(_genres);

  GenreProvider() {
    _loadGenres();
  }

  void _loadGenres()  {
    _genres =  GenreDB.getGenre();
    notifyListeners();
  }

  void addGenre(String genre)  {
    GenreDB.addGenre(genre);
     _loadGenres();
  }

  void deleteGenre(String genre)  {
    GenreDB.deleteGenre(genre);
     _loadGenres();
  }

  void editGenre(String oldGenre, String newGenre)  {
    GenreDB.editGenre(oldGenre, newGenre);
     _loadGenres();
  }
}