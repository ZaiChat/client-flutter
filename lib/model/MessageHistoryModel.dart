
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class MessageHistoryModel extends ChangeNotifier {

  List<Message> _messages = List.empty(growable: true);

  int get length => _messages.length;

  Message getByIndex(int index) => _messages[index];

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
}

class Message {

  final UuidValue uuid;
  final String text;
  final String author;
  final DateTime dateTime;

  const Message({
    required this.uuid,
    required this.text,
    required this.author,
    required this.dateTime
  });
}