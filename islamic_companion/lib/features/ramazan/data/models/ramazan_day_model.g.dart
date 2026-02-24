// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ramazan_day_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RamazanDayModelAdapter extends TypeAdapter<RamazanDayModel> {
  @override
  final int typeId = 3;

  @override
  RamazanDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RamazanDayModel(
      dateKey: fields[0] as String,
      hijriDay: fields[1] as int,
      rozaCompleted: fields[2] as bool,
      taraweehDone: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RamazanDayModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.hijriDay)
      ..writeByte(2)
      ..write(obj.rozaCompleted)
      ..writeByte(3)
      ..write(obj.taraweehDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RamazanDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
