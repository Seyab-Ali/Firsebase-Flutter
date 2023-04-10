import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firsebase_flutter/ui/firestore/firestore_list_screen.dart';
import 'package:firsebase_flutter/ui/posts/post_screen.dart';
import 'package:flutter/material.dart';


import '../ui/auth/login_screen.dart';
import '../ui/image_upload.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    if (user != null) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              )));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              )));
    }
  }
}
