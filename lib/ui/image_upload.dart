import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firsebase_flutter/utils/utils.dart';
import 'package:firsebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  firebase_storage.FirebaseStorage firebaseStorage =
      firebase_storage.FirebaseStorage.instance;
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('Post');

  Future getImageGallary() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Utils.snackBar("No image Picked", context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallary();
                },
                child: Container(
                  height: 220,
                  width: 220,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Icon(Icons.image),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                loading: loading,
                title: 'Upload',
                onpress: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      .ref('/foldername' + DateTime.now().millisecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);
                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    databaseReference
                        .child('1')
                        .set({'id': '3468759449', 'title': newUrl.toString()})
                        .then((value) => {
                              setState(() {
                                loading = false;
                              }),
                              Utils.snackBar("Image Uploaded", context)
                            })
                        .onError((error, stackTrace) => {
                              setState(() {
                                loading = false;
                              }),
                              Utils.snackBar(error.toString(), context)
                            });
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils.snackBar(error.toString(), context);
                  });
                })
          ],
        ),
      ),
    );
  }
}
