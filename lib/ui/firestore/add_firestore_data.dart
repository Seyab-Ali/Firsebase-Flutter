import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firsebase_flutter/utils/utils.dart';
import 'package:firsebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  bool loading = false;
  TextEditingController postController = TextEditingController();
  final firebaseFirestore = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firestore Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                  hintText: "What is in Your Mind?",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                loading: loading,
                title: "Add Post",
                onpress: () async {
                  setState(() {
                    loading = true;
                  });
                   String id =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  firebaseFirestore
                      .doc(id)
                      .set({'title': postController.text.toString(), 'id': id})
                      .then((value) => {
                            Utils.snackBar("Post Added", context),
                            setState(() {
                              loading = false;
                            })
                          })
                      .onError((error, stackTrace) => {
                            Utils.snackBar(error.toString(), context),
                            setState(() {
                              loading = false;
                            })
                          });
                }),
          ],
        ),
      ),
    );
  }
}
