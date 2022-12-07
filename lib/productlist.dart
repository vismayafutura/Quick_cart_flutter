import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quick_shop/productview.dart';

import 'const.dart';

class ProductList extends StatefulWidget {
  String id;

   ProductList({Key? key,required this.id}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  Future<dynamic> getData() async {
    var data={
      "id": widget.id,
    };
    var res = await post(Uri.parse('${Con.url}product_list.php'),body: data);
    print(res.body);
    return jsonDecode(res.body);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal.withOpacity(0.3),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snap) {
          if(!snap.hasData){
           return Center(child: Text('No Data'));
          }
          if(snap.connectionState==ConnectionState.waiting){
         return   Center(child: CircularProgressIndicator());
          }else {
              return Column(
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      height: 50,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: snap.data.length,
                        itemBuilder: (context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        print('>>>>>>>>>>>>>>>${snap.data![index]}');
                                        return ProductView(id: snap.data![index]['id'],sid: snap.data![index]['sid'],);
                                      },
                                    ));
                                  },
                                  title: Text(snap.data![index]['product']),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        Con.imgBase+snap.data![index]['image']),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          }
      ),
    );
  }
}
