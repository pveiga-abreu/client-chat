import 'package:clientchat/helper/authenticate.dart';
import 'package:clientchat/helper/constants.dart';
import 'package:clientchat/helper/helperfunctions.dart';
import 'package:clientchat/helper/theme.dart';
import 'package:clientchat/services/auth.dart';
import 'package:clientchat/services/database.dart';
import 'package:clientchat/views/chat.dart';
import 'package:clientchat/views/search.dart';
import 'package:clientchat/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:clientchat/widgets/get_device_items.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;

  int _deviceState;

  bool isDisconnecting = false;

  final textFieldController = TextEditingController();

  final testLEDONFieldController = TextEditingController();
  final testLEDOFFFieldController = TextEditingController();

  final upFieldController = TextEditingController();
  final downFieldController = TextEditingController();
  final rightFieldController = TextEditingController();
  final leftFieldController = TextEditingController();

  bool checkIfPressing = false;

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  Stream chatRooms;

  // Botão na App Bar que faz o refresh nos dispositivos encontrados
  Widget refreshDevices() {
    return Column(
      children: [
        FlatButton.icon(
          icon: Icon(
            Icons.refresh,
            color: CustomTheme.textColor,
          ),
          label: Text(
            "",
            style: TextStyle(
              color: CustomTheme.textColor,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          splashColor: CustomTheme.colorAccent,
          onPressed: () async {
            // So, that when new devices are paired
            // while the app is running, user can refresh
            // the paired devices list.
            await getPairedDevices().then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Device list refreshed')));
            });
          },
        ),
      ],
    );
  }

  // Switch de ligar/desligar bluetooth
  // seletor do dispositivo e botão de conexão
  Widget bluetoothConfig() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], 
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(children: <Widget>[
        Visibility(
          visible:
              _isButtonUnavailable && _bluetoothState == BluetoothState.STATE_ON,
          child: LinearProgressIndicator(
            backgroundColor: CustomTheme.textColorGreen,
            valueColor: AlwaysStoppedAnimation<Color>(CustomTheme.colorAccent),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Habilitar Bluetooth',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.textColorGreen,
                    fontSize: 16,
                  ),
                ),
              ),
              Switch(
                value: _bluetoothState.isEnabled,
                onChanged: (bool value) {
                  future() async {
                    if (value) {
                      await FlutterBluetoothSerial.instance.requestEnable();
                    } else {
                      await FlutterBluetoothSerial.instance.requestDisable();
                    }

                    await getPairedDevices();
                    _isButtonUnavailable = false;

                    if (_connected) {
                      _disconnect();
                    }
                  }

                  future().then((_) {
                    setState(() {});
                  });
                },
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Dispositivo:',
                style: TextStyle(
                  color: CustomTheme.textColorGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                width: 100,
                child: DropdownButton(
                  isExpanded: true,
                  style: const TextStyle(color: Colors.black),
                  items: GetDeviceItems.getDeviceItems(_devicesList),
                  onChanged: (value) => setState(() => _device = value),
                  value: _devicesList.isNotEmpty ? _device : null,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        CustomTheme.textColorGreen)),
                onPressed: _isButtonUnavailable
                    ? null
                    : _connected
                        ? _disconnect
                        : _connect,
                child: Text(_connected ? 'Desconectar' : 'Conectar'),
              ),
            ],
          ),
        ),
      ])),
    );
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                    connection: connection,
                    deviceState: _deviceState,
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    BluetoothHelper.enableBluetooth(_bluetoothState, getPairedDevices);

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text(
          'Sentimento Virtual',
          style: TextStyle(color: CustomTheme.textColor, fontSize: 18),
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          refreshDevices(),
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
          child: ListView(children: <Widget>[
        bluetoothConfig(),
        chatRoomsList(),
      ])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Dispositivo não selecionado')));
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Dispositivo conectado')));

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _deviceState = 0;
    });

    await connection.close();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Dispositivo desconectado')));
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  void _sendTextMessageToBluetooth(String message) async {
    connection.output.add(utf8.encode(message + "\r\n"));
    await connection.output.allSent;

    setState(() {
      _deviceState = -1; // device off
    });
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final BluetoothConnection connection;
  final int deviceState;

  ChatRoomsTile(
      {this.userName,
      @required this.chatRoomId,
      this.connection,
      this.deviceState});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      userName: userName,
                      chatRoomId: chatRoomId,
                      connection: connection,
                      deviceState: deviceState,
                    )));
      },
      child: Container(
        color: CustomTheme.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: CustomTheme.textColorGreen,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: CustomTheme.textColor,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
