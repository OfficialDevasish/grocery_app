import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../my_utils/common_functions.dart';
import 'add_data_to_realtime_db.dart';


class MainFirebaseRealtimeDbScreen extends StatefulWidget {
  const MainFirebaseRealtimeDbScreen({Key? key}) : super(key: key);

  @override
  State<MainFirebaseRealtimeDbScreen> createState() => _MainFirebaseRealtimeDbScreenState();
}

class _MainFirebaseRealtimeDbScreenState extends State<MainFirebaseRealtimeDbScreen> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Data My");

  var _keyForm = GlobalKey<FormState>();

  bool isLoading= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var user = _auth.currentUser;
    if (user != null) {
      debugPrint("user existed, user: ${user.email}");
    } else {
      debugPrint("no user");
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(title: Text("Main Screen"), actions: [
              IconButton(
                  onPressed: () {
                    _auth.signOut()
                    .then((value) {
                      toast("SignOut");
                      Navigator.pop(context);
                    })
                    .onError((error, stackTrace) {
                      toast("Something went wrong.");
                    });
                  },
                  icon: Icon(Icons.logout))
            ]),
            body: Container(
              child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: ref, itemBuilder: (context, snapshot, animation, index) {
                return Card(
                  elevation: 3,
                    child: ListTile(
                      title: Text(snapshot.child("title").value.toString()),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(child: ListTile(
                              onTap:(){
                            ref.child(snapshot.child("id").value.toString()).remove();
                            Navigator.pop(context);
                          },leading :Icon(Icons.delete),title: Text("delete"))),
                          PopupMenuItem(child: ListTile(
                              onTap: (){
                            ref.child(snapshot.child("id").value.toString()).update({"title": "${snapshot.child("title").value.toString()} - ${DateTime.now().millisecondsSinceEpoch.toString()}"});
                            Navigator.pop(context);
                          },leading :Icon(Icons.edit),title: Text("edit"))),
                        ],
                      ),
                    )
                );
              },),
            ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                debugPrint("onPressed:");
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddDataToRealtimeDb()));
                },child: Icon(Icons.add_circle)),
        )
    );
  }



}
