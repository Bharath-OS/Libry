import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

late Box genreBox;

class GenreDB{
  static List<String> getGenre(){
    return genreBox.values.toList().cast<String>();
  }

  static void addGenre(String newGenre) {
    genreBox.add(newGenre);
  }

  static int? getIndex(String searchKey){
    int index = 0;
    List<String> genres = genreBox.values.toList().cast<String>();
    index = genres.indexOf(searchKey);
    return index != -1? genres.indexOf(searchKey) : null;
  }

  static void deleteGenre(String genre){
    int? index = getIndex(genre);
    if(index != null){
      genreBox.deleteAt(index);
    }
    else{
      throw Exception("Genre $genre is not found");
    }
  }

  static void editGenre(String oldGenre, String newGenre){
    int? index = getIndex(oldGenre);
    if(index != null){
      genreBox.putAt(index, newGenre);
    }
    else{
      throw Exception("Genre $oldGenre not found");
    }
  }
}