import 'dart:async';
import 'dart:convert';
import 'package:xmpp_stone/src/logger/Log.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;
import 'dart:io';
import 'package:console/console.dart';
import 'package:image/image.dart' as image;
import 'dart:developer';

final String TAG = 'example';

class Openfire {
// List <String>arguments

  static bool openFireLogin(String user, String pass) {
    print(user);
    print(pass);
    bool conectado = false;
    String userAtDomain = user + '@openfiresentvirtual.ddns.net';
    String password = pass;
    print(userAtDomain);
    // Openfire({userAtdomain, password});

    //Log.logLevel = LogLevel.DEBUG;
    //Log.logXmpp = false;
    //Log.d(TAG, 'Type user@domain:');
    // var userAtDomain = 'kayc.kennedy@openfiresentvirtual.ddns.net';
    //Log.d(TAG, 'Type password');
    // var password = 'kayc123';
    var jid = xmpp.Jid.fromFullJid(userAtDomain);

    var account = xmpp.XmppAccountSettings(
        userAtDomain, jid.local, jid.domain, password, 5222,
        resource: 'xmppstone');
    var connection = xmpp.Connection(account);

    connection.connect();

    xmpp.MessagesListener messagesListener = ExampleMessagesListener();
    ExampleConnectionStateChangedListener(connection, messagesListener);
    var presenceManager = xmpp.PresenceManager.getInstance(connection);
    presenceManager.subscriptionStream.listen((streamEvent) {
      if (streamEvent.type == xmpp.SubscriptionEventType.REQUEST) {
        print("opa");
        Log.d(TAG, 'Accepting presence request');
        presenceManager.acceptSubscription(streamEvent.jid);
      }
    });

    // Nome Usuário + "Dominio" do servidor, valor fixo = @laptop-9ujgpavm
    var receiver = 'ghabriel.fiorotti@laptop-9ujgpavm';
    var receiverJid = xmpp.Jid.fromFullJid(receiver);
    var messageHandler = xmpp.MessageHandler.getInstance(connection);
    getConsoleStream().asBroadcastStream().listen((String str) {
      messageHandler.sendMessage(receiverJid, str);
    });

    // Verifica se a conexão foi realizada com sucesso
    if (xmpp.XmppConnectionState != '') {
      conectado = true;
    }
    return conectado = false;
  }
}

class ExampleConnectionStateChangedListener
    implements xmpp.ConnectionStateChangedListener {
  xmpp.Connection _connection;
  xmpp.MessagesListener _messagesListener;

  StreamSubscription<String> subscription;

  ExampleConnectionStateChangedListener(
      xmpp.Connection connection, xmpp.MessagesListener messagesListener) {
    _connection = connection;
    _messagesListener = messagesListener;
    _connection.connectionStateStream.listen(onConnectionStateChanged);
  }

  @override
  void onConnectionStateChanged(xmpp.XmppConnectionState state) {
    print('$state testando conexao');
    if (state == xmpp.XmppConnectionState.Ready) {
      print(TAG);
      print("teste");

      var vCardManager = xmpp.VCardManager(_connection);
      vCardManager.getSelfVCard().then((vCard) {
        if (vCard != null) {
          Log.d(TAG, 'Your info' + vCard.buildXmlString());
        }
      });
      var messageHandler = xmpp.MessageHandler.getInstance(_connection);
      var rosterManager = xmpp.RosterManager.getInstance(_connection);
      messageHandler.messagesStream.listen(_messagesListener.onNewMessage);
      sleep(const Duration(seconds: 1));
      var receiver = 'ghabriel.fiorotti@laptop-9ujgpavm';
      var receiverJid = xmpp.Jid.fromFullJid(receiver);
      rosterManager.addRosterItem(xmpp.Buddy(receiverJid)).then((result) {
        if (result.description != null) {
          Log.d(TAG, 'add roster' + result.description);
        }
      });
      sleep(const Duration(seconds: 1));
      vCardManager.getVCardFor(receiverJid).then((vCard) {
        if (vCard != null) {
          Log.d(TAG, 'Receiver info' + vCard.buildXmlString());
          if (vCard != null && vCard.image != null) {
            var file = File('test456789.jpg')
              ..writeAsBytesSync(image.encodeJpg(vCard.image));
            Log.d(TAG, 'IMAGE SAVED TO: ${file.path}');
          }
        }
      });
      var presenceManager = xmpp.PresenceManager.getInstance(_connection);
      presenceManager.presenceStream.listen(onPresence);
    }
  }

  void onPresence(xmpp.PresenceData event) {
    Log.d(
        TAG,
        'presence Event from ' +
            event.jid.fullJid +
            ' PRESENCE: ' +
            event.showElement.toString());
  }
}

Stream<String> getConsoleStream() {
  return Console.adapter.byteStream().map((bytes) {
    var str = ascii.decode(bytes);
    str = str.substring(0, str.length - 1);
    return str;
  });
}

class ExampleMessagesListener implements xmpp.MessagesListener {
  @override
  void onNewMessage(xmpp.MessageStanza message) {
    if (message.body != null) {
      print('${message.fromJid.userAtDomain}: ${message.body}');
    }
  }
}
