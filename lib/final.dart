import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_shop/bottomnav.dart';

class Final extends StatefulWidget {
  const Final({Key? key}) : super(key: key);

  @override
  State<Final> createState() => _FinalState();
}

class _FinalState extends State<Final> {

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds:2)).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyNavigationBar();
      },));
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: Container(
            height: 500,
              width: 500,
              child: Lottie.asset('assets/gif/confirm.json')
          ),
        ),
    );
  }
}
