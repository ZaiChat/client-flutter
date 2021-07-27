import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class ApplicationState extends ChangeNotifier {

  ApplicationState() {
    _init();
  }

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
      } else {
        _email = null;
        _displayName = null;
      }
      notifyListeners();
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}