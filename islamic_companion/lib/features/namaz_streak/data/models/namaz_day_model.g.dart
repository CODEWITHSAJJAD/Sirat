// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namaz_day_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NamazDayModelAdapter extends TypeAdapter<NamazDayModel> {
  @override
  final int typeId = 1;

  @override
  NamazDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NamazDayModel(
      dateKey: fields[0] as String,
      fajr: fields[1] as bool,
      dhuhr: fields[2] as bool,
      asr: fields[3] as bool,
      maghrib: fields[4] as bool,
      isha: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NamazDayModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.fajr)
      ..writeByte(2)
      ..write(obj.dhuhr)
      ..writeByte(3)
      ..write(obj.asr)
      ..writeByte(4)
      ..write(obj.maghrib)
      ..writeByte(5)
      ..write(obj.isha);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NamazDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
