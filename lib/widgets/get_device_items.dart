import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class GetDeviceItems {
  static List<DropdownMenuItem<BluetoothDevice>> getDeviceItems(_devicesList) {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(
            device.name,
            overflow: TextOverflow.ellipsis,
          ),
          value: device,
        ));
      });
    }
    return items;
  }
}
