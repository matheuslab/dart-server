class Message {
  final String chatId;
  final String sender;
  final String recipient;
  final String message;
  Message(this.chatId, this.sender, this.recipient, this.message);
  Map<String, dynamic> toMap() => {
    'chatId': chatId,
    'sender': sender,
    'recipient': recipient,
    'message': message,
  };
  factory Message.fromMap(Map<String, dynamic> map) =>
      Message(map['chatId'], map['sender'], map['recipient'], map['message']);
  @override
  String toString() {
    return 'Message{chatId: $chatId, sender: $sender, recipient: $recipient, message: $message}';
  }
}
class Chat {
  final String chatId;
  final List<Message> _messages;
  List<Message> get messages => List.unmodifiable(_messages.reversed);
  Chat(this.chatId, this._messages);
  void addMessage(Message message) => _messages.add(message);
  factory Chat.fromMap(Map<String, dynamic> map) {
    final List<dynamic> messages = map['messages'];
    return Chat(
      map['chatId'],
      messages.map<Message>((map) => Message.fromMap(map)).toList(),
    );
  }
  Map<String, dynamic> toMap() => {
    'chatId': chatId,
    'messages': _messages.map((message) => message.toMap()).toList(),
  };
}