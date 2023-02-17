import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../my_utils/common_functions.dart';
import 'firebase_login_with_phone_number_screen.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({Key? key, required this.verificationId}) : super(key: key);

  final String verificationId;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final _tag = "VerifyOtp";
  var _formKey = GlobalKey<FormState>();

  bool isVisibleEmailError = false;
  bool isVisiblePasswordError = false;

  var _otp = "";

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
                        child: Text("Verify with OTP",
                            style: GoogleFonts.ptSerif(fontSize: 30)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text("Enter OTP \n& verify.",
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Enter OTP",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                isVisibleEmailError = true;
                              });
                            } else {
                              setState(() {
                                isVisibleEmailError = false;
                              });
                              _otp = value.toString();
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: isVisibleEmailError,
                        child: Container(
                          margin: EdgeInsets.only(left: 12, right: 10),
                          child: Text("Please enter phone number",
                              style: GoogleFonts.ptSerif(
                                  fontSize: 12, color: Colors.red)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 50,
                        margin:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState!.validate();
                            if (!isValid) {
                              return;
                            }

                            var credential = PhoneAuthProvider.credential(
                                verificationId: widget.verificationId,
                                smsCode: _otp);

                            await _auth
                                .signInWithCredential(credential)
                                .then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FirebaseLoginWithPhoneNumberScreen()));
                            }).onError((error, stackTrace) {
                              toast("Fail");
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  strokeWidth: 4, color: Colors.white)
                              : Text("Send OTP",
                                  style: GoogleFonts.cormorantGaramond(
                                      fontSize: 20, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ])),
          ),
        ))));
  }
}
