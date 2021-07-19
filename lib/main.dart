import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZaiChat',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ZaiChatHomePage(),
    );
  }
}

class ZaiChatHomePage extends StatelessWidget {
  ZaiChatHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ZaiChat"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container()
            ),
            MessageInput()
          ],
        ),
      ),
    );
  }
}

class MessageInput extends StatefulWidget {


  @override
  State createState() {
    return _MessageInputState();
  }
}

class _MessageInputState extends State<MessageInput> {

  final _controller = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _controller.addListener((){
      setState(() {});
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    await showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
          title: Text("Message sent"),
          content: Text(_controller.text)
        )
    );
    _controller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) { _sendMessage(); },
                  decoration: const InputDecoration(
                    hintText: 'Message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_controller.text.isNotEmpty)
                TextButton(
                    onPressed: _sendMessage,
                    child: Text("Send")
                )
            ],
          ),
        ),
      );
  }
}