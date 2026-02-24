// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasbeeh_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasbeehModelAdapter extends TypeAdapter<TasbeehModel> {
  @override
  final int typeId = 2;

  @override
  TasbeehModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasbeehModel(
      id: fields[0] as String,
      name: fields[1] as String,
      arabic: fields[2] as String,
      targetCount: fields[3] as int,
      currentCount: fields[4] as int,
      dateKey: fields[5] as String,
      isCompleted: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TasbeehModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.arabic)
      ..writeByte(3)
      ..write(obj.targetCount)
      ..writeByte(4)
      ..write(obj.currentCount)
      ..writeByte(5)
      ..write(obj.dateKey)
      ..writeByte(6)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasbeehModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
