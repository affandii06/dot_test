import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dot_test/model/image-categori-model.dart';
import 'package:dot_test/view/add-pengeluaran.dart';

class BottomSheetMenu {
  bottomModal(BuildContext context, String fromPage ){
    List image = ImageCategory().imageCategory;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12))
        ),
        context: context,
        builder: (context){
          return Container(
            height: 450,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pilih Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3
                        ),
                        itemCount: image.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: image[index]['color'],
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(image[index]['image']),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(image[index]['title'], style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                            onTap: (){
                              if(fromPage == 'addform'){
                                Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AddPengeluaran(index)));
                              }else {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddPengeluaran(index)));
                              }
                            },
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}