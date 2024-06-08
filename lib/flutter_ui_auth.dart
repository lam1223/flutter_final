import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';




class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final auth = FirebaseAuth.instance;
  final province =[EmailAuthProvider()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: auth.currentUser == null?"/sign-in": "/profile",
      routes: {
        "/sign-in":(context){
          return SignInScreen(
            providers: province,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.restorablePushNamed(context, "/profile");
               })

            ],
          );
        },
        "/profile":(context){
          return  Scaffold(
             appBar: AppBar(
          title: Text("flutter_ui-POVINCE"),
          ),
          );
        }
      },
  
    );
  }
}