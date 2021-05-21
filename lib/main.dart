import 'package:flutter/material.dart';
import 'package:tela_login/pages/login.pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentimentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      // home: LoginPage(),
      initialRoute: '/login',
      routes :{
        '/login' : (BuildContext context) => LoginPage()

      }
    );
  }
}
