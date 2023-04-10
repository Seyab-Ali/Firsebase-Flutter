import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firsebase_flutter/ui/firestore/add_firestore_data.dart';
import 'package:firsebase_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final firebaseFirestore = FirebaseFirestore.instance.collection("Users").snapshots();
CollectionReference reference = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore'),
        actions: [
          IconButton(
              onPressed: () {
                auth
                    .signOut()
                    .then((value) => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              )),
                          Utils.snackBar("Logout Successfully", context)
                        })
                    .onError((error, stackTrace) =>
                        {Utils.snackBar(error.toString(), context)});
              },
              icon: Icon(Icons.logout_outlined)),
          SizedBox(
            width: 10,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFirestoreDataScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),

          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //       if (!snapshot.hasData) {
          //         return CircularProgressIndicator();
          //       } else {
          //         Map<dynamic, dynamic> map =
          //             snapshot.data!.snapshot.value as dynamic;
          //         List<dynamic> list = [];
          //         list.clear();
          //         list = map.values.toList();
          //         return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(list[index]['description']),
          //               subtitle: Text(list[index]['aa'].toString()),
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // ),
StreamBuilder<QuerySnapshot>(
  stream: firebaseFirestore,
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

    if(snapshot.connectionState == ConnectionState.waiting){
      return CircularProgressIndicator();
    }
    if(snapshot.hasError){
      return Text('Some Erorr');
    }

return Expanded(
    child: ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        return ListTile(

          onTap: (){
            // reference.doc(snapshot.data!.docs[index]['id'].toString()).update({
            //   'title': 'hello muslims of the world'
            // }).then((value) => {
            //   Utils.snackBar("Updated", context)
            // }).onError((error, stackTrace) => {
            //   Utils.snackBar(error.toString(), context)
            // });
            reference.doc(snapshot.data!.docs[index]['id'].toString()).delete();
          },
          title: Text(snapshot.data!.docs[index]['title'].toString()),
          subtitle: Text(snapshot.data!.docs[index]['id'].toString()),


        );
      },
    ));
} ,),

        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(hintText: 'Edit'),
            ),
          ),
          actions: [
            TextButton(onPressed: () {}, child: Text('Update')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'))
          ],
        );
      },
    );
  }
}
