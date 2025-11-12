class Books {
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
  Books({
    required this.title,
    required this.author,
    required this.year,
    required this.language,
    required this.publisher,
    required this.genre,
    required this.pages,
    required this.totalCopies,
    required this.copiesAvailable,
    required this.coverPicture
  });
}

class BookKeys{
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
