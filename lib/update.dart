import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:quick_shop/bottomnav.dart';
import 'package:quick_shop/homepage.dart';
import 'package:quick_shop/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';

class Profile extends StatefulWidget {
  String? id;

  Profile({Key? key, required this.id}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var name = TextEditingController();
  var place = TextEditingController();
  var email = TextEditingController();
  var mobile = TextEditingController();
  Future<void> getSave() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('cus_id');
    var data={
      "id": sp,
      "name":name.text,
      "place":place.text,
      "email":email.text,
      "mobile":mobile.text
    };
    var res = await post(Uri.parse('${Con.url}save_profile.php'),body: data);
    print(res.body);
    if (res.statusCode == 200){
      var message = jsonDecode(res.body)["message"];
      if (message == "Added") {
        Fluttertoast.showToast(msg: 'Updated Successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return MyNavigationBar();
        },));
      }
      else{
        Fluttertoast.showToast(msg: 'Something went wrong !');
      }
    }
  }

  Future<dynamic> getData() async {
    var data = {
      "id": widget.id,
    };
    var resp = await post(Uri.parse('${Con.url}view_details.php'), body: data);
    print(resp.body);
    name.text=jsonDecode(resp.body)[0]['name'];
    place.text=jsonDecode(resp.body)[0]['place'];
    email.text=jsonDecode(resp.body)[0]['email'];
    mobile.text=jsonDecode(resp.body)[0]['mobile'];
    return jsonDecode(resp.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: getData(),
              builder: (context, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              'Update your Profile',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: name,
                              decoration: InputDecoration(
                                  label: Text(snap.data![index]['name']),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: place,
                              decoration: InputDecoration(
                                  label: Text(snap.data![index]['place']),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                  label: Text(snap.data![index]['email']),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: mobile,
                              decoration: InputDecoration(

                                  label: Text(snap.data![index]['mobile']),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              onTap: () {
                                getSave();
                              },
                              child: Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Center(
                                    child: Text(
                                  'Save',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                } else {
                  return Text('data');
                }
              })),
    );
  }
}
