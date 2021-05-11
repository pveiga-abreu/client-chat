import 'package:virtual_feeling/app/models/user_model.dart';

class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Current User',
  imageUrl: 'assets/images/greg.jpg',
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
List<User> favorites = [ghabriel, paulo, rusley, pedro];

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: ghabriel,
    time: '5:30 PM',
    text: 'Cadê os bebê cachorro ?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: rusley,
    time: '4:30 PM',
    text: 'Fez a eso da penha ?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: pedro,
    time: '3:30 PM',
    text: 'man, ta no git',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: guilherme,
    time: '1:30 PM',
    text: 'ele usa só table kkk, bixo é ruim',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: paulo,
    time: '10:30 AM',
    text: 'to fazendo um complo pra tia fazer café sem açucar',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: diego,
    time: '10:56 AM',
    text: 'Fala dev, siga a rocket no discord.',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: filipe,
    time: '12:34 AM',
    text: 'Saiu vídeo novo no canal, corre lá...',
    isLiked: false,
    unread: false,
  )
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: paulo,
    time: '3:15 PM',
    text: 'deixa eu ver na planilha aqui..',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:45 PM',
    text: 'ein, quem joga hoje no pong ?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '1:30 PM',
    text: 'kkkk deixa com o pai',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: paulo,
    time: '10:30 PM',
    text: 'to fazendo um complo pra tia fazer café sem açucar',
    isLiked: true,
    unread: true,
  ),
];
