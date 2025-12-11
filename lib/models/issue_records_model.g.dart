// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_records_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IssueRecordsAdapter extends TypeAdapter<IssueRecords> {
  @override
  final int typeId = 3;

  @override
  IssueRecords read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IssueRecords(
      issueId: fields[0] as String,
      bookId: fields[1] as int,
      memberId: fields[2] as int,
      borrowDate: fields[3] as DateTime,
      dueDate: fields[4] as DateTime,
      returnDate: fields[5] as DateTime?,
      isReturned: fields[6] as bool,
      fineAmount: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, IssueRecords obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.issueId)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.memberId)
      ..writeByte(3)
      ..write(obj.borrowDate)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.returnDate)
      ..writeByte(6)
      ..write(obj.isReturned)
      ..writeByte(7)
      ..write(obj.fineAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueRecordsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
