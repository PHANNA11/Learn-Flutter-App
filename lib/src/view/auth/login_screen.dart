import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/src/view/auth/sign_up_screen.dart';
import 'package:firebase_project/src/view/home/home_screen.dart';
import 'package:firebase_project/src/widget/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isHintPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(
              size: 200,
            ),
            TextFielWidget(
              controller: emailController,
              prefixIcon: Icons.email,
              hintText: 'Enter E-mail',
            ),
            TextFielWidget(
              controller: passwordController,
              prefixIcon: Icons.lock_open_rounded,
              hintText: 'Enter password',
              hintPassword: isHintPassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHintPassword = !isHintPassword;
                    });
                  },
                  icon: Icon(isHintPassword
                      ? Icons.visibility
                      : Icons.visibility_off)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                  color: Colors.blueAccent,
                  child: const Text('Sign In'),
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      if (credential.user!.getIdToken() != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false);
                      }
                    } on FirebaseAuthException catch (e) {
                      log(e.credential!.providerId);
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }),
            ),
            // TODO : Login with google and Facebook
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const CircleAvatar(
                      child: Icon(
                        Icons.facebook,
                        size: 40,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      // Trigger the authentication flow
                      final GoogleSignInAccount? googleUser =
                          await GoogleSignIn().signIn();

                      // Obtain the auth details from the request
                      final GoogleSignInAuthentication? googleAuth =
                          await googleUser?.authentication;

                      // Create a new credential
                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth?.accessToken,
                        idToken: googleAuth?.idToken,
                      );
                      var userCredentail = await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      if (userCredentail != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false);
                      }
                    },
                    child: const CircleAvatar(
                      child: Icon(
                        Icons.language,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'If you have account!.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ));
                    },
                    child: const Text("Create account"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
