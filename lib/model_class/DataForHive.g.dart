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
      fields[0] as Assets,
    );
  }

  @override
  void write(BinaryWriter writer, DataForHive obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.assets);
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

class AssetsAdapter extends TypeAdapter<Assets> {
  @override
  final int typeId = 1;

  @override
  Assets read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assets(
      fields[1] as Preview1000,
    );
  }

  @override
  void write(BinaryWriter writer, Assets obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj._preview1000);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class Preview1000Adapter extends TypeAdapter<Preview1000> {
  @override
  final int typeId = 2;

  @override
  Preview1000 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Preview1000(
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Preview1000 obj) {
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
      other is Preview1000Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
