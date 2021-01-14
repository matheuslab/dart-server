import 'package:socket_io/socket_io.dart';
import 'dart:io' show Platform;

main() {
  // Dart server
  List<Map<String, dynamic>> messages = [];
  var io = new Server();

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  io.on('connection', (client) {
    client.emit('previousMessages', messages);
    client.on('sendMessage', (data) {
      messages.add(data);
      client.broadcast.emit('receivedMessage', data);
    });
  });
  io.listen(port);
}