// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataForHive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataForHiveAdapter extends TypeAdapter<DataForHive> {
  @override
  final int typeId = 0;

  @override
  DataForHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataForHive(
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DataForHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataForHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
