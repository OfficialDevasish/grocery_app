import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../my_utils/common_functions.dart';
import 'main_firebase_realtime_db_screen.dart';


class AddDataToRealtimeDb extends StatefulWidget {
  const AddDataToRealtimeDb({Key? key}) : super(key: key);

  @override
  State<AddDataToRealtimeDb> createState() => _AddDataToRealtimeDbState();
}

class _AddDataToRealtimeDbState extends State<AddDataToRealtimeDb> {

  final _tag = "DataAddScreen";
  bool cbValue = false;

  var _keyForm = GlobalKey<FormState>();

  bool isVisibleTitleError = false;
  bool isVisibleDataError = false;

  var _titleData = "";
  var _descData = "";

  final databaseRef = FirebaseDatabase.instance.ref("Data My");

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(
        appBar: AppBar(title: Text("DataAddScreen"),),
          body: Form(
            key: _keyForm,
            child: SingleChildScrollView(
              child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                labelText: "Enter title",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  isVisibleTitleError = true;
                                });
                              } else {
                                setState(() {
                                  isVisibleTitleError = false;
                                });
                                _titleData = value.toString();
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: isVisibleTitleError,
                          child: Container(
                            margin: EdgeInsets.only(left: 12, right: 10),
                            child: Text("Please enter title",
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
                                labelText: "Enter description",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  isVisibleDataError = true;
                                });
                              } else {
                                setState(() {
                                  isVisibleDataError = false;
                                });
                                _descData = value.toString();
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: isVisibleDataError,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "Please enter description",
                              style: GoogleFonts.ptSerif(
                                  fontSize: 12, color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                isLoading=true;
                              });

                              String id  = DateTime.now().millisecondsSinceEpoch.toString() ;

                              databaseRef.child(id).set({
                                "id":id,
                                "title":_titleData,
                                "data":_descData
                              }).then((value) {
                                toast("Added");
                                setState(() {
                                  isLoading=false;
                                });

                                Navigator.push(context, MaterialPageRoute(builder: (context) => MainFirebaseRealtimeDbScreen()));

                              }).onError((error, stackTrace) {
                                toast("Error");
                                setState(() {
                                  isLoading=false;
                                });
                              });

                            },
                            child: isLoading
                                ? CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            )
                                : Text(
                              "Add Data",
                              style: GoogleFonts.ptSerif(
                                  fontSize: 17, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ])),
            ),
          )
      )
    );
  }

}
