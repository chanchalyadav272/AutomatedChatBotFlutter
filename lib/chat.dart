import 'package:chatbot/chat.dart';
import 'package:chatbot/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Message> _messages = <Message>[];
  final TextEditingController _textController = TextEditingController();

  Future<void> getChatbotReply(String userReply) async {
    print("You: " + userReply);
    _textController.clear();
    Message userQuery = Message(
      index: 1,
      text: userReply,
    );

    setState(() {
      _messages.insert(0, userQuery);
    });

    var response = await http.get(Uri.parse(
        "http://api.brainshop.ai/get?bid=167640&key=CHi7zETXqF9tNXT6&uid=chanchalyadav272&msg=userReply"));
    var data = jsonDecode(response.body);
    print("Jarvis: " + data["cnt"]);
    // print(data["cnt"]);
    Message botResponse = Message(index: 2, text: data["cnt"]);

    setState(() {
      _messages.insert(0, botResponse);
    });

    // return data["cnt"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.02,
              left: 8,
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    autofocus: true,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                    controller: _textController,
                    onSubmitted: getChatbotReply,
                    decoration: InputDecoration.collapsed(
                        hintText: "Send a message",
                        hintStyle: TextStyle(fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => getChatbotReply(_textController.text),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final int index;
  final String text;
  const Message({Key? key, required this.index, required this.text})
      : super(key: key);

  List<Widget> jarvisMessage(context) {
    return <Widget>[
      new Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 50),
              padding: EdgeInsets.all(8),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white54),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 50),
              padding: EdgeInsets.all(8),
              child: Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white54),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: index % 2 == 0 ? jarvisMessage(context) : myMessage(context),
      ),
    );


  }
}
