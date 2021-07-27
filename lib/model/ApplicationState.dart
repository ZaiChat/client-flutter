import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class ApplicationState extends ChangeNotifier {

  ApplicationState() {
    _init();
  }

  String? _uid;
  String? get uid => _uid;

  String? _email;
  String? get email => _email;

  String? _displayName;
  String? get displayName => _displayName;

  void _init() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _email = user.email;
        _displayName = user.displayName;
        _uid = user.uid;
      } else {
        _email = null;
        _displayName = null;
        _uid = null;
      }
      notifyListeners();
    });
  }

  void postMessage(String text) async {
    await FirebaseFirestore.instance
        .collection("messages")
        .doc("default")
        .collection("messages")
        .add({
          "uid": this.uid,
          "text": text,
          "createdAt": DateTime.now().millisecondsSinceEpoch
        });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}