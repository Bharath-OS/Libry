class BookModel {
  int? id;
  String title;
  String author;
  String year;
  String language;
  String publisher;
  String genre;
  int pages;
  int totalCopies;
  int copiesAvailable;
  String coverPicture;
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
  });

  // Simple helper to adjust copies count
  void adjustCopies(int delta) {
    copiesAvailable = (copiesAvailable + delta);
    if (copiesAvailable < 0) copiesAvailable = 0;
  }

  BookModel copyWith({
    int? id,
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
  }) {
    return BookModel(
      id: id??this.id,
      title: title??this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      language: language ?? this.language,
      publisher: publisher ?? this.publisher,
      genre: genre ?? this.genre,
      pages: pages ?? this.pages,
      totalCopies: totalCopies ?? this.totalCopies,
      copiesAvailable: copiesAvailable ?? this.copiesAvailable,
      coverPicture: coverPicture ?? this.coverPicture,
    );
  }
}

class BookKeys {
  static const String title = "title";
  static const String author = "author";
  static const String publishYear = "year";
  static const String language = "language";
  static const String publisherName = "publisher";
  static const String genre = "genre";
  static const String pages = "pages";
  static const String totalCopies = "totalCopies";
  static const String copiesAvailable = "copiesAvailable";
  static const String coverPicture = "coverPicture";
}
