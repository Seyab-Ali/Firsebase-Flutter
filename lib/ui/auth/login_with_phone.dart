import 'package:firebase_auth/firebase_auth.dart';
import 'package:firsebase_flutter/ui/auth/verify_code_screen.dart';
import 'package:firsebase_flutter/utils/utils.dart';
import 'package:firsebase_flutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
   bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();

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
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: '+92 346 8759449',
                ),
              ),
              SizedBox(
                height: 80,
              ),
              RoundButton(
                  title: 'Login',
                  loading:  loading,
                  onpress: () async {

                setState(() {
                  loading = true;
                });
                    await auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text.toString(),

                      verificationCompleted: (_) { setState(() {
                        loading = false;
                      });},
                      verificationFailed: (FirebaseAuthException e) {
                        setState(() {
                          loading = false;
                        });
                        Utils.snackBar(e.toString(), context);
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                      verificationId: verificationId,
                                    )));
                        setState(() {
                          loading = false;
                        });
                      },

                      codeAutoRetrievalTimeout: (e) {
                        Utils.snackBar(e.toString(), context);
                        setState(() {
                          loading = false;
                        });
                      },
                    );
                  })
            ],
          ),
        ));
  }
}

