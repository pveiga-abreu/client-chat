import 'package:flutter/material.dart';
import 'package:virtual_feeling/app/pages/talk.dart';


void main() => runApp(VirtualFeeling());

class VirtualFeeling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Talk(),
      ),
    );
  }
}


