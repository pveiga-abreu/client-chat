import 'package:virtual_feeling/app/models/user_model.dart';

class Message {
  final User sender;
  final User recipient;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  bool unread;

  Message({
    this.sender,
    this.recipient,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });

  void readMessage(Message message) {
    message.unread = false;
  }
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Current User',
  imageUrl: 'https://avatars.githubusercontent.com/u/49495564?v=4',
);

// USERS
final User paulo = User(
  id: 1,
  name: 'Paulo Victor',
  imageUrl: 'https://avatars.githubusercontent.com/u/50430192?v=4',
);
final User ghabriel = User(
  id: 2,
  name: 'Ghabriel',
  imageUrl: 'https://avatars.githubusercontent.com/u/50412408?v=4',
);
final User guilherme = User(
  id: 3,
  name: 'Guilherme Kunsh',
  imageUrl: 'https://avatars.githubusercontent.com/u/75049024?v=4',
);
final User pedro = User(
  id: 4,
  name: 'Pedro',
  imageUrl: 'https://avatars.githubusercontent.com/u/29384810?v=4',
);
final User rusley = User(
  id: 5,
  name: 'Rusley',
  imageUrl: 'https://avatars.githubusercontent.com/u/14168622?v=4',
);
final User diego = User(
  id: 6,
  name: 'Diego Fernandes',
  imageUrl: 'https://avatars.githubusercontent.com/u/2254731?v=4',
);
final User filipe = User(
  id: 7,
  name: 'Filipe Deschamps',
  imageUrl: 'https://avatars.githubusercontent.com/u/4248081?v=4',
);

// FAVORITE CONTACTS
List<User> contacts = [
  ghabriel,
  paulo,
  rusley,
  pedro,
  guilherme,
  diego,
  filipe
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: paulo,
    recipient: currentUser,
    time: '3:15 PM',
    text: 'deixa eu ver na planilha aqui..',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: currentUser,
    recipient: paulo,
    time: '2:45 PM',
    text: 'ein, quem joga hoje no pong ?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: currentUser,
    recipient: paulo,
    time: '1:30 PM',
    text: 'kkkk deixa com o pai',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: paulo,
    recipient: currentUser,
    time: '10:30 PM',
    text: 'to fazendo um complo pra tia fazer café sem açucar',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    recipient: ghabriel,
    time: '10:30 PM',
    text: 'to fazendo ',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: ghabriel,
    recipient: currentUser,
    time: '10:30 PM',
    text: 'fez o projeto ?',
    isLiked: true,
    unread: true,
  ),
];
