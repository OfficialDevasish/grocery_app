import 'package:flutter/material.dart';

class FirebaseSignupLoginScreen extends StatefulWidget {
  const FirebaseSignupLoginScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseSignupLoginScreen> createState() => _FirebaseSignupLoginScreenState();
}

class _FirebaseSignupLoginScreenState extends State<FirebaseSignupLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Signup & Login Firebase')),
        body: Container(
          width: double.infinity,

        ),
      ),
    );
  }
}
