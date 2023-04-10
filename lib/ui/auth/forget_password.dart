import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firsebase_flutter/utils/utils.dart';
import 'package:firsebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.black,
                  )
                )
              ),
            ),
          ),
          SizedBox(height: 20,),
          RoundButton(loading: loading, title: 'Forget Password', onpress: (){
            setState(() {
              loading = true;
            });
          firebaseAuth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
            setState(() {
              loading = false;
            });
            Utils.snackBar('Password reset link has send to your email', context);
          }).onError((error, stackTrace) {
            setState(() {
              loading = false;
            });
            Utils.snackBar(error.toString(), context);
          });
          })
        ],
      ),
    );
  }
}
