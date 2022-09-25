

//Login Screen
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  login() async {
    try {
      final responce = await http.post(
          Uri.parse('http://adeegmarket.zamindarestate.com/api/v1/login'),
          headers: {
            'Content-Type': "application/json",
          },
          body: jsonEncode(
              {'email': 'customer@example.com', 'password': '123456'}));

      print(responce.statusCode);

      if (responce.statusCode == 200) {
        print("Body: ${responce.body}");
        var data = jsonDecode(responce.body);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('mytoken', data['token'].toString());
        preferences.setBool('login', true);
        log("Data Save");

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyHomePage(title: "Home")));
      }
    } catch (e) {
      print("Catch Error________________");
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              login();
            },
            child: Text("Login Button")),
      ),
    );
  }
}

