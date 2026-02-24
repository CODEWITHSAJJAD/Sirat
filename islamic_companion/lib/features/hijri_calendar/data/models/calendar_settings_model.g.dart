// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_settings_model.dart';

class CalendarSettingsModelAdapter extends TypeAdapter<CalendarSettingsModel> {
  @override
  final int typeId = 5;

  @override
  CalendarSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarSettingsModel(
      moonAdjustment: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarSettingsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.moonAdjustment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
