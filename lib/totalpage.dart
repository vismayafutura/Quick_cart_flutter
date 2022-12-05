import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';
import 'final.dart';

class TotalPage extends StatefulWidget {
  const TotalPage({Key? key}) : super(key: key);

  @override
  State<TotalPage> createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {

  Future<dynamic> getData() async {

    SharedPreferences spref=await SharedPreferences.getInstance();

    var data = {
      "id":spref.getString('cus_id'),


    };
    var res =await post(Uri.parse('${Con.url}total_amount.php'),body: data);
    print(res.body);
    return jsonDecode(res.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Total Amount')),automaticallyImplyLeading: false,),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snap) {
          if(snap.hasData){
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      return Center(child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(

                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(snap.data![index]['product'].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    Text("  X  "),
                                    Text(snap.data![index]['quandity'].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                                    Text("  "),
                                    Text(snap.data![index]['value'].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Text(snap.data![index]['total'].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                              ],
                            ),

                          ],
                        ),
                      ));
                    },

                  ),
                ),
                Card(
                  child: Container(
                      height: 80,width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('Grand Total :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return Final();
                                  },));
                                },
                                child: Container(
                                    child: Center(child: Text('Confirm',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                height: 50,
                                  width: 150,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ),
                )
              ],
            );

          }
          else{
            return Center(child: CircularProgressIndicator());
          }
  }
      ),

    );
  }
}
