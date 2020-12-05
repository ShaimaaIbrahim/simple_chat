import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_chat/registeration.dart' ;
import 'package:simple_chat/registeration.dart';
import 'package:simple_chat/chat.dart';
import 'package:simple_chat/log_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
        initialRoute: MyHomePage.id,
     routes: {
        MyHomePage.id : (context ) => MyHomePage(),
        Regesteration.id: (context) =>Regesteration(),
        Chatting.id : (context ) => Chatting(),
        LogIn.id: (context) =>LogIn(),
     },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  static const String id ="HOME_SCREEN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "logo",
                child: Container(
                  width: 100,
                  child: Image.asset("assets/images/chat.png"),
                ),
              ),
              Text("My Chat", style: TextStyle(fontSize: 40)),
            ],
          ),
          SizedBox(height: 50,),
          CustomButton(
            callback: (){
              Navigator.of(context).pushNamed(LogIn.id);
            },
            text: "Log In",
          ),
          SizedBox(height: 10,),
          CustomButton(
            callback: (){
              Navigator.of(context).pushNamed(Regesteration.id);

            },
            text: "Register",
          ),
        ],
      ),
    );
  }
}


class CustomButton extends StatelessWidget{

  final VoidCallback callback;
  final String text;

 const CustomButton({this.callback, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.all(8),
    child: Material(
     color : Colors.blueGrey,
     elevation: 6,
     borderRadius: BorderRadius.circular(30),
     child: MaterialButton(
         onPressed: callback,
         minWidth : 20,
         height: 45,
         child: Text(text),
     ),
    ),
    );
  }

}
