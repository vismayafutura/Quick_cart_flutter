import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quick_shop/marketview.dart';

import 'const.dart';

class SuperMarket extends StatefulWidget {
  const SuperMarket({Key? key}) : super(key: key);

  @override
  State<SuperMarket> createState() => _SuperMarketState();
}

class _SuperMarketState extends State<SuperMarket> {
  Future<List> getData()async{
    var res = await get(Uri.parse('${Con.url}supermarket_list.php'));
    print(res.body);
    return jsonDecode(res.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal,),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snap) {
          if(snap.hasData) {
            return ListView.builder(
                itemCount: snap.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 3,
                    child: ListTile(
                        leading: const Icon(Icons.list),
                        trailing: ElevatedButton(onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return MarketView(id: snap.data![index]['id']);
                          },));
                        }, child:

                        Text('View'),),
                        title: Text(snap.data![index]['name'])),
                  );
                });
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
