import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaichat/model/ApplicationState.dart';
import 'package:zaichat/model/MessageHistoryModel.dart';

import '../util.dart';

class MessagingScreen extends StatelessWidget {

  final String myUid;

  MessagingScreen(this.myUid);

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider(
          create: (_) => MessageHistoryModel(),
          child:
          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: MessageHistory(myUid)
                ),
                MessageInput()
              ],
            ),
          )
      );
}

class MessageHistory extends StatelessWidget {

  final String myUid;

  MessageHistory(this.myUid);

  @override
  Widget build(BuildContext context) =>
      Consumer<MessageHistoryModel>(
          builder: (context, messageHistory, _) =>
              ListView.separated(
                reverse: true,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  final message = messageHistory.getByIndex(index);
                  return MessageRow(message, message.author == myUid);
                },
                itemCount: messageHistory.length,
              )
      );
}

class MessageRow extends StatelessWidget {

  final Message message;
  final bool selfMessage;

  MessageRow(this.message, this.selfMessage);

  @override
  Widget build(BuildContext context) =>
      Row(
        textDirection: selfMessage ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text(message.author.characters.first.toUpperCase()))
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(message.text)
          ),
        ],
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

  final _focusNode = FocusNode();

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
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = Message(
        uuid: randomUuid(),
        text: _controller.text,
        author: "Vitaly",
        dateTime: DateTime.now()
    );
    // Provider
    //   .of<MessageHistoryModel>(context, listen: false)
    //   .addMessage(message);
    Provider
        .of<ApplicationState>(context, listen: false)
        .postMessage(message.text);
    _controller.text = "";
    _focusNode.requestFocus();
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
                  autofocus: true,
                  focusNode: _focusNode,
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
