import 'package:clientchat/helper/constants.dart';
import 'package:clientchat/helper/theme.dart';
import 'package:clientchat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Chat extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  final BluetoothConnection connection;
  final int deviceState;

  Chat({this.userName, this.chatRoomId, this.connection, this.deviceState});

  @override
  _ChatState createState() => _ChatState(this.connection, this.deviceState);
}

class _ChatState extends State<Chat> {
  final BluetoothConnection connection;
  int deviceState;

  String ultMensagem = "";

  _ChatState(this.connection, this.deviceState);

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Future<String> analisarMessagem(dados) async {
    var tamanho = dados.length - 1;
    var mensagem = "";
    for (var i = tamanho; i >= 0; i--) {
      if (dados[i].data["sendBy"] == widget.userName) {
        mensagem = dados[i].data["message"];

        break;
      }
    }

    if (mensagem != "" && mensagem == ultMensagem) {
      return "NOTHING";
    } else {
      ultMensagem = mensagem;
    }

    var headers = {
      'Authorization':
          'Basic MjExNi1JN053RkhJeTpsMDZMcW54dVN3c2FQLzgyeHlBY1Y1ekpFM3lHMmlQdg==',
      'Content-Type': 'application/json'
    };

    var request = http.Request(
        'POST', Uri.parse('https://api.gotit.ai/NLU/v1.5/Analyze?&'));

    request.body = json.encode({"T": mensagem, "S": true});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var resp = '';
    if (response.statusCode == 200) {
      resp = await response.stream.bytesToString();
    } else {
      resp = response.reasonPhrase;
    }
    Map valueMap = jsonDecode(resp);
    String sentiment = valueMap['sentiment']['label'];

    if (sentiment == 'POSITIVE') {
      _sendTextMessageToBluetooth('p');
    } else if (sentiment == 'NEGATIVE') {
      _sendTextMessageToBluetooth('n');
    }

    return sentiment;
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          if (snapshot.data.documents[snapshot.data.documents.length - 1]
                  ["sendBy"] ==
              widget.userName) {
            analisarMessagem(snapshot.data.documents)
                .then((value) => print(value));
          }
        }

        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var newIndex = (snapshot.data.documents.length - index) - 1;

                  return MessageTile(
                    message: snapshot.data.documents[newIndex].data["message"],
                    sendByMe: Constants.myName ==
                        snapshot.data.documents[newIndex].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  void _sendTextMessageToBluetooth(String message) async {
    connection.output.add(utf8.encode(message + "\r\n"));
    await connection.output.allSent;

    setState(() {
      deviceState = -1; // device off
    });
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              child: chatMessages(),
              padding: EdgeInsets.only(bottom: 100),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: CustomTheme.backgroundColor,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.message),
                      iconSize: 25.0,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: messageEditingController,
                        onChanged: (value) {},
                        decoration: InputDecoration.collapsed(
                          hintText: 'Digite sua mensagem...',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 25.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          addMessage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xFF56E8B3), const Color(0xFF56E8B3)]
                  : [const Color(0xFF56E8B3), const Color(0xFF56E8B3)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: CustomTheme.textColor,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
