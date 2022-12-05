import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';

class Userfeedback extends StatefulWidget {
  const Userfeedback({Key? key}) : super(key: key);

  @override
  State<Userfeedback> createState() => _UserfeedbackState();
}

class _UserfeedbackState extends State<Userfeedback> {
  Future<dynamic> getData() async {
    var res = await post(Uri.parse('${Con.url}view_feedback.php'));
    print(res.body);
    return jsonDecode(res.body);
  }
  var feedback = TextEditingController();
  Future<void> getSave() async {

    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('cus_id');
    var data = {
      "id": sp,
      "feedback": feedback.text,
    };
    var response =await post(Uri.parse('${Con.url}add_feedback.php'),body: data);
    print(response.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snap) {
          if(snap.hasData){
            return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (context, index) {
                return  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('feedback',style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('Customers',style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 3,

                      child: Container(

                        height: 60,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snap.data![index]['feedback'].toString()),
                              Text(snap.data![index]['id'].toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Add your feedback'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller:feedback,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()
                                          ),
                                        ),
                                        SizedBox(height: 30,),
                                        Row(

                                          children: [
                                            SizedBox(width: 200,),
                                            FloatingActionButton(onPressed: (){},child: Icon(Icons.send),),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Icon(Icons.add),
                        ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    )
                  ],
                );
              },

            );
          }
          else{
            return  FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add your feedback'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder()
                              ),
                            ),
                            SizedBox(height: 30,),
                            Row(

                              children: [
                                SizedBox(width: 200,),
                                FloatingActionButton(onPressed: (){

                                },child: Icon(Icons.send),),
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
              child: Icon(Icons.add),
            );
          }
        }
      
      ),
    );
  }
}
