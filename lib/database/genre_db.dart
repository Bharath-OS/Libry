import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

late Box genreBox;

//todo rework on the genre methods
class GenreDB{
  static List<String> getGenre(){
    return genreBox.values.toList() as List<String>;
  }

  static void addGenre(String newGenre){
    genreBox.add(newGenre);
  }

  static int? getIndex(String searchKey){
    int index = 0;
    List<String> genres = getGenre();
    for(String genre in genres){
      if(genre == searchKey){
        return index;
      }
      index++;
    }
    return null;
  }

  void deleteGenre(String genre){
    int? index = getIndex(genre);
    if(index != null){
      genreBox.deleteAt(index);
    }
    else{
      print("Element not found");
    }
  }
}