import 'package:firebase_auth/firebase_auth.dart';
import 'package:firsebase_flutter/ui/posts/post_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController verifyCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login With Phone'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: verifyCodeController,
                decoration: InputDecoration(
                  hintText: '6-digit code',
                ),
              ),
              SizedBox(
                height: 80,
              ),
              RoundButton(
                title: 'Verify',
                loading: loading,
                onpress: () async {
                  setState(() {
                    loading= true;
                  });
                  final authCredential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyCodeController.text.toString());
                  try {
                    await auth.signInWithCredential(authCredential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostScreen(),
                        ));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils.snackBar(e.toString(), context);
                  }
                },
              )
            ],
          ),
        ));
  }
}
