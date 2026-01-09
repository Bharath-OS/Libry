// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberModelAdapter extends TypeAdapter<MemberModel> {
  @override
  final int typeId = 1;

  @override
  MemberModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberModel(
      id: fields[0] as String?,
      memberId: fields[2] as String?,
      name: fields[1] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      address: fields[5] as String,
      totalBorrow: fields[6] as int,
      currentlyBorrow: fields[7] as int,
      fine: fields[8] as double,
      joined: fields[9] as DateTime,
      expiry: fields[10] as DateTime,
      fineBalance: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MemberModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.memberId)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.totalBorrow)
      ..writeByte(7)
      ..write(obj.currentlyBorrow)
      ..writeByte(8)
      ..write(obj.fine)
      ..writeByte(9)
      ..write(obj.joined)
      ..writeByte(10)
      ..write(obj.expiry)
      ..writeByte(11)
      ..write(obj.fineBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
