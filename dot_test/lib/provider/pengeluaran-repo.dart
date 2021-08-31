import 'package:dot_test/model/image-categori-model.dart';
import 'package:dot_test/model/pengeluaran.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class ListPengeluaran with ChangeNotifier {

  List listdata = [];
  List listharian = [];
  List listkemarin = [];

  int harian = 0;
  int bulanan = 0;

  String dateNow = DateTime.now().toString().substring(0,10);
  String monthNow = DateTime.now().toString().substring(5,7);

  List image = ImageCategory().imageCategory;

  getList() async{
    harian = 0;
    bulanan = 0;
    print(dateNow);
    var data1 = await Hive.openBox<Pengeluaran>('Pengeluaran');
    listdata = data1.values.toList();
    print(listdata[0]);

    if(listdata.length != 0){
      for(int i = 0; i<listdata.length; i++){
        Pengeluaran pengeluaran = listdata[i];
        //add total harian
        if(pengeluaran.tanggal == dateNow){
          harian = harian + int.parse(pengeluaran.total);
          print('harian');
          print(harian);
        }
        //add total bulanan
        if(pengeluaran.tanggal.substring(5,7) == monthNow){
          bulanan = bulanan + int.parse(pengeluaran.total);
          print('bulanan');
          print(bulanan);
        }

        for(int k = 0; k<image.length; k++){
          if(pengeluaran.jenis == image[k]['title']){
            image[k]['total'] = pengeluaran.total;
          }
        }
      }
    }
    notifyListeners();
  }

  addList(String nama, String jenis, String tanggal, String total) async{
    var data1 = await Hive.openBox<Pengeluaran>('Pengeluaran');
    // var data1 = Hive.box('Pengeluaran');
    data1.add(Pengeluaran(nama, jenis, tanggal, total));
    print(listdata);
    notifyListeners();
  }
}