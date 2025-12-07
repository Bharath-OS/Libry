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
    index = genres.indexOf(searchKey);
    return index != -1? genres.indexOf(searchKey) : null;
  }

  static void deleteGenre(String genre){
    int? index = getIndex(genre);
    if(index != null){
      genreBox.deleteAt(index);
    }
    else{
      print("Element not found");
    }
  }

  static void editGenre(String oldGenre, String newGenre){
    int? index = getIndex(oldGenre);
    print("genre index : $index");
    if(index != null){
      genreBox.putAt(index, newGenre);
    }
    else{
      print("Error editing value");
    }
  }
}