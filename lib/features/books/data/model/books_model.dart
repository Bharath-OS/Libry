import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'books_model.g.dart';

@HiveType(typeId: 2)
class BookModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  String year;

  @HiveField(4)
  String language;

  @HiveField(5)
  String publisher;

  @HiveField(6)
  String genre;

  @HiveField(7)
  int pages;

  @HiveField(8)
  int totalCopies;

  @HiveField(9)
  int copiesAvailable;

  @HiveField(10)
  String coverPicture;

  @HiveField(11)
  Uint8List? coverPictureData;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.language,
    required this.publisher,
    required this.genre,
    required this.pages,
    required this.totalCopies,
    required this.copiesAvailable,
    this.coverPicture = "assets/images/dummy_book_cover.png",
    this.coverPictureData,
  });

  // Simple helper to adjust copies count
  void adjustCopies(int delta) {
    copiesAvailable = (copiesAvailable + delta);
    if (copiesAvailable < 0) copiesAvailable = 0;
  }

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? year,
    String? language,
    String? publisher,
    String? genre,
    int? pages,
    int? totalCopies,
    int? copiesAvailable,
    String? coverPicture,
    Uint8List? coverPictureData,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      language: language ?? this.language,
      publisher: publisher ?? this.publisher,
      genre: genre ?? this.genre,
      pages: pages ?? this.pages,
      totalCopies: totalCopies ?? this.totalCopies,
      copiesAvailable: copiesAvailable ?? this.copiesAvailable,
      coverPicture: coverPicture ?? this.coverPicture,
      coverPictureData: coverPictureData ?? this.coverPictureData,
    );
  }
}
