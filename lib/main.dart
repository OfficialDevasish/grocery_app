import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/firebase_realtime_database/main_firebase_realtime_db_screen.dart';
import 'package:grocery_app/firebase_signup_login/firebase_signup_login_screen.dart';
import 'package:grocery_app/my_utils/my_images.dart';
import 'firebase_expense_calculator/expanse_calculator_list_screen.dart';
import 'notification/my_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  MyNotification.initialize();

  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  debugPrint("${remoteMessage.data.toString()}");
  debugPrint("${remoteMessage.notification.toString()}");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // service.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
        body: SafeArea(
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(10),
          child: Column(children: [
            SizedBox(height: 35),
            Text("Welcome Screen",
                style: GoogleFonts.ptSerif(
                    fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Expanded(
                child: Text("Flutter FireBase Demo Grocery App",
                    style: GoogleFonts.ptSerif(fontSize: 15))),
            Expanded(
              flex: 2,
              child: Container(
                height: 150,
                width: 150,
                child: Image.asset(MyImages.firebaseImgPath),
              ),
            ),
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      firebaseSignupLoginWidget(),
                      const SizedBox(height: 5),
                      firebaseLoginWithPhoneNumber(),
                      const SizedBox(height: 5),
                      firebaseRealtimeDbWidget(),
                      const SizedBox(height: 5),
                      firebaseFireStoreDbWidget(),
                      const SizedBox(height: 5),
                      firebaseExpenseCalculatorWidget(),
                    ],
                  ),
                ))
          ])),
    ));
  }

  firebaseSignupLoginWidget() => Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: ElevatedButton(
            onPressed: () {
              debugPrint("main: onPressed:");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FirebaseSignupLoginScreen()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text("Firebase Signup Login",
                style: GoogleFonts.ptSerif(fontSize: 17))),
      );

  firebaseLoginWithPhoneNumber()=>  Container(
    width: double.infinity,
    height: 50,
    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
    child: ElevatedButton(
        onPressed: () {
          debugPrint("main: onPressed:");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FirebaseSignupLoginScreen()));
        },
        // style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.blue,
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10))),
        child: Text("Firebase Login With Phone",
            style: GoogleFonts.ptSerif(fontSize: 17))),
  );

  firebaseRealtimeDbWidget() => Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: ElevatedButton(
            onPressed: () {
              debugPrint("main: onPressed:");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MainFirebaseRealtimeDbScreen()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text("Firebase Realtime DB",
                style: GoogleFonts.ptSerif(fontSize: 17))),
      );

  firebaseFireStoreDbWidget() => Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: ElevatedButton(
            onPressed: () {
              debugPrint("main: onPressed:");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MainFirebaseFirestoreDbScreen()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text("Firebase Firestore Db",
                style: GoogleFonts.ptSerif(fontSize: 17))),
      );

  firebaseExpenseCalculatorWidget() => Container(
    width: double.infinity,
    height: 50,
    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
    child: ElevatedButton(
        onPressed: () {
          debugPrint("main: onPressed:");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  const ExpenseCalculatorListScreen()));
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text("Firebase Expense Db",
            style: GoogleFonts.ptSerif(fontSize: 17))),
  );

  Future<void> googleLogin() async {

    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var reslut = await _googleSignIn.signIn();
      if (reslut == null) {
        return;
      }

      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);

      var finalResult = await FirebaseAuth.instance.signInWithCredential(credential);

      print("Result $reslut");
      print(reslut.displayName);
      print(reslut.email);
      print(reslut.photoUrl);


    } catch (error) {
      print(error);
    }


  }

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }
}
