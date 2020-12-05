import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatting extends StatefulWidget {
  static const String id = "CHATTING";
  final FirebaseUser user;

  Chatting({this.user});

  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if (controller.text.length > 0) {
      await firestore.collection("messages").add({
         'from': widget.user.email,
         'text': controller.text,
         'date': DateTime.now().toIso8601String().toString()
      });
      controller.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 3000),
          curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: "logo",
          child: Container(
            height: 40,
            child: Image.asset("assets/images/chat.png"),
          ),
        ),
        title: Text("My Chat Room"),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                auth.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // ignore: missing_required_param
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("messages").orderBy("date").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((document) => Message(
                          me: widget.user.email == document.data()["from"],
                          from: document.data()["from"],
                          text: document.data()['text']))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: [
                      //to bind messages into listview
                      ...messages
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter Your Message",
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => callback(),
                  )),
                  SendButton(text: "send", callback: callback),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  SendButton({this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final bool me;
  final String from;
  final String text;

  const Message({this.me, this.from, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(from),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10),
            elevation: 6,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  text,
                )),
          ),
        ],
      ),
    );
  }
}
