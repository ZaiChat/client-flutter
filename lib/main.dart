import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaichat/model/MessageHIstory.dart';
import 'package:zaichat/util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    ChangeNotifierProvider(
      create: (_) => MessageHistoryModel(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("ZaiChat"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: MessageHistory()
            ),
            MessageInput()
          ],
        ),
      ),
    );
  }
}

class MessageHistory extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    Consumer<MessageHistoryModel>(
      builder: (context, messageHistory, _) =>
        ListView.separated(
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            final message = messageHistory.getByIndex(index);
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(message.text, key: ValueKey(message.uuid))
              )
            );
          },
          itemCount: messageHistory.length,
        )
    );
}

class MessageInput extends StatefulWidget {

  @override
  State createState() {
    return _MessageInputState();
  }
}

class _MessageInputState extends State<MessageInput> {

  final _controller = TextEditingController(text: "");

  var _showSendButton = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener((){
      if (_controller.text.isNotEmpty != _showSendButton)
        setState(() {
          _showSendButton = _controller.text.isNotEmpty;
        });
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = Message(
      uuid: randomUuid(),
      text: _controller.text,
      author: "Vitaly",
      dateTime: DateTime.now()
    );
    Provider
      .of<MessageHistoryModel>(context, listen: false)
      .addMessage(message);
    _controller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5,
              offset: Offset(0.0, 2)
            )
          ]
        ),
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
              if (_showSendButton)
                ElevatedButton(
                    onPressed: _sendMessage,
                    child: Text("Send")
                )
            ],
          ),
        ),
      );
  }
}