
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<univeristyModel> universityList = [];
  List<univeristyModel> punjabList = [];
  bool loading = false;

  getData() async {
    setState(() {
      loading = true;
    });
    final responce = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=pakistan'));
    log(responce.statusCode.toString());
    if (responce.statusCode == 200) {
      List data = jsonDecode(responce.body).toList();

      for (int i = 0; i < data.length; i++) {
        univeristyModel uniModel = univeristyModel(
          countryName: data[i]['country'].toString(),
          countryCode: data[i]['alpha_two_code'].toString(),
          provinceName: data[i]['state-province'].toString(),
          universityName: data[i]['name'].toString(),
        );
        universityList.add(uniModel);

         punjabList = universityList.where((element) =>
            element.provinceName.toString() == "Panjab"  ).toList();
      }
      setState(() {
        loading = false;
      });
    }
  }

  logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      var token = pref.getString('mytoken');
      print("Token: $token");
      final responce = await http.post(
        Uri.parse('http://adeegmarket.zamindarestate.com/api/v1/logout'),
        headers: {
          'Content-Type': "application/json",
          'Authorization': "Bearer $token"
        },
      );

      print(responce.statusCode);
      print("Body: ${responce.body}");

      pref.setString('token', "null");
      pref.setBool('login', false);
      Navigator.of(context).pushAndRemoveUntil((MaterialPageRoute(builder: (context) => Login())), (route) => false);
    } catch (e) {
      print("Catch Error________________");
      print(e.toString());
    }
  }
  
  List<univeristyModel> filterList = [];
TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              ElevatedButton(onPressed: (){
                getData();
              }, child: Text("Get Data")),

              TextField(
                controller: controller,
                onChanged: (e){
              setState(() {
                filterList = universityList.where((univeristyModel element) =>
                    element.provinceName.toString().toUpperCase()
                        .contains(controller.text.toString().toUpperCase())
                    ||
                    element.universityName.toString().toUpperCase()
                    .contains(controller.text.toString().toUpperCase())
                
                ).toList() ;
              });
                  
                },
              ),
              loading == true
                  ? Text("Loading...")
                  : 
              filterList.length >0 ?
              ListView.builder(
                shrinkWrap: true,
                itemCount:  filterList.length,
                itemBuilder: (context, i) {
                  return Text("${filterList[i].provinceName.toString()} :   ${filterList[i].universityName.toString()}");
                },
              ):
              
              ListView.builder(
                shrinkWrap: true,
                itemCount: punjabList.length,
                itemBuilder: (context, i) {
                  return Text("${punjabList[i].provinceName.toString()} :   ${punjabList[i].universityName.toString()}");
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          logout();
          // getData();
        },
        tooltip: 'Increment',
        label: Text("Logout"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

