import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/my_utils/my_color.dart';
import '../my_utils/common_functions.dart';

class FirebaseLoginScreen extends StatefulWidget {
  const FirebaseLoginScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseLoginScreen> createState() => _FirebaseLoginScreenState();
}

class _FirebaseLoginScreenState extends State<FirebaseLoginScreen> {

  final _tag = "LoginScreen";
  final _formKey = GlobalKey<FormState>();

  bool cbValue = false;

  bool isVisibleEmailError = false;
  bool isVisiblePasswordError = false;

  var _emailData = "";
  var _passwordData = "";

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SafeArea(
                child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                              Container(
                                width: double.infinity,
                                child: Center(
                                  child: Text(_tag,
                                      style: GoogleFonts.cormorantGaramond(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          )),
                      const SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text("Login Account",
                            style: GoogleFonts.ptSerif(fontSize: 30)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                            "Enter your Email and Password \nfor Login.",
                            style: GoogleFonts.ptSerif(
                                fontSize: 16, color: Colors.black45)),
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
                        width: double.infinity,
                        height: 50,
                        margin:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            final isValid = _formKey.currentState!.validate();
                            if (!isValid) {
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            _auth.signInWithEmailAndPassword(
                                    email: _emailData, password: _passwordData)
                                .then((value) {
                              debugPrint("Success");
                              toast("Success");

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             DefaultMainScreen()));

                              setState(() {
                                isLoading = false;
                              });

                            }).onError((error, stackTrace) {
                              debugPrint("Fail");
                              toast("Fail");
                              setState(() {
                                isLoading = false;
                              });
                            });

                            // var signUpData=SignUpDataPassModel(name: _nameData,mail: _emailData,pass: _passwordData);
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(signUpData: signUpData)));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  strokeWidth: 4, color: Colors.white)
                              : Text("Login",
                                  style: GoogleFonts.cormorantGaramond(
                                      fontSize: 17, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 17),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Don't have account?",
                                style: TextStyle(fontSize: 13)),
                            GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             SignUpScreen()));
                                },
                                child: Text("Create new account.",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: MyColor.darkGreen)))
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Or",
                                style: GoogleFonts.ptSerif(
                                    fontSize: 16, color: Colors.black38))
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.facebook),
                          label: Text("Connect with facebook"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: ElevatedButton.icon(
                          onPressed: () {

                          },
                          icon: Icon(Icons.g_mobiledata),
                          label: Text("Connect with Google"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ])),
          ),
        ))));
  }


}
