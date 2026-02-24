// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zakat_record_model.dart';

class ZakatRecordModelAdapter extends TypeAdapter<ZakatRecordModel> {
  @override
  final int typeId = 4;

  @override
  ZakatRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZakatRecordModel(
      id: fields[0] as String,
      year: fields[1] as int,
      cashPKR: fields[2] as double,
      goldGrams: fields[3] as double,
      silverGrams: fields[4] as double,
      businessValuePKR: fields[5] as double,
      goldRatePerGram: fields[6] as double,
      silverRatePerGram: fields[7] as double,
      totalAssetsInPKR: fields[8] as double,
      zakatPayable: fields[9] as double,
      nisabUsed: fields[10] as String,
      isZakatDue: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ZakatRecordModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.cashPKR)
      ..writeByte(3)
      ..write(obj.goldGrams)
      ..writeByte(4)
      ..write(obj.silverGrams)
      ..writeByte(5)
      ..write(obj.businessValuePKR)
      ..writeByte(6)
      ..write(obj.goldRatePerGram)
      ..writeByte(7)
      ..write(obj.silverRatePerGram)
      ..writeByte(8)
      ..write(obj.totalAssetsInPKR)
      ..writeByte(9)
      ..write(obj.zakatPayable)
      ..writeByte(10)
      ..write(obj.nisabUsed)
      ..writeByte(11)
      ..write(obj.isZakatDue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZakatRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
