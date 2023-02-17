import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_login_screen.dart';

class FirebaseSignUpScreen extends StatefulWidget {
  const FirebaseSignUpScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseSignUpScreen> createState() => _FirebaseSignUpScreenState();
}

class _FirebaseSignUpScreenState extends State<FirebaseSignUpScreen> {
  final _tag = "SignUpScreen";
  bool cbValue = false;

  final _keyForm = GlobalKey<FormState>();

  bool isVisibleEmailError = false;
  bool isVisiblePasswordError = false;

  var _emailData = "";
  var _passwordData = "";

  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    statusBarColorChange();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
                child: Form(
                  key: _keyForm,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    actionBar(),
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Text("Create Account",
                          style: GoogleFonts.ptSerif(fontSize: 30)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                          "Enter your Name, Email and Password \nfor Sign up.",
                          style: GoogleFonts.ptSerif(
                              fontSize: 16, color: Colors.black45)),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Enter email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            setState(() {
                              isVisibleEmailError = true;
                            });
                          } else {
                            setState(() {
                              isVisibleEmailError = false;
                            });
                            _emailData = value.toString();
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: isVisibleEmailError,
                      child: Container(
                        margin: EdgeInsets.only(left: 12, right: 10),
                        child: Text("Please enter email",
                            style: GoogleFonts.ptSerif(
                                fontSize: 12, color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        obscureText: false,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: "Enter password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              isVisiblePasswordError = true;
                            });
                          } else {
                            setState(() {
                              isVisiblePasswordError = false;
                            });
                            _passwordData = value.toString();
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: isVisiblePasswordError,
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "Please enter password",
                          style: GoogleFonts.ptSerif(
                              fontSize: 12, color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Checkbox(
                            value: cbValue,
                            onChanged: (value) {
                              setState(() {
                                this.cbValue = value!;
                              });
                            },
                          ),
                          Text(
                              "By checking you agree to our teams & \nconditions",
                              style: GoogleFonts.ptSerif())
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          final isValid = _keyForm.currentState!.validate();
                          if (!isValid) {
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          // var signUpData = SignUpDataPassModel(name: _nameData,mail: _emailData,pass: _passwordData);

                          await _auth.createUserWithEmailAndPassword(
                                  email: _emailData, password: _passwordData)
                              .then((value) {
                            debugPrint("Success");
                            Fluttertoast.showToast(
                                msg: "Success",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            setState(() {
                              isLoading = false;
                            });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirebaseLoginScreen()));
                          }).onError((error, stackTrace) {
                            debugPrint("Fail");
                            Fluttertoast.showToast(
                                msg: "Fail",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            setState(() {
                              isLoading = false;
                            });
                          });

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(signUpData: signUpData)));
                        },
                        child: isLoading
                            ? CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              )
                            : Text(
                                "SIGN UP",
                                style: GoogleFonts.ptSerif(
                                    fontSize: 17, color: Colors.white),
                              ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),


                  ]),
            ),
          ),
        ))));
  }

  void statusBarColorChange() => SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black12));

  actionBar() => Container(
      width: double.infinity,
      height: 40.0,
      margin: const EdgeInsets.only(top: 15),
      child: Stack(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: Text(_tag,
                  style: GoogleFonts.ptSerif(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ));


}
