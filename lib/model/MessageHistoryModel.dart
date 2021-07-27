
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:zaichat/util.dart';

class MessageHistoryModel extends ChangeNotifier {

  MessageHistoryModel() {
    _subscription =
      FirebaseFirestore.instance
          .collection("messages")
          .doc("default")
          .collection("messages")
          .orderBy("createdAt")
          .limitToLast(100)
          .snapshots()
          .listen((event) {
            final all = event.docs.map((e) =>
              Message(
                uuid: randomUuid(),
                text: e.get("text") as String,
                author: "default",
                dateTime: DateTime.fromMicrosecondsSinceEpoch(e.get("createdAt") as int)
              )
            );
            event.docChanges.forEach((e) {
              if (e.type == DocumentChangeType.added) {
                final m = Message(
                    uuid: randomUuid(),
                    text: e.doc.get("text") as String,
                    author: "default",
                    dateTime: DateTime.fromMicrosecondsSinceEpoch(e.doc.get("createdAt") as int)
                );
                _messages.add(m);
              }
            });
            if (_messages.isEmpty && all.isNotEmpty) {
              _messages.addAll(all);
            }
            notifyListeners();
          });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  StreamSubscription<dynamic>? _subscription;

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

  Message({
    required this.uuid,
    required this.text,
    required this.author,
    required this.dateTime
  });
}