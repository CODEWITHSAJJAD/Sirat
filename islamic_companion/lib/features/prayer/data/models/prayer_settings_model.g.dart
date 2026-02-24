// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerSettingsModelAdapter extends TypeAdapter<PrayerSettingsModel> {
  @override
  final int typeId = 0;

  @override
  PrayerSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerSettingsModel(
      cityName: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      useAutoLocation: fields[3] as bool,
      fajrOffset: fields[4] as int,
      dhuhrOffset: fields[5] as int,
      asrOffset: fields[6] as int,
      maghribOffset: fields[7] as int,
      ishaOffset: fields[8] as int,
      azanEnabled: fields[9] as bool,
      vibrationEnabled: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerSettingsModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.cityName)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.useAutoLocation)
      ..writeByte(4)
      ..write(obj.fajrOffset)
      ..writeByte(5)
      ..write(obj.dhuhrOffset)
      ..writeByte(6)
      ..write(obj.asrOffset)
      ..writeByte(7)
      ..write(obj.maghribOffset)
      ..writeByte(8)
      ..write(obj.ishaOffset)
      ..writeByte(9)
      ..write(obj.azanEnabled)
      ..writeByte(10)
      ..write(obj.vibrationEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
