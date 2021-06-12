import 'package:clientchat/helper/helperfunctions.dart';
import 'package:clientchat/helper/theme.dart';
import 'package:clientchat/views/sobre.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  Future<String> name = HelperFunctions.getUserEmailSharedPreference();
  Future<String> email = HelperFunctions.getUserEmailSharedPreference();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              '',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.colorAccent),
            ),
            accountEmail: Text(
              '',
              style: TextStyle(fontWeight: FontWeight.bold, color: CustomTheme.colorAccent),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre o APP'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Sobre(),
                )),
          )
        ],
      ),
    );
  }
}
