// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pengeluaran.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PengeluaranAdapter extends TypeAdapter<Pengeluaran> {
  @override
  int get typeId => Pengeluaran.typeId;
  Pengeluaran read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pengeluaran(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Pengeluaran obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.jenis)
      ..writeByte(2)
      ..write(obj.tanggal)
      ..writeByte(3)
      ..write(obj.total);
  }
}
