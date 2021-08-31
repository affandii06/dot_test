import 'package:dot_test/model/image-categori-model.dart';
import 'package:dot_test/model/pengeluaran.dart';
import 'package:dot_test/provider/pengeluaran-repo.dart';
import 'package:dot_test/widget/bottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../util.dart';
import 'package:hive/hive.dart';

class AddPengeluaran extends StatefulWidget {
  int number;
  AddPengeluaran(this.number);
  @override
  _AddPengeluaranState createState() => _AddPengeluaranState(this.number);
}

class _AddPengeluaranState extends State<AddPengeluaran> {
  int number;
  _AddPengeluaranState(this.number);

  List image = ImageCategory().imageCategory;
  var colorList = ColorList();
  DateTime _selectedDateTime;

  TextEditingController cDateTime = TextEditingController();
  TextEditingController cnama = TextEditingController();
  TextEditingController ctotal = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ListPengeluaran>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ListPengeluaran>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengeluaran Baru', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 18),),
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 10, right: 10),
        child: ListView(
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: cnama,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: 'Nama Pengeluaran'
                    ),
                  ),

                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        hintText: image[number]['title'],
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: image[number]['color'],
                            ),
                            child: Center(
                              child: SvgPicture.asset(image[number]['image']),
                            ),
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Icon(Icons.navigate_next),
                            ),
                          ),
                        )
                    ),
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: cDateTime,
                    onTap: () {
                      BottomSheetMenu().bottomModal(context, 'addform');
                    },
                  ),

                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        hintText: 'Tanggal Pengeluaran',
                        suffixIcon: Icon(Icons.date_range)
                    ),
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: cDateTime,
                    onTap: () {
                      _selectDateTime(context);
                    },
                  ),

                  SizedBox(height: 20,),
                  TextFormField(
                    controller: ctotal,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        hintText: 'Nominal'
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 40,),
                  RaisedButton(
                    color: colorList.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text('Simpan', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    onPressed: (){
                      data.addList(cnama.text, image[number]['title'], cDateTime.text, ctotal.text);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MyHomePage()), (route) => false);
                    }
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  _selectDateTime(BuildContext context) async {
    DateTime setSelectedDateTime = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime == null ? DateTime.now() : _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
        builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      });

      if (setSelectedDateTime != null) {
        _selectedDateTime = setSelectedDateTime;
        cDateTime
          ..text = _selectedDateTime.toString().substring(0,10)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: cDateTime.text.length,
              affinity: TextAffinity.upstream));
      }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
