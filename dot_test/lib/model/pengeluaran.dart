import 'package:hive/hive.dart';
part 'pengeluaran.g.dart';

@HiveType(typeId: 0)
class Pengeluaran extends HiveObject {
  static const int typeId = 1;
  @HiveField(0)
  String nama;
  @HiveField(1)
  String jenis;
  @HiveField(2)
  String tanggal;
  @HiveField(3)
  String total;

  Pengeluaran(this.nama, this.jenis, this.tanggal, this.total);
}