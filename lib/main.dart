import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaichat/model/ApplicationState.dart';
import 'package:zaichat/screens/AuthScreen.dart';
import 'package:zaichat/screens/MessagingScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      child:
        MaterialApp(
          title: 'ZaiChat',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: ZaiChatHomePage(),
        )
    );
}

class ZaiChatHomePage extends StatelessWidget {
  ZaiChatHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) =>
          Scaffold(
            appBar: AppBar(
              title: Text("ZaiChat " + (appState.displayName ?? "")),
              actions: [
                if (appState.email != null)
                  IconButton(
                      onPressed: () {
                        appState.signOut();
                      },
                      icon: Icon(Icons.logout)
                  )
              ],
            ),
            body: (){
              if (appState.email != null)
                return MessagingScreen();
              else
                return AuthScreen();
            }()
          )
      );
    }
  }
