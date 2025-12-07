import 'package:flutter/material.dart';

import '../database/genre_db.dart';

class GenreProvider extends ChangeNotifier{

  List<String> get getGenre => GenreDB.getGenre();
  void addGenre(String genre){
    GenreDB.addGenre(genre);
    notifyListeners();
  }

  void deleteGenre(String genre){
    GenreDB.deleteGenre(genre);
    notifyListeners();
  }

  void editGenre(String oldGenre, newGenre){
    GenreDB.editGenre(oldGenre,newGenre);
    notifyListeners();
  }
}