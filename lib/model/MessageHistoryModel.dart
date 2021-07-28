
import 'dart:async';
import 'dart:collection';

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
            if (_messages.isEmpty)
              event.docs.forEach((e) {
                final m =
                Message(
                    uuid: randomUuid(),
                    text: e.get("text") as String,
                    author: e.get("uid") as String,
                    dateTime: DateTime.fromMicrosecondsSinceEpoch(
                        e.get("createdAt") as int)
                );
                _messages.addFirst(m);
              });
            else
              event.docChanges.forEach((e) {
                if (e.type == DocumentChangeType.added) {
                  final m = Message(
                      uuid: randomUuid(),
                      text: e.doc.get("text") as String,
                      author: e.doc.get("uid") as String,
                      dateTime: DateTime.fromMicrosecondsSinceEpoch(e.doc.get("createdAt") as int)
                  );
                  _messages.addFirst(m);
                }
              });
            notifyListeners();
          });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  StreamSubscription<dynamic>? _subscription;

  ListQueue<Message> _messages = ListQueue(100);

  int get length => _messages.length;

  Message getByIndex(int index) => _messages.elementAt(index);
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