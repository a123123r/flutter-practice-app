
// Splash Screen
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var checkLogin = pref.getBool('login');
      print("checkLogin: $checkLogin");

      if (checkLogin == null || checkLogin == false  ) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyHomePage(title: "title")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlutterLogo(),
      ),
    );
  }
}

