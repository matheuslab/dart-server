import 'package:socket_io/socket_io.dart';
import 'dart:io' show Platform;
import 'chat.dart';

void main() {
  // Dart server
  final Map<String, List<Message>> chats = {
    'Alberto': [],
    'Bruno': [],
    'Carlos': [],
  };

  var io = new Server();

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 3000 : int.parse(portEnv);

  io.on('connection', (client) {
    print('Client connected');
    final chatsList = chats.entries.map((e) => Chat(e.key, e.value).toMap()).toList();
    client.emit(
      'chats',
      chatsList,
    );
    client.on('getPreviousMessages', (data) {
      print(data);
      final chatId = data['chatId'];
      client.emit('previousMessages',
          chats[chatId].map((message) => message.toMap()).toList());
    });
    client.on('sendMessage', (data) {
      print('message data is ${data['message']}');
      final message = Message.fromMap(data['message']);
      chats[message.chatId].add(message);
      client.broadcast.emit('receivedMessage', message.toMap());
      final chatsList = chats.entries.map((e) => Chat(e.key, e.value).toMap()).toList();
      client.broadcast.emit('chats', chatsList);
    });
  });


  io.listen(port);
}