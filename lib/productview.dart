import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:quick_shop/bottomnav.dart';
import 'package:quick_shop/homepage.dart';
import 'package:quick_shop/supermarket.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';



class ProductView extends StatefulWidget {
   ProductView({Key? key,required this.id,required this.sid}) : super(key: key);
  String? id;
  String? sid;
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String dropdownvalue = 'Kg';

  // List of items in our dropdown menu
  var items = [
    'Kg',
    'Count',
    'Litre',

  ];
  Future<dynamic> getData() async {

    var data = {
      "id":widget.id,
    };
    var res = await post(Uri.parse('${Con.url}product_view.php'),body: data);
    print(res.body);
    return jsonDecode(res.body);
  }


  var qua = TextEditingController();
  Future<void> getDetails() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('cus_id');
    print(widget.sid);
    var data = {
      "cus_id":sp,
      "sid":widget.sid,
      "product_id": widget.id,
      "quandity":qua.text,
      "value":dropdownvalue,
    };
    var resp = await post(Uri.parse('${Con.url}add_cart.php'),body: data);
    print(resp.body);
    // return jsonDecode(resp.body);
    if(resp.statusCode==200){
      var msg = jsonDecode(resp.body)["message"];
      if(msg=="Added"){
        Fluttertoast.showToast(msg: 'Added to cart');
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SuperMarket(),), (route) => false);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SuperMarket();
        },));
      }
      else{
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.teal.withOpacity(0.3),
      body: SafeArea(
        child: FutureBuilder(
          future: getData(),
          builder: (context,snap) {
            if (snap.hasData) {
              print(snap.data);
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(snap.data![index]['product'], style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.withOpacity(0.9),
                        ),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 20,),

                              Column(
                                children: [
                                  Container(

                                    height: 300,
                                    width: 250,

                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              Con.imgBase+snap.data![index]['image'])
                                      ),
                                      color: Colors.white,
                                    ),


                                  ),

                                ],
                              ),

                            ],
                          ),

                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Text('Price  :${snap.data![index]['price']}', style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.withOpacity(0.9),
                                      fontSize: 20,
                                    ),),
                                    SizedBox(height: 15,),


                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 70,
                                right: 70,
                                bottom: 25),
                            child: TextFormField(
                              controller: qua,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'How much you want?'
                              ),
                            ),
                          ),

                          DropdownButton(

                            // Initial Value
                            value: dropdownvalue,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),

                          SizedBox(height: 30,),
                          InkWell(
                            onTap: () {
                              // print(qua.text);
                              // print(dropdownvalue);
                              getDetails();

                              // Navigator.push(
                              //     context, MaterialPageRoute(builder: (context) {
                              //   return MyNavigationBar();
                              // },));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.teal,

                              ),

                              child: Center(
                                  child: Text('Add To Cart', style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold
                                  ),)),
                              height: 55,
                              width: 250,

                            ),
                          )
                        ],
                      )

                    ],

                  );
                },

              );
            }
            else{
              return Text('no data');
            }
          }
        ),
      ),
    );
  }
}
