import 'package:dot_test/provider/pengeluaran-repo.dart';
import 'package:dot_test/widget/bottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'model/pengeluaran.dart';
import 'util.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDoc = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDoc.path);
  Hive.registerAdapter(PengeluaranAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListPengeluaran>(create: (create) => ListPengeluaran())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var colorList = ColorList();

  String date = DateTime.now().toString().substring(0,10);
  String kemarin = DateTime.now().subtract(Duration(days:1)).toString().substring(0,10);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = Provider.of<ListPengeluaran>(context, listen: false);
    data.getList();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ListPengeluaran>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorList.blue,
        child: Center(
          child: Icon(Icons.add),
        ),
        onPressed: (){
          BottomSheetMenu().bottomModal(context, 'homepage');
        },
      ),

      body: Container(
        margin: EdgeInsets.only(left: 10, top: 50),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, User!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 10,),
                Text('Jangan Lupa Catat Keuanganmu Setiap Hari', style: TextStyle(color: Colors.grey),),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: colorList.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pengeluaranmu hari ini', style: TextStyle(color: Colors.white),),
                          SizedBox(height: 10,),
                          Text(NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(data.harian), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: colorList.tile,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pengeluaranmu bulan ini', style: TextStyle(color: Colors.white),),
                          SizedBox(height: 10,),
                          Text(NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(data.bulanan) , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20,),
            Text('Pengeluaran berdasarkan kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

            Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.image.length,
                itemBuilder: (context, index){
                  return Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: Offset(0,5)
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: data.image[index]['color'],
                            ),
                            child: Center(
                              child: SvgPicture.asset(data.image[index]['image']),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(data.image[index]['title'], style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 10,),
                          Text(NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(int.parse(data.image[index]['total'])) , style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  );
                },
              ),
            ),

            SizedBox(height: 20,),
            Text('Hari ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 20,),

            Container(
              height: 200,
              child: ListView.builder(
                itemCount: data.listdata.length,
                itemBuilder: (context, index){
                  Pengeluaran dataharian = data.listdata[index];
                  String imageharian;
                  Color colorharian;
                  if(dataharian.tanggal != date){
                    return Container();
                  }
                  else {
                    if(dataharian.jenis == "Makanan"){
                      imageharian = "assets/makanan.svg";
                      colorharian = ColorList().yellow;
                    }
                    if(dataharian.jenis == "Internet"){
                      imageharian = "assets/internet.svg";
                      colorharian = ColorList().blue3;
                    }
                    if(dataharian.jenis == "Edukasi"){
                      imageharian = "assets/edukasi.svg";
                      colorharian = ColorList().orange;
                    }
                    if(dataharian.jenis == "Hadiah"){
                      imageharian = "assets/hadiah.svg";
                      colorharian = ColorList().red;
                    }
                    if(dataharian.jenis == "Transport"){
                      imageharian = "assets/transport.svg";
                      colorharian = ColorList().purple1;
                    }
                    if(dataharian.jenis == "Belanja"){
                      imageharian = "assets/belanja.svg";
                      colorharian = ColorList().green;
                    }
                    if(dataharian.jenis == "Alat Rumah"){
                      imageharian = "assets/alatrumah.svg";
                      colorharian = ColorList().purple2;
                    }
                    if(dataharian.jenis == "Olahraga"){
                      imageharian = "assets/olahraga.svg";
                      colorharian = ColorList().blue2;
                    }
                    if(dataharian.jenis == "Hiburan"){
                      imageharian = "assets/hiburan.svg";
                      colorharian = ColorList().blue1;
                    }
                    return Container(
                      height: 60,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 0.5,
                                offset: Offset(0, 5)
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: colorharian,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(imageharian),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(dataharian.nama),
                              ],
                            ),
                            Text(NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(int.parse(dataharian.total)) , style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            SizedBox(height: 20,),
            Text('Kemarin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 20,),

            Container(
              height: 200,
              child: ListView.builder(
                itemCount: data.listdata.length,
                itemBuilder: (context, index){
                  Pengeluaran datakemarin = data.listdata[index];
                  String imagekemarin;
                  Color colorkemarin;
                  if(datakemarin.tanggal != kemarin){
                    return Container();
                  }
                  else {
                    if(datakemarin.jenis == "Makanan"){
                      imagekemarin = "assets/makanan.svg";
                      colorkemarin = ColorList().yellow;
                    }
                    if(datakemarin.jenis == "Internet"){
                      imagekemarin = "assets/internet.svg";
                      colorkemarin = ColorList().blue3;
                    }
                    if(datakemarin.jenis == "Edukasi"){
                      imagekemarin = "assets/edukasi.svg";
                      colorkemarin = ColorList().orange;
                    }
                    if(datakemarin.jenis == "Hadiah"){
                      imagekemarin = "assets/hadiah.svg";
                      colorkemarin = ColorList().red;
                    }
                    if(datakemarin.jenis == "Transport"){
                      imagekemarin = "assets/transport.svg";
                      colorkemarin = ColorList().purple1;
                    }
                    if(datakemarin.jenis == "Belanja"){
                      imagekemarin = "assets/belanja.svg";
                      colorkemarin = ColorList().green;
                    }
                    if(datakemarin.jenis == "Alat Rumah"){
                      imagekemarin = "assets/alatrumah.svg";
                      colorkemarin = ColorList().purple2;
                    }
                    if(datakemarin.jenis == "Olahraga"){
                      imagekemarin = "assets/olahraga.svg";
                      colorkemarin = ColorList().blue2;
                    }
                    if(datakemarin.jenis == "Hiburan"){
                      imagekemarin = "assets/hiburan.svg";
                      colorkemarin = ColorList().blue1;
                    }
                    return Container(
                      height: 60,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 0.5,
                                offset: Offset(0, 5)
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: colorkemarin,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(imagekemarin),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(datakemarin.nama),
                              ],
                            ),
                            Text(NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(int.parse(datakemarin.total)) , style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


