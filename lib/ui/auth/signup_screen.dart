
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firsebase_flutter/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    obscurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SignUp'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: "Enter Email",
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email)),
            ),
            ValueListenableBuilder(
              valueListenable: obscurePassword,
              builder: (context, value, child) {
                return TextFormField(
                  focusNode: passwordFocusNode,
                  obscureText: obscurePassword.value,
                  obscuringCharacter: '*',
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                        onTap: () {
                          obscurePassword.value = !obscurePassword.value;
                        },
                        child: Icon(obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility)),
                  ),
                );
              },
            ),
            SizedBox(
              height: height * 0.085,
            ),
            RoundButton(
              title: "Signup",
              loading: loading,
              onpress: () {
                if (emailController.text.isEmpty) {
                  Utils.snackBar("Please Enter email", context);
                } else if (passwordController.text.isEmpty) {
                  Utils.snackBar("Please Enter password", context);
                } else if (passwordController.text.length < 6) {
                  Utils.snackBar("Please Enter 6  password", context);
                } else {
setState(() {
   loading = true;

});
                    _firebaseAuth
                        .createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString())
                        .then((value) {
                      setState(() {
                         loading = false;

                      });
                        Utils.snackBar("User Registered Successfully ", context);
                    }).onError((error, stackTrace) {
                      setState(() {
                         loading = false;

                      });
                      Utils.snackBar(error.toString(), context);

                    });
                  }
                              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              },
              child: const Text("Already have an account? LogIn"),
            )
          ],
        ),
      ),
    );
  }
}
