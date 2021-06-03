import 'package:flutter/material.dart';
import 'package:virtual_feeling/app/helpers/app_colors.dart';
import 'package:virtual_feeling/app/pages/sobre.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Marcus Castilho',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen),
            ),
            accountEmail: Text(
              'marcucastilho@ucl.br',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.darkGreen),
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
