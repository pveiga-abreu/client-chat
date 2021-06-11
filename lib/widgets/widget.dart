import 'package:clientchat/helper/theme.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'Procurar Amigos',
      style: TextStyle(color: CustomTheme.textColor, fontSize: 18),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: CustomTheme.textColorGreen),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: CustomTheme.textColorGreen)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: CustomTheme.textColorGreen)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: CustomTheme.textColor, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: CustomTheme.backgroundColor, fontSize: 17);
}
