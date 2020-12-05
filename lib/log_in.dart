import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/chat.dart';

import 'main.dart';

class LogIn extends StatefulWidget {

  static const String id ="LOG_IN";

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: email, password: password))
        .user;

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Chatting(user : user);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: "logo",
              child: Container(
                width: 120,
                child: Image.asset("assets/images/chat.png"),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          TextField(
            onChanged: (value) => email=value,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter Your Email",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            onChanged: (value) => password=value,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter Your password",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          CustomButton(
            callback: () async {
              await loginUser();
            },
            text: "LogIn",
          )
        ],
      ),
    );

  }

}