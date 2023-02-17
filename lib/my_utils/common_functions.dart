import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'my_color.dart';

class CommonFunctions {

   void isLogin(BuildContext context){

      final auth= FirebaseAuth.instance;
      final currantUser=auth.currentUser;

      if (currantUser!=null) {
         Timer.periodic(Duration(seconds: 3), (timer) {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => DefaultMainScreen()));
         });
      }
   }
}

void toast(String msg) {
   Fluttertoast.showToast(
       msg: msg,
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
       timeInSecForIosWeb: 1,
       backgroundColor: MyColor.lightBlackColorForToast,
       textColor: Colors.white,
       fontSize: 16.0);
}