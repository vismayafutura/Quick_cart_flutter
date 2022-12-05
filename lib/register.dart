import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_shop/login.dart';

import 'const.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var name = TextEditingController();
  var place = TextEditingController();
  var email = TextEditingController();
  var mobile = TextEditingController();
  var username = TextEditingController();
  var password = TextEditingController();
  Future<void> getRegister() async {
    print(fkey.currentState!.validate());
    if(fkey.currentState!.validate()) {
      print('object');
      var data = {
        "name": name.text,
        "place": place.text,
        "email": email.text,
        "mobile": mobile.text,
        "username": username.text,
        "password": password.text,
      };
      print(data);
      var res = await post(Uri.parse('${Con.url}register.php'), body: data);
      print(res.body);
      if (res.statusCode == 200) {
        var message = jsonDecode(res.body)["message"];
        if (message == "Added") {
          Fluttertoast.showToast(msg: 'Successfully Registered...');
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return Login();
            },
          ));
        } else {
          Fluttertoast.showToast(msg: 'Something went wrong!');
        }
      }
    }
  }
  var fkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(key: fkey,
            child: ListView(
              children: [
                SizedBox(height: 50,),
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return 'This field is requires';
                    }
                  },
                  controller: name,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Enter your name',
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return 'This field is requires';
                    }
                  },
                  controller: place,
                  decoration: InputDecoration(
                      hintText: 'Place',
                      labelText: 'Enter your Place',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return 'This field is requires';
                    }
                  },
                  controller: email,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Enter your email',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return 'field is empty';
                    }else if(v.length<10){
                      return 'Invalid Mobile Number';
                    }

                  },
                  controller: mobile,
                  decoration: InputDecoration(
                      hintText: 'Mobile',
                      labelText: 'Enter your Mobile number',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return 'This field is requires';
                    }
                  },
                  controller: username,
                  decoration: InputDecoration(
                      hintText: 'Username',
                      labelText: 'Enter your Username',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return 'This field is requires';
                    }
                    else if(v!.length<6){
                      return 'Password must contain 6 charectors';
                    }
                  },
                  controller: password,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Enter your Password',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: (){
                    getRegister();
                  },
                  child: Container(
                    height: 60,
                    width: 200,

                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),  color: Colors.teal,),

                    child: Center(child: Text('Register',style: TextStyle(fontSize: 17),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ) ,
    );
  }
}
