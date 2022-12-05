import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quick_shop/homepage.dart';
import 'package:quick_shop/productlist.dart';

import 'bottomnav.dart';
import 'const.dart';

class MarketView extends StatefulWidget {
  MarketView({Key? key,required this.id}) : super(key: key);
String id;
  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  Future<dynamic> getData() async {
    print(widget.id);
    var data={
      "id":widget.id,
    };
    var res = await post(Uri.parse('${Con.url}category_list.php',),body: data);
    print(res.body);
    return jsonDecode(res.body);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      // ),
      backgroundColor: Colors.teal.withOpacity(0.3),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snap) {
          if(!snap.hasData){
            return Center(child: Text('No data'));
          }
          if(snap.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FloatingActionButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return MyNavigationBar();
                            },));
                          },child: Icon(Icons.home,color: Colors.black),backgroundColor: Colors.white),
                          FloatingActionButton(onPressed: (){

                          },child: Icon(Icons.shopping_cart,color: Colors.black,),backgroundColor: Colors.white,),
                        ],
                      ),



                      SizedBox(height: 250,),


                    ],
                  ),

                ),
                Expanded(
                  child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                    height: 150,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        itemCount: snap.data.length,
                          itemBuilder: (BuildContext context, int index)  {
                          return Card(
                          elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),

                              child: ListTile(
                                leading: Icon(Icons.menu,color: Colors.black,),
                                title: Text(snap.data![index]['category']??'no cat'),
                                trailing: SizedBox(

                                  height: 40,
                                    width: 40,
                                    child: FloatingActionButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return ProductList(id: snap.data![index]['id']??'no cat',);
                                      },));
                                    },child: Icon(Icons.arrow_forward_ios_outlined,size: 16,color: Colors.black,),backgroundColor: Colors.white,)),
                              ),
                            ),
                          );

                        }
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
      )
    );
  }
}
