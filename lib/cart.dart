import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:quick_shop/totalpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  var dlt_id;
  bool isFailed=false;

  Future<dynamic> getData() async {
    // print('entered...............');
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('cus_id');
    print(sp);
    var data = {
      "id": sp,
    };
    var res = await post(Uri.parse('${Con.url}cart_view.php'), body: data);
    print(res.body);

    var message = jsonDecode(res.body)[0]["message"];
    if (message == "Added") {
      setState(() {
        isFailed=false;
      });

    }else{
      setState(() {
        isFailed=true;
      });
Fluttertoast.showToast(msg: 'Something fishy');
    }

    return jsonDecode(res.body);
  }

  Future<void> getDelete(String rid) async {
    var dat = {"id": rid};
    print(rid);
    var resp = await post(Uri.parse('${Con.url}delete_cart.php'), body: dat);
    print(resp.statusCode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.withOpacity(0.3),
      body: SafeArea(
        child: isFailed?Center(child: Text('Your cart is Empty!',style: TextStyle(color: Colors.white),),) :Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Cart',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            'Items',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                          Column(
                            children: [
                              Text('Quandity',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text('Price',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            children: [
                              Text('  ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: getData(),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snap.data.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(snap.data![index]
                                                    ['product'] ??
                                                'no data'),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 30,
                                                  left: 10),
                                              child: Text(snap.data![index]
                                                  ['quandity']),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 30,
                                                  left: 10),
                                              child: Text(
                                                  snap.data![index]['value']),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 30,
                                                  left: 10),
                                              child: Text(
                                                  snap.data![index]['price']),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 15,
                                                  left: 10),
                                              child: IconButton(
                                                  onPressed: () {
                                                    var idss = snap.data![index]
                                                        ['request'];
                                                    getDelete(idss);
                                                  },
                                                  icon: Icon(Icons.delete)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return TotalPage();
                                },
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.teal,
                              ),
                              height: 40,
                              width: 120,
                              child: Center(child: Text('Total Amount')),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                // height: 700,
                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
