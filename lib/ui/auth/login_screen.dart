import 'package:firebase_auth/firebase_auth.dart';
import 'package:firsebase_flutter/ui/auth/forget_password.dart';
import 'package:firsebase_flutter/ui/auth/signup_screen.dart';
import 'package:firsebase_flutter/ui/posts/post_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';
import 'login_with_phone.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

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

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
      Utils.snackBar("SignUp Successfully ", context);
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils.snackBar(error.toString(), context);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ForgetPassword();
                  },));
                }, child: Text('Forget Password?'))),
          ),
          SizedBox(
            height: height * 0.030,
          ),
          RoundButton(
            loading: loading,
            title: "Login",
            onpress: () {
              if (emailController.text.isEmpty) {
                Utils.snackBar("Please Enter email", context);
              } else if (passwordController.text.isEmpty) {
                Utils.snackBar("Please Enter password", context);
              } else if (passwordController.text.length < 6) {
                Utils.snackBar("Please Enter 6  password", context);
              } else {
                login();
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
                    builder: (context) => const SignUpScreen(),
                  ));
            },
            child: const Text("Don't have an account? Sign Up"),
          ),
          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginWithPhoneNumber(),));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.black, width: 5),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Center(child:  Text('SignUp with Phone')),
              ),
            ),
          )
        ],
      ),
    );
  }
}
