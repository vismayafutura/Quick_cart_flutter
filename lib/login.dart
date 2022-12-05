import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_shop/bottomnav.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_shop/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';
import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var username = TextEditingController();
  var password = TextEditingController();

  Future<void> getData() async {
    print(fkey.currentState!.validate());
    if(fkey.currentState!.validate()) {
      var data = {
        "username": username.text,
        "password": password.text,
      };

      var res = await post(Uri.parse('${Con.url}login.php'), body: data);
      print(res.body);
      if (res.statusCode == 200) {
        var message = jsonDecode(res.body)["message"];
        var id = jsonDecode(res.body)["login_id"];

        if (message == "User Successfully LoggedIn") {
          SharedPreferences spref = await SharedPreferences.getInstance();
          spref.setString('cus_id', id);
          Fluttertoast.showToast(msg: 'Successfully Login');
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MyNavigationBar();
            },
          ));
        } else {
          Fluttertoast.showToast(msg: 'Invalid username or password !');
        }
      }
    }
  }
  var fkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: fkey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Lottie.asset('assets/gif/login.json'),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 30, left: 50, right: 50, top: 50),
                  child: TextFormField(
                    validator: (v){
                      if(v!.isEmpty){
                        return 'This field is required';
                      }
                    },
                    controller: username,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        hintText: 'Username',
                        labelText: 'Enter your username',
                        border: OutlineInputBorder(),
                        focusColor: Colors.orange),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    left: 50,
                    right: 50,
                  ),
                  child: TextFormField(
                    validator: (v){
                      if(v!.isEmpty){
                        return 'This field is required';
                      }
                    },
                    controller: password,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Enter your password',
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: InkWell(
                    onTap: () {
                      getData();
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return MyNavigationBar();
                      // },));
                    },
                    child: Container(
                        child: Center(child: Text('LOGIN')),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.teal,
                        ),
                        height: 50,
                        width: 300,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap:  (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Register();
                        },));
                      },

                    child: Text('Create new account?')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
