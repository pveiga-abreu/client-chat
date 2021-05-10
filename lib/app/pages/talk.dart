import 'package:flutter/material.dart';
import 'package:virtual_feeling/app/widgets/appbar/app_bar_widget.dart';

class Talk extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return StateTalk();
  }
}

class StateTalk extends State<Talk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF439E7D),
        child: Icon(Icons.message_outlined),
        onPressed: () {
        },
      ),
    );
  }
}
