import 'package:flutter/material.dart';
import 'package:virtual_feeling/app/helpers/app_colors.dart';
import 'package:virtual_feeling/app/pages/home_page.dart';
import 'package:virtual_feeling/app/pages/login-page.dart';

import 'app/pages/home_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.tema,
        accentColor: AppColors.lightGrey,
      ),
      home: LoginPage(),
    );
  }
}
