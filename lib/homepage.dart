import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_shop/update.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> getData()  async {
    SharedPreferences spref=await SharedPreferences.getInstance();
    var sp = spref.getString('cus_id');
    print(sp);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Profile(id: sp);
    },));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          
          Lottie.asset('assets/gif/home.json'),
          // ListView.builder(
          //     itemCount: 1,
          //     itemBuilder: (context, index) {
                 Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                          radius: 40.0,
                          child: Icon(Icons.account_circle,color: Colors.white,size: 40,),
                          backgroundColor: Colors.teal.withOpacity(0.4)),
                      title: const Text(
                        "UserName",
                      ),
                      subtitle: const Text("This is SubTitle"),
                      trailing: IconButton(
                          onPressed: () {
                            getData();
                          },
                          icon:const Icon(Icons.edit)),

                    ),
                  ),

                 ),

          Card(
            elevation: 3.0,
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 5.0, vertical: 10.0),
              child: ListTile(
                leading: CircleAvatar(
                    radius: 40.0,
                    child: Icon(Icons.shopping_cart,color: Colors.white,size: 30,),
                    backgroundColor: Colors.teal.withOpacity(0.4)),
                title: const Text(
                  "View My Cart",
                ),
                // subtitle: const Text(""),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Cart();
                      },));
                    },
                    icon:const Icon(Icons.arrow_forward_ios_outlined)),

              ),
            ),

          ),

        ]),
    );
  }
}
