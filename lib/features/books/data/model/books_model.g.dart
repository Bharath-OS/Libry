// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 2;

  @override
  BookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      author: fields[2] as String,
      year: fields[3] as String,
      language: fields[4] as String,
      publisher: fields[5] as String,
      genre: fields[6] as String,
      pages: fields[7] as int,
      totalCopies: fields[8] as int,
      copiesAvailable: fields[9] as int,
      coverPicture: fields[10] as String,
      coverPictureData: fields[11] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.publisher)
      ..writeByte(6)
      ..write(obj.genre)
      ..writeByte(7)
      ..write(obj.pages)
      ..writeByte(8)
      ..write(obj.totalCopies)
      ..writeByte(9)
      ..write(obj.copiesAvailable)
      ..writeByte(10)
      ..write(obj.coverPicture)
      ..writeByte(11)
      ..write(obj.coverPictureData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
