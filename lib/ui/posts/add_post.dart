import 'package:firebase_database/firebase_database.dart';
import 'package:firsebase_flutter/utils/utils.dart';
import 'package:firsebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
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

                  final String id = DateTime.now().millisecondsSinceEpoch.toString();
                  await databaseRef
                      .child(id)
                      .set({
                        'id': id,
                        'title': postController.text.toString()
                      })
                      .then((value) => {
                            setState(() {
                              loading = false;
                            }),
                            Utils.snackBar("Post Added", context)
                          })
                      .onError((error, stackTrace) => {
                            setState(() {
                              loading = false;
                            }),
                            Utils.snackBar(error.toString(), context)
                          });
                }),
          ],
        ),
      ),
    );
  }
}
